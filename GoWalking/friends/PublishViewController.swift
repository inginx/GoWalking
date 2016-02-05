//
//  PublishViewController.swift
//  GoWalking
//
//  Created by 称一称 on 16/2/3.
//  Copyright © 2016年 称一称. All rights reserved.
//

import UIKit

class PublishViewController: UITableViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{

    @IBOutlet weak var textview: UITextView!
    @IBOutlet weak var image: UIImageView!


    var TapAction:UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        TapAction =  UITapGestureRecognizer(target: self, action: "hideKeyboard")
    }

    @IBAction func cancelTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
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

    }

    func showimagePicker(){
        let x = UIImagePickerController()
        x.delegate = self
        presentViewController(x, animated: true, completion: nil)
    }


    func publish(){
        let currentImage = self.image.image!
        let fileurl = currentImage.saveWithName("toPublish.jpg")

    }

}
