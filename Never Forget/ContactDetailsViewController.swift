//
//  ContactDetailsViewController.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-29.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ContactDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var contactPicture: UIImageView!
    @IBOutlet var nameButton: UIButton!
    @IBOutlet var pencilIcon: UIImageView!
    @IBOutlet var setPicButton: UIButton!
    @IBOutlet var cameraIcon: UIImageView!
    @IBOutlet var tableView: UITableView!
    var imagePicker : UIImagePickerController!
    
    @IBOutlet var lent: UILabel!
    @IBOutlet var borrow: UILabel!
    @IBOutlet var total: UILabel!
    
    let db:Database = Database()
    var operations:[Operation]!
    
    var contact:Contact!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contact"
        self.view.layer.insertSublayer(Utils.defaultGradient(frame: self.view.frame), at: 0)
        
        tableView.register(UINib(nibName: "OperationInContactTableViewCell", bundle: nil), forCellReuseIdentifier: "opContact")
        
        contactPicture.layer.cornerRadius = 80
        contactPicture.clipsToBounds = true
        
        setPicButton.backgroundColor = .clear
        setPicButton.layer.cornerRadius = 80
        setPicButton.clipsToBounds = true
        setPicButton.setTitle("Tap To Set", for: .normal)
        
        setPicButton.layer.borderColor = UIColor.white.cgColor
        setPicButton.layer.borderWidth = 1
        setPicButton.setTitleColor(.white, for: .normal)
        setPicButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)
        
        cameraIcon.image = UIImage.fontAwesomeIconWithName(.Camera, textColor: .white, size: CGSize(width: 48, height: 48))
        pencilIcon.image = UIImage.fontAwesomeIconWithName(.Pencil, textColor: .white, size: CGSize(width: 60, height: 60))
        
        nameButton.setTitleColor(.white, for: .normal)
        nameButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 28)
        nameButton.setTitle(contact.name, for: .normal)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.setImageAction(_:)))
        cameraIcon.addGestureRecognizer(tap)
        cameraIcon.isUserInteractionEnabled = true
        
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        
        let total = db.get(type: "credit", contact: contact.id) - db.get(type: "debt", contact: contact.id)
        lent.text = "$" + (NSString(format: "%.2f", db.get(type: "credit", contact: contact.id)) as String)
        borrow.text = "$" + (NSString(format: "%.2f", db.get(type: "debt", contact: contact.id)) as String)
        self.total.text = "$" + (NSString(format: "%.2f", total) as String)
        lent.textColor = Colors.light
        borrow.textColor = .red
        self.total.textColor = .white
        
        if UIImage(data: contact?.image as! Data) != nil
        {
            setPicButton.isHidden = true
            contactPicture.image = UIImage(data: contact?.image as! Data)
        }
        
    }
    
    @IBAction func setName(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Enter your name", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            print("OK Pressed")
            
            if !(alertController.textFields?[0].text?.isEmpty)!
            {
                self.db.setContactName(contact: self.contact, name: (alertController.textFields?[0].text!)!)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTable"), object: nil)
                self.nameButton.setTitle((alertController.textFields?[0].text!)!, for: .normal)
                print("Name Set")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("Cancel")
        }
        
        alertController.addTextField { (textField) in}
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            contactPicture.contentMode = .scaleAspectFit
            contactPicture.image = imageWithImage(pickedImage, newSize: CGSize(width: 200, height: 200))
            
            let notificationName = Notification.Name("tableReload")
            NotificationCenter.default.post(name: notificationName, object: nil)
            
            db.setContactPicture(contact: contact, image: contactPicture.image!)
            setPicButton.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setImageAction(_ sender: AnyObject)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose Image Source", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let roll = UIAlertAction(title: "Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            return
        })
        
        optionMenu.addAction(camera)
        optionMenu.addAction(roll)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    //opDetailsContact
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "opDetailsContact"
        {
            let details = segue.destination as! DetailsViewController
            details.op = sender as! Operation
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "opDetailsContact", sender: operations[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "opContact", for: indexPath) as! OperationInContactTableViewCell
        
        cell.amountLabel.text = "$" + (NSString(format: "%.2f", operations[indexPath.row].amount) as String)
        cell.arrowImage.image = UIImage(named: "Arrow")
        if !operations[indexPath.row].isDebt
        {
            cell.arrowImage.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
        }
        cell.userImage.image = (db.getUserPicture() != nil) ? db.getUserPicture() : UIImage(named: "userDefault")
        cell.contactImage.image = (UIImage(data: contact.image as Data) != nil) ? UIImage(data: contact.image as Data) : UIImage(named: "userDefault")
        
        return cell
    }
}
