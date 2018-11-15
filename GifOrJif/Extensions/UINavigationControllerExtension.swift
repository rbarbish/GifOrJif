//
//  UINavigationControllerExtension.swift
//  GifOrJif
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
