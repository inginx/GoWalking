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

class LoginViewController: UIViewController {


    var x:LoginViewTable!
    
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var container: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeNavigationBarTextColor()
        self.automaticallyAdjustsScrollViewInsets = false
        x = childViewControllers.last as!LoginViewTable
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "goToRegPage", name: "goToRegPage", object: nil)
        
    }
    
    func goToRegPage(){
        self.navigationController?.pushViewController(inf.getVC("register"), animated: true)
    }

    @IBAction func LoginTap(sender: AnyObject) {
        x.login()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        x.resignFirstResponders()
    }
    

    @IBAction func qqLogin(sender: AnyObject) {
        inf.tencentOAuth.authorize(["get_user_info","get_simple_userinfo"])

    }


    func loginFromOpenid(){
        if (self.presentingViewController != nil){
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }else{
            let vc = inf.getVC("mainVC")
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    @IBAction func close(sender:UIStoryboardSegue) {}
}


class LoginViewTable: UITableViewController,UITextViewDelegate {
    @IBOutlet weak var usernamefield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    
    func resignFirstResponders(){
        usernamefield.resignFirstResponder()
        passwordfield.resignFirstResponder()
    }
    @IBAction func textVauleChange(sender: AnyObject) {

    }

    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField.tag == 201{
            passwordfield.becomeFirstResponder()
            return true
        }
        passwordfield.resignFirstResponder()
        return true
    }


    func login(){

        if usernamefield.text?.characters.count < 3 || passwordfield.text?.characters.count <= 3{
            KVNProgress.showErrorWithStatus("还没填完整呢！")
            return
        }
        KVNProgress.showWithStatus("登录中")
        inf.登录(usernamefield.text!, pwd: passwordfield.text!){
            self.loginFinish()
        }
    }

    func loginFinish(){
        KVNProgress.dismiss()
        if (self.presentingViewController != nil){
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }else{
            let vc = inf.getVC("mainVC")
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }


}


