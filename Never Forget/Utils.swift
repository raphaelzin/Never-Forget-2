//
//  Utils.swift
//  Never Forget
//
//  Created by Raphael Souza on 2016-09-20.
//  Copyright © 2016 com.raphael. All rights reserved.
//

import Foundation
import UIKit

import  UserNotifications
import UserNotificationsUI //framework to customize the notification

func imageWithImage(_ image: UIImage, newSize: CGSize) -> UIImage
{
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}

public extension UIFont
{
    public static func nfDefault(size:Int) -> UIFont
    {
        return UIFont(name: "AvenirNextCondensed-DemiBold", size: CGFloat(size))!
    }
}

extension UIImage {
    func urlOf(name:String) -> URL? {
        do {
            let imageData = UIImagePNGRepresentation(self)
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentDirectory = paths[0] as String
            let myFilePath = NSURL(fileURLWithPath: documentDirectory).appendingPathComponent(name)
            try imageData?.write(to: myFilePath!, options: .atomicWrite)
            let url = myFilePath! as URL
            return url
        } catch {
            NSLog("Could not save image to local directory!")
            return nil
        }
    }
}

class Utils
{
    static func scheduleNotification(operation:Operation)
    {
        if operation.notifyAt!.timeIntervalSinceNow < 0 { return }
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [operation.createdAt.description])
        let content = UNMutableNotificationContent()
        content.title = "Never forget"
        content.body = (operation.isDebt) ? "Remember that money you borrow!" : "Remember that money you lent!"
        content.categoryIdentifier = operation.notifyAt!.description
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: operation.notifyAt!.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(
            identifier: operation.createdAt.description, content: content, trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    static func defaultGradient(frame:CGRect)->CAGradientLayer
    {
        let gradient: CAGradientLayer = CAGradientLayer()
        let dark = UIColor(red: 58/255, green: 123/255, blue: 213/255, alpha: 1)
        let light = UIColor(red: 0, green: 210/255, blue: 255/255, alpha: 1)
        
        gradient.colors = [dark.cgColor,light.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
        return gradient
    }
    
    static func getFirstName(fullName:String?)->String?
    {
        if fullName == nil { return nil }
        return fullName?.characters.split {$0 == " "}.map { String($0) }[0]
    }
    
    static func getFormatedDate(date:Date)->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, EEEE"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func getFormatedTime(date:Date)->String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

