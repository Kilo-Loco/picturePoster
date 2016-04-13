//
//  ViewController.swift
//  Picture Poster
//
//  Created by Kyle Lee on 4/12/16.
//  Copyright © 2016 Kilo Loco. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedImageBtn: UIButton!
    @IBOutlet weak var uploadImageBtn: UIButton!
    @IBOutlet weak var label: UILabel!
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.uploadImageBtn.hidden = true
        //self.uploadImageBtn.userInteractionEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
        self.imageView.image = image
        self.selectedImage = image
        
        if self.selectedImage != nil {
            self.uploadImageBtn.hidden = false
            self.selectedImageBtn.hidden = true
        }
    }
    
    @IBAction func selectImage(sender:UIButton) {
        presentViewController(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(sender:UIButton!) {
        guard self.selectedImage != nil else {
            print("nil image")
            return
        }
        self.uploadImageBtn.hidden = true
        self.label.text = "Uploading..."
        
        if let myImg = self.selectedImage, let imgData = UIImageJPEGRepresentation(myImg, 0.8) {
            
            Alamofire.upload(
                .POST,
                "http://52.89.160.63/slack/test/verify",
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: imgData, name: "upload", fileName: "file.png", mimeType: "image/png")
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                            self.label.text = "Upload Successful"
                        }
                        
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
                }
            )
        }
        self.selectedImageBtn.hidden = false
        
    }
}