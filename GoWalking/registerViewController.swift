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

class registerViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var nicknameLabel: UITextField!
    @IBOutlet weak var mailLabel: UITextField!
    @IBOutlet weak var loginButton: MKButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.enabled = false
        loginButton.layer.borderWidth = 1
    }
    
    @IBAction func textfieldVauleChange(sender: AnyObject) {
        if usernameLabel.text?.characters.count > 3 &&
           passwordLabel.text?.characters.count > 5 &&
        nicknameLabel.text?.characters.count > 3 &&
        mailLabel.text?.characters.count > 3 &&
        mailLabel.text?.rangeOfString("@") != nil
        {
            loginButton.enabled = true
        }
        else {loginButton.enabled = false}
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resignResponder()
    }
    func resignResponder() {
        usernameLabel.resignFirstResponder()
        passwordLabel.resignFirstResponder()
        nicknameLabel.resignFirstResponder()
        mailLabel.resignFirstResponder()
        moveDown()
    }
    @IBAction func moveUp(sender: AnyObject) {
        let dis = sHeight - loginButton.frame.origin.y-loginButton.frame.size.height-216.0-10-36
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
    @IBAction func LoginButtonTap(sender: AnyObject) {
        resignResponder()
        let username = usernameLabel.text!
        let password = passwordLabel.text!
        let nickname = nicknameLabel.text!
        let mail = mailLabel.text!
        
        let userData =
        [
            "username":username,
            "pwd":password,
            "nickname":nickname,
            "email":mail
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
                    inf.username = username
                    inf.password = password
                    inf.nickname = nickname
                    let VC = inf.getVC("mainVC")
                    self.presentViewController(VC, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
}
