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

protocol ContainButtonDelegate{
    func moveUp()
    func moveDown()
    func enableButon()
    func disableButton()
}

class registerViewController: UIViewController,ContainButtonDelegate{


    @IBOutlet weak var regidstButton: MKButton!
    @IBOutlet weak var contaniner: UIView!
    var buttonOrignFrame:CGRect!
    var registerTable:registerviewDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        regidstButton.enabled = false
        self.automaticallyAdjustsScrollViewInsets = false
        let x = childViewControllers.last as! RegistTableViewController
        x.parentView = self
        self.registerTable = x

        buttonOrignFrame = regidstButton.frame




    }

    @IBAction func RegistButtionTap(sender: AnyObject) {
        registerTable.regist()
    }


    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        registerTable.resignResponder()
        moveDown()

    }
    func moveUp() {
        let dis = sHeight - regidstButton.frame.origin.y-regidstButton.frame.size.height-216.0-10-36
        if dis<0.0{
            UIView.animateWithDuration(0.3){
                self.regidstButton.frame=CGRect(x: self.buttonOrignFrame.origin.x,y: self.buttonOrignFrame.origin.y+dis,width: self.buttonOrignFrame.width,height: self.buttonOrignFrame.height)
            }
        }

    }

    func moveDown(){
        UIView.animateWithDuration(0.3){
            self.regidstButton.frame = self.buttonOrignFrame
        }
    }

    func enableButon() {
        regidstButton.enabled = true

    }
    func disableButton() {
        regidstButton.enabled = false
    }


}


class RegistTableViewController: UITableViewController,UITextViewDelegate ,registerviewDelegate{


    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var mail: UITextField!

    var parentView:ContainButtonDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
    }


    @IBAction func textChanged(sender: AnyObject) {
        if username.text?.characters.count > 3 &&
           password.text?.characters.count > 5 &&
        nickname.text?.characters.count > 3 &&
        mail.text?.characters.count > 3 &&
        mail.text?.rangeOfString("@") != nil
        {
            parentView?.enableButon()
        }
        else {
            parentView?.disableButton()
        }
    }


    func resignResponder() {
        username.resignFirstResponder()
        password.resignFirstResponder()
        nickname.resignFirstResponder()
        mail.resignFirstResponder()
    }


    @IBAction func EditBeginddd(sender: UITextView) {
        parentView?.moveUp()
        sender.text = ""
    }

    @IBAction func EditEnd(sender: UITextField) {
        if sender.text == ""{
            switch (sender.tag){
            case 101: sender.text = "用户名不能为空"
            case 102: sender.text = "长度6位或以上"
            case 103: sender.text = "长度3位或以上"
            case 104: sender.text = "支持主流邮箱"
            default:break

            }

        }
    }
    

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("end")
        resignResponder()
        parentView!.moveDown()

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
