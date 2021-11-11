//
//  NeedleView.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//


import UIKit

class NeedleView: UIImageView {
    
    convenience init() {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        image = .needleIcon
    }
}
