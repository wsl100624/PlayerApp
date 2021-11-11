//
//  TimeLabel.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

class TimeLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        font = .systemFont(ofSize: 13)
        textColor = .label
        backgroundColor = .systemFill
        textAlignment = .center
        layer.cornerRadius = 5
        
        text = "00:00"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
