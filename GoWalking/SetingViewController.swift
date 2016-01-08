//
//  SetingViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/23.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit

class SetingViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    
    @IBAction func logoutTap(sender: AnyObject) {
        inf.logout()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = "hello"
        return cell
    }

    
}
