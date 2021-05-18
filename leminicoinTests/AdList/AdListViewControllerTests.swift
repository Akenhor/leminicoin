//
//  AdListViewControllerTests.swift
//  leminicoinTests
//
//  Created by Pierre Semler on 17/05/2021.
//

import XCTest
@testable import leminicoin

class AdListViewControllerTests: XCTestCase {
    
    var sut: AdListViewController!
    var output: InteractorSpy!
    var router: RouterSpy!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setup_AdListViewController()
        loadView()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    func setup_AdListViewController() {
        sut = AdListViewController(nibName: nil, bundle: nil)
        sut.ads = [
            AdListModel(
                id: 1, category: CategoryModel(
                    id: 1,
                    name: "Loisir",
                    backgroundColor: .red,
                    titleColor: .red
                ),
                title: "Place de concerts",
                smallImageUrl: nil,
                price: "123€",
                isUrgentImage: nil)
        ]
        sut.categories = [
            CategoryModel(id: 1, name: "Loisir", backgroundColor: .red, titleColor: .red),
            CategoryModel(id: 2, name: "Véhicules", backgroundColor: .yellow, titleColor: .black)
        ]
        output = InteractorSpy()
        sut.output = output
        router = RouterSpy()
        sut.router = router
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Foundation.Date())
    }
    
    func testRetrieveCategoriesAndAdsWhenViewDidLoad() {
        sut.viewDidLoad()
        XCTAssert(output.loadCategoriesAndAdsWasCalled)
    }
    
    func testGetDtoWhenCellIsTouched(){
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(item: 0, section: 0))
        XCTAssert(output.getDtoWasCalled)
    }
    
    func testDowloadImageWhenCellIsRendered(){
        let _ = sut.tableView(sut.tableView, cellForRowAt: IndexPath(item: 0, section: 0))
        XCTAssert(output.downloadSmallImageWasCalled)
    }
    
    func testSelectFilterWhenCellIsTouched(){
        guard let collectionView = (sut.tableView(sut.tableView, viewForHeaderInSection: 0)?.subviews.last) as? UICollectionView else {
            XCTFail()
            return
        }
        sut.collectionView(collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        XCTAssert(output.selectFilterWasCalled)
    }
    
    func testClearFilterWhenButtonIsTouched(){
        guard let resetFilterButton = sut.tableView(sut.tableView, viewForHeaderInSection: 0)?.subviews[1] as? UIButton else {
            XCTFail()
            return
        }
        resetFilterButton.sendActions(for: .touchUpInside)
        XCTAssert(output.clearFilterWasCalled)
    }
    
    func testSearchQueryWhenSearchBarUpdated(){
        sut.updateSearchResults(for: sut.navigationItem.searchController!)
        XCTAssert(output.searchQueryWasCalled)
    }
    
    func testTableViewDataSourceMatchAds() {
        XCTAssertEqual(sut.tableView.dataSource?.tableView(sut.tableView, numberOfRowsInSection: sut.ads.count), 1)
    }
    
    func testCollectionDataSourceMatchCategories() {
        sut.viewDidLoad()
        guard let collectionView = sut.tableView(sut.tableView, viewForHeaderInSection: 0)?.subviews.last as? UICollectionView else {
            XCTFail()
            return
        }
        XCTAssertEqual(collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 1), sut.categories.count)
    }
    
    func testDisplayCatsAds() {
        //Given
        let categories = [
            CategoryModel(id: 1, name: "Photos", backgroundColor: .red, titleColor: .red),
            CategoryModel(id: 2, name: "Movies", backgroundColor: .red, titleColor: .red),
            CategoryModel(id: 3, name: "Dance", backgroundColor: .red, titleColor: .red)
        ]
        let ads = [
            AdListModel(id: 1, category: categories[0], title: nil, smallImageUrl: nil, price: "", isUrgentImage: nil),
            AdListModel(id: 2, category: categories[2], title: nil, smallImageUrl: nil, price: "", isUrgentImage: nil)]
        //When
        sut.display(categories: categories, ads: ads)
        //Then
        XCTAssert(sut.categories.count > 0)
        XCTAssert(sut.ads.count > 0)
        XCTAssertEqual(sut.categories.count, categories.count)
        XCTAssertEqual(sut.ads.count, ads.count)
    }
    
    func testNavigationToDetail() {
        //Given
        let adDto = AdDto(id: nil, category_id: nil, title: nil, description: nil, price: nil, images_url: nil, creation_date: nil, is_urgent: nil)
        //When
        sut.displayDto(dto: adDto, withCategory: "Formation")
        //Then
        XCTAssert(router.navigateToDetailWasCalled)
    }
    
    class InteractorSpy: AdListInteractorProtocol {
        var loadCategoriesAndAdsWasCalled = false
        var getDtoWasCalled = false
        var downloadSmallImageWasCalled = false
        var selectFilterWasCalled = false
        var searchQueryWasCalled = false
        var clearFilterWasCalled = false
        
        func loadCategoriesAndAds() {
            loadCategoriesAndAdsWasCalled = true
        }
        
        func getDto(for modelId: Int64, categoryId: Int) {
            getDtoWasCalled = true
        }
        
        func downloadSmallImage(for url: URL?, forCell: AdCell, id: Int64) {
            downloadSmallImageWasCalled = true
        }
        
        func select(filter id: Int) {
            selectFilterWasCalled = true
        }
        
        func search(for query: String?) {
            searchQueryWasCalled = true
        }
        
        func clearFilter() {
            clearFilterWasCalled = true
        }
    }
    
    class RouterSpy: AdListRouterProtocol {
        var navigateToDetailWasCalled = false
        
        func navigateToAdDetail(with ad: AdDto, withCategory: String) {
            navigateToDetailWasCalled = true
        }
    }
}
