//
//  ThumbnailCell.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    
    static let id = String(describing: ThumbnailCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented - create programmatically")
    }
}
