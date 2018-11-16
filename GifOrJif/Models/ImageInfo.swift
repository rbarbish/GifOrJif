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
    var descStr: String
    var instagramUserName: String
    var numLikes: Int
    
    init(dataDict:[String:Any]) {
        if let urlDict = dataDict["urls"] as? [String: Any] {
            self.imgURLSmall = URL(string: (urlDict["small"] as? String) ?? "")
            self.imgURLReg = URL(string: (urlDict["regular"] as? String) ?? "")
        }
        if let userDict = dataDict["user"] as? [String: Any] {
            self.instagramUserName = userDict["instagram_username"] as? String ?? ""
        }
        else {
            self.instagramUserName = ""
        }
        self.descStr = dataDict["description"] as? String ?? ""
        self.numLikes = dataDict["likes"] as? Int ?? 0
    }
    
}
