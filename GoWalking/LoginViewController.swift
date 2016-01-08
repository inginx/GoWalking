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



class LoginViewController: UIViewController ,ContainButtonDelegate{


    var x:LoginViewTable!
    
    
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.enabled = false
        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.tintColor = navBarTextColor
        self.navigationController?.navigationBar.titleTextAttributes = navTitleAttribute
        x = childViewControllers.last as!LoginViewTable
        x.parent = self

    }
    
    

    @IBAction func LoginTap(sender: AnyObject) {
        x.login()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        print(loginButton.enabled)
        x.resignFirstResponders()
        moveDown()
    }
    
    func moveUp(){
//        let dis = sHeight - loginButton.frame.origin.y-loginButton.frame.size.height-216.0-10
//        if dis<0.0{
//            UIView.animateWithDuration(0.3){
//                self.view.frame=CGRect(x: 0,y: dis,width: sWidth,height: sHeight)
//            }
//        }
    }

    func moveDown(){
        UIView.animateWithDuration(0.3){
            self.view.frame=CGRect(x: 0,y: 0,width: sWidth,height: sHeight)
        }
    }

    func enableButon(){
        loginButton.enabled = true
    }
    func disableButton(){
        loginButton.enabled = false
    }


    @IBAction func close(sender:UIStoryboardSegue) {}
}


class LoginViewTable: UITableViewController,UITextViewDelegate {
    @IBOutlet weak var usernamefield: UITextField!
    @IBOutlet weak var passwordfield: UITextField!
    var parent:ContainButtonDelegate?

    func resignFirstResponders(){
        usernamefield.resignFirstResponder()
        passwordfield.resignFirstResponder()
    }
    @IBAction func textVauleChange(sender: AnyObject) {
        if usernamefield.text?.characters.count > 3 && passwordfield.text?.characters.count > 3{
            parent?.enableButon()
        }
        else {
            parent?.disableButton()
        }
    }

    @IBAction func EditBeginddd(sender: AnyObject) {
        (sender as! UITextField).text = ""
    }


    @IBAction func EditEnd(sender: UITextField) {
        if sender.text != "" {return}
        switch sender.tag{
        case 201:sender.text = "请输入用户名"
        case 202:sender.text = "..."
        default:break
        }
    }
    


    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if textField.tag == 201{
            passwordfield.becomeFirstResponder()
            return true
        }
        parent?.moveDown()
        passwordfield.resignFirstResponder()
        return true
    }


    func login(){
        KVNProgress.showWithStatus("登录中")
        inf.登录(usernamefield.text!, pwd: passwordfield.text!){
            inf.username = self.usernamefield.text!
            inf.password = self.passwordfield.text!
            inf.saveUser()
            KVNProgress.dismiss()
            let vc = inf.getVC("mainVC")
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

}


