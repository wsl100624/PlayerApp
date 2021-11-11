//
//  ThumbnailCell.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    
    static let id = String(describing: ThumbnailCell.self)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        [
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ].forEach { $0.isActive = true }
    }
    
    func fill(_ image: UIImage) {
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented - create programmatically")
    }
}
