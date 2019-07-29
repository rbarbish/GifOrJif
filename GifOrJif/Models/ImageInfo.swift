//
//  ImageInfo.swift
//  Ross Barbish
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import Foundation

struct ImageInfo: Codable {
    struct Urls: Codable {
        let small: String?
        let regular: String?
    }
    struct User: Codable {
        let instagram_username: String?
    }
    let urls: Urls
    let user: User
    let description: String?
    let likes: Int?
    
    var urlSmall: URL? {
        get {
            guard let small = urls.small else { return nil }
            return URL(string: small)
        }
    }
    
    var urlReg: URL? {
        get {
            guard let reg = urls.regular else { return nil }
            return URL(string: reg)
        }
    }
    
}
