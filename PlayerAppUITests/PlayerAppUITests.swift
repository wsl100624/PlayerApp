//
//  PlayerAppUITests.swift
//  PlayerAppUITests
//
//  Created by Will Wang on 11/10/21.
//

import XCTest
import PlayerApp

@testable import PlayerApp
import AVFoundation

class PlayerAppUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func test_play_button_exist() {
        XCTAssert(app.toolbars["Toolbar"].buttons["play"].exists)
    }
    
    func test_pause_button_exist() {
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["play"].tap()
        XCTAssert(toolbar.buttons["pause"].exists)
    }
    
    func test_player_view_exist() {
        XCTAssert(app.otherElements["playerView"].exists)
    }
    
    func test_scrubber_view_exist() {
        XCTAssert(app.otherElements["scrubberView"].exists)
    }
    
    func test_collection_view_exist() {
        let collectionView = app.collectionViews.element(boundBy: 0)
        XCTAssert(collectionView.exists)
    }
    
    func test_collection_view_can_scroll_horizontally() {
        let collectionView = app.collectionViews.element(boundBy: 0)
        collectionView.swipeLeft()
        collectionView.swipeRight()
    }
    
    func test_collection_view_cannot_scroll_vertically() {
        let collectionView = app.collectionViews.element(boundBy: 0)
        collectionView.swipeUp()
        collectionView.swipeDown()
    }

}
