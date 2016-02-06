//
//  urls.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/2.
//  Copyright © 2016年 称一称. All rights reserved.
//

let urls = url()

class url{
//    let prefix = "https://learning2learn.cn/gowalking"
    let prefix = "http://127.0.0.1:8000/gowalking"

    let login:String
    let detail:String
    let circleFeed:String
    let uploadAvatar:String
    let uploadInfo:String
    let publishFeed:String
    let register:String
    let searchUser:String
    init(){
        login = "\(prefix)/user/login"
        register = "\(prefix)/user/register"
        detail = "\(prefix)/user/person"
        uploadAvatar = "\(prefix)/user/uploadavatar/"
        uploadInfo = "\(prefix)/user/uploadinfo/"
        searchUser = "\(prefix)/user/find/"


        circleFeed = "\(prefix)/friends/content"
        publishFeed = "\(prefix)/friends/publish/"
    }
}

