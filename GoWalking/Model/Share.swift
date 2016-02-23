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
