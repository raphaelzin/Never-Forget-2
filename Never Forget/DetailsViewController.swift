//
//  DetailsViewController.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-27.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit
import  UserNotifications
import FontAwesome_swift

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var userPic: UIImageView!
    @IBOutlet var arrowImage: UIImageView!
    @IBOutlet var contactPic: UIImageView!
    @IBOutlet var amount: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var contactName: UILabel!
    @IBOutlet var tableView: UITableView!
    let db:Database = Database()
    var op:Operation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.insertSublayer(Utils.defaultGradient(frame: self.view.frame), at: 0)
        
        title = "Details"
        
        userPic.layer.cornerRadius = 50
        contactPic.layer.cornerRadius = 50
        userPic.clipsToBounds = true
        contactPic.clipsToBounds = true
        
        tableView.allowsSelection = false
        tableView.separatorColor = Colors.light
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let px = 1 / UIScreen.main.scale
        let frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: px)
        let line: UIView = UIView(frame: frame)
        tableView.tableHeaderView = line
        line.backgroundColor = tableView.separatorColor
        
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(28)] as Dictionary!
        navigationItem.rightBarButtonItem = UIBarButtonItem(title:String.fontAwesomeIconWithName(FontAwesome.Edit), style: .plain, target: self, action: #selector(DetailsViewController.editOperation))
        
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshContent()
        tableView.reloadData()
    }
    
    func refreshContent()
    {
        let contact = db.getContactForID(id: op.hisID)
        userPic.image = db.getUserPicture()
        
        userName.text = (Utils.getFirstName(fullName: db.getUserName()) != nil) ? Utils.getFirstName(fullName: db.getUserName()!) : ""
        arrowImage.image = UIImage(named: "Arrow")
        if !op.isDebt { arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI)) }
        amount.text = "$ " + (NSString(format: "%.2f", op.amount) as String)
        
        amount.textColor = .white
        userName.textColor = .white
        contactName.textColor = .white
        
        contactPic.image = (contact == nil || UIImage(data: contact?.image as! Data) == nil) ? UIImage(named: "userDefault") : UIImage(data: contact?.image as! Data)
        contactName.text = Utils.getFirstName(fullName: contact?.name)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "opDetails", for: indexPath)
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Details"
            cell.detailTextLabel?.text = op.details
        case 1:
            cell.textLabel?.text = "When"
            cell.detailTextLabel?.text = Utils.getFormatedDate(date: op.when as Date)
        case 2:
            cell.textLabel?.text = "Paid?"
            cell.detailTextLabel?.text = ""
            let paidSwich = UISwitch()
            paidSwich.addTarget(self, action: #selector(DetailsViewController.switcher), for: .valueChanged)
            paidSwich.isOn = op.isPaid
            paidSwich.onTintColor = Colors.light
            cell.accessoryView = paidSwich
        case 3:
            cell.textLabel?.text = "Notification"
            cell.detailTextLabel?.text = Utils.getFormatedTime(date: op.notifyAt as! Date)
        default:
            print("Nothing to do here")
        }
        
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        
        cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)
        cell.detailTextLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)
        
        return cell
    }
    
    func editOperation()
    {
        performSegue(withIdentifier: "edit", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"
        {
            let editView = segue.destination as! EditOperationViewController
            editView.op = self.op
        }
    }
    
    func switcher()
    {
        do
        {
            try uiRealm.write({ () -> Void in
                op.isPaid = !op.isPaid
            })
        }
        catch
        {
            print("nops")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (op.notifyAt != nil) ? 4 : 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
