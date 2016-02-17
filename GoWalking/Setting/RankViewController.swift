//
//  mk.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/17.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit
import KVNProgress

class RankViewController: UIViewController,UIWebViewDelegate{
    var webView: UIWebView?
    override func loadView() {
        super.loadView()
        self.webView = UIWebView()
        self.view = self.webView
        webView?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "排行榜"
        KVNProgress.showWithStatus("加载中")

        let url = NSURL(string:urls.rank)
        let req = NSURLRequest(URL:url!)
        self.webView!.loadRequest(req)
    }

    func webViewDidFinishLoad(webView: UIWebView){
        KVNProgress.dismiss()
    }


}
