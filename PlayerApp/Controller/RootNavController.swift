//
//  RootNavController.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//

import UIKit

class RootNavController: UINavigationController {
    
    init() {
        super.init(rootViewController: PlayerViewController())
        isToolbarHidden = false
        toolbar.scrollEdgeAppearance = UIToolbarAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

