//
//  ScrubberView.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit
import AVFoundation

class ScrubberView: UIView {
    
    private lazy var collectionView = ThumbnailCollectionView()
    private lazy var needleView = NeedleView()
    private lazy var timeLabel = TimeLabel()
    private lazy var dispatchGroup = DispatchGroup()
    
    var centerInset: CGFloat = 0
    var thumbnails = [Thumbnail]()
    var asset: AVAsset? { didSet { createThumbnails(asset) } }
    
    var handleImageError: ((String) -> Void)?
    var handleScroll: ((Double) -> Void)?
    
    var needleViewCenterXConstraint: NSLayoutConstraint!
    var timeLabelCenterXConstraint: NSLayoutConstraint!
    
    // MARK: - UIView Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        setupTimeLabel()
        setupCollectionView()
        setupNeedleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCollectionViewInset()
    }
    
    // MARK: - Update View
    
    func updateUI(_ time: Double) {
        updateTimeLabel(time)
        scrollCollectionView(time)
    }
    
    func updateTimeLabel(_ time: Double) {
        timeLabel.text = time.formatted()
    }
    
    // MARK: - Private Functions
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].forEach { $0.isActive = true }
    }
    
    private func setupNeedleView() {
        addSubview(needleView)
        
        needleViewCenterXConstraint = needleView.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        [
            needleView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            needleView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            needleViewCenterXConstraint
        ].forEach { $0.isActive = true }
    }
    
    private func setupTimeLabel() {
        addSubview(timeLabel)
        
        timeLabelCenterXConstraint = timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        [
            timeLabelCenterXConstraint,
            timeLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: .labelPadBottom)
        ].forEach { $0.isActive = true }
    }
    
    
    private func setCollectionViewInset() {
        centerInset = bounds.width / 2
        collectionView.contentInset = .init(top: .zero, left: centerInset, bottom: .zero, right: centerInset)
    }
    
    private func scrollCollectionView(_ time: Double) {
        let totalDuration = asset?.duration.seconds ?? 0.0
        let ratio = time / totalDuration
        
        let totalLength = collectionView.contentSize.width
        let currentPosition = ratio * totalLength
        collectionView.contentOffset.x = currentPosition - centerInset
    }
    
    private func getCaptureTimes(_ asset: AVAsset) -> [NSValue] {
        var times = [NSValue]()
        let thumbnailCount = Int(asset.duration.seconds / .captureInterval)
        
        for i in 0...thumbnailCount {
            let seconds = Int(.captureInterval) * i
            let time = CMTime(seconds: Double(seconds), preferredTimescale: 1)
            times.append(NSValue(time: time))
            dispatchGroup.enter()
        }
        return times
    }
    
    private func createThumbnails(_ asset: AVAsset?) {
        guard let asset = asset else { return }
        
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.generateCGImagesAsynchronously(forTimes: getCaptureTimes(asset)) {
            
            [weak self] (_, cgImage, _, _, error) in
            
            if let error = error {
                self?.handleImageError?(error.localizedDescription)
                return
            }
            
            guard let cgImage = cgImage else { return }
            
            DispatchQueue.main.async {
                let thumbnail = Thumbnail(image: UIImage(cgImage: cgImage))
                self?.thumbnails.append(thumbnail)
                self?.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
}
