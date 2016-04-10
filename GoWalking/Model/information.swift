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





class information: NSObject {
    let x = NSUserDefaults.standardUserDefaults()

    var username:String! , password:String!;
    var nickname = ""
    var avatar = "default.png"
    var mail = ""
    var introduce = ""
    var openid = ""

    var total_dis:Double = 0.0
    var today_dis:Double = 0.0

    var logined:Bool = false

    var tencentOAuth: TencentOAuth!
    
    override init(){
        super.init()
        if let a = x.objectForKey("username") as? String {username = a} else {username=""}
        if let a = x.objectForKey("password") as? String {password = a} else {password=""}
        if let a = x.objectForKey("nickname") as? String {nickname = a}
        if let a = x.objectForKey("avatar") as? String {avatar = a} else {avatar="default.png"}
        if let a = x.objectForKey("mail") as? String {mail = a} else {mail=""}
        if let a = x.objectForKey("introduce")as? String {introduce = a} else {introduce = ""}
        if let a = x.objectForKey("Tencentopenid")as? String {openid = a} else {openid = ""}

//        if let a = x.objectForKey("total_dis")as? Double {total_dis = a} else {total_dis = 0}
//        if let a = x.objectForKey("today_dis")as? Double {today_dis = a} else {today_dis = 0}
        self.计算路程()

        }
    
    func getVC(x:String)->UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewControllerWithIdentifier(x)
        return VC
    }
    
    func saveUser(){
        x.setObject(username, forKey: "username")
        x.setObject(password, forKey: "password")
        x.setObject(nickname, forKey: "nickname")
        x.setObject(introduce, forKey: "introduce")
        x.setObject(openid, forKey: "Tencentopenid")

//        x.setObject(today_dis, forKey: "today_dis")
//        x.setObject(total_dis, forKey: "total_dis")
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
        x.removeObjectForKey("username")
        x.removeObjectForKey("password")
        x.removeObjectForKey("nickname")
        x.removeObjectForKey("Tencentopenid")
        username = ""
        password = ""
        nickname = ""
        openid = ""
    }


    func 登录(errHandler:((String?)->())?=nil,completionHandler:(()->())?=nil){
        if password == "" && openid != ""{
            loginWithTencent(errHandler,completionHandler:completionHandler)
        }else{
            登录(inf.username,pwd: inf.password,errHandler:errHandler,completionHandler:completionHandler)
        }
    }


    func loginWithTencent(errHandler:((String?)->())?=nil,completionHandler:(()->())?=nil){
        let para = ["openid":openid]
        request(.POST, urls.tencentLogin,parameters:para).responseJSON(){
            s in guard let res = s.result.value else{return}
            if (res["status"] as! Bool){
                self.logined = true
                self.username = res["username"] as! String
                self.获取详细信息(completionHandler)
            }else{
                let error = res["Msg"] as! String
                print(error)
                if error == "haventReg"{errHandler?(error)}
                else{
                KVNProgress.showErrorWithStatus(error)
                errHandler?(error)
                }
            }

        }
    }

    func 登录(username:String,pwd:String,errHandler:((String)->())?=nil,completionHandler:(()->())?=nil){
        let para = ["user":username,"pwd":pwd]
        print("开始登录")
        Alamofire.request(.POST, urls.login,parameters:para).responseJSON(){
            s in
            print(s)
            guard let  res = s.result.value else{ KVNProgress.showErrorWithStatus("网络故障");return}
            let status = res["status"] as! Bool;
            if status == true{
                self.logined = true
                inf.username = username
                inf.password = pwd
                self.获取详细信息(completionHandler)
            }
            else {
                let error = res["Msg"] as! String
                KVNProgress.showErrorWithStatus(error)
                errHandler?(error)
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
            self.introduce = res["introduce"] as! String

            inf.saveUser()
            completionHandler?()
            self.计算路程()
        }

    }

    func 计算路程(Handler:(()->())? = nil){
        var dis = 0.0
        var todaydis = 0.0
        var secondCount = 0
        let todayDateS = NSDate().description
        let todayString = todayDateS.substringToIndex(todayDateS.startIndex.advancedBy(10))

        let history:[RunningData]!

        if let a = x.objectForKey("history") as? NSData {
            history = NSKeyedUnarchiver.unarchiveObjectWithData(a) as![RunningData]
        } else  { history = [] }

        for one in history{
            dis += one.distance
            secondCount += one.seconds
            if one.startTime.description.substringToIndex(one.startTime.description.startIndex.advancedBy(10)) == todayString{
                todaydis += one.distance
            }
        }
        today_dis = todaydis
        total_dis = dis
        self.saveUser()

        let para = ["total":dis,"today":todaydis]
        if logined{
            request(.POST, urls.rank,parameters:para)
        }

        Handler?()
    }

}




