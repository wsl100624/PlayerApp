//
//  PlayerViewController.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit
import AVFoundation

final class PlayerViewController: UIViewController {
    
    private lazy var player = AVPlayer()
    
    private lazy var scrubberView = ScrubberView()
    
    private lazy var playerView = PlayerView()
    
    private lazy var playPauseButton = UIButton(image: .playIcon,
                                                target: self,
                                                action: #selector(playPauseButtonPressed))
    
    private lazy var previousTime = CMTime.zero
    
    private lazy var isSeekInProgress = false
    
    // get the status of the video (playing, paused, etc)
    private var playerTimeControlStatusObserver: NSKeyValueObservation?
    
    // get the ready to play status of the video
    private var playerItemStatusObserver: NSKeyValueObservation?
    
    // get current time
    private var timeObserverToken: Any?
    
    // 600 can represent 24/25/35 fps film
    // reference: https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwipnNST3JD0AhUFbc0KHXJGDXsQFnoECAYQAQ&url=https%3A%2F%2Fwarrenmoore.net%2Funderstanding-cmtime&usg=AOvVaw0DZBRIxN_pOQaaSIpVBSGR
    private let preferredTimeScale: CMTimeScale = 600
    
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
    
    // MARK: - Player
    
    private func loadVideo() {
        // video reference: https://www.pexels.com/video/high-speed-photography-of-blue-ink-diffusion-in-water-9669109/
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
                setupPlayer(asset)
                scrubberView.asset = asset
            }
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
    
    private func setupPlayer(_ asset: AVAsset) {
        playerView.accessibilityIdentifier = "playerView"
        
        let playerItem = AVPlayerItem(asset: asset)
        player.replaceCurrentItem(with: playerItem)
        playerView.player = player
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
        
        let interval = CMTime(value: 1, timescale: preferredTimeScale)
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let strongSelf = self else { return }
            strongSelf.updateScrubberView(time)
        }
    }
    
    private func removePlayerObserver() {
        player.pause()
        
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    // MARK: - Play Button
    
    private func setupPlayPauseButton() {
        let barButtonItem = UIBarButtonItem(customView: playPauseButton)
        toolbarItems = [.flexibleSpace(), barButtonItem, .flexibleSpace()]
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
    
    @objc private func playPauseButtonPressed() {
        switch player.timeControlStatus {
        case .playing:
            player.pause()
        case .paused:
            seekToStartIfNeeded()
            player.play()
        default:
            player.pause()
        }
    }
    
    // MARK: - Scrubber View
    
    private func setupScrubberView() {
        scrubberView.accessibilityIdentifier = "scrubberView"
        
        view.addSubview(scrubberView)
        [
            scrubberView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrubberView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrubberView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrubberView.heightAnchor.constraint(equalToConstant: .cellHeight)
        ].forEach { $0.isActive = true }
        
        scrubberView.handleImageError = { [weak self] message in
            self?.showAlert(message)
        }
        
        scrubberView.handleScroll = { [weak self] currentTime in
            self?.updateVideo(currentTime)
        }
    }
    
    private func updateScrubberView(_ time: CMTime) {
        let timeElapsed = time.seconds
        if player.timeControlStatus == .playing {
            scrubberView.updateUI(timeElapsed)
        }
    }
    
    // MARK: - Show/Hide UI
    
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
    
   // MARK: - Control Video
    
    private func updateVideo(_ currentTime: Double) {
        let time = CMTime(seconds:currentTime, preferredTimescale: preferredTimeScale)
        seekVideo(to: time)
        // tried player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
        // but it's pretty laggy, especially when scrolling backward
    }
    
    // reference: https://developer.apple.com/library/archive/qa/qa1820/_index.html#//apple_ref/doc/uid/DTS40016828
    private func seekVideo(to time: CMTime) {
        player.pause()
        
        if CMTimeCompare(time, previousTime) != 0 {
            previousTime = time
            if !isSeekInProgress {
                trySeekToTime()
            }
        }
    }
    
    private func trySeekToTime() {
        guard let status = player.currentItem?.status else {
            showAlert("Cannot find player's current status, perhaps playerItemStatusObserver is lost")
            return
        }
        if status == .readyToPlay {
            actuallySeekToTime()
        }
    }
    
    private func actuallySeekToTime() {
        
        isSeekInProgress = true
        let seekTimeInProgress = previousTime
        
        player.seek(to: previousTime, toleranceBefore: .zero, toleranceAfter: .zero) { _ in
            
            if seekTimeInProgress == self.previousTime {
                
                // let the next seek continue
                self.isSeekInProgress = false
            } else {
                self.trySeekToTime()
            }
        }
    }
    
    
    private func setupPlayerView() {
        view.addSubview(playerView)
        [
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.bottomAnchor.constraint(equalTo: scrubberView.topAnchor, constant: .playerPadBottom),
        ].forEach { $0.isActive = true }
    }
    
    private func seekToStartIfNeeded() {
        if player.currentItem?.currentTime() == player.currentItem?.duration {
            player.seek(to: .zero)
        }
    }
}
