//
//  AdDetailPresenterTests.swift
//  leminicoinTests
//
//  Created by Pierre Semler on 18/05/2021.
//

import XCTest
@testable import leminicoin

class AdDetailPresenterTests: XCTestCase {
    
    var sut: AdDetailPresenter!
    var output: ViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        setup_AdDetailPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setup_AdDetailPresenter() {
        sut = AdDetailPresenter()
        output = ViewControllerSpy()
        sut.output = output
    }
    
    func testDisplayImageWithData() {
        //Given
        let data = #imageLiteral(resourceName: "AppLogo").pngData()
        //When
        sut.present(thumbImageData: data)
        //Then
        XCTAssert(output.displayImageWasCalled)
        XCTAssertEqual(output.thumbImage.pngData(), #imageLiteral(resourceName: "AppLogo").pngData())
    }
    
    func testDisplayImageWithNilData() {
        //Given
        //When
        sut.present(thumbImageData: nil)
        //Then
        XCTAssert(output.displayImageWasCalled)
        XCTAssertEqual(output.thumbImage.pngData(), #imageLiteral(resourceName: "ImagePlaceholder").pngData())
    }
    
    func testDontDisplayAdWithNilCat() {
        //Given
        let ad = AdDto(
                    id: 1,
                    category_id: 3,
                    title: "Appartement",
                    description: nil,
                    price: 120000,
                    images_url: nil,
                    creation_date: "2019-11-06T11:19:20+0000",
                    is_urgent: false
                )
        
        //When
        sut.present(ad: ad, withCategory: nil)
        //Then
        XCTAssertFalse(output.displayAdWasCalled)
    }
    
    func testDisplayUrgentAdWithCatAndWithoutURL() {
        //Given
        let ad = AdDto(
                    id: 1,
                    category_id: 3,
                    title: "Appartement",
                    description: "Appart à vendre",
                    price: 120000,
                    images_url: nil,
                    creation_date: "2019-11-06T11:19:20+0000",
                    is_urgent: true
                )
        let category = "Véhicule"
        //When
        sut.present(ad: ad, withCategory: category)
        //Then
        XCTAssert(output.displayAdWasCalled)
        XCTAssertEqual(output.adModel.categoryName, category)
        XCTAssertEqual(output.adModel.title, ad.title)
        XCTAssertEqual(output.adModel.description, ad.description)
        XCTAssertNil(output.adModel.thumbImageUrl)
        XCTAssertEqual(output.adModel.isUrgentImage, #imageLiteral(resourceName: "AdIsUrgent"))
    }
    
    func testDisplayNotUrgentAdWithCatAndURL() {
        //Given
        let ad = AdDto(
                    id: 1,
                    category_id: 3,
                    title: "Appartement",
                    description: "Appart à vendre",
                    price: 120000,
                    images_url: AdImageDto(small: "https://api/small/image.png", thumb: "https://api/thumb/image.png"),
                    creation_date: "2019-11-06T11:19:20+0000",
                    is_urgent: false
                )
        let category = "Véhicule"
        //When
        sut.present(ad: ad, withCategory: category)
        //Then
        XCTAssert(output.displayAdWasCalled)
        XCTAssertEqual(output.adModel.categoryName, category)
        XCTAssertEqual(output.adModel.title, ad.title)
        XCTAssertEqual(output.adModel.description, ad.description)
        XCTAssertNotNil(output.adModel.thumbImageUrl)
        XCTAssertNil(output.adModel.isUrgentImage)
    }

    class ViewControllerSpy: AdDetailViewControllerProtocol {
        
        var displayAdWasCalled = false
        var displayImageWasCalled = false
        var adModel = AdDetailModel(categoryName: "", title: nil, description: nil, thumbImageUrl: nil, price: "", creationDate: "", isUrgentImage: nil)
        var thumbImage = UIImage()
        
        func display(ad: AdDetailModel) {
            displayAdWasCalled = true
            adModel = ad
        }
        
        func display(thumbImage: UIImage) {
            displayImageWasCalled = true
            self.thumbImage = thumbImage
        }
    }
}
