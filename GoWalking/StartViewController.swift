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

    @IBOutlet weak var runStartButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        inf.checklogin(loginCheck)
        inf.reflash()

        runStartButton.frame = CGRectMake(runStartButton.frame.origin.x, runStartButton.frame.origin.y, runStartButton.frame.width, runStartButton.frame.width)
        runStartButton.layer.cornerRadius = runStartButton.layer.frame.width/2
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
