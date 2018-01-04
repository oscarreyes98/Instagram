//
//  PictureCell.swift
//  Instagram
//
//  Created by Oscar Reyes on 1/3/18.
//  Copyright © 2018 Oscar Reyes. All rights reserved.
//

import UIKit
import Parse

class PictureCell: UITableViewCell {

    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    var instagramPost: PFObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
