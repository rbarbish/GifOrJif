//
//  ImageInfo.swift
//  Ross Barbish
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import Foundation

struct ImageInfo {
    
    var imgURLSmall: URL?
    var imgURLReg: URL?
    
    init(dataDict:[String:Any]) {
        if let urlDict = dataDict["urls"] as? [String: Any] {
            self.imgURLSmall = URL(string: (urlDict["small"] as? String) ?? "")
            self.imgURLReg = URL(string: (urlDict["regular"] as? String) ?? "")
        }
    }
    
}
