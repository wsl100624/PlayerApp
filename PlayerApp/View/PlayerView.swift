//
//  PlayerView.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit
import AVFoundation


// A custom view to include AVPlayer
// and set the layer from default CALayer to AVPlayerLayer

// reference: https://developer.apple.com/documentation/avfoundation/media_playback_and_selection/creating_a_movie_player_app_with_basic_playback_controls

class PlayerView: UIView {
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var player: AVPlayer? {
        set { playerLayer.player = newValue }
        get { playerLayer.player }
    }
    
    var playerLayer: AVPlayerLayer {
        self.layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
