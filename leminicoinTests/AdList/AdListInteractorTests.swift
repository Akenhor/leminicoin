//
//  AdListInteractorTests.swift
//  leminicoinTests
//
//  Created by Pierre Semler on 18/05/2021.
//

import XCTest
@testable import leminicoin

class AdListInteractorTests: XCTestCase {
    
    var sut: AdListInteractor!
    var output: PresenterSpy!
    var appDependencies: AppDependencies!
    
    override func setUp() {
        super.setUp()
        setup_AdListInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setup_AdListInteractor() {
        sut = AdListInteractor()
        output = PresenterSpy()
        sut.output = output
    }
    
    func loadMockData() {
        appDependencies = AppDependencySpy.sharedSpy
        sut.appDependency = appDependencies
        sut.loadCategoriesAndAds()
        wait(for: [output.expectation], timeout: 10)
    }
    
    func loadMockError() {
        appDependencies = AppDependencyErrorSpy.sharedSpy
        sut.appDependency = appDependencies
        sut.loadCategoriesAndAds()
        wait(for: [output.expectation], timeout: 10)
    }
    
    func downloadMockData(url: URL?, cellId: Int64) {
        let cell = AdCell(frame: .zero)
        cell.representedIdentifier = cellId
        appDependencies = AppDependencySpy.sharedSpy
        sut.appDependency = appDependencies
        sut.downloadSmallImage(for: url, forCell: cell, id: cellId)
        wait(for: [output.expectation], timeout: 10)
    }
    
    
    func testPresentCatAdsFiltersWhenRequestCompleted() {
        //Given
        //When
        loadMockData()
        //Then
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(sut.ads.count, 7)
    }
    
    func testPresentErrorWhenRequestFailed() {
        //Given
        //When
        loadMockError()
        //Then
        XCTAssert(output.presentErrorNetworkWasCalled)
    }
    
    func testPresentSmallImageWhenDownloadComplete() {
        //Given
        //When
        downloadMockData(url: URL(fileURLWithPath: "downloadImage"), cellId: 1)
        //Then
        XCTAssert(output.presentSmallImageDataWasCalled)
        XCTAssertNotNil(output.smallImage)
    }
    
    func testPresentNilSmallImageDataWhenURLNil() {
        //Given
        //When
        downloadMockData(url: nil, cellId: 1)
        //Then
        XCTAssert(output.presentSmallImageDataWasCalled)
        XCTAssertNil(output.smallImage)
    }
    
    func testPresentNilSmallImageDataWhenDownloadError() {
        //Given
        //When
        downloadMockData(url: URL(fileURLWithPath: "genericError"), cellId: 1)
        //Then
        XCTAssert(output.presentSmallImageDataWasCalled)
        XCTAssertNil(output.smallImage)
    }
    
    func testDontPresentAdDtoWhenSelectedAdModelNotMatch() {
        //Given
        let adModel = AdListModel(
            id: 10,
            category: CategoryModel(
                id: 3,
                name: "Sport",
                backgroundColor: .red,
                titleColor: .red
            ),
            title: nil,
            smallImageUrl: nil,
            price: "",
            isUrgentImage: nil)
        //When
        loadMockData()
        sut.getDto(for: adModel.id, categoryId: adModel.category.id)
        //Then
        XCTAssertFalse(output.presentAdDtoWasCalled)
    }
    
    func testDontPresentAdDtoWhenSelectedCatModelNotMatch() {
        //Given
        let adModel = AdListModel(
            id: 1,
            category: CategoryModel(
                id: 2,
                name: "Loisir",
                backgroundColor: .red,
                titleColor: .red
            ),
            title: nil,
            smallImageUrl: nil,
            price: "",
            isUrgentImage: nil)
        //When
        loadMockData()
        sut.getDto(for: adModel.id, categoryId: adModel.category.id)
        //Then
        XCTAssertFalse(output.presentAdDtoWasCalled)
    }
    
    func testPresentAdDtoWhenSelectedAdModelAndCatModelMatch() {
        //Given
        let adModel = AdListModel(
            id: 1,
            category: CategoryModel(
                id: 3,
                name: "Sport",
                backgroundColor: .red,
                titleColor: .red
            ),
            title: nil,
            smallImageUrl: nil,
            price: "",
            isUrgentImage: nil)
        //When
        loadMockData()
        sut.getDto(for: adModel.id, categoryId: adModel.category.id)
        //Then
        XCTAssert(output.presentAdDtoWasCalled)
    }
    
    func testSortingByUrgencyDate() {
        //Given
        //When
        loadMockData()
        //Then
        XCTAssertEqual(sut.ads[0].id, 6)
        XCTAssertEqual(sut.ads[1].id, 2)
        XCTAssertEqual(sut.ads[2].id, 4)
        XCTAssertEqual(sut.ads[3].id, 1)
        XCTAssertEqual(sut.ads[4].id, 3)
        XCTAssertEqual(sut.ads[5].id, 5)
        XCTAssertEqual(sut.ads[6].id, 7)
    }
    
    func testFilterBySportCat() {
        //Given
        sut.filters = [3]
        sut.searchFilter = ""
        //When
        loadMockData()
        //Then
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(output.filteredAds.count, 3)
    }
    
    func testFilterBySportAndLoisirCat() {
        //Given
        sut.filters = [3,4]
        sut.searchFilter = ""
        //When
        loadMockData()
        //Then
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(output.filteredAds.count, 6)
    }
    
    func testClearFilter() {
        //Given
        sut.filters = [1, 2]
        //When
        loadMockData()
        sut.clearFilter()
        //Then
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(sut.filters.count, 0)
        XCTAssertEqual(output.filteredAds.count, 7)
    }
    
    func testFilledMatchingSearchFilter() {
        //Given
        let query = "Du"
        //When
        loadMockData()
        sut.search(for: query)
        //Then
        XCTAssertEqual(sut.searchFilter, query)
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(output.filteredAds.count, 2)
    }
    
    func testFilledMatchingSearchWithCatFilter() {
        //Given
        let query = "Du"
        sut.filters = [4]
        //When
        loadMockData()
        sut.search(for: query)
        //Then
        XCTAssertEqual(sut.searchFilter, query)
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(output.filteredAds.count, 1)
    }
    
    func testNoMatchingSearchFilter() {
        //Given
        let query = "Test"
        //When
        loadMockData()
        sut.search(for: query)
        //Then
        XCTAssertEqual(sut.searchFilter, query)
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(output.filteredAds.count, 0)
    }
    
    func testEmptySearchFilter() {
        //Given
        let query = ""
        //When
        loadMockData()
        sut.search(for: query)
        //Then
        XCTAssertEqual(sut.searchFilter, query)
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(output.filteredAds.count, 7)
    }
    
    func testAddFilter(){
        //Given
        sut.filters = [1]
        //When
        loadMockData()
        sut.select(filter: 2)
        //Then
        XCTAssert(sut.filters.contains(2))
        XCTAssertEqual(sut.filters.count, 2)
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(output.filteredAds.count, 1)
    }
    
    func testRemoveFilter(){
        //Given
        sut.filters = [1,2]
        //When
        loadMockData()
        sut.select(filter: 2)
        //Then
        XCTAssertFalse(sut.filters.contains(2))
        XCTAssertEqual(sut.filters.count, 1)
        XCTAssert(output.presentCategoriesAndAdsAndFiltersWasCalled)
        XCTAssertEqual(output.filteredAds.count, 0)
    }
    
    class AppDependencySpy: AppDependencies {
        static let sharedSpy = AppDependencySpy()
        
        override var networkRepository: NetworkRepository {
            return NetworkRepositorySpy(components: URLComponents())
        }
    }
    
    class NetworkRepositorySpy: NetworkRepository {
        
        public var mustFailed = false
        
        override var networkService: NetworkService {
            return NetworkServiceSpy(with: URLComponents())
        }
        
        override func loadAds(completion: @escaping (Result<[AdDto], NetworkError>) -> Void) {
            let url = URL(fileURLWithPath: "loadAds")
            networkService.request(urlRequest: URLRequest(url: url), completion: completion)
        }
        
        override func loadCategories(completion: @escaping (Result<[CategoryDto], NetworkError>) -> Void) {
            let url = mustFailed ? URL(fileURLWithPath: "genericError") : URL(fileURLWithPath: "loadCat")
            networkService.request(urlRequest: URLRequest(url: url), completion: completion)
        }
        override func downloadAdImage(at url: URL?, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
            networkService.download(urlRequest: URLRequest(url: url!), completion: completion)
        }
    }
    
    class AppDependencyErrorSpy: AppDependencies {
        static let sharedSpy = AppDependencyErrorSpy()
        
        override var networkRepository: NetworkRepository {
            return NetworkErrorRepositorySpy(components: URLComponents())
        }
    }
    
    class NetworkErrorRepositorySpy: NetworkRepository {
        
        override var networkService: NetworkService {
            return NetworkServiceSpy(with: URLComponents())
        }
        
        override func loadAds(completion: @escaping (Result<[AdDto], NetworkError>) -> Void) {
            let url = URL(fileURLWithPath: "genericError")
            networkService.request(urlRequest: URLRequest(url: url), completion: completion)
        }
        
        override func loadCategories(completion: @escaping (Result<[CategoryDto], NetworkError>) -> Void) {
            let url = URL(fileURLWithPath: "genericError")
            networkService.request(urlRequest: URLRequest(url: url), completion: completion)
        }
    }
    
    class PresenterSpy: AdListPresenterProtocol {
        
        var presentCategoriesAndAdsAndFiltersWasCalled = false
        var presentSmallImageDataWasCalled = false
        var presentAdDtoWasCalled = false
        var presentErrorNetworkWasCalled = false
        var filteredAds = [AdDto]()
        var smallImage: Data? = Data()
        let expectation = XCTestExpectation()
        
        func present(categories: [CategoryDto], ads: [AdDto], filters: [Int]) {
            presentCategoriesAndAdsAndFiltersWasCalled = true
            filteredAds = ads
            expectation.fulfill()
        }
        
        func present(smallImageData: Data?, forCell: AdCell) {
            presentSmallImageDataWasCalled = true
            smallImage = smallImageData
            expectation.fulfill()
        }
        
        func present(dto: AdDto, withCategory: String) {
            presentAdDtoWasCalled = true
        }
        
        func present(error: NetworkError) {
            presentErrorNetworkWasCalled = true
        }
    }
}

