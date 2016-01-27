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



    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Done, target: self, action: "saveTouch")
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "avatarTouch")
        avatar.setRound()
        avatar.addGestureRecognizer(singleTap)
        avatar.kf_setImageWithURL(getAvatarUrl(inf.avatar))
    }


    //Touch process
    func avatarTouch(){
        let x = ZDSinaWeiboActionSheet(wihtTitlesArr: ["更改头像","取消"], isNeedCancleBtn: false)
        x.delegate = self
        x.tag = 20
        x.show()
    }

    func saveTouch(){
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


    func saveImage(currentImage:UIImage){
        let imageName = "avastar.jpg"
        let imageData:NSData = UIImageJPEGRepresentation(currentImage, 0.5)!
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
            let fileURL = documentsURL.URLByAppendingPathComponent(imageName)
                imageData.writeToURL(fileURL, atomically: false)
        "https://learning2learn.cn/gowalking/uploadavatar/\(inf.username)"

        Alamofire.upload(.POST, "http://127.0.0.1:8000/gowalking/uploadavatar/\(inf.username)", file: fileURL).responseJSON(){
            s in
            print(s)

        }

    }



    //save
    func save(){
        saveImage(avatar.image!)
        print("save")
    }
}
