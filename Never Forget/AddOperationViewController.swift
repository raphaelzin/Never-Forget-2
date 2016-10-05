//
//  AddOperationViewController.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-22.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit
import Eureka
import FontAwesome_swift
import UserNotifications

class AddOperationViewController: FormViewController {

    @IBOutlet var saveButton: UIButton!
    let db = Database()
    var op:Operation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add"
        tableView?.separatorColor = .clear
        tableView?.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        
        
        form +++ Section()
            <<< TextRow("name"){ row in
                row.title = "Name"
                row.placeholder = "Ex: Raphael"
                row.placeholderColor = Colors.light
                
                }.cellSetup{ cell, row in
                    cell.backgroundColor = .clear
                    
                    cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!+5)
                }.cellUpdate{cell, row in
                    cell.textLabel?.textColor = .white
                    cell.textField.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!)
                    cell.textField.textColor = Colors.light
            }
            
            <<< DecimalRow("amount"){
                $0.title = "Amount"
                $0.placeholder = "Ex: 8,63"
                $0.placeholderColor = Colors.light
                $0.formatter = DecimalFormatter()
                $0.useFormatterDuringInput = true
                }.cellSetup{ cell, row in
                    cell.backgroundColor = .clear
                    cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!+5)
                    
                }.cellUpdate{cell, row in
                    cell.textLabel?.textColor = .white
                    cell.textField.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!)
                    cell.textField.textColor = Colors.light
            }
            
            <<< TextRow("details"){ row in
                row.title = "Details"
                row.placeholder = "Ex: Pizza, Diner"
                row.placeholderColor = Colors.light
                
                
                }.cellSetup{ cell, row in
                    cell.backgroundColor = .clear
                    cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!+5)
                }.cellUpdate{cell, row in
                    cell.textLabel?.textColor = .white
                    cell.textField.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!)
                    cell.textField.textColor = Colors.light
            }
            
            <<< DateRow("when"){
                $0.title = "When"
                $0.value = NSDate() as Date
                }.cellSetup{ cell, row in
                    cell.backgroundColor = .clear
                    cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!+5)
                }.cellUpdate{cell, row in
                    cell.textLabel?.textColor = .white
                    cell.detailTextLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!)
                    cell.detailTextLabel?.textColor = Colors.light
            }
            
            <<< SwitchRow("switchReminder")
            {
                $0.title = "Remind Me"
            }.cellSetup{ cell, row in
                cell.backgroundColor = .clear
                cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!+5)
            }.cellUpdate{cell, row in
                cell.switchControl?.onTintColor = Colors.light
                cell.switchControl?.isOn = false
                cell.textLabel?.textColor = .white
                cell.detailTextLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!)
                cell.detailTextLabel?.textColor = Colors.light
            }
            
            <<< DateRow("reminder"){
                
                $0.hidden = Condition.function(["switchReminder"], { form in
                    return !((form.rowBy(tag:"switchReminder") as? SwitchRow)?.value ?? false)
                })
                $0.title = "Notify Me At"
                $0.value = NSDate() as Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, HH:mm"
                $0.dateFormatter =  dateFormatter
                }.cellSetup{ cell, row in
                    cell.backgroundColor = .clear
                    cell.datePicker.datePickerMode = .dateAndTime
                    cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!+5)
                }.cellUpdate{cell, row in
                    cell.textLabel?.textColor = .white
                    cell.detailTextLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: (cell.textLabel?.font.pointSize)!)
                    cell.detailTextLabel?.textColor = Colors.light
                    cell.detailTextLabel?.text = Utils.getFormatedTime(date: cell.datePicker.date)
            }
        
            <<< SegmentedRow<String>("borrow")
                {
                    $0.options = ["I Lent", "I Borrow"]
                    $0.value = "I Lent"
                }.cellSetup{ cell, row in
                    cell.backgroundColor = .clear
                }.cellUpdate{cell, row in
                    cell.segmentedControl.tintColor = .white
            }
        
 
        let gradient: CAGradientLayer = CAGradientLayer()
 
        gradient.colors = [Colors.dark.cgColor,Colors.light.cgColor]
        gradient.locations = [0.0 , 1.0]
        
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, at: 0)
        
        tableView?.backgroundColor = .clear
        
        saveButton.backgroundColor = .white
        saveButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 24)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor(red: 0, green: 210/255, blue: 255/255, alpha: 1), for: .normal)
        
        saveButton.layer.shadowRadius = 6
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveButton.layer.shadowOpacity = 0.5
        saveButton.layer.masksToBounds = false
        saveButton.layer.cornerRadius = 6
        saveButton.superview?.bringSubview(toFront: saveButton)
    }
    

    @IBAction func saveAction(_ sender: AnyObject)
    {
        let values = form.values()
        
        if values["amount"]! == nil || values["name"]! == nil || values["details"]! == nil
        {
            let alertController = UIAlertController(title: "Can't Save", message: "You have to fill all fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                print("OK Pressed")
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        op = Operation()
        op.amount = values["amount"]! as! Double
        op.details = values["details"] as! String
        op.when = values["when"] as! NSDate
        
        if (values["borrow"] as! String) == "I Lent"
        {
            op.isDebt = false
        }
        else
        {
            op.isDebt = true
        }
        
        if values["switchReminder"]! != nil && (values["switchReminder"]! as! Bool) == true
        {
            scheduleNotification(when: values["reminder"] as! NSDate)
            op.notifyAt = values["reminder"] as? NSDate
        }
        
        print(values["name"] as! String)
        
        let name = (values["name"] as! String).trimmingCharacters(in: .whitespaces)
        
        if db.getContactByName(name: name) == nil
        {
            let contact = Contact()
            contact.name = name
            contact.id = db.mkID()
            op.hisID = contact.id
            db.addContact(newContact: contact)
        }
        else
        {
            let contact = db.getContactByName(name: name)
            op.hisID = (contact?.id)!
        }
        
        db.addOperation(newOperation: op)
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    func scheduleNotification(when:NSDate)
    {
        let content = UNMutableNotificationContent()
        content.title = "Never forget"
        content.body = (op.isDebt) ? "Remember that money you borrow!" : "Remember that money you lent!"
        content.categoryIdentifier = when.description
        
        print("Trigger in \(when.timeIntervalSinceNow)s")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: when.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(
            identifier: op.createdAt.description, content: content, trigger: trigger
        )
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
