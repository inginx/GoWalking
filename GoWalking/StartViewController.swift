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
    @IBOutlet weak var totalCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inf.登录({KVNProgress.showErrorWithStatus("密码错误");inf.logout()})
        runStartButton.setRound()
    }
    
    override func viewWillAppear(animated: Bool) {
        updateTotalLabel()
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
    
    
    func updateTotalLabel(){
        let data = NSUserDefaults.standardUserDefaults()
        let history:[RunningData]!
        if let a = data.objectForKey("history") as? NSData {
            history = NSKeyedUnarchiver.unarchiveObjectWithData(a) as![RunningData]
        } else  { history = [] }
        var dis = 0.0
        for one in history{
            dis += one.distance
        }
        totalCountLabel.text = String(format: "%.2fKM",dis/1000)
        
    }
}
