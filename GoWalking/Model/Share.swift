//
//  Share.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/23.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit

class Share: NSObject {

    static var weixinToken: dispatch_once_t = 0

    static var weiboToken: dispatch_once_t = 0

    static func weibo(title: String, img: UIImage) {
        dispatch_once(&weiboToken) {
            WeiboSDK.registerApp("433281613")
        }

        let authRequest = WBAuthorizeRequest()
        authRequest.redirectURI = "https://api.weibo.com/oauth2/default.html"
        authRequest.scope = "all"

        //微博内容
        let obj = WBMessageObject()
        obj.text = title

        //微博图片
        let weibo_image = WBImageObject()
        weibo_image.imageData = UIImageJPEGRepresentation(img, 1.0)

        obj.imageObject = weibo_image

        let request = WBSendMessageToWeiboRequest.requestWithMessage(obj, authInfo:authRequest, access_token:nil) as! WBSendMessageToWeiboRequest
        request.shouldOpenWeiboAppInstallPageIfNotInstalled = false
        WeiboSDK.sendRequest(request)
    }

    static func timeline(title: String, img: UIImage) {
        dispatch_once(&weixinToken) {
            WXApi.registerApp("wx85f3d518c47c320a")
        }

        let ext=WXImageObject()
        ext.imageData=UIImagePNGRepresentation(img)

        let message = WXMediaMessage()
        message.mediaObject=ext

        let req=SendMessageToWXReq()
        req.message=message
        req.bText=false
        req.scene=1
        WXApi.sendReq(req)
    }

    static func qq(title: String, description: String, url: String, byQzone: Bool = false) {
        let newsObj = QQApiNewsObject.objectWithURL(NSURL(string: url),
            title: title,
            description: description,
            previewImageData: UIImageJPEGRepresentation(UIImage(named: "bg7")!, 1.0)) as! QQApiNewsObject
        if byQzone {
            newsObj.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
        }
        let req = SendMessageToQQReq(content:newsObj)
        QQApiInterface.sendReq(req)
    }

    
}
