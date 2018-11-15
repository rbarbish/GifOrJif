//
//  UIViewControllerExtension.swift
//  GifOrJif
//
//  Created by Ross Barbish on 8/20/17.
//  Copyright © 2017 Ross Barbish All rights reserved.
//

import UIKit

enum ViewMode {
    case create, edit
}

extension UIViewController {
    
    var resetCacheNotificationName: String {
        return "didResetCache"
    }
    
    func showLeavePrompt(_ completion: (() -> Void)? = nil) {
        let confirmation = UIAlertController(
            title: "Are you sure you want to leave without saving your changes?",
            message: nil,
            preferredStyle: .alert
        )
        confirmation.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (action) in
            guard let tvc = self else { return }
            if completion != nil {
                completion!()
            }
            else {
                tvc.navigationController!.popViewController(animated: true)
            }
        }))
        confirmation.addAction(UIAlertAction(title: "No", style: .cancel))
        present(confirmation, animated: true, completion: nil)
    }
    
    var backTitle: String {
        get {
            return previousViewController != nil ? previousViewController!.title ?? "Back" : "Back"
        }
    }
    
    func setValue(field: UITextField, value: Any) {
        if !(value is NSNull),
            let value = value as? String {
            field.text = value
        }
    }
    
    var previousViewController:UIViewController? {
        if let controllersOnNavStack = self.navigationController?.viewControllers, controllersOnNavStack.count >= 2 {
            let n = controllersOnNavStack.count
            return controllersOnNavStack[n - 2]
        }
        return nil
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(
            title: "Alert",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
