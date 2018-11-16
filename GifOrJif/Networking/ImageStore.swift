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
    
    private func fetchImages(searchWord: String, completion: @escaping (Data?, URLResponse?, Bool) -> ()) {
        guard let url = URL(string: "https://api.unsplash.com/search/photos?page=1&query=\(searchWord)") else {
            completion(nil, nil, false)
            return
        }
        var urlReq = URLRequest(url: url)
        urlReq.addValue("Accept-Version", forHTTPHeaderField: "v1")
        urlReq.addValue("Authorization", forHTTPHeaderField: "Client-ID \(API.ACCESS_KEY)")
        URLSession.shared.dataTask(with: urlReq) { data, response, error in
            completion(data, response, error == nil)
            }.resume()
    }
    
}
