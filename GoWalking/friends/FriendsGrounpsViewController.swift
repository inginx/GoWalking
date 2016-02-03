//
//  FriendsGrounpsViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/1/9.
//  Copyright © 2016年 称一称. All rights reserved.
//
import Alamofire
import KVNProgress


class FriendsGrounpsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {

    @IBOutlet weak var avastar: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var dataArray:[NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        avastar.setRound()
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        self.tableview.estimatedRowHeight = 220.0;
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nickname.text = inf.nickname
        avastar.addPicFromUrl(inf.avatar)
        getData()
    }

    func getData(){
        request(.POST, urls.circleFeed).responseJSON{
            s in guard let res = s.result.value else{return}
            self.dataArray = res as![NSDictionary]
            self.tableview.reloadData()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableview.deselectRowAtIndexPath(indexPath, animated: false)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArray.count
     }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let cell:UITableViewCell!
        let data = dataArray[indexPath.row]
        let picurl = data["pic"] as! String
        if picurl == ""{
            cell = self.tableview.dequeueReusableCellWithIdentifier("friendnopiccell")!
        }else{
            cell = self.tableview.dequeueReusableCellWithIdentifier("friendgroupcell")!}

        let content = cell.viewWithTag(52) as! UILabel
        content.text = data["content"] as? String
        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell:UITableViewCell!
        let data = dataArray[indexPath.row]
        let picurl = data["pic"] as! String
        if picurl == ""{
            cell = self.tableview.dequeueReusableCellWithIdentifier("friendnopiccell")!
        }
        else{
            cell = self.tableview.dequeueReusableCellWithIdentifier("friendgroupcell")!
            let pic = cell.viewWithTag(53) as! UIImageView
            pic.addPicFromUrl(data["pic"] as! String)
        }
        let avatar = cell.viewWithTag(50) as! UIImageView
        let name = cell.viewWithTag(51) as! UILabel
        let content = cell.viewWithTag(52) as! UILabel

        name.text = data["name"] as? String
        content.text = data["content"] as? String
        avatar.addPicFromUrl(data["avatar"] as! String)

        return cell
    }


}
