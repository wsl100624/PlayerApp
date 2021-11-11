//
//  PlayerViewController.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    private lazy var scrubberView = ScrubberView()
    
    private lazy var player = AVPlayer()
    
    private lazy var playerView = PlayerView()
    
    private lazy var playPauseButton = UIButton(image: .playIcon,
                                                target: self,
                                                action: #selector(playPauseButtonPressed))
    
    // get the status of the video (playing, paused, etc)
    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    
    // get the ready to play status of the video
    private var playerItemStatusObserver: NSKeyValueObservation?
    
    // get current time
    private var timeObserverToken: Any?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupPlayPauseButton()
        setupScrubberView()
        setupPlayerView()
        
        loadVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removePlayerObserver()
        super.viewWillDisappear(animated)
    }
    
    private func removePlayerObserver() {
        player.pause()
        
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    private func loadVideo() {
        guard let videoUrl = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
            showAlert("Cannot find video.")
            return
        }
        
        let asset = AVURLAsset(url: videoUrl)
        loadValues(for: asset)
    }
    
    private func loadValues(for asset: AVURLAsset) {
        let assetKeys: [String] = [
            "playable",
            "hasProtectedContent"
        ]
        
        Task {
            await asset.loadValues(forKeys: assetKeys)

            if validateValues(for: asset, with: assetKeys) {
                setupPlayerObservers()
                playerView.player = player
                
                let playerItem = AVPlayerItem(asset: asset)
                player.replaceCurrentItem(with: playerItem)
            }
        }
        
    }
    
    private func setupPlayerObservers() {
        
        playerTimeControlStatusObserver = player.observe(\.timeControlStatus,
                                                          options: [.initial, .new]) { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.updatePlayPauseButton()
            }
        }
        
        playerItemStatusObserver = player.observe(\.currentItem?.status,
                                                          options: [.initial, .new]) { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        let interval = CMTime(value: 1, timescale: 2)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let strongSelf = self else { return }
            strongSelf.updateScrubberView(time)
        }
    }
    
    private func updateScrubberView(_ time: CMTime) {
        let timeElapsed = time.seconds
        if player.timeControlStatus == .playing {
            print(timeElapsed)
        }
    }
    
    private func updateUI() {
        guard let currentItem = player.currentItem else {
            hideControls()
            showAlert("Cannot find current video from player")
            return
        }
        
        switch currentItem.status {
        case .readyToPlay:
            showControls()
        default:
            hideControls()
        }
    }
    
    private func hideControls() {
        playPauseButton.isHidden = true
        scrubberView.isHidden = true
    }
    
    private func showControls() {
        scrubberView.isHidden = false
        playPauseButton.isHidden = false
    }
    
    private func updatePlayPauseButton() {
        let status = self.player.timeControlStatus
        
        switch status {
        case .playing:
            self.playPauseButton.setPauseIcon()
        default:
            self.playPauseButton.setPlayIcon()
        }
    }
    
    private func validateValues(for asset: AVAsset, with keys: [String]) -> Bool {
        for key in keys {
            var error: NSError?
            if asset.statusOfValue(forKey: key, error: &error) == .failed {
                let message = "The media failed to load the key \(key)."
                showAlert(message)
                return false
            }
        }
        
        if !asset.isPlayable {
            let message = "The media isn't playable."
            showAlert(message)
            return false
        } else if asset.hasProtectedContent {
            let message = "it contains protected content."
            showAlert(message)
            return false
        }
        
        return true
    }
    
    private func setupPlayPauseButton() {
        let barButtonItem = UIBarButtonItem(customView: playPauseButton)
        toolbarItems = [.flexibleSpace(), barButtonItem, .flexibleSpace()]
    }
    
    private func setupScrubberView() {
        view.addSubview(scrubberView)
        [
            scrubberView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrubberView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrubberView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrubberView.heightAnchor.constraint(equalToConstant: .cellHeight)
        ].forEach { $0.isActive = true }
    }
    
    private func setupPlayerView() {
        view.addSubview(playerView)
        [
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: scrubberView.topAnchor),
        ].forEach { $0.isActive = true }
    }
    
    
    // MARK: - Action

    @objc private func playPauseButtonPressed() {
        switch player.timeControlStatus {
        case .playing:
            player.pause()
        case .paused:
            player.play()
        default:
            player.pause()
        }
    }
}
