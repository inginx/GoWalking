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
    let submitTencent:String
    let chandePwd:String
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
    let updateRunningDis:String
    let rank:String
    init(){
        login = "\(prefix)/user/login"
        tencentLogin = "\(prefix)/user/Tencentlogin"
        submitTencent = "\(prefix)/user/submitTencent"
        chandePwd = "\(prefix)/user/chandePwd"

        register = "\(prefix)/user/register"
        detail = "\(prefix)/user/person"
        uploadAvatar = "\(prefix)/user/uploadavatar/"
        uploadInfo = "\(prefix)/user/uploadinfo/"
        searchUser = "\(prefix)/user/find/"


        circleFeed = "\(prefix)/friends/content"
        publishFeed = "\(prefix)/friends/publish/"
        deleFeed = "\(prefix)/friends/delFeed/"
        updateRunningDis = "\(prefix)/user/updateRunningDis"


        friendList = "\(prefix)/friends/list"
        addfriend = "\(prefix)/friends/add/"
        wait4Accept = "\(prefix)/friends/waitforaccept"
        friendstatment = "\(prefix)/friends/statement/"
        acceptFriend = "\(prefix)/friends/accept/"
        rank = "\(prefix)/friends/rank"
    }
}

