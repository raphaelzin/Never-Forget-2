//
//  User.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-10-11.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object
{
    dynamic var name = ""
    dynamic var image = NSData()
    dynamic var createdAt = NSDate()
}
