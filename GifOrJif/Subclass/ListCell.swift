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
}

class ListCell: UITableViewCell {
    
    weak var delegate:ListCellDelegate?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewForeground: UIView!
    var idx = 0
    
    override func awakeFromNib() {
        viewForeground.layer.cornerRadius = 10
        viewForeground.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    func setupCell(idx: Int) {
        self.idx = idx
    }
    
    @IBAction func atnImage(imgButton: UIButton) {
        delegate?.didSelectImage(imgView: imgView)
    }
    
}
