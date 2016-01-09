//
//  historyViewController.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/27.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit

class historyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableview: UITableView!
    
    var history:[RunningData]!
    var data : NSUserDefaults!
    override func viewDidLoad() {
        super.viewDidLoad()
        data = NSUserDefaults.standardUserDefaults()
        getData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
//MARK: Datas
    func getData(){
        if let a = data.objectForKey("history") as? NSData {
            history = NSKeyedUnarchiver.unarchiveObjectWithData(a) as![RunningData]
        } else  { history = [] }
    }
    
    func saveData(){
        let historyData = NSKeyedArchiver.archivedDataWithRootObject(history)
        data.setObject(historyData, forKey: "history")
    }

//MARK: Tableview

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return history.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("historycell")! as UITableViewCell
        cell.textLabel?.text = String(format:"%.2f m",history[indexPath.row].distance )
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        history.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        saveData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "history"{
            let vc = segue.destinationViewController as! historyDetailViewController
            let indexPath = tableview.indexPathForSelectedRow
            vc.data = history[(indexPath?.row)!]
        }
    }


}
