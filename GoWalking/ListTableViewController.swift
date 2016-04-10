//
//  ListTableViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/5.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit
import Alamofire

enum ListTableKind{
    case friends
    case waitForAccept
}


class ListTableViewController: UITableViewController {


    var dataArray:[NSDictionary]! = []
    var kind:ListTableKind!

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

    }

    func getData(){
        let url:String!
        switch kind as ListTableKind{
        case .friends:url = urls.friendList
        case .waitForAccept:url = urls.wait4Accept
        }
        print(url)
        request(.GET, url).responseJSON{
            s in guard let res = s.result.value else{return}
            print(s)
            self.dataArray = res["data"] as![NSDictionary]
            self.tableView.reloadData()
        }
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("list")!
        let avatar = cell.viewWithTag(40) as! UIImageView
        let userLabel = cell.viewWithTag(41) as! UILabel
        let introduce = cell.viewWithTag(42) as! UILabel
        let data = dataArray[indexPath.row]
        avatar.addPicFromUrl(data["avatar"] as! String)
        userLabel.text = data["nickname"] as? String
        introduce.text = data["introduce"] as? String

        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let VC = segue.destinationViewController as! FriendDetailViewController
        let indexPath = tableView.indexPathForSelectedRow
        VC.data = dataArray[(indexPath?.row)!]
        switch kind as ListTableKind{
        case .waitForAccept:VC.VCKind = DetailVCMode.WatiForAccept
        case .friends:VC.VCKind = DetailVCMode.Friend
        }
    }

}
