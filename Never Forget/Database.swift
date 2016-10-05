//
//  Database.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-23.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import Foundation
import RealmSwift


class Database: NSObject {
    
    var operations : Results<Operation>!
    
    
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
    
    func initiateUser()
    {
        let user = User()
        user.name = ""
        user.image = NSData()
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
    }
    
    func setUserPicture(picData:UIImage)
    {
        //##########################################################
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
    }
    
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
    
    func getOperations()->Results<Operation>
    {
        return uiRealm.objects(Operation.self)
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
}

class User: Object
{
    dynamic var image = NSData()
    dynamic var name = ""
}
