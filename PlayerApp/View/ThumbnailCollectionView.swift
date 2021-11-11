//
//  ThumbnailCollectionView.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

class ThumbnailCollectionView: UICollectionView {
    
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: .cellWidth, height: .cellHeight)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: ThumbnailCollectionView.createLayout())
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        register(ThumbnailCell.self, forCellWithReuseIdentifier: ThumbnailCell.id)
        alwaysBounceHorizontal = true
        alwaysBounceVertical = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
