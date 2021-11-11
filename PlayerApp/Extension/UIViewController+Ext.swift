//
//  UIViewController+Ext.swift
//  PlayerApp
//
//  Created by Will Wang on 11/10/21.
//


import UIKit

extension UIViewController {
    
    func showAlert(_ message: String) {
        
        // make sure it's in main thread
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true)
        }
    }
}
