//
//  SetingViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/23.
//  Copyright © 2015年 称一称. All rights reserved.
//
import UIKit
import KVNProgress
import Alamofire

class SettingTable: UITableViewController,SinaWeiboActionSheetDelegate {

    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var usermail: UILabel!
    override func viewDidLoad() {
        userIcon.setRound()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        username.text = inf.nickname
        usermail.text = inf.mail
        userIcon.addPicFromUrl((inf.avatar))
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section{
//        case 0: self.navigationController?.pushViewController(inf.getVC("profiles"), animated: true)
        case 2: showLogout()
        default :break
        }
    }

    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (((presentingViewController)?.isMemberOfClass(UIAlertController)) != nil){
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func showPwdChange(){
        self.navigationController?.pushViewController(inf.getVC("pwdchange"), animated: true)
    }

    func showLogout() {
        let x = ZDSinaWeiboActionSheet(wihtTitlesArr: ["退出","取消"], isNeedCancleBtn: false)
        x.delegate = self
        x.show()
    }


    func sinaWeiboActionSheetDidClick(actionSheet: ZDSinaWeiboActionSheet!, selectedItem selectedLine: Int) {
        if selectedLine == 0{
            if (self.presentingViewController != nil){
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }else{
                self.presentViewController(inf.getVC("LoginNav"), animated: true, completion: nil)
                inf.logout()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {


        if segue.identifier == "myfriend"{
            let VC = segue.destinationViewController as! ListTableViewController
            VC.kind = ListTableKind.friends
        }
        else if segue.identifier == "acceptList"{
            let VC = segue.destinationViewController as! ListTableViewController
            VC.kind = ListTableKind.waitForAccept
        }
    }

}


