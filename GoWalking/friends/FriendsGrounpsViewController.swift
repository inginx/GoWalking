//
//  FriendsGrounpsViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/1/9.
//  Copyright © 2016年 称一称. All rights reserved.
//
import Alamofire
import KVNProgress
import Kingfisher


class FriendsGrounpsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {

    @IBOutlet weak var avastar: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var dataArray:[NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        nickname.text = inf.nickname
        avastar.kf_setImageWithURL(getPicUrl(inf.avatar))
        getData()

    }

    func getData(){
        request(.POST, "http://127.0.0.1:8000/gowalking/friends/content").responseJSON{
            s in guard let res = s.result.value else{return}
            self.dataArray = res as![NSDictionary]
            KVNProgress.showSuccess()
            self.tableview.reloadData()

        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableview.deselectRowAtIndexPath(indexPath, animated: false)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArray.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        guard let cell = self.tableview.dequeueReusableCellWithIdentifier("friendgroupcell") else {return UITableViewCell()}
        let data = dataArray[indexPath.row] 
        let avatar = cell.viewWithTag(50) as! UIImageView
        let name = cell.viewWithTag(51) as! UILabel
        let content = cell.viewWithTag(52) as! UILabel
        avatar.kf_setImageWithURL(getPicUrl(data["avatar"] as! String))
        name.text = data["name"] as? String
        content.text = data["content"] as? String
        return cell
    }


}
