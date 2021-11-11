//
//  ScrubberView.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

class ScrubberView: UIView {
    
    private lazy var collectionView = ThumbnailCollectionView()
    private lazy var needleView = NeedleView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupCollectionView()
        setupNeedleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset = bounds.width / 2
        collectionView.contentInset = .init(top: .zero, left: inset, bottom: .zero, right: inset)
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
        [
            needleView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            needleView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            needleView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor)
        ].forEach { $0.isActive = true }
    }
}
