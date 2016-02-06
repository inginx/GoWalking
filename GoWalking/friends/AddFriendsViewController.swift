//
//  AddFriendsViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/1/31.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit
import Alamofire
import KVNProgress

class AddFriendsViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
    }
    
    var data:[NSDictionary] = []

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        guard let x = self.tableView.dequeueReusableCellWithIdentifier("searchFriends") else {return UITableViewCell()}
        let avatar = x.viewWithTag(40) as! UIImageView
        let nameLabel = x.viewWithTag(41) as! UILabel
        let detailLabel = x.viewWithTag(42) as! UILabel
        let row = indexPath.row
        avatar.addPicFromUrl(data[row]["avatar"]as! String)
        nameLabel.text = data[row]["nickname"]as? String
        detailLabel.text = data[row]["introduce"]as? String
        return x
    }
    
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("search")
        searchBar.resignFirstResponder()
        let text = searchBar.text!
        request(.GET, "\(urls.searchUser)\(text)").responseJSON{
            s in
            guard let res = s.result.value else{KVNProgress.showErrorWithStatus("网络异常");return}
            let r = res["data"] as! [NSDictionary]
            self.data = r
            self.tableView.reloadData()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let VC = segue.destinationViewController as! FriendDetailViewController
        let indexPath = tableView.indexPathForSelectedRow!
//        VC.username = data[indexPath.row]["username"] as! String
        VC.data =  data[indexPath.row]
        VC.VCKind = DetailVCMode.Stranger
    }
    


}
