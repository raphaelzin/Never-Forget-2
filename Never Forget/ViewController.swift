//
//  ViewController.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-20.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import FontAwesome_swift
import Eureka
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    
    var noOperations:UILabel!
    
    let db:Database = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Main"
        
        self.view.layer.insertSublayer(Utils.defaultGradient(frame: self.view.frame), at: 0)
        tableView?.backgroundColor = .clear
        tableView.separatorColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        addButton.backgroundColor = .white
        addButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 24)
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(UIColor(red: 0, green: 210/255, blue: 255/255, alpha: 1), for: .normal)

        addButton.layer.shadowRadius = 6
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowOpacity = 0.5
        
        addButton.layer.masksToBounds = false
        addButton.layer.cornerRadius = 6
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(24)] as Dictionary!
        navigationItem.leftBarButtonItem = UIBarButtonItem(title:String.fontAwesomeIconWithName(FontAwesome.Gear), style: .plain, target: self, action: #selector(ViewController.settings))
        
        navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:String.fontAwesomeIconWithName(FontAwesome.Users), style: .plain, target: self, action: #selector(ViewController.contacts))
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        
        
        let notificationName = Notification.Name("tableReload")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.reloadData), name: notificationName, object: nil)
        
        noOperations = UILabel(frame: CGRect(x:0, y:0, width:200, height:120))
        noOperations.center = CGPoint(x:view.frame.size.width/2, y:view.frame.size.height/2)
        noOperations.textAlignment = .center
        noOperations.text = "You have no borrows or lends to be reminded of!"
        noOperations.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 24)
        noOperations.textColor = .white
        noOperations.numberOfLines = 3
        self.view.addSubview(noOperations)
        if tableView.numberOfSections == 0 { noOperations.isHidden = false }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details"
        {
            let details = segue.destination as! DetailsViewController
            details.op = sender as! Operation
        }
    }
    
    @IBAction func addOperationAction(_ sender: AnyObject) {
        performSegue(withIdentifier: "addOperation", sender: nil)
    }
    
    func settings()
    {
        performSegue(withIdentifier: "profile", sender: nil)
    }
    
    func contacts()
    {
        performSegue(withIdentifier: "contacts", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        if tableView.numberOfSections > 0
        {
            noOperations.isHidden = true
        }
    }
    
    func reloadData()
    {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && db.getOperations().filter("isPaid == false").count > 0
        {
            return db.getOperations().filter("isPaid == false").count
        }
        return db.getOperations().filter("isPaid == true").count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (db.getOperations().filter("isPaid == false").count == 0 && db.getOperations().filter("isPaid == true").count == 0)
        {
            return 0
        }
        if (db.getOperations().filter("isPaid == false").count != 0 && db.getOperations().filter("isPaid == true").count != 0)
        {
            return 2
        }
        return 1
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let op = db.getOperations()[indexPath.row]
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("Delete",comment: "Delete Cell Action"), handler:{(action:UITableViewRowAction,indexPath:IndexPath) -> Void in
            
            self.tableView.beginUpdates()
            if tableView.numberOfRows(inSection: indexPath.section) == 1
            {
                self.tableView.deleteSections([indexPath.section], with: .left)
            }
            else
            {
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
            self.db.deleteOperation(op: op)
            self.tableView.endUpdates()
            if self.tableView.numberOfSections == 0 { self.noOperations.isHidden = false }
            
        })
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "operation", for: indexPath) as! OperationTableViewCell
        let op:Operation!
        if indexPath.section == 0 && db.getOperations().filter("isPaid == false").count > 0
        {
            op = db.getOperations().filter("isPaid == false")[indexPath.row]
        }
        else
        {
            op = db.getOperations().filter("isPaid == true")[indexPath.row]
        }
        
        cell.arrowImage.image = UIImage(named: "Arrow")
        cell.amount.text = "$" + (NSString(format: "%.2f", op.amount) as String)
        cell.userName.text = (db.getUserName() == nil) ? "" : Utils.getFirstName(fullName: db.getUserName()!)
        cell.contactName.text = (db.getContactForID(id: op.hisID) != nil) ? Utils.getFirstName(fullName: (db.getContactForID(id: op.hisID)?.name)!) : ""
        cell.userImage.image = (db.getUserPicture() != nil) ? db.getUserPicture() : UIImage(named: "userDefault")

        if !op.isDebt { cell.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)); }
        
        if db.getContactForID(id: op.hisID) != nil && UIImage(data: db.getContactForID(id: op.hisID)?.image as! Data) != nil
        {
            cell.contactImage.image = UIImage(data: db.getContactForID(id: op.hisID)?.image as! Data)
        }
        else
        {
            cell.contactImage.image = UIImage(named: "userDefault")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && db.getOperations().filter("isPaid == false").count > 0
        {
            self.performSegue(withIdentifier: "details", sender: db.getOperations().filter("isPaid == false")[indexPath.row])
        }
        else
        {
            self.performSegue(withIdentifier: "details", sender: db.getOperations().filter("isPaid == true")[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            if (db.getOperations().filter("isPaid == false").count > 0)
            {
                return NSLocalizedString("Not Paid", comment: "not paid section title")
            }
        }
        if (db.getOperations().filter("isPaid == false").count == 0 && db.getOperations().filter("isPaid == true").count == 0)
        {
            return  ""
        }
        return NSLocalizedString("Paid", comment: "paid section title")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 34))
        headerView.backgroundColor = .white
        header.backgroundView = headerView
        header.backgroundColor = .white
        
        
        if let textlabel = header.textLabel {
            textlabel.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)
            textlabel.textColor = Colors.light
            
            if db.getOperations().filter("isPaid == false").count == 0 && db.getOperations().filter("isPaid == true").count == 0
            {
                textlabel.text = ""
            }
            
            if section == 0{
                if db.getOperations().filter("isPaid == false").count > 0
                {
                    textlabel.text = NSLocalizedString("Not Paid", comment: "not paid section title")
                }
                else
                {
                    textlabel.text = NSLocalizedString("Paid", comment: "paid section title")
                }
            }
            if section == 1
            {
                if db.getOperations().filter("isPaid == true").count > 0
                {
                    textlabel.text = NSLocalizedString("Paid", comment: "paid section title")
                }
                else
                {
                    textlabel.text = ""
                }
            }
        }
    }
}

