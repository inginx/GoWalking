//
//  AddFriendsViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/1/31.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit

class AddFriendsViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var data:[String] = ["fdfsd"]

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        guard let x = self.tableView.dequeueReusableCellWithIdentifier("searchFriends") else {return UITableViewCell()}
        let avatar = x.viewWithTag(40) as! UIImageView
        let nameLabel = x.viewWithTag(41) as! UILabel
        let detailLabel = x.viewWithTag(42) as! UITextView
        
        
        return x
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("editend")
    }
    
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
//    print("1111")
//        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("search")
        searchBar.resignFirstResponder()
        data.append(searchBar.text!)
        tableView.reloadData()
        
    }
    


}
