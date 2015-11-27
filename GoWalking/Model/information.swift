//
//  person.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/22.
//  Copyright © 2015年 称一称. All rights reserved.
//
import Alamofire

var inf = information()
let sWidth = UIScreen.mainScreen().bounds.width
let sHeight = UIScreen.mainScreen().bounds.height

class information: NSObject {
    var username:String! , password:String!;
    var nickname=""

    
    override init(){
        let x = NSUserDefaults.standardUserDefaults()
        if let a = x.objectForKey("username") as? String {username = a} else {username=""}
        if let a = x.objectForKey("password") as? String {password = a} else {password=""}
        if let a = x.objectForKey("nickname") as? String {nickname = a}
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
        Alamofire.request(.POST, "https://learning2learn.cn/py/gowalking/login",parameters:para).responseJSON{
            s in
            print(s)
            guard let res = s.result.value else{completionHandler(false);return}
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
    
    func reflash(completation:(()->Void)? = nil){
        print("reflash")
        Alamofire.request(.GET, "https://learning2learn.cn/py/gowalking/person").responseJSON(){
            s in
            guard let res = s.result.value else{return}
            if res["success"]as!Bool == false {return}
            inf.nickname = res["nickname"] as! String
            self.saveUser()
            if completation != nil
            {
                completation!()
            }
        }
    }

    





}
