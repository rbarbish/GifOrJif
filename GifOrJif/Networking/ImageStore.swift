//
//  ImageStore.swift
//  GifOrJif
//
//  Created by Ross Barbish on 11/16/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import Foundation

class ImageStore: NSObject
{
    
    static let instance = ImageStore()
    
    func fetchImages(searchWord: String, completion: @escaping (Data?, URLResponse?, Bool) -> ()) {
        guard let url = URL(string: "https://api.unsplash.com/search/photos?page=1&query=\(searchWord)") else {
            completion(nil, nil, false)
            return
        }
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "GET"
        urlReq.addValue("v1", forHTTPHeaderField: "Accept-Version")
        urlReq.addValue("Client-ID \(API.ACCESS_KEY)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlReq) { data, response, error in
            completion(data, response, error == nil)
            }.resume()
    }
    
}
