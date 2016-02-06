//
//  PublishViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/3.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit
import Alamofire
import KVNProgress


class PublishViewController: UITableViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{

    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var image: UIImageView!


    var TapAction:UITapGestureRecognizer!
    var hasPic:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        TapAction =  UITapGestureRecognizer(target: self, action: "hideKeyboard")
    }

    @IBAction func cancelTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func confirmTap(sender: AnyObject) {
        publish(){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    func hideKeyboard(){
        textview.resignFirstResponder()
        tableView.removeGestureRecognizer(TapAction)
    }

    func textViewDidBeginEditing(textView: UITextView){
        tableView.addGestureRecognizer(TapAction)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.section{
        case 1:showimagePicker()
        default:break
        }
    }


    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        picker.dismissViewControllerAnimated(true, completion: nil)
        var image: UIImage!
        if(picker.allowsEditing){
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        }else{
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.image.image = image
        }
        hasPic = true
    }

    func showimagePicker(){
        let x = UIImagePickerController()
        x.delegate = self
        presentViewController(x, animated: true, completion: nil)
    }


    func publish(completeAction:(()->())? = nil){
        let content = textview.text
        Alamofire.upload(
            .POST,
            "\(urls.publishFeed)\(inf.username)",
            multipartFormData: { multipartFormData in
                if self.hasPic{
                    let fileurl = self.image.image!.saveWithName("toPublish.jpg")
                    multipartFormData.appendBodyPart(fileURL: fileurl, name: "image")
                    multipartFormData.appendBodyPart(data: "y".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "haspic")
                }else{
                    multipartFormData.appendBodyPart(data: "n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "haspic")
                }
                multipartFormData.appendBodyPart(data: content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "content")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        guard let r = response.result.value else{KVNProgress.showErrorWithStatus("返回异常"); return}
                        print(r)
                        let s = r["success"] as! Bool
                        if s {completeAction?()}
                        else {KVNProgress.showErrorWithStatus(r["Msg"]as!String)}
                    }
                case .Failure(_):
                    KVNProgress.showErrorWithStatus("网络故障")
                }
            }
        )

    }




}
