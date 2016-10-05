//
//  Contact.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-23.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import Foundation
import RealmSwift

class Contact: Object
{
    dynamic var name = ""
    dynamic var id = 0
    dynamic var image = NSData()
}
