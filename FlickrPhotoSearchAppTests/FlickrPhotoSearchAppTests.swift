//
//  FlickrPhotoSearchAppTests.swift
//  FlickrPhotoSearchAppTests
//
//  Created by Matthias Wagner on 22.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import XCTest
import FlickrPhotoSearchAppKit

class FlickrPhotoSearchAppTests: XCTestCase {

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
}
