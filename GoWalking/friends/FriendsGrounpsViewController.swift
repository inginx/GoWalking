//
//  FriendsGrounpsViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/1/9.
//  Copyright © 2016年 称一称. All rights reserved.
//

class FriendsGrounpsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var tableview: UITableView!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        guard let cell = self.tableview.dequeueReusableCellWithIdentifier("friendgroupcell") else {return UITableViewCell()}

        return cell
    }


}
