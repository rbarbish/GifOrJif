//
//  ListCell.swift
//  GifOrJif
//
//  Created by Ross Barbish on 11/15/18.
//  Copyright © 2018 Ross Barbish. All rights reserved.
//

import Foundation
import UIKit

protocol ListCellDelegate:class {
    func didSelectImage(imgView: UIImageView)
    func didSelectUser(username: String)
}

class ListCell: UITableViewCell {
    
    weak var delegate:ListCellDelegate?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var btnInstaUser: UIButton!
    @IBOutlet weak var viewForeground: UIView!
    var imageInfo:ImageInfo!
    var idx = 0
    
    override func awakeFromNib() {
        viewForeground.layer.cornerRadius = 10
        viewForeground.layer.masksToBounds = true
        lblDesc.adjustsFontSizeToFitWidth = true
        lblLikes.adjustsFontSizeToFitWidth = true
        super.awakeFromNib()
    }
    
    func setupCell(imageInfo: ImageInfo, idx: Int) {
        self.imageInfo = imageInfo
        if let urlSmall = imageInfo.urlSmall {
            imgView.kf.setImage(with: urlSmall)
        }
        lblDesc.text = (imageInfo.description ?? "").isEmpty ? "No Description" : imageInfo.description
        let userNameEmpty = imageInfo.user.instagram_username?.isEmpty ?? true
        let userTxt = userNameEmpty ? "N/A" : imageInfo.user.instagram_username!
        btnInstaUser.isEnabled = !userNameEmpty
        btnInstaUser.setTitle("@\(userTxt)", for: .normal)
        lblLikes.text = "\(imageInfo.likes ?? 0) Likes"
        self.idx = idx
    }
    
    @IBAction func atnImage(imgButton: UIButton) {
        delegate?.didSelectImage(imgView: imgView)
    }
    
    @IBAction func atnInstaUser(userButton: UIButton) {
        delegate?.didSelectUser(username: imageInfo.user.instagram_username ?? "")
    }
    
}
