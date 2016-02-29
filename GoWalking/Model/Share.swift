//
//  Share.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/23.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit
import PopMenu


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

    static func qq(title: String, description: String, img: UIImage, byQzone: Bool = false) {

        let newsObj = QQApiImageObject.objectWithData(UIImageJPEGRepresentation(img, 1.0), previewImageData: (UIImageJPEGRepresentation(UIImage(named: "AppIcon")!, 1.0)), title: title, description: description)  as! QQApiImageObject

        if byQzone {
            newsObj.cflag = UInt64(kQQAPICtrlFlagQZoneShareOnStart)
        }
        let req = SendMessageToQQReq(content:newsObj)
        QQApiInterface.sendReq(req)
    }

    static func shareAction(img:UIImage,view:UIView!){
        var items = [MenuItem]()

        items.append(MenuItem(title: "微博", iconName: "weibo"))

        if TencentOAuth.iphoneQQInstalled() {
//            items.append(MenuItem(title: "QQ", iconName: "qq"))
            items.append(MenuItem(title: "说说", iconName: "qzone"))
        }
        if WXApi.isWXAppSupportApi() {
//            items.append(MenuItem(title: "微信", iconName: "weixin"))
            items.append(MenuItem(title: "朋友圈", iconName: "timeline"))
        }

        let popMenu = PopMenu(frame: CGRectMake(0, 0, sWidth, sHeight), items: items)

        popMenu.didSelectedItemCompletion = {
            item in
            switch item.title {
            case "微博": Share.weibo("哈哈，看看我的运动结果",img: img)
            case "QQ": Share.qq("我的运动成果", description: "羡慕吧！", img: img)
            case "说说": Share.qq("我的运动成果", description: "羡慕吧！", img: img, byQzone: true)
//            case "微信": Share.weixin("教务处通知", description: self.titleLabel.text!, url: self.url)
            case "朋友圈": Share.timeline("我的运动", img: img)
            default:break
            }
        }

        popMenu.showMenuAtView(view)
    }
    
}
