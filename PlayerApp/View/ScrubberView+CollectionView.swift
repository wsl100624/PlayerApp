//
//  ScrubberView+CollectionView.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit


extension ScrubberView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCell.id, for: indexPath) as! ThumbnailCell
        return cell
    }
}
