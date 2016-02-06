//
//  FriendDetailViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/1/31.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit
import Alamofire
import KVNProgress

class FriendDetailViewController: UITableViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var intriduceLabel: UITextView!
    @IBOutlet weak var button: UIButton!

    var username:String!
    var VCKind:DetailVCMode!
    var data:NSDictionary!
    override func viewDidLoad() {
        super.viewDidLoad()
        GetData()
        ModeSet()
    }

    func ModeSet(){
        switch VCKind as DetailVCMode{
        case .Friend:isFriend()
        case .Stranger:isStranger()
        case .WatiForAccept:isWatiForAccept()
        }
    }

    func isFriend(){
        button.setTitle("取消关注", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.redColor()
    }

    func isStranger(){
        button.setTitle("关注", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.blueColor()
        button.addTarget(self, action: "follow", forControlEvents: UIControlEvents.TouchDown)
    }

    func isWatiForAccept(){
        button.setTitle("接受", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.greenColor()
        button.addTarget(self, action: "accept", forControlEvents: UIControlEvents.TouchDown)
    }


    func GetData(){
        self.imageView.addPicFromUrl(data["avatar"]as!String)
        self.nicknameLabel.text = data["nickname"]as? String
        self.usernameLabel.text = data["username"]as? String
        self.mailLabel.text = data["mail"]as? String
        self.intriduceLabel.text = data["introduce"]as? String

    }

    func follow(){
        let to = data["username"] as! String
        request(.GET, "\(urls.addfriend)\(to)").responseJSON{
            s in
            guard let res = s.result.value else{return}
            if res["success"] as! Bool{
                self.button.setTitle("等待对方批准", forState: UIControlState.Normal)
                self.button.userInteractionEnabled = false
                self.button.backgroundColor = UIColor.grayColor()
            }else{
                KVNProgress.showErrorWithStatus(res["Msg"] as! String)
            }
        }
    }

    func accept(){
        print("accept")
        let to = data["username"] as! String
        request(.GET, "\(urls.acceptFriend)\(to)").responseJSON{
            s in
            guard let res = s.result.value else{return}
            if res["success"] as! Bool{
                self.button.setTitle("已接受", forState: UIControlState.Normal)
                self.button.userInteractionEnabled = false
                self.button.backgroundColor = UIColor.grayColor()
            }else{
                KVNProgress.showErrorWithStatus(res["Msg"] as! String)
            }
        }
    }

}

enum DetailVCMode{
    case Friend
    case Stranger
    case WatiForAccept
}
