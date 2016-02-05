//
//  ListTableViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/5.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("list")!
        
        return cell
    }

}
