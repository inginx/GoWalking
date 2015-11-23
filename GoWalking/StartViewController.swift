//
//  StartViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/22.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        inf.checklogin(loginCheck)
    }
    
    func loginCheck(x:Bool){
        if !x{
            let VC = inf.getVC("LoginVC")
            presentViewController(VC, animated: true, completion: nil)
        }
    }
    
    @IBAction func StartButtonTap(sender: AnyObject) {
        let VC = inf.getVC("runningVC")
        presentViewController(VC, animated: true, completion: nil)
    }
}
