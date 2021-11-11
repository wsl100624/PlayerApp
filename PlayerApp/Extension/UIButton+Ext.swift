//
//  UIButton+Ext.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

extension UIButton {
    
    convenience init(image: UIImage, target: Any, action: Selector) {
        self.init(type: .system)
        setImage(image, for: .normal)
        addTarget(target, action: action, for: .primaryActionTriggered)
    }
    
    func setPlayIcon() {
        setImage(.playIcon, for: .normal)
    }
    
    func setPauseIcon() {
        setImage(.pauseIcon, for: .normal)
    }
}
