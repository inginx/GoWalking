//
//  AppDelegate.swift
//  GoWalking
//
//  Created by 称一称 on 15/11/13.
//  Copyright © 2015年 称一称. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import KVNProgress

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,TencentSessionDelegate ,WXApiDelegate,WeiboSDKDelegate{

    var window: UIWindow?



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let MAPAPIKey = "c9705494a8a108d527d6b68580008145"
        MAMapServices.sharedServices().apiKey = MAPAPIKey
        AMapSearchServices.sharedServices().apiKey = MAPAPIKey
        AMapNaviServices.sharedServices().apiKey = MAPAPIKey

//        swizzlingMethod(UIViewController.self,oldSelector: "viewDidLoad",newSelector: "viewDidLoadForChangeTitleColor")

        inf.tencentOAuth = TencentOAuth(appId: "1105180266", andDelegate: self)

        if inf.username == ""{
            window=UIWindow(frame: UIScreen.mainScreen().bounds)
            window!.makeKeyAndVisible()
            let VC = inf.getVC("LoginNav")
            window?.rootViewController = VC
        }
        
        return true
    }
// change nav color
//    func swizzlingMethod(clzz: AnyClass, oldSelector: Selector, newSelector: Selector) {
//        let oldMethod = class_getInstanceMethod(clzz, oldSelector)
//        let newMethod = class_getInstanceMethod(clzz, newSelector)
//        method_exchangeImplementations(oldMethod, newMethod)
//    }




//MARK: - 第三方登录
    func tencentDidLogin() {
        if !inf.tencentOAuth.accessToken.isEmpty {
            inf.openid = inf.tencentOAuth.openId


            if(inf.password != ""){
                request(.POST, urls.submitTencent,parameters : ["openid":inf.openid]).responseJSON{
                    s in guard let res = s.result.value else {return}
                    if res["success"] as! Bool {
                        KVNProgress.showSuccessWithStatus("绑定成功")
                    }else{
                        KVNProgress.showErrorWithStatus(res["Msg"] as! String)
                    }
                }
                inf.saveUser()
                return
            }


            inf.loginWithTencent(LoginWithOpenidErroeHandler){
                let x = inf.getVC("mainVC")
                self.window?.rootViewController?.presentViewController(x, animated: true, completion: nil)
            }
        }

    }

    func LoginWithOpenidErroeHandler(x: String?){
        if x! == "haventReg"{
            inf.tencentOAuth.getUserInfo()

        }
    }

    func tencentDidNotLogin(cancelled: Bool) {

    }
    func tencentDidNotNetWork() {}

    func onReq(req: BaseReq!) {}
    func onResp(resp: BaseResp!){
        if resp.errCode == 0 {shareSuccss()}
        else if resp.errCode == -2 {shareFailure()}
    }

    func didReceiveWeiboRequest(request: WBBaseRequest!) {}
    func didReceiveWeiboResponse(response: WBBaseResponse!){
        if response.statusCode == .Success {shareSuccss()}
        else if response.statusCode == .UserCancel {shareFailure()}
    }

    func shareSuccss() {
        //KVNProgress.showSuccessWithStatus("分享成功")
    }

    func shareFailure() {
        //KVNProgress.showErrorWithStatus("用户取消发送")
    }

    func getUserInfoResponse(response:APIResponse){
        if inf.username != "" {
//            inf.openid = 
//            inf
        }
        inf.nickname = response.jsonResponse["nickname"] as! String
        inf.avatar = response.jsonResponse["figureurl_qq_2"] as! String
        
        let x = inf.getVC("register") as! registerViewController
        var presentedVC = window?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
            print(presentedVC)
            if presentedVC!.isKindOfClass(UINavigationController){break}
        }
        (presentedVC as! UINavigationController).pushViewController(x, animated: true)
    }

    func handleTencentOpenUrl(url: String) -> Bool {
        TencentOAuth.HandleOpenURL(NSURL(string: url))
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool{
        let string = url.absoluteString
        if string.hasPrefix("tencent1105180266") {return handleTencentOpenUrl(string)}
        else if string.hasPrefix("wx") {return WXApi.handleOpenURL(url, delegate: self)}
        return false
    }

}


