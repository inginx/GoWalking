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
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        tableview.backgroundView = UIImageView(image: UIImage(named: "history_bg1"))
    }
    
    override func viewWillAppear(animated: Bool) {
        getData()
        tableview.reloadData()
    }
    
    
//MARK: Datas
    func getData(){
        if let a = data.objectForKey("history") as? NSData {
            history = NSKeyedUnarchiver.unarchiveObjectWithData(a) as![RunningData]
        } else  { history = [] }

        history = history.sort({$0.startTime.timeIntervalSince1970 > $1.startTime.timeIntervalSince1970})

        if history.count == 0{
            showEmptyLabel()
        }
        else{
            if let x = self.view.viewWithTag(50){
                x.removeFromSuperview()
                tableview.hidden = false
            }
        }
    }
    
    func saveData(){
        let historyData = NSKeyedArchiver.archivedDataWithRootObject(history)
        data.setObject(historyData, forKey: "history")
    }

//MARK: Tableview

    func showEmptyLabel(){
        if (self.view.viewWithTag(50) != nil){return}
        let x = UILabel(frame: CGRectMake(0, sHeight/2, sWidth, 20.0))
        x.tag = 50
        x.text = "暂时没有记录哦~先跑跑步吧！"
        x.textAlignment = NSTextAlignment.Center
        self.view.addSubview(x)
        tableview.hidden = true
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return history.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("historycell")! as UITableViewCell
        let startTime = cell.viewWithTag(1) as! UILabel
        let seconds = cell.viewWithTag(2) as! UILabel
        let distance = cell.viewWithTag(3) as! UILabel
        let kindImg = cell.viewWithTag(4) as! UIImageView
        let data = history[indexPath.row]

        startTime.text = data.startTime.toString()

        let min=data.seconds/60;
        let hour=min/60;
        seconds.text = String(format: "%d:%d:%d",hour%24,min%60,data.seconds%60)

        distance.text = String(format:"%.2f",data.distance/1000 )

        let img:UIImage!
        switch data.kind as RunningType{
        case .walking :img = UIImage(named: "走路")!
        case .runing:img = UIImage(named: "跑步")!
        case .cycling:img = UIImage(named: "骑车")!
        }
        kindImg.image = img

        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        history.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        saveData()
        if history.count == 0{showEmptyLabel()}
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "history"{
            let vc = segue.destinationViewController as! historyDetailViewController
            let indexPath = tableview.indexPathForSelectedRow
            vc.data = history[(indexPath?.row)!]
        }
    }


}
