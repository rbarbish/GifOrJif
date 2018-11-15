//
//  BaseViewController.swift
//  GifOrJif
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func enableView(isViewEnabled: Bool) {
        view.isUserInteractionEnabled = isViewEnabled
        navigationController?.navigationBar.isUserInteractionEnabled = isViewEnabled
    }
    
    func showGenericError() {
        presentAlert(title: "Error", message: "Something went wrong.")
    }
    
    func getNavAndStatusBarHeight() -> CGFloat {
        if self.navigationController != nil {
            return self.navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        }
        return UIApplication.shared.statusBarFrame.height
    }
    
    func getNavBarHeight() -> CGFloat {
        if self.navigationController != nil {
            return self.navigationController!.navigationBar.frame.height
        }
        return 0.0
    }
    
    func getStatusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
