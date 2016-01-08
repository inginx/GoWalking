//
//  StartViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/22.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit
import KVNProgress
class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        inf.checklogin(loginCheck)
        inf.reflash()
        self.navigationController?.navigationBar.titleTextAttributes = navTitleAttribute
        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.tintColor = navBarTextColor
    }
    
    func loginCheck(x:Bool){
        if !x{
            inf.logout()
            let VC = inf.getVC("LoginVC")
            KVNProgress.showErrorWithStatus("登入过期", completion: { () -> Void in
                self.presentViewController(VC, animated: true, completion: nil)
            })
        }
    }
 
    
    @IBAction func StartButtonTap(sender: AnyObject) {
        let VC = inf.getVC("runningVC")
        presentViewController(VC, animated: true, completion: nil)
    }
}
