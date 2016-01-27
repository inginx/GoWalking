//
//  FriendsGrounpsViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/1/9.
//  Copyright © 2016年 称一称. All rights reserved.
//

class FriendsGrounpsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {

    @IBOutlet weak var avastar: UIImageView!
    @IBOutlet weak var nickname: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nickname.text = inf.nickname
        avastar.kf_setImageWithURL(getAvatarUrl(inf.avatar))

    }
    @IBOutlet weak var tableview: UITableView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.tableview.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        guard let cell = self.tableview.dequeueReusableCellWithIdentifier("friendgroupcell") else {return UITableViewCell()}

        return cell
    }


}
