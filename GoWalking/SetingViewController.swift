//
//  SetingViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/23.
//  Copyright © 2015年 称一称. All rights reserved.
//
import UIKit
import KVNProgress
import Qiniu
import Alamofire
import AFNetworking
import HappyDNS

protocol settingView{
    func showLogout()
}
class SetingViewController: UIViewController,SinaWeiboActionSheetDelegate,settingView {

    override func viewDidLoad() {
        super.viewDidLoad()
        let x = self.childViewControllers.last as! SettingTable
        x.delegate = self
    }

    func showLogout() {
        let x = ZDSinaWeiboActionSheet(wihtTitlesArr: ["退出","取消"], isNeedCancleBtn: false)
        x.delegate = self
        x.show()
    }

    func sinaWeiboActionSheetDidClick(actionSheet: ZDSinaWeiboActionSheet!, selectedItem selectedLine: Int) {
        if selectedLine == 0{
            self.dismissViewControllerAnimated(true,completion: nil)
            inf.logout()
        }
    }


}

class SettingTable: UITableViewController {

    @IBOutlet weak var userIcon: UIImageView!
    var delegate:settingView?
    override func viewDidLoad() {
        self.userIcon.layer.cornerRadius = userIcon.frame.width/2
        self.userIcon.clipsToBounds = true
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section{
        case 1:self.getToken()
        case 2:delegate?.showLogout()
        default :break
        }
    }

    func logoutTap(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "退出", style: UIAlertActionStyle.Default){
            _ in
            print("???")
            KVNProgress.showWithStatus("请稍后")

                        })
        alert.addAction(UIAlertAction(title: "算了", style: UIAlertActionStyle.Default, handler: nil))

        presentViewController(alert, animated: true,completion: nil)

    }

    func getToken(){
        request(.GET, "http://127.0.0.1:8000/files/token").responseJSON{
            r in
            let res = r.result.value as! NSDictionary
            let t = res["token"] as! String
            print(t)
            self.qiniuTest(t)
        }
    }


    func qiniuTest(token:String){
        let item = NSData(base64EncodedString: "fdsafsf", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)

        let upManager = QNUploadManager()
        upManager.putData(item, key: "fdsf" , token: token , complete: { (info, key, resp) -> Void in
            print("\(info),\(key),\(resp)")
            print(info.statusCode)

            if (info.statusCode == 200 && resp != nil){

            }else{

            }

            }, option: nil)

    }


    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (((presentingViewController)?.isMemberOfClass(UIAlertController)) != nil){
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            print("111")
        }
    }
}


