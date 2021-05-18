//
//  AdListPresenterTests.swift
//  leminicoinTests
//
//  Created by Pierre Semler on 18/05/2021.
//

import XCTest
@testable import leminicoin

class AdListPresenterTests: XCTestCase {
    
    var sut: AdListPresenter!
    var output: ViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        setup_AdListPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setup_AdListPresenter() {
        sut = AdListPresenter()
        output = ViewControllerSpy()
        sut.output = output
    }
    
    func testDisplayImageWithData() {
        //Given
        let data = #imageLiteral(resourceName: "AdIsUrgent").pngData()
        let adCell = AdCell()
        //When
        sut.present(smallImageData: data, forCell: adCell)
        //Then
        XCTAssert(output.displayImageWasCalled)
        XCTAssertNotEqual(output.smallImage.pngData(), #imageLiteral(resourceName: "ImagePlaceholder").pngData())
    }
    
    func testDisplayImageWithNilData() {
        //Given
        let adCell = AdCell()
        //When
        sut.present(smallImageData: nil, forCell: adCell)
        //Then
        XCTAssert(output.displayImageWasCalled)
        XCTAssertEqual(output.smallImage.pngData(), #imageLiteral(resourceName: "ImagePlaceholder").pngData())
    }
    
    func testDisplayDto() {
        //Given
        let adDto = AdDto(id: nil, category_id: nil, title: nil, description: nil, price: nil, images_url: nil, creation_date: nil, is_urgent: nil)
        //When
        sut.present(dto: adDto, withCategory: "Loisir")
        //Then
        XCTAssert(output.displayDtoWasCalled)
    }
    
    func testDisplayCatsAds() {
        //Given
        let cats = [CategoryDto(id: 1, name: "Véhicules"), CategoryDto(id: nil, name: nil), CategoryDto(id: 3, name: "Immobilier")]
        let ads = [
            AdDto(
                id: 1,
                category_id: 3,
                title: "Appartement",
                description: nil,
                price: 120000,
                images_url: nil,
                creation_date: "2019-11-06T11:19:20+0000",
                is_urgent: false
            ),
            AdDto(
                id: nil,
                category_id: nil,
                title: nil,
                description: nil,
                price: nil,
                images_url: nil,
                creation_date: nil,
                is_urgent: nil
            ),
            AdDto(
                id: 3,
                category_id: 1,
                title: "Peugeot 407",
                description: "Bon état",
                price: 9670,
                images_url: AdImageDto(small: "https://api/small/image.png", thumb: "https://api/thumb/image.png"),
                creation_date: "2015-07-22T16:38:10+0000",
                is_urgent: true
            )
        ]
        let filters = [3]
        //When
        sut.present(categories: cats, ads: ads, filters: filters)
        //Then
        XCTAssert(output.displayCategoriesAdsWasCalled)
        XCTAssertEqual(output.catsModel.count, 2)
        XCTAssertEqual(output.catsModel[0].id, cats[0].id)
        XCTAssertEqual(output.catsModel[0].name, cats[0].name)
        XCTAssertEqual(output.catsModel[0].backgroundColor, .white)
        XCTAssertEqual(output.catsModel[0].titleColor, AppColor.primaryColor.color)
        XCTAssertEqual(output.catsModel[1].id, cats[2].id)
        XCTAssertEqual(output.catsModel[1].name, cats[2].name)
        XCTAssertEqual(output.catsModel[1].backgroundColor, AppColor.primaryColor.color)
        XCTAssertEqual(output.catsModel[1].titleColor, .white)
        XCTAssertEqual(output.adsModel.count, 2)
        XCTAssertEqual(output.adsModel[0].id, ads[0].id)
        XCTAssertEqual(output.adsModel[0].category.id, ads[0].category_id)
        XCTAssertEqual(output.adsModel[0].title, ads[0].title)
        XCTAssertEqual(output.adsModel[0].smallImageUrl, nil)
        XCTAssertEqual(output.adsModel[0].isUrgentImage, nil)
        XCTAssertEqual(output.adsModel[1].id, ads[2].id)
        XCTAssertEqual(output.adsModel[1].category.id, ads[2].category_id)
        XCTAssertEqual(output.adsModel[1].title, ads[2].title)
        XCTAssertNotNil(output.adsModel[1].smallImageUrl)
        XCTAssertEqual(output.adsModel[1].isUrgentImage, #imageLiteral(resourceName: "AdIsUrgent"))
    }
    
    func testDisplayDataTaskError() {
        //Given
        let error = NetworkError.dataTaskError(NSError())
        //When
        sut.present(error: error)
        //Then
        XCTAssert(output.displayErroWasCalled)
        XCTAssertEqual(output.errorTitle, L10n.Error.Generic.title)
        XCTAssertEqual(output.errorMessage, L10n.Error.DataTask.message)
    }
    
    func testDisplayBadResponseError() {
        //Given
        let error = NetworkError.badResponse(nil)
        //When
        sut.present(error: error)
        //Then
        XCTAssert(output.displayErroWasCalled)
        XCTAssertEqual(output.errorTitle, L10n.Error.Generic.title)
        XCTAssertEqual(output.errorMessage, L10n.Error.BadResponse.message)
    }
    
    func testDisplayNoDataError() {
        //Given
        let error = NetworkError.noData
        //When
        sut.present(error: error)
        //Then
        XCTAssert(output.displayErroWasCalled)
        XCTAssertEqual(output.errorTitle, L10n.Error.Generic.title)
        XCTAssertEqual(output.errorMessage, L10n.Error.NoData.message)
    }
    
    func testDisplayGenericError() {
        //Given
        let error = NetworkError.badLocalUrl
        //When
        sut.present(error: error)
        //Then
        XCTAssert(output.displayErroWasCalled)
        XCTAssertEqual(output.errorTitle, L10n.Error.Generic.title)
        XCTAssertNil(output.errorMessage)
    }
    
    class ViewControllerSpy: AdListViewControllerProtocol {
        var displayCategoriesAdsWasCalled = false
        var displayImageWasCalled = false
        var displayDtoWasCalled = false
        var displayErroWasCalled = false
        var smallImage = UIImage()
        var catsModel = [CategoryModel]()
        var adsModel = [AdListModel]()
        var errorTitle = ""
        var errorMessage: String? = ""
        
        func display(categories: [CategoryModel], ads: [AdListModel]) {
            displayCategoriesAdsWasCalled = true
            catsModel = categories
            adsModel = ads
        }
        
        func display(smallImage: UIImage, forCell: AdCell) {
            displayImageWasCalled = true
            self.smallImage = smallImage
        }
        
        func displayDto(dto: AdDto, withCategory: String) {
            displayDtoWasCalled = true
        }
        
        func display(error title: String, message: String?) {
            displayErroWasCalled = true
            errorTitle = title
            errorMessage = message
        }
    }
}
