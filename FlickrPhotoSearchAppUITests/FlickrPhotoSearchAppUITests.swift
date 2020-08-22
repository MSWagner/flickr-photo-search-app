//
//  FlickrPhotoSearchAppUITests.swift
//  FlickrPhotoSearchAppUITests
//
//  Created by Matthias Wagner on 21.08.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import XCTest
@testable import FlickrPhotoSearchApp

class FlickrPhotoSearchAppUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["-testing"]

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests

    func testRefresh() throws {
        // UI tests must launch the application that they test.
        app.launch()

        /// Navbar
        isNavbarInDefaultStateTest()

        /// Start Loading
        isLoadingViewVisibleTest()

        /// End Loading
        areHalloweenCellsVisibleTest()

        /// Refresh
        app.buttons["refreshButton"].tap()
        isLoadingViewVisibleTest()
        areHalloweenCellsVisibleTest()
    }

    func testSearch() throws {
        // UI tests must launch the application that they test.
        app.launch()

        /// Navbar
        isNavbarInDefaultStateTest()

        /// Start Loading
        isLoadingViewVisibleTest()

        /// End Loading
        areHalloweenCellsVisibleTest()

        /// Search
        app.buttons["searchButton"].tap()

        XCTAssertTrue(app.searchFields.firstMatch.waitForExistence(timeout: 10))
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 10))

        app.keys["A"].tap()
        app.keys["u"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.keys["r"].tap()
        app.keys["i"].tap()
        app.keys["a"].tap()

        app.keyboards.buttons["Search"].tap()

        /// Start Loading
        isLoadingViewVisibleTest()

        /// End Loading
        areAustriaCellsVisibleTest()
        isNavbarInDefaultStateTest()
    }

    // MARK: - Reusable Functions

    func isNavbarInDefaultStateTest() {
        XCTAssertEqual(app.navigationBars.buttons.count, 2)

        let searchButton = app.buttons["searchButton"]
        let refreshButton = app.buttons["refreshButton"]

        XCTAssertTrue(searchButton.waitForExistence(timeout: 1))
        XCTAssertTrue(refreshButton.waitForExistence(timeout: 1))
    }

    // MARK: - Loading

    func isLoadingViewVisibleTest() {
        let titleLabel = app.staticTexts["loadingView.title"]

        let onlyLoadingViewVisible = titleLabel.waitForExistence(timeout: 10)
            && app.descendants(matching: .activityIndicator).element.exists

        XCTAssertTrue(onlyLoadingViewVisible, "Loading view should be visible")
    }

    func areHalloweenCellsVisibleTest() {
        XCTAssertTrue(app.tables.cells.firstMatch.waitForExistence(timeout: 10))
        XCTAssertEqual(app.tables.cells.count, 25, "25 images should be visible from the stub Halloween json")
    }

    func areAustriaCellsVisibleTest() {
        let exists = NSPredicate(format: "count == 23")
        expectation(for: exists, evaluatedWith: app.tables.cells, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)

        XCTAssertTrue(app.tables.cells.firstMatch.waitForExistence(timeout: 10))
        XCTAssertEqual(app.tables.cells.count, 23, "23 images should be visible from the stub Austria json")
    }

    // MARK: - Performane

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
