//
//  UIImage+Ext.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

extension UIImage {
    
    static var playIcon: UIImage {
        return UIImage(systemName: "play.fill")!
    }
    
    static var pauseIcon: UIImage {
        return UIImage(systemName: "pause.fill")!
    }
    
    static var needleIcon: UIImage {
        return UIImage(named: "needle")!.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
}


