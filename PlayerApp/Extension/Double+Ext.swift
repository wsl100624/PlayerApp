//
//  Double+Ext.swift
//  PlayerApp
//
//  Created by Will Wang on 11/11/21.
//

import Foundation

extension Double {
    
    static let captureInterval: Double = 5.0
    
    // format time as "00:00"
    
    func formatted() -> String? {
        
        let components = DateComponents(second: Int(self))
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        
        return formatter.string(for: components)
    }
}
