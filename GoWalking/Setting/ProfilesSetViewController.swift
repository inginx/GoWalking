//
//  ProfilesSetViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/1/27.
//  Copyright © 2016年 称一称. All rights reserved.
//
import UIKit
import KVNProgress
import Alamofire
import Kingfisher

class ProfilesSetViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SinaWeiboActionSheetDelegate {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var mailField: UITextField!

    var avatatModify = false


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: self, action: "saveTouch")
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "avatarTouch")
        let TableTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "resignFirst")
        avatar.setRound()
        avatar.addGestureRecognizer(singleTap)
        tableView.addGestureRecognizer(TableTap)
        avatar.kf_setImageWithURL(getPicUrl(inf.avatar))
        nicknameField.text = inf.nickname
        mailField.text = inf.mail
    }


    //Touch process
    func avatarTouch(){
        let x = ZDSinaWeiboActionSheet(wihtTitlesArr: ["更改头像","取消"], isNeedCancleBtn: false)
        x.delegate = self
        x.tag = 20
        x.show()
    }

    func saveTouch(){
        resignFirst()
        let x = ZDSinaWeiboActionSheet(wihtTitlesArr: ["确认更改","取消"], isNeedCancleBtn: false)
        x.delegate = self
        x.tag = 21
        x.show()
    }

    //image picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker.dismissViewControllerAnimated(true, completion: nil)
        var image: UIImage!
        if(picker.allowsEditing){
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
           image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        self.avatar.image = image
        self.avatatModify = true

    }

    func showimagePicker(){
        let x = UIImagePickerController()
        x.delegate = self
        presentViewController(x, animated: true, completion: nil)
    }

    // actionSheet
    func sinaWeiboActionSheetDidClick(actionSheet: ZDSinaWeiboActionSheet!, selectedItem selectedLine: Int) {
        switch actionSheet.tag{
        case 20:if selectedLine == 0 {showimagePicker()}
        case 21:if selectedLine == 0 {save()}
        default:break
        }

    }


    //saving
    func saveImage(completion:(()->())?=nil){
        let currentImage = self.avatar.image!
        let imageName = "avastar.jpg"
        let imageData:NSData = UIImageJPEGRepresentation(currentImage, 0.5)!
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fileURL = documentsURL.URLByAppendingPathComponent(imageName)
                imageData.writeToURL(fileURL, atomically: false)
        Alamofire.upload(
            .POST,
            "http://127.0.0.1:8000/gowalking/uploadavatar/\(inf.username)",
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: fileURL, name: "avatar")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        guard let r = response.result.value else{KVNProgress.dismiss(); return}
                        let s = r["success"] as! Bool
                        if s {completion?()}
                    }
                case .Failure(_):
                    KVNProgress.showErrorWithStatus("网络故障")
                }
            }
        )
    }

    func resignFirst(){
        nicknameField.resignFirstResponder()
        mailField.resignFirstResponder()
    }

    //save
    func save(){
        let nickname = nicknameField.text!
        let mail = mailField.text!
        KVNProgress.showWithStatus("保存中")
        let data = ["nickname":nickname,
            "mail": mail]

        request(.POST, "http://127.0.0.1:8000/gowalking/uploadinfo/\(inf.username)",parameters:data).responseJSON(){s in
            guard let res = s.result.value else {return}
            if (res["success"] as! Bool) == true{
                if self.avatatModify{self.saveImage(){self.savedone()}}
                else {self.savedone()}
            }
        }
    }

    func savedone(){
        inf.获取详细信息()
        KVNProgress.dismiss()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
