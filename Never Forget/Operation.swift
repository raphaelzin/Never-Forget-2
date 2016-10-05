//
//  Operation.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-22.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import Foundation
import RealmSwift

class Operation: Object
{
    dynamic var details = ""
    dynamic var isDebt = true
    dynamic var hisID = Int()
    dynamic var amount = Double()
    dynamic var when = NSDate()
    dynamic var notifyAt:NSDate?
    
    //Don't touch
    dynamic var isPaid = false
    dynamic var createdAt = NSDate()
}
