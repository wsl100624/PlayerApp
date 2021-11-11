//
//  ScrubberView+ScrollView.swift
//  PlayerApp
//
//  Created by Will Wang on 11/11/21.
//

import UIKit


extension ScrubberView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // make sure it's not been called when first loaded
        guard scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating else { return }
        
        let currentTime = calculateCurrentTime(scrollView)
        
        updateTimeLabel(currentTime)
        handleScroll?(currentTime)
        
        snapNeedleAndTimeLabel(scrollView)
    }
    
    private func calculateCurrentTime(_ scrollView: UIScrollView) -> Double {
        let totalLength = scrollView.contentSize.width
        let currentPosition = scrollView.contentOffset.x + centerInset
        
        // 0 <= ration <= 1
        let ratio = min(max(currentPosition / totalLength, 0.0), 1.0)
        
        let totalSeconds = asset?.duration.seconds ?? 0.0
        
        return  ratio * totalSeconds
    }
    
    private func snapNeedleAndTimeLabel(_ scrollView: UIScrollView) {
        let currentPosition = scrollView.contentOffset.x + centerInset
        let totalLength = scrollView.contentSize.width
        
        var dragDistance: CGFloat = 0
        
        if currentPosition > totalLength {
            dragDistance = totalLength - currentPosition
        } else if currentPosition < 0 {
            dragDistance = abs(currentPosition)
        }
        
        needleViewCenterXConstraint.constant = dragDistance
        timeLabelCenterXConstraint.constant = dragDistance
    }
    
}
