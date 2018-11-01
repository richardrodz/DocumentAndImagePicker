//
//  UDTableViewCell.swift
//  ImageDocumentPicker
//
//  Created by Richard Rodriguez on 10/31/18.
//  Copyright © 2018 Richard Rodriguez. All rights reserved.
//

import UIKit

class UDTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCellForImages(image: UIImage, name: String) {
        thumbnail.image = image
        nameLabel.text = name
    }
    
    func configureCellForDocuments(document: UIDocument) {
        switch document.fileType {
        default:
            thumbnail.image = UIImage(named: "documentImage")
        }
        nameLabel.text = document.localizedName
    }
}

struct ImageInfo {
    var image: UIImage
    var name: String
}
