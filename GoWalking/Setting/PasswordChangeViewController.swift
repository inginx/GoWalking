//
//  PasswordChangeViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/16.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit
import KVNProgress
import Alamofire
class PasswordChangeViewController: UITableViewController {

    @IBOutlet weak var pwdFirst: UITextField!
    @IBOutlet weak var pwdSecond: UITextField!

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section == 1{
            commitChange()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    func commitChange(){
        if pwdFirst.text != pwdSecond.text{
            KVNProgress.showErrorWithStatus("两次输入不同")
            return
        }
        if pwdFirst.text?.characters.count < 6{
            KVNProgress.showErrorWithStatus("密码长度不得低于6位")
            return
        }
        KVNProgress.showWithStatus("请稍后")
        request(.POST, urls.chandePwd,parameters:["pwd":pwdFirst.text!]).responseJSON{
            s in guard let res = s.result.value else{return}
            if (res["success"] as! Bool) {
                inf.password = self.pwdFirst.text!
                KVNProgress.showSuccessWithStatus("修改成功", completion: { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }else{
                KVNProgress.showErrorWithStatus(res["Msg"]as! String)
            }
        }
    }
}
