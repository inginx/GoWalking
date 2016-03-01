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
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inf.登录({s in KVNProgress.showErrorWithStatus(s);inf.logout()})
        runStartButton.setRound()
        
        self.changeNavigationBarTextColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = navBarColor
        self.navigationController?.navigationBar.tintColor = navBarTextColor

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startRunning", name: "startRunning", object: nil)



    }

    override func viewWillAppear(animated: Bool) {
        updateTotalLabel()
    }


    func startRunning(){
        let VC = inf.getVC("runningVC")
        presentViewController(VC, animated: true, completion: nil)
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
        totalCountLabel.text = String(format: "%.2f",inf.total_dis/1000)
        totalTimeLabel.text = String(format: "%.1f", Double(inf.total_dis)/3600)
    }


}
