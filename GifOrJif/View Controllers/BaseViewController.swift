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
    
    private var progressHUD:MBProgressHUD?
    
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
    
    func showSpinnerWithText(text:String, isViewEnabled:Bool = false, inView: UIView? = nil) {
        enableView(isViewEnabled: isViewEnabled)
        hideSpinnerIfVisible()
        progressHUD = MBProgressHUD.showAdded(to: (inView == nil ? self.view : inView)!, animated: true)
        progressHUD?.mode = MBProgressHUDMode.indeterminate
        progressHUD?.label.text = text
    }
    
    func showLoadingBarWithText(text:String, progressCount:Int, totalCount:Int, isViewEnabled:Bool = false) {
        enableView(isViewEnabled: isViewEnabled)
        hideSpinnerIfVisible()
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD?.mode = MBProgressHUDMode.determinateHorizontalBar
        progressHUD?.label.text = text + " \(progressCount) of \(totalCount)"
        progressHUD?.progress = Float(progressCount) / Float(totalCount)
    }
    
    func updateProgressBarWithProgress(text:String, progressCount:Int, totalCount:Int, isViewEnabled:Bool = false) {
        enableView(isViewEnabled: isViewEnabled)
        guard let hud = progressHUD else { return }
        hud.label.text = text + " \(progressCount) of \(totalCount)"
        hud.progress = Float(progressCount) / Float(totalCount)
    }
    
    func hideSpinnerIfVisible(afterDelay:Double = 0.0, isViewEnabled:Bool = true) {
        enableView(isViewEnabled: isViewEnabled)
        guard let hud = self.progressHUD else { return }
        if afterDelay == 0.0 {
            hud.hide(animated: true)
        }
        else {
            hud.hide(animated: true, afterDelay: afterDelay)
        }
    }
    
    func showErrorHUD(text:String, hideAfterDelay:Double = 2.0, isViewEnabled:Bool = true) {
        enableView(isViewEnabled: isViewEnabled)
        hideSpinnerIfVisible()
        if let hud = progressHUD {
            hud.hide(animated: false)
            progressHUD = nil
        }
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD?.label.text = text
        progressHUD?.customView = UIImageView(image: UIImage(named: "closeHUD")?.maskWithColor(color: UIColor(white: 0, alpha: 0.7)))
        progressHUD?.mode = MBProgressHUDMode.customView
        progressHUD?.hide(animated: true, afterDelay: hideAfterDelay)
    }
    
    func showSuccessHUD(text:String, hideAfterDelay:Double = 2.0, isViewEnabled:Bool = true) {
        enableView(isViewEnabled: isViewEnabled)
        hideSpinnerIfVisible()
        if let hud = progressHUD {
            hud.hide(animated: false)
            progressHUD = nil
        }
        progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD?.label.text = text
        progressHUD?.customView = UIImageView(image: UIImage(named: "checkHUD")?.maskWithColor(color: UIColor(white: 0, alpha: 0.7)))
        progressHUD?.mode = MBProgressHUDMode.customView
        progressHUD?.hide(animated: true, afterDelay: hideAfterDelay)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
