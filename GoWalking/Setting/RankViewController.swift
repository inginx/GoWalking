//
//  mk.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/17.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit
import KVNProgress
import Alamofire
import MJRefresh


class RankViewController: UITableViewController{

    var dataArray:[NSDictionary] = []
    let header = MJRefreshNormalHeader()

    override func viewDidLoad() {
        super.viewDidLoad()
        SetReflash()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.header.beginRefreshing()
    }



    func SetReflash(){
        header.setRefreshingTarget(self, refreshingAction: Selector("getRank"))
        header.setTitle("下拉刷新", forState: MJRefreshState.WillRefresh)
        header.setTitle("刷新ing", forState: MJRefreshState.Refreshing)
        self.tableView.mj_header = header
    }



    func getRank(){
        request(.GET, urls.rank).responseJSON(){
            s in guard let res = s.result.value else {return}
            self.dataArray =  res["data"] as! [NSDictionary]
            self.tableView.reloadData()
            self.header.endRefreshing()
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        guard let x = self.tableView.dequeueReusableCellWithIdentifier("rankcell") else {return UITableViewCell()}
        let avatar = x.viewWithTag(40) as! UIImageView
        let nameLabel = x.viewWithTag(41) as! UILabel
        let todayLabel = x.viewWithTag(42) as! UILabel
        let totalLabel = x.viewWithTag(43) as! UILabel

        let row = indexPath.row
        let data = dataArray[row]
        avatar.addPicFromUrl(data["avatar"] as! String)
        avatar.setRound()
        nameLabel.text = (data["nickname"] as! String)
        todayLabel.text = "\((data["today"] as! NSNumber).integerValue)"
        totalLabel.text = "\((data["total"] as! NSNumber).integerValue)"


        return x

    }




}
