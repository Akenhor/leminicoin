//
//  AdDetailViewControllerTests.swift
//  leminicoinTests
//
//  Created by Pierre Semler on 18/05/2021.
//

import XCTest
@testable import leminicoin

class AdDetailViewControllerTests: XCTestCase {
    
    var sut: AdDetailViewController!
    var output: InteractorSpy!

    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setup_AdDetailViewController()
        loadView()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    func setup_AdDetailViewController() {
        sut = AdDetailViewController(nibName: nil, bundle: nil)
        output = InteractorSpy()
        sut.output = output
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Foundation.Date())
    }
    
    func testRetrieveDetailWhenViewDidLoad() {
        sut.viewDidLoad()
        XCTAssert(output.loadDetailWasCalled)
    }
    
    func testDisplayAd() {
        //Given
        let adModel = AdDetailModel(categoryName: "Locations", title: "Caravene à louer", description: "Une petite caravane FENT vous attend au bord de la plage, avec tout le confort sur le pallier", thumbImageUrl: nil, price: "120€", creationDate: "2015-07-22T16:38:10+0000", isUrgentImage: #imageLiteral(resourceName: "AdIsUrgent"))
        //When
        sut.display(ad: adModel)
        //Then
        XCTAssertEqual(sut.ad?.categoryName, adModel.categoryName)
        XCTAssertEqual(sut.ad?.title, adModel.title)
        XCTAssertEqual(sut.ad?.description, adModel.description)
        XCTAssertEqual(sut.ad?.thumbImageUrl, adModel.thumbImageUrl)
        XCTAssertEqual(sut.ad?.price, adModel.price)
        XCTAssertEqual(sut.ad?.creationDate, adModel.creationDate)
        XCTAssertEqual(sut.ad?.isUrgentImage, adModel.isUrgentImage)
    }
    
    func testDisplayImage() {
        //Given
        let image = #imageLiteral(resourceName: "AppLogo")
        //When
        sut.display(thumbImage: image)
        //Then
        XCTAssertEqual(sut.thumbImage, #imageLiteral(resourceName: "AppLogo"))
    }
    
    class InteractorSpy: AdDetailInteractorProtocol {
        
        var loadDetailWasCalled = false
        
        func prepare(ad: AdDto, withCategory: String) {}
        
        func loadDetail() {
            loadDetailWasCalled = true
        }
    }
}
