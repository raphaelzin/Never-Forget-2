//
//  Database.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-23.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import Foundation
import RealmSwift
import CloudKit

class Database: NSObject {
    
    var operations : Results<Operation>!
    var ckdb = CloudKitDatabase()
    // MARK: User Methods
    
    override init()
    {
        super.init()
        let notificationName = Notification.Name("initUser")
        NotificationCenter.default.addObserver(self, selector: #selector(Database.initiateUser), name: notificationName, object: nil)
    }
    
    
    func getUserName() -> String?
    {
        if uiRealm.objects(User.self).count != 0
        {
            return uiRealm.objects(User.self)[0].name
        }
        else
        {
            return nil
        }
    }
    
    func setUserName(name:String)
    {
        
        let users = uiRealm.objects(User.self)
        if users.count == 0 { initiateUser() }
        do
        {
            try uiRealm.write { () -> Void in
                uiRealm.objects(User.self)[0].name = name
            }
        }catch
        {
            print("Could not set name")
        }
        print("Has cloud user? \(ckdb.hasCloudUser())")
        ckdb.setUserName(name: name, user: users[0])
        
    }
    
    func setUserPicture(picData:UIImage)
    {
        let users = uiRealm.objects(User.self)
        if users.count == 0 { initiateUser() }
        do
        {
            try uiRealm.write { () -> Void in
                uiRealm.objects(User.self)[0].image = UIImagePNGRepresentation(picData)! as NSData
            }
        }catch
        {
            print("Could not set Picture")
        }
        ckdb.setUserPicture(user: users[0], image: picData)
    }
    
    func getUserPicture()->UIImage?
    {
        if uiRealm.objects(User.self).count != 0
        {
            return UIImage(data: uiRealm.objects(User.self)[0].image as Data)
        }
        else
        {
            return nil
        }
    }
    
    func initiateUser()
    {
        
        
        let user = User()
        user.name = ""
        user.image = NSData()

        
        
//        if ckdb.hasCloudUser()
//        {
        user.name = ckdb.getUserName()
        user.createdAt = ckdb.getUserCreatedDate()
//        }
//        else
//        {
//            ckdb.initiateCKUser(user: user)
//        }
        
        do
        {
            try uiRealm.write { () -> Void in
                uiRealm.add(user)
            }
        }catch
        {
            print("Could not save User")
        }
        
    }
    
    // MARK: Contact Methods
    
    func setContactPicture(contact:Contact, image:UIImage)
    {
        do
        {
            try uiRealm.write { () -> Void in
                contact.image = UIImagePNGRepresentation(image)! as NSData
            }
        }catch
        {
            print("Could not save Operation")
        }
    }
    
    func setContactName(contact:Contact, name:String)
    {
        do
        {
            try uiRealm.write { () -> Void in
                contact.name = name
            }
        }catch
        {
            print("Could not save Operation")
        }
        
    }
    
    func getContacts()->Results<Contact>
    {
        return uiRealm.objects(Contact.self)
    }
    
    func getContactForID(id:Int)->Contact?
    {
        let contacts = uiRealm.objects(Contact.self)
        if contacts.count == 0
        {
            return nil
        }
        for i in 0...contacts.count-1
        {
            if contacts[i].id == id
            {
                return contacts[i]
            }
        }
        return nil
    }
    
    func getContactByName(name:String)->Contact?
    {
        let contacts = uiRealm.objects(Contact.self)
        if contacts.count == 0
        {
            return nil
        }
        for i in 0...contacts.count-1
        {
            print("\(contacts[i].name.lowercased()) == \(name.lowercased())")
            if contacts[i].name.lowercased() == name.lowercased()
            {
                print("Match!")
                return contacts[i]
            }
        }
        return nil
    }
    
    func addContact(newContact:Contact)
    {
        do
        {
            try uiRealm.write { () -> Void in
                uiRealm.add(newContact)
            }
        }catch
        {
            print("Could not save Operation")
        }
    }
    
    
    func deleteContact(contact:Contact)
    {
        do
        {
            
            try uiRealm.write({ () -> Void in
                uiRealm.delete(contact)
            })
        }
        catch
        {
            print("Can't Delete Contact")
        }
    }
    
    func mkID()->Int
    {
        if UserDefaults.standard.value(forKey: "ids") == nil
        {
            UserDefaults.standard.set(0, forKey: "ids")
            return 0
        }
        else
        {
            let id = UserDefaults.standard.value(forKey: "ids") as! Int
            UserDefaults.standard.set(id+1, forKey: "ids")
            return id+1
        }
    }
    
    
    // MARK: Operation Methods
    
    func deleteOperation(op:Operation)
    {
        do
        {
            
            try uiRealm.write({ () -> Void in
                uiRealm.delete(op)
            })
        }
        catch
        {
            print("Can't Delete Operation")
        }
    }
    
    
    func getOperations()->Results<Operation>
    {
        return uiRealm.objects(Operation.self)
    }
    
    
    func addOperation(newOperation:Operation)
    {
        do
        {
            try uiRealm.write { () -> Void in
                uiRealm.add(newOperation)
            }
        }catch
        {
            print("Could not save Operation")
        }
        
        
        let timestampAsString = String(format: "%f", newOperation.createdAt.timeIntervalSinceReferenceDate)
        let timestampParts = timestampAsString.components(separatedBy: ".")
        
        let userID = CKRecordID(recordName: timestampParts[0])
        let ckUser = CKRecord(recordType: "Operation", recordID: userID)
        
        ckUser.setObject(newOperation.amount as CKRecordValue?, forKey: "amount")
        ckUser.setObject(newOperation.createdAt as CKRecordValue?, forKey: "createdAt")
        ckUser.setObject(newOperation.details as CKRecordValue?, forKey: "details")
        ckUser.setObject(newOperation.hisID as CKRecordValue?, forKey: "hisID")
        ckUser.setObject(newOperation.isDebt as CKRecordValue?, forKey: "isDebt")
        ckUser.setObject(newOperation.isPaid as CKRecordValue?, forKey: "isPaid")
        ckUser.setObject(newOperation.notifyAt as CKRecordValue?, forKey: "notifyAt")
        ckUser.setObject(newOperation.when as CKRecordValue?, forKey: "when")

    }
    
    
    func get(type:String, contact:Int)->Double
    {
        let op = self.getOperations()
        if op.count == 0
        {
            return 0
        }
        var total:Double = 0
        for i in 0...op.count-1
        {
            if type == "debt" && op[i].isDebt && op[i].hisID == contact
            {
                total = total + op[i].amount
            }
            if type == "credit" && !op[i].isDebt  && op[i].hisID == contact
            {
                total = total + op[i].amount
            }
        }
        return total
        
    }
    
    func get(type:String)->Double
    {
        
        let op = self.getOperations()
        if op.count == 0
        {
            return 0
        }
        var total:Double = 0
        for i in 0...op.count-1
        {
            if type == "debt" && op[i].isDebt
            {
                total = total + op[i].amount
            }
            if type == "credit" && !op[i].isDebt
            {
                total = total + op[i].amount
            }
        }
        return total
    }
    
    func switchPaid(operation:Operation)
    {
        do
        {
            try uiRealm.write({ () -> Void in
                operation.isPaid = !operation.isPaid
            })
        }
        catch
        {
            print("nops")
        }
    }
    
    func editOperation(operation:Operation, editTo:Operation)
    {
        do
        {
            try uiRealm.write { () -> Void in
                operation.amount = editTo.amount
                operation.hisID = editTo.hisID
                operation.details = editTo.details
                operation.notifyAt = editTo.notifyAt
                operation.isDebt = editTo.isDebt
            }
        }catch
        {
            print("Could not update Operation")
        }
    }
}

