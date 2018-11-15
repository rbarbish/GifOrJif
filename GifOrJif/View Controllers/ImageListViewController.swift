//
//  ImageListViewController.swift
//  GifOrJif
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import UIKit

class ImageListViewController: BaseViewController {

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    //MARK: - Layout
    
    private func setupView() {
        setupBackground()
    }
    
    private func setupBackground() {
        guard let bgImage = UIImage(named: "background") else { return }
        UIGraphicsBeginImageContext(view.frame.size)
        bgImage.draw(in: view.bounds)
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            view.backgroundColor = UIColor(patternImage: image)
        }
    }
}

