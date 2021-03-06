//
//  extensions.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/2.
//  Copyright © 2016年 称一称. All rights reserved.
//
import Kingfisher
import Foundation

let sWidth = UIScreen.mainScreen().bounds.width
let sHeight = UIScreen.mainScreen().bounds.height
let navBarColor = UIColor(red: 44.0/255.0, green: 171.0/255.0, blue: 241.0/255.0, alpha: 1.0)
let navBarTextColor = UIColor.whiteColor()
let navTitleAttribute = NSDictionary(object: navBarTextColor,forKey: NSForegroundColorAttributeName) as! [String : AnyObject]


extension UIViewController {
//    func ChangeTitleColor() {
//        if self.isKindOfClass(UINavigationController.classForCoder()) {
//            self.changeNavigationBarTextColor(self as! UINavigationController)
//        }
//    }

    func changeNavigationBarTextColor() {
        let nav = self.navigationController
        nav!.navigationBar.titleTextAttributes = navTitleAttribute
        nav!.navigationBar.barTintColor = navBarColor
        nav!.navigationBar.tintColor = navBarTextColor
    }
}

extension UIView{
    func setRound(){
        dispatch_async(dispatch_get_main_queue()) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, self.frame.width)
            self.layer.cornerRadius = self.layer.frame.width/2
            if self.isKindOfClass(UIImageView){self.clipsToBounds = true}
        }
    }
}

extension NSDate{
    func toString(format:String = "yyyy-MM-dd hh:mm") -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}

extension UIImageView{
    func addPicFromUrl(x:String){
        if (x.rangeOfString("http") != nil){self.kf_setImageWithURL(NSURL(string:x)!);return}
        self.kf_setImageWithURL(NSURL(string:"http://7xq7zd.com1.z0.glb.clouddn.com/\(x)")!)
    }
}

extension UIImage{
    func saveWithName(filename:String)->NSURL{
        let imageData:NSData = UIImageJPEGRepresentation(self, 0.5)!
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fileURL = documentsURL.URLByAppendingPathComponent(filename)
        imageData.writeToURL(fileURL, atomically: false)
        return fileURL
    }
}

extension String{
    func isEmail()->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
        

    }
}
