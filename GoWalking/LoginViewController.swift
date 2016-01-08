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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.tintColor = navBarTextColor
        self.navigationController?.navigationBar.titleTextAttributes = navTitleAttribute
        x = childViewControllers.last as!LoginViewTable
    }
    
    

    @IBAction func LoginTap(sender: AnyObject) {
        x.login()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        x.resignFirstResponders()
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
            inf.username = self.usernamefield.text!
            inf.password = self.passwordfield.text!
            inf.saveUser()
            KVNProgress.dismiss()
            let vc = inf.getVC("mainVC")
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

}


