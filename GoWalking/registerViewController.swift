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


class registerViewController: UIViewController{


    @IBOutlet weak var regidstButton: MKButton!
    @IBOutlet weak var contaniner: UIView!
    var registerTable:registerviewDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        let x = childViewControllers.last as! RegistTableViewController
        registerTable = x
    }

    @IBAction func RegistButtionTap(sender: AnyObject) {
        registerTable.regist()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        registerTable.resignResponder()

    }

}


class RegistTableViewController: UITableViewController,UITextViewDelegate ,registerviewDelegate{


    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var mail: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
    }

    func resignResponder() {
        username.resignFirstResponder()
        password.resignFirstResponder()
        nickname.resignFirstResponder()
        mail.resignFirstResponder()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resignResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool{
        switch textField.tag{
        case 101:password.becomeFirstResponder()
        case 102:nickname.becomeFirstResponder()
        case 103:mail.becomeFirstResponder()
        default:textField.resignFirstResponder()
        }

        return true
    }

    func regist() {
        if username.text! == "" {KVNProgress.showErrorWithStatus("用户名不能为空");return}
        if password.text?.characters.count < 5{KVNProgress.showErrorWithStatus("密码至少为6位");return}
        if nickname.text?.characters.count <= 3{KVNProgress.showErrorWithStatus("昵称至少为3位");return}
        if mail.text?.characters.count < 3 || mail.text?.rangeOfString("@") == nil{KVNProgress.showErrorWithStatus("邮箱不合法");return}


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
