//
//  AdDetailInteractorTests.swift
//  leminicoinTests
//
//  Created by Pierre Semler on 18/05/2021.
//

import XCTest
@testable import leminicoin

class AdDetailInteractorTests: XCTestCase {
    
    var sut: AdDetailInteractor!
    var output: PresenterSpy!
    var appDependencies: AppDependencies!
    
    override func setUp() {
        super.setUp()
        setup_AdDetailInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setup_AdDetailInteractor() {
        sut = AdDetailInteractor()
        output = PresenterSpy()
        appDependencies = AppDependencySpy.sharedSpy
        sut.output = output
        sut.appDependency = appDependencies
    }
    
    func downloadMockData(adDto: AdDto) {
        sut.prepare(ad: adDto, withCategory: "Véhicule")
        sut.loadDetail()
        wait(for: [output.expectation], timeout: 10)
    }
    
    func testLoadDetailWhithNilAd() {
        //Given
        //When
        sut.loadDetail()
        //Then
        XCTAssertFalse(output.presentAdWasCalled)
        XCTAssertFalse(output.presentImageWasCalled)
    }
    
    func testPresentDetailWhithAdAndNilImage() {
        //Given
        let adDto = AdDto(id: 1, category_id: 1, title: nil, description: nil, price: nil, images_url: nil, creation_date: nil, is_urgent: nil)
        //When
        downloadMockData(adDto: adDto)
        //Then
        XCTAssert(output.presentAdWasCalled)
        XCTAssert(output.presentImageWasCalled)
        XCTAssertNil(output.thumbImage)
    }
    
    func testPresentDetailWhithAdAndImage() {
        //Given
        let adDto = AdDto(id: 1, category_id: 1, title: nil, description: nil, price: nil, images_url: AdImageDto(small: "http://api/smallApi/image.png", thumb: "http://thumbApi/downloadImage"), creation_date: nil, is_urgent: nil)
        //When
        downloadMockData(adDto: adDto)
        //Then
        XCTAssert(output.presentAdWasCalled)
        XCTAssert(output.presentImageWasCalled)
        XCTAssertNotNil(output.thumbImage)
    }
    
    func testPresentDetailWhithAdAndDowloadErrorImage() {
        //Given
        let adDto = AdDto(id: 1, category_id: 1, title: nil, description: nil, price: nil, images_url: AdImageDto(small: "http://api/smallApi/image.png", thumb: "http://thumbApi/downloadError"), creation_date: nil, is_urgent: nil)
        //When
        downloadMockData(adDto: adDto)
        //Then
        XCTAssert(output.presentAdWasCalled)
        XCTAssert(output.presentImageWasCalled)
        XCTAssertNil(output.thumbImage)
    }
    
    class AppDependencySpy: AppDependencies {
        static let sharedSpy = AppDependencySpy()
        
        override var networkRepository: NetworkRepository {
            return NetworkRepositorySpy(components: URLComponents())
        }
    }
    
    class NetworkRepositorySpy: NetworkRepository {
        
        override var networkService: NetworkService {
            return NetworkServiceSpy(with: URLComponents())
        }

        override func downloadAdImage(at url: URL?, completion: @escaping (Result<Data?, NetworkError>) -> Void) {
            networkService.download(urlRequest: URLRequest(url: url!), completion: completion)
        }
    }
    
    class PresenterSpy: AdDetailPresenterProtocol {
        var presentAdWasCalled = false
        var presentImageWasCalled = false
        var thumbImage: Data? = Data()
        var expectation = XCTestExpectation()
        
        func present(ad: AdDto, withCategory: String?) {
            presentAdWasCalled = true
        }
        
        func present(thumbImageData: Data?) {
            presentImageWasCalled = true
            thumbImage = thumbImageData
            expectation.fulfill()
        }
    }
}
