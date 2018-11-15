//
//  UIColorExtension.swift
//  GifOrJif
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func colorWithRGB(red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat) -> UIColor? {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }
    
    static func colorWithHex(hex: String) -> UIColor? {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        return UIColor(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    static func darkerColorForColor(color: UIColor) -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        
        return UIColor()
    }
    
    static func lighterColorForColor(color: UIColor) -> UIColor {
        
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        
        if color.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }
        
        return UIColor()
    }
    
}

extension UIColor {
    
    //HEX - #34495e
    static let rbDarkBlue = UIColor.colorWithRGB(red: 52, green: 73, blue: 94, alpha: 1.0)!
    
    //HEX - #1ed760
    static let rbSpotify = UIColor.colorWithRGB(red: 30, green: 215, blue: 96, alpha: 1.0)!
    
    //HEX - #febe16
    static let rbYellow = UIColor.colorWithRGB(red: 254, green: 190, blue: 22, alpha: 1.0)!
    
}
