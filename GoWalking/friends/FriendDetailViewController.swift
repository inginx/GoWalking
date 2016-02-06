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

    var username:String!
    var VCKind:DetailVCMode!
    override func viewDidLoad() {
        super.viewDidLoad()
        ModeSet()
        GetData()


    }

    func ModeSet(){
        switch VCKind as DetailVCMode{
        case .Friend:break
        case .Stranger:break
        case .WatiForAccept:break
        }
    }

    func GetData(){
        request(.GET, "\(urls.detail)/\(inf.username)").responseJSON{
            s in
            guard let res = s.result.value else{KVNProgress.showError();return}
            self.imageView.addPicFromUrl(res["avatar"]as!String)
            self.nicknameLabel.text = res["nickname"]as?String
            self.usernameLabel.text = res["username"]as?String
            self.mailLabel.text = res["mail"]as?String
            self.intriduceLabel.text = res["introduce"]as?String

        }
    }

}

enum DetailVCMode{
    case Friend
    case Stranger
    case WatiForAccept
}
