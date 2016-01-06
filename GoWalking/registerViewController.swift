//
//  registerViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/24.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit
import KVNProgress
import Alamofire

protocol registerviewDelegate{
    func regist()
    func resignResponder()
}

class registerViewController: UIViewController {

//    @IBOutlet weak var loginButton: MKButton!

    var a = 5;
    var registerTable:registerviewDelegate?
//    var 
    override func viewDidLoad() {
        super.viewDidLoad()
//        loginButton.enabled = false
//        loginButton.layer.borderWidth = 1
        self.automaticallyAdjustsScrollViewInsets = false
//let x = containView.viewWithTag(2) as! RegistTableViewController
//        self.registerTable = x


    }

//    @IBAction func textfieldVauleChange(sender: AnyObject) {
//        if usernameLabel.text?.characters.count > 3 &&
//           passwordLabel.text?.characters.count > 5 &&
//        nicknameLabel.text?.characters.count > 3 &&
//        mailLabel.text?.characters.count > 3 &&
//        mailLabel.text?.rangeOfString("@") != nil
//        {
//            loginButton.enabled = true
//        }
//        else {loginButton.enabled = false}
//    }
//    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        registerTable?.resignResponder()
        print("test start")
        print(a)
    }
//    @IBAction func moveUp(sender: AnyObject) {
//        let dis = sHeight - loginButton.frame.origin.y-loginButton.frame.size.height-216.0-10-36
//        if dis<0.0{
//            UIView.animateWithDuration(0.3){
//                self.view.frame=CGRect(x: 0,y: dis,width: sWidth,height: sHeight)
//            }
//        }
//
//    }
//
//    func moveDown(){
//        UIView.animateWithDuration(0.3){
//            self.view.frame=CGRect(x: 0,y: 0,width: sWidth,height: sHeight)
//        }
//    }


}


class RegistTableViewController: UITableViewController,UITextViewDelegate ,registerviewDelegate{


    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var mail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

//        let x = inf.getVC("register") as! registerViewController
//        print(x)
//        x.a = 23
//        let x = self.parentViewController as! registerViewController
//        x.registerTable = self
        self.automaticallyAdjustsScrollViewInsets = false
    }


    

    func resignResponder() {
        username.resignFirstResponder()
        password.resignFirstResponder()
        nickname.resignFirstResponder()
        mail.resignFirstResponder()
    }


    func regist() {
        let user = username.text!
        let pwd = password.text!
        let nick = nickname.text!
        let email = mail.text!
        let userData =
        [
            "username":user,
            "pwd":pwd,
            "nickname":nick,
            "email":email
        ]

        KVNProgress.showWithStatus("请稍后")
        Alamofire.request(.POST, "https://learning2learn.cn/py/gowalking/register",parameters:userData).responseJSON{
            s in
            guard let res = s.result.value else {KVNProgress.showErrorWithStatus("服务器故障");return}
            print(res)
            if res["success"]as! Bool == false{
                KVNProgress.showErrorWithStatus(res["Msg"]as!String);
                return
            }
            else {
                KVNProgress.showSuccessWithStatus(res["Msg"]as!String){
                    s in
                    inf.username = user
                    inf.password = pwd
                    inf.nickname = nick
                    let VC = inf.getVC("mainVC")
                    self.presentViewController(VC, animated: true, completion: nil)
                }
            }
        }
    }

}
