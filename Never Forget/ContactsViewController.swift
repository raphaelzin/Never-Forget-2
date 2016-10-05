//
//  ContactsViewController.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-28.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    let db = Database()
    var noContacts:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.insertSublayer(Utils.defaultGradient(frame: self.view.frame), at: 0)
        
        title = "Contacts"
        
        tableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: "contact")
        tableView?.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        noContacts = UILabel(frame: CGRect(x:0, y:0, width:220, height:120))
        noContacts.center = CGPoint(x:view.frame.size.width/2, y:view.frame.size.height/2)
        noContacts.textAlignment = .center
        noContacts.text = "You have no Contacts yet, add them by creating lends/borrows!"
        noContacts.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 24)
        noContacts.textColor = .white
        noContacts.numberOfLines = 3
        self.view.addSubview(noContacts)
        if db.getContacts().count != 0
        {
            noContacts.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as! ContactTableViewCell
        let contact = db.getContacts()[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.contactName.text = contact.name
        cell.contactName.textColor = .white
        
        cell.contactPicture.image = (UIImage(data: contact.image as Data) == nil) ? UIImage(named: "userDefault") : UIImage(data: contact.image as Data)
        cell.lentLabel.text = "$ " + (NSString(format: "%.2f", db.get(type: "credit", contact: contact.id)) as String)
        cell.lentLabel.textColor = UIColor(red: 110/255, green: 223/255, blue: 95/255, alpha: 1)
        cell.borrowLabel.text = "$ " + (NSString(format: "%.2f", db.get(type: "debt", contact: contact.id)) as String)
        cell.borrowLabel.textColor = .red//UIColor(red: 223/255, green: 70/255, blue: 63/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = db.getContacts()[indexPath.row]
        performSegue(withIdentifier: "contactDetails", sender: contact)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactDetails"
        {
            let detailsView = segue.destination as! ContactDetailsViewController
            detailsView.operations = [Operation]()
            for op in db.getOperations()
            {
                if op.hisID == (sender as! Contact).id
                {
                    detailsView.operations.append(op)
                }
            }
            
            detailsView.contact = sender as! Contact
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return db.getContacts().count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let contact = db.getContacts()[indexPath.row]
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("Delete",comment: "Delete Cell Action"), handler:{(action:UITableViewRowAction,indexPath:IndexPath) -> Void in
            self.db.deleteContact(contact: contact)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        })
        
        return [deleteAction]
        
    }

}
