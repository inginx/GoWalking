//
//  StartViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/22.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit
import KVNProgress
import Alamofire

class StartViewController: UIViewController {

    @IBOutlet weak var runStartButton: UIButton!
    @IBOutlet weak var totalCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inf.登录({s in KVNProgress.showErrorWithStatus(s);inf.logout()})
        runStartButton.setRound()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
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
        var todaydis = 0.0
        let todayDateS = NSDate().description
        let todayString = todayDateS.substringToIndex(todayDateS.startIndex.advancedBy(10))
        for one in history{
            dis += one.distance
            if one.startTime.description.substringToIndex(one.startTime.description.startIndex.advancedBy(10)) == todayString{
                todaydis += one.distance
            }
        }
        totalCountLabel.text = String(format: "%.2f",dis/1000)

        let para = ["total":dis,"today":todaydis]
        request(.POST, urls.updateRunningDis,parameters:para)
        }


}
