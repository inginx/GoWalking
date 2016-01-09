//
//  SetingViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/23.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit
import KVNProgress
class SetingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    

}

class SettingTable: UITableViewController {

    @IBOutlet weak var userIcon: UIImageView!

    override func viewDidLoad() {
        self.userIcon.layer.cornerRadius = userIcon.frame.width/2
        self.userIcon.clipsToBounds = true
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section{
        case 2:logoutTap()
        default :break
        }
    }

    func logoutTap(){
        let alert = UIAlertController(title: "确定退出？", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "去意已决", style: UIAlertActionStyle.Default){
            _ in
            self.dismissViewControllerAnimated(true, completion: nil)
            inf.logout()
            })
        alert.addAction(UIAlertAction(title: "算了", style: UIAlertActionStyle.Cancel, handler: nil))
        presentViewController(alert, animated: true,completion: nil)

    }
}


