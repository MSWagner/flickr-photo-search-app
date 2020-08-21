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
        isNavbarInNotSearchState()

        /// Start Loading
        hasAppStartedLoading()

        /// End Loading
        hasAppEndLoadingAndShowingCells()

        /// Refresh
        app.buttons["refreshButton"].tap()
        hasAppStartedLoading()
        hasAppEndLoadingAndShowingCells()
    }

    // MARK: - Reusable Functions

    func isNavbarInNotSearchState() {
        XCTAssertEqual(app.navigationBars.buttons.count, 2)

        let searchButton = app.buttons["searchButton"]
        let refreshButton = app.buttons["refreshButton"]

        XCTAssertTrue(searchButton.waitForExistence(timeout: 1))
        XCTAssertTrue(refreshButton.waitForExistence(timeout: 1))
    }

    func hasAppStartedLoading() {
        let onlyLoadingViewVisible = isLoadingViewVisible(timeout: 5) && isEmptyViewVisible() && app.tables.cells.count == 0
        XCTAssertFalse(onlyLoadingViewVisible, "Only the loading view should be visible")
    }

    func hasAppEndLoadingAndShowingCells() {
        XCTAssertTrue(app.tables.cells.firstMatch.waitForExistence(timeout: 5))
        XCTAssertEqual(app.tables.cells.count, 25, "25 images should be visible from the stub json")
    }

    func isLoadingViewVisible(timeout: TimeInterval? = nil) -> Bool {
        let titleLabel = app.staticTexts["loadingView.title"]

        if let timeout = timeout {
            return titleLabel.waitForExistence(timeout: timeout) && app.descendants(matching: .activityIndicator).element.exists
        }

        return titleLabel.exists && app.descendants(matching: .activityIndicator).element.exists
    }

    func isEmptyViewVisible(timeout: TimeInterval? = nil) -> Bool {
        let titleLabel = app.staticTexts["emptyView.title"]
        let retryLabel = app.staticTexts["emptyView.retry"]

        if let timeout = timeout {
            return titleLabel.waitForExistence(timeout: timeout) && retryLabel.exists
        }

        return titleLabel.exists && retryLabel.exists
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
