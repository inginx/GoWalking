//
//  person.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/22.
//  Copyright © 2015年 称一称. All rights reserved.
//
import Alamofire
import KVNProgress
import UIKit

var inf = information()
let sWidth = UIScreen.mainScreen().bounds.width
let sHeight = UIScreen.mainScreen().bounds.height
let navBarColor = UIColor(red: 44.0/255.0, green: 171.0/255.0, blue: 241.0/255.0, alpha: 1.0)
let navBarTextColor = UIColor.whiteColor()
let navTitleAttribute = NSDictionary(object: navBarTextColor,forKey: NSForegroundColorAttributeName) as! [String : AnyObject]

let urls = url()

class url{
    let login = "https://learning2learn.cn/gowalking/login"
    let detail = "https://learning2learn.cn/gowalking/person"
    let circleFeed = "https://learning2learn.cn/gowalking/friends/content"
    let uploadAvatar = "https://learning2learn.cn/gowalking/uploadavatar/"
    let uploadInfo = "https://learning2learn.cn/gowalking/uploadinfo/"
}


class information: NSObject {
    var username:String! , password:String!;
    var nickname = ""
    var avatar = "default.png"
    var mail = ""

    
    override init(){
        let x = NSUserDefaults.standardUserDefaults()
        if let a = x.objectForKey("username") as? String {username = a} else {username=""}
        if let a = x.objectForKey("password") as? String {password = a} else {password=""}
        if let a = x.objectForKey("nickname") as? String {nickname = a}
        if let a = x.objectForKey("avatar") as? String {avatar = a} else {avatar="default.png"}
        if let a = x.objectForKey("mail") as? String {mail = a} else {mail=""}
        }
    
    func getVC(x:String)->UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewControllerWithIdentifier(x)
        return VC
    }
    
    func saveUser(){
        let x = NSUserDefaults.standardUserDefaults()
        x.setObject(username, forKey: "username")
        x.setObject(password, forKey: "password")
        x.setObject(nickname, forKey: "nickname")
    }
    
    func checklogin(completionHandler:(Bool)->Void){
        let para = ["user":username,"pwd":password]
        Alamofire.request(.POST, urls.login,parameters:para).responseJSON{
            s in
            print(s)
            guard let res = s.result.value else{completionHandler(true);return}
            let status = res["status"] as!Bool
            if status{
                completionHandler(true)
            }
            else{
                completionHandler(false)
            }
                
        }
    }
    
    func logout(){
        let x = NSUserDefaults.standardUserDefaults()
        x.removeObjectForKey("username")
        x.removeObjectForKey("password")
        x.removeObjectForKey("nickname")
        username = ""
        password = ""
        nickname = ""
    }


    func 登录(errHandler:(()->())?=nil,completionHandler:(()->())?=nil){
        登录(inf.username,pwd: inf.password,errHandler:errHandler,completionHandler:completionHandler)
    }

    func 登录(username:String,pwd:String,errHandler:(()->())?=nil,completionHandler:(()->())?=nil){
        let para = ["user":username,"pwd":pwd]
        print("开始登录")
        Alamofire.request(.POST, urls.login,parameters:para).responseJSON(){
            s in
            print(s)
            guard let  res = s.result.value else{ KVNProgress.showErrorWithStatus("网络故障");return}
            let status = res["status"] as! Bool;
            if status == true{
                inf.username = username
                inf.password = pwd
                self.获取详细信息(completionHandler)
            }
            else {
                let error = res["Msg"] as! String
                KVNProgress.showErrorWithStatus(error)
                errHandler?()
            }
        }
    }

    func 获取详细信息(completionHandler:(()->())?=nil){
        print("获取详细信息")
        Alamofire.request(.GET, urls.detail).responseJSON(){
            s in
            guard let res = s.result.value else{KVNProgress.showErrorWithStatus("服务器故障");return}
            if res["success"]as!Bool == false {KVNProgress.showErrorWithStatus("获取信息失败");return}
            self.nickname = res["nickname"] as! String
            self.avatar = res["avatar"]as! String
            self.mail = res["mail"]as!String
            inf.saveUser()
            completionHandler?()
        }

    }

}

func getPicUrl(x:String) -> NSURL{
    return NSURL(string:"http://7xq7zd.com1.z0.glb.clouddn.com/\(x)")!
}


extension UIViewController {
    func viewDidLoadForChangeTitleColor() {
        self.viewDidLoadForChangeTitleColor()
        if self.isKindOfClass(UINavigationController.classForCoder()) {
            self.changeNavigationBarTextColor(self as! UINavigationController)
        }
    }

    func changeNavigationBarTextColor(navController: UINavigationController) {
        let nav = navController as UINavigationController
        nav.navigationBar.titleTextAttributes = navTitleAttribute
        nav.navigationBar.barTintColor = navBarColor
        nav.navigationBar.tintColor = navBarTextColor

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
