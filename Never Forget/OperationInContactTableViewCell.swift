//
//  OperationInContactTableViewCell.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-30.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit

class OperationInContactTableViewCell: UITableViewCell {

    @IBOutlet var userImage: UIImageView!
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var contactImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contactImage.layer.cornerRadius = 22
        userImage.layer.cornerRadius = 22
        
        contactImage.clipsToBounds = true
        userImage.clipsToBounds = true
        
        amountLabel.textColor = .white
        
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
