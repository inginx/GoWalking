//
//  LoginViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/22.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit
import KVNProgress
import Alamofire
class LoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var username: MKTextField!
    
    @IBOutlet weak var password: MKTextField!
    
    @IBOutlet weak var loginButton: MKButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderWidth = 1
        loginButton.enabled = false

    }
    
    
    @IBAction func LoginTap(sender: AnyObject) {
        KVNProgress.showWithStatus("加载中")
        let user = (username.text)!
        let pwd = (password.text)!
        
        登录(user,pwd: pwd)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField.tag == 1{
            password.becomeFirstResponder()
            return true
        }
        moveDown()
        password.resignFirstResponder()
        return true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        username.resignFirstResponder()
        password.resignFirstResponder()
        moveDown()
    }
    
    @IBAction func moveUp(sender: MKTextField) {
        let dis = sHeight - loginButton.frame.origin.y-loginButton.frame.size.height-216.0-10
        if dis<0.0{
            UIView.animateWithDuration(0.3){
                self.view.frame=CGRect(x: 0,y: dis,width: sWidth,height: sHeight)
            }
        }

    }
    
    func moveDown(){
        UIView.animateWithDuration(0.3){
            self.view.frame=CGRect(x: 0,y: 0,width: sWidth,height: sHeight)
        }
    }


    @IBAction func textVauleChange(sender: MKTextField) {
        if username.text?.characters.count > 3 && password.text?.characters.count >= 3{
            loginButton.enabled = true
        }
        else {
            loginButton.enabled = false
        }
    }
    
    func 登录(username:String,pwd:String){
        let para = ["user":username,"pwd":pwd]
        print("开始登录")
        Alamofire.request(.POST, "https://learning2learn.cn/py/gowalking/login",parameters:para).responseJSON(){
            s in
            print(s)
            guard let  res = s.result.value else{ KVNProgress.showErrorWithStatus("网络故障");return}
            let status = res["status"] as! Bool;
            if status == true{
                inf.username = (self.username.text)!
                inf.password = (self.password.text)!
                self.获取详细信息()
            }
            else {
                let error = res["Msg"] as! String
                KVNProgress.showErrorWithStatus(error)
            }
        }
    }
    
    func 获取详细信息(){
        print("获取详细信息")
        Alamofire.request(.GET, "https://learning2learn.cn/py/gowalking/person").responseJSON(){
            s in
            
            print(s)
            guard let res = s.result.value else{KVNProgress.showErrorWithStatus("服务器故障");return}
            if res["success"]as!Bool == false {KVNProgress.showErrorWithStatus("获取信息失败");return}
            inf.nickname = res["nickname"] as! String
            self.登录完成()
        }
        
    }
    func 登录完成(){
        inf.saveUser()
        KVNProgress.dismiss()
        let mainVC = inf.getVC("mainVC")
        self.presentViewController(mainVC, animated: true, completion: nil)
    }
}


