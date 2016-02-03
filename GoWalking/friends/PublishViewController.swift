//
//  PublishViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/3.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit

class PublishViewController: UITableViewController {

    @IBOutlet weak var textview: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
    }

    @IBAction func cancelTap(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
    }

    func hideKeyboard(){
        textview.resignFirstResponder()
    }

}
