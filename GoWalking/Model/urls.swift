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
    let tencentLogin:String
    let detail:String
    let circleFeed:String
    let uploadAvatar:String
    let uploadInfo:String
    let publishFeed:String
    let deleFeed:String
    let register:String
    let searchUser:String
    let friendList:String
    let addfriend:String
    let wait4Accept:String
    let acceptFriend:String
    let friendstatment:String
    init(){
        login = "\(prefix)/user/login"
        tencentLogin = "\(prefix)/user/Tencentlogin"

        register = "\(prefix)/user/register"
        detail = "\(prefix)/user/person"
        uploadAvatar = "\(prefix)/user/uploadavatar/"
        uploadInfo = "\(prefix)/user/uploadinfo/"
        searchUser = "\(prefix)/user/find/"


        circleFeed = "\(prefix)/friends/content"
        publishFeed = "\(prefix)/friends/publish/"
        deleFeed = "\(prefix)/friends/delFeed/"


        friendList = "\(prefix)/friends/list"
        addfriend = "\(prefix)/friends/add/"
        wait4Accept = "\(prefix)/friends/waitforaccept"
        friendstatment = "\(prefix)/friends/statement/"
        acceptFriend = "\(prefix)/friends/accept/"
    }
}

