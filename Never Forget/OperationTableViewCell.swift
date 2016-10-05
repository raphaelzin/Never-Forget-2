//
//  OperationTableViewCell.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-20.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit

class OperationTableViewCell: UITableViewCell {

    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var contactImage: UIImageView!
    @IBOutlet var amount: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var contactName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        amount.textColor = .white
        userName.textColor = .white
        contactName.textColor = .white
        
        userImage.layer.cornerRadius = 63/2
        userImage.clipsToBounds = true
        
        contactImage.layer.cornerRadius = 63/2
        contactImage.clipsToBounds = true
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
