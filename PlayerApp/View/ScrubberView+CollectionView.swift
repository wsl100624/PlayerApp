//
//  ScrubberView+CollectionView.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit


extension ScrubberView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        thumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.id, for: indexPath) as! ThumbnailCell
        
        let thumbnail = thumbnails[indexPath.item]
        
        if let image = thumbnail.image {
            cell.fill(image)
        }
        
        return cell
    }
}
