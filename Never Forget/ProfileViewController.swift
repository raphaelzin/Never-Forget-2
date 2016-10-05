//
//  ProfileViewController.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-25.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import UIKit
import FontAwesome_swift


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var cameraIcon: UIImageView!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var setButton: UIButton!
    @IBOutlet var userName: UIButton!
    @IBOutlet var pencilImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    var imagePicker : UIImagePickerController!
    
    let db:Database = Database()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.insertSublayer(Utils.defaultGradient(frame: self.view.frame), at: 0)
        self.title = "Profile"
        
        profilePicture.layer.cornerRadius = 80
        profilePicture.clipsToBounds = true
        
        setButton.backgroundColor = .clear
        setButton.layer.cornerRadius = 80
        setButton.clipsToBounds = true
        setButton.setTitle("Tap To Set", for: .normal)
        
        setButton.layer.borderColor = UIColor.white.cgColor
        setButton.layer.borderWidth = 1
        setButton.setTitleColor(.white, for: .normal)
        setButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)

        cameraIcon.image = UIImage.fontAwesomeIconWithName(.Camera, textColor: .white, size: CGSize(width: 48, height: 48))
        pencilImage.image = UIImage.fontAwesomeIconWithName(.Pencil, textColor: .white, size: CGSize(width: 60, height: 60))
        
        userName.setTitleColor(.white, for: .normal)
        userName.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 28)
        
        if db.getUserName() == nil || (db.getUserName()?.isEmpty)!
        {
            userName.setTitle("Tap to set name", for: .normal)
        }
        else
        {
            userName.setTitle(db.getUserName()!, for: .normal)
        }
        if db.getUserPicture() != nil
        {
            setButton.isHidden = true
            profilePicture.image = db.getUserPicture()
        }
        
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.setImageAction(_:)))
        cameraIcon.addGestureRecognizer(tap)
        cameraIcon.isUserInteractionEnabled = true
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        
        
    }
    
    @IBAction func setName(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Enter your name", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            print("OK Pressed")
            
            if !(alertController.textFields?[0].text?.isEmpty)!
            {
                self.db.setUserName(name: (alertController.textFields?[0].text!)!)
                self.userName.setTitle((alertController.textFields?[0].text!)!, for: .normal)
                let notificationName = Notification.Name("tableReload")
                NotificationCenter.default.post(name: notificationName, object: nil)
                print("Name Set")
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("Cancel")
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Your Name"
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .yes
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profilePicture.contentMode = .scaleAspectFit
            profilePicture.image = imageWithImage(pickedImage, newSize: CGSize(width: 200, height: 200))
            db.setUserPicture(picData: profilePicture.image!)
            
            let notificationName = Notification.Name("tableReload")
            NotificationCenter.default.post(name: notificationName, object: nil)
            setButton.isHidden = true
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "overall", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Credit"
            cell.detailTextLabel?.text = "$ " + (NSString(format: "%.2f", db.get(type: "credit")) as String)
        case 1:
            cell.textLabel?.text = "Debt"
            cell.detailTextLabel?.text = "$ " + (NSString(format: "%.2f", db.get(type: "debt")) as String)
        case 2:
            cell.textLabel?.text = "Total"
            let total = db.get(type: "credit") - db.get(type: "debt")
            cell.detailTextLabel?.text = "$ " + (NSString(format: "%.2f", total) as String)
        default:
            print("Nothing to do on default")
            
        }
        
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        
        cell.textLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)
        cell.detailTextLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 22)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
}
