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
        let x = UITableViewCell()
        x.textLabel?.text = data[indexPath.row]
        return x
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        print("fsdadf")
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
