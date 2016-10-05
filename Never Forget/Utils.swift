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

class Utils
{
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

