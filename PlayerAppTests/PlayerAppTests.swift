//
//  PlayerAppTests.swift
//  PlayerAppTests
//
//  Created by Will Wang on 11/10/21.
//

import XCTest
@testable import PlayerApp
import AVFoundation

class PlayerAppTests: XCTestCase {
    
    var sut: PlayerViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = PlayerViewController()
        _ = sut.view
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_background_color_is_system_background_color() {
        // given
        let color = UIColor.systemBackground
        
        // when
        let backgroundColor = sut.view.backgroundColor
        
        // then
        XCTAssertEqual(backgroundColor, color)
    }
    
    func test_video_url_is_valid() {
        let url = Bundle.main.url(forResource: "video", withExtension: "mp4")
        XCTAssertNotNil(url)
    }
    
    func test_asset_is_able_to_load_keys() {
        // given
        let url = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        let asset = AVURLAsset(url: url)
        let promise = expectation(description: "keys are loaded")
        let values = ["playable", "hasProtectedContent"]
        var error: NSError?
        
        // when
        asset.loadValuesAsynchronously(forKeys: values) {
            
            // then
            promise.fulfill()
            values.forEach {
                XCTAssertEqual(asset.statusOfValue(forKey: $0, error: &error), .loaded)
            }
        }
        
        wait(for: [promise], timeout: 2)
    }
    
    func test_asset_is_playable() {
        // given
        let url = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        let asset = AVURLAsset(url: url)
        let promise = expectation(description: "playable key is loaded")
        let values = ["playable"]
        
        // when
        asset.loadValuesAsynchronously(forKeys: values) {
            
            // then
            promise.fulfill()
            XCTAssertTrue(asset.isPlayable)
        }
        
        wait(for: [promise], timeout: 2)
    }
    
    func test_asset_does_not_contain_protected_content() {
        // given
        let url = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        let asset = AVURLAsset(url: url)
        let promise = expectation(description: "hasProtectedContent key is loaded")
        let values = ["hasProtectedContent"]
        
        // when
        asset.loadValuesAsynchronously(forKeys: values) {
            
            // then
            promise.fulfill()
            XCTAssertFalse(asset.hasProtectedContent)
        }
        
        wait(for: [promise], timeout: 2)
    }

}
