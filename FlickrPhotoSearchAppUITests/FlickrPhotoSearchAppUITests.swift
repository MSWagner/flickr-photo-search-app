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
        print(app.debugDescription)
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

        XCTAssertTrue(app.searchFields["searchTextView"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.keyboards.firstMatch.waitForExistence(timeout: 10))

        typeOnKeyboard(keys: "Austria")

        XCTAssertTrue(app.keyboards.buttons["Search"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.keyboards.buttons["Search"].isEnabled, "Search button should be enabled")

        app.keyboards.buttons["Search"].forceTapElement()

        /// Start Loading
        isLoadingViewVisibleTest()

        /// End Loading
        areAustriaCellsVisibleTest()
        isNavbarInDefaultStateTest()
    }

    // MARK: - Navbar

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

    // MARK: - Keyboard Helper

    func typeOnKeyboard(keys: String) {
        guard !keys.isEmpty else { return }

        for key in keys {
            typeOnKeyboard(key: String(key))
        }
    }

    func typeOnKeyboard(key: String) {
        guard !key.isEmpty  else { return }

        if app.keys[key].exists {
            app.keys[key].forceTapElement()

            return
        }

        var key = key.uppercased()

        var keyExist = app.keys[key].exists
        if !keyExist {
            key = key.lowercased()
            keyExist = app.keys[key.lowercased()].exists
        }

        app.keys[key].forceTapElement()
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

// MARK: - ForceTap

extension XCUIElement {

    /// Workaround for CI Testing with Github Actions (keys not tapable)
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
}
