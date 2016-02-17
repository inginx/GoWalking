//
//  FriendsGrounpsViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/1/9.
//  Copyright © 2016年 称一称. All rights reserved.
//
import Alamofire
import KVNProgress
import MJRefresh

class FriendsGrounpsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {

    @IBOutlet weak var tableview: UITableView!

    var dataArray:[NSDictionary] = []
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()

    var page:Int = 0
    var noMore:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.rowHeight = UITableViewAutomaticDimension;
        self.tableview.estimatedRowHeight = 220.0;
        SetReflash()
        tableview.mj_header.beginRefreshing()
    }

    func SetReflash(){
        header.setRefreshingTarget(self, refreshingAction: Selector("pullUp"))
        header.setTitle("下拉刷新", forState: MJRefreshState.WillRefresh)
        header.setTitle("刷新ing", forState: MJRefreshState.Refreshing)
        self.tableview.mj_header = header
        footer.setRefreshingTarget(self, refreshingAction: Selector("pullDown"))
        footer.setTitle("加载更多", forState: MJRefreshState.WillRefresh)
        footer.setTitle("没啦！自己发一条吧！", forState: MJRefreshState.NoMoreData)
        self.tableview.mj_footer = footer
    }

    func pullUp(){
        getData(false){
            self.tableview.mj_header.endRefreshing()
        }
    }

    func pullDown(){
        getData(true){
            if self.noMore{self.tableview.mj_footer.endRefreshingWithNoMoreData()}
            else{self.tableview.mj_footer.endRefreshing()}
        }
    }

    func getData(addPage:Bool,complete:(()->())? = nil){
        if !addPage{self.page = 0}else{self.page++}
        request(.POST, urls.circleFeed,parameters:["page":page]).responseJSON{
            s in guard let res = s.result.value else{self.page--;return}
            self.noMore =  res["end"] as! Bool

            if !addPage{
                self.dataArray = res["data"] as![NSDictionary]
                self.tableview.reloadData()
            }else{
                self.dataArray.appendContentsOf(res["data"] as![NSDictionary])
                self.tableview.reloadData()
            }
            complete?()
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
            pic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "showBigPic:"))
        }
        let avatar = cell.viewWithTag(50) as! UIImageView
        let name = cell.viewWithTag(51) as! UILabel
        let content = cell.viewWithTag(52) as! UILabel
        let timeLabel = cell.viewWithTag(54) as! UILabel
        let delButton = cell.viewWithTag(55) as! UIButton

        if (data["username"] as! String ) == inf.username{
            delButton.hidden = false
            delButton.addTarget(self, action: "deleButtonTap:", forControlEvents: UIControlEvents.TouchDown)
        }
        avatar.layer.cornerRadius = avatar.layer.frame.width/2
        avatar.clipsToBounds = true

        name.text = data["nickname"] as? String
        content.text = data["content"] as? String
        timeLabel.text = data["time"] as? String
        avatar.addPicFromUrl(data["avatar"] as! String)



        return cell
    }

    func deleButtonTap(sender:AnyObject){
        let x = (sender.superview)!!.superview as! UITableViewCell
        let indexPath = tableview.indexPathForCell(x)
        let mid = dataArray[(indexPath?.row)!]["mid"] as! String
        request(.GET, "\(urls.deleFeed)\(mid)").responseJSON{
            s in
            guard let res = s.result.value else{return}
            if res["success"] as! Bool == true{
                self.dataArray.removeAtIndex((indexPath?.row)!)
                self.tableview.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Top)
            }else{
                let err = res["Msg"] as! String
                KVNProgress.showErrorWithStatus(err)
            }
        }
        
    }
    
    var oldframe:CGRect!

    func showBigPic(sender:AnyObject){
        let x = ( sender.view as! UIImageView ).image
        let xx = ( sender.view as! UIImageView )
        
        let imageView = UIImageView(image: x)
        imageView.userInteractionEnabled = true
        imageView.multipleTouchEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "disMissBigPic:"))


        let newframe = xx.convertRect(xx.bounds, toView: self.view)
        oldframe = newframe
        imageView.frame = newframe
        
        let window = UIApplication.sharedApplication().delegate?.window
        window!!.addSubview(imageView)
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
  
        imageView.frame = CGRectMake(0.0, self.tableview.frame.origin.y, self.tableview.frame.size.width, self.tableview.frame.size.height)
        
        UIView.commitAnimations()

    }

    func disMissBigPic(sender:AnyObject){
        let x = (sender.view as! UIImageView )
        UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.TransitionNone, animations: { () -> Void in
            x.frame = self.oldframe
            }) { _ in
                x.removeFromSuperview()
        }
    }


}
