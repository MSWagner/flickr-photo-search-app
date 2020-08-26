//
//  FlickrPhotoSearchAppTests.swift
//  FlickrPhotoSearchAppTests
//
//  Created by Matthias Wagner on 22.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import XCTest
import Mocker
import Combine
import AlamofireImage
@testable import FlickrPhotoSearchApp
@testable import FlickrPhotoSearchAppKit

class FlickrPhotoSearchAppTests: XCTestCase {

    private var cancellAbleBag = [AnyCancellable]()

    public final class MockedData {
        public static let testWontFailImageFileURL: URL = Bundle(for: MockedData.self).url(forResource: "test_wont_fail", withExtension: "png")!
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPhotoSorting() throws {
        let photos: [Photo] = [
            Photo(title: "Z", url_sq: URL(string: "https://www.austria.info")!),
            Photo(title: "zA", url_sq: URL(string: "https://www.google.com")!),
            Photo(title: "aB", url_sq: URL(string: "https://www.austria.info")!),
            Photo(title: "Zb", url_sq: URL(string: "https://www.google.com")!),
            Photo(title: "A", url_sq: URL(string: "https://www.google.com")!)
        ]

        let sortedPhotos = photos.sorted()

        XCTAssertEqual(sortedPhotos[0].title, "A")
        XCTAssertEqual(sortedPhotos[1].title, "aB")
        XCTAssertEqual(sortedPhotos[2].title, "Z")
        XCTAssertEqual(sortedPhotos[3].title, "zA")
        XCTAssertEqual(sortedPhotos[4].title, "Zb")
    }

    @available(iOS 13.0, *)
    func testImageDetailViewModelSuccessfulLoading() throws {
        /// Setup Mock
        let imageURL = URL(string: "https://test.com/test_wont_fail.png")!

        var mock = Mock(url: imageURL, dataType: .imagePNG, statusCode: 200, data: [
            .get: try! Data(contentsOf: MockedData.testWontFailImageFileURL)
        ])
        mock.delay = DispatchTimeInterval.seconds(3)
        mock.register()

        /// Setup Alamofire Mock Configuration
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let alamofireDownloader = ImageDownloader(configuration: configuration,
                                                  downloadPrioritization: .fifo,
                                                  maximumActiveDownloads: 4,
                                                  imageCache: AutoPurgingImageCache())

        /// Create Instances
        let photo = Photo(title: "TestWontFail", url_sq: imageURL)
        let imageDetailViewModel = ImageDetailViewModel(photo: photo, imageDownloader: alamofireDownloader)

        /// Start state is loading
        XCTAssertEqual(imageDetailViewModel.state, .loading)
        XCTAssertEqual(imageDetailViewModel.image, nil)

        /// Check init loading of the image
        let imageNotNilExpectation = self.expectation(description: "image")
        cancellAbleBag += imageDetailViewModel.$image.sink { (image) in
            if image != nil {
                imageNotNilExpectation.fulfill()
            }
        }

        let contentAvailableExpectation = self.expectation(description: "content")
        cancellAbleBag += imageDetailViewModel.$state.sink { (state) in
            if state == .content {
                XCTAssertNotNil(imageDetailViewModel.image)
                contentAvailableExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
