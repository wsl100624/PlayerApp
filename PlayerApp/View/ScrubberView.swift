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
    private(set) lazy var timeLabel = TimeLabel()
    private lazy var dispatchGroup = DispatchGroup()
    private let captureInterval: Double = 5.0
    
    var initialInset: CGFloat = 0
    var thumbnails = [Thumbnail]()
    
    var asset: AVAsset? {
        didSet {
            guard let asset = asset else { return }
            createThumbnails(asset)
        }
    }
    
    var handleCaptureError: ((String) -> Void)?
    var handleScroll: ((Double) -> Void)?
    
    var needleViewCenterXConstraint: NSLayoutConstraint!
    var timeLabelCenterXConstraint: NSLayoutConstraint!
    
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
        
        initialInset = bounds.width / 2
        collectionView.contentInset = .init(top: .zero, left: initialInset, bottom: .zero, right: initialInset)
    }
    
    func updateUI(_ time: Double) {
        updateTimeLabel(time)
        moveCollectionView(time)
    }
    
    private func moveCollectionView(_ time: Double) {
        let totalDuration = asset?.duration.seconds ?? 0.0
        let ratio = time / totalDuration
        
        let totalLength = collectionView.contentSize.width
        let currentPosition = ratio * totalLength
        collectionView.contentOffset.x = currentPosition - initialInset
    }
    
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
            timeLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -8)
        ].forEach { $0.isActive = true }
    }
    
    private func getCaptureTimes(_ asset: AVAsset) -> [NSValue] {
        var times = [NSValue]()
        let thumbnailCount = Int(asset.duration.seconds / captureInterval)
        
        for i in 0...thumbnailCount {
            let seconds = Int(captureInterval) * i
            let time = CMTime(seconds: Double(seconds), preferredTimescale: 1)
            times.append(NSValue(time: time))
            dispatchGroup.enter()
        }
        return times
    }
    
    private func createThumbnails(_ asset: AVAsset) {
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.generateCGImagesAsynchronously(forTimes: getCaptureTimes(asset)) { [weak self] (_, cgImage, _, _, error) in
            
            if let error = error {
                self?.handleCaptureError?(error.localizedDescription)
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
