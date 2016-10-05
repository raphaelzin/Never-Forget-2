//
//  ContactTableViewCell.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-29.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet var contactPicture: UIImageView!
    @IBOutlet var lentLabel: UILabel!
    @IBOutlet var contactName: UILabel!
    @IBOutlet var borrowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        contactPicture.layer.cornerRadius = 29
        contactPicture.clipsToBounds = true
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
