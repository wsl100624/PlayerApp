//
//  ScrubberView+ScrollView.swift
//  PlayerApp
//
//  Created by Will Wang on 11/11/21.
//

import UIKit


extension ScrubberView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isDragging || scrollView.isTracking || scrollView.isDecelerating else { return }
        let currentTime = calculateCurrentTime(scrollView)
        updateTimeLabel(currentTime)
        snapNeedleAndTimeLabel(scrollView)
        handleScroll?(currentTime)
    }
    
    private func calculateCurrentTime(_ scrollView: UIScrollView) -> Double {
        let totalLength = scrollView.contentSize.width
        let currentPosition = scrollView.contentOffset.x + initialInset
        
        // 0 <= ration <= 1
        let ratio = min(max(currentPosition / totalLength, 0.0), 1.0)
        
        let totalSeconds = asset?.duration.seconds ?? 0.0
        
        return  ratio * totalSeconds
    }
    
    private func snapNeedleAndTimeLabel(_ scrollView: UIScrollView) {
        let currentPosition = scrollView.contentOffset.x + initialInset
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
    
    func updateTimeLabel(_ time: Double) {
        let components = DateComponents(second: Int(time))
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        
        let text = formatter.string(for: components)
        timeLabel.text = text
    }
    
}
