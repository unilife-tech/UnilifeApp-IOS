//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import TOCropViewController
import SDWebImage
import AVFoundation
import MobileCoreServices


class OpinionShareVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {

    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var viwBottomSecion: UIView!
    @IBOutlet weak var viwBottomInnerOption: UIView!
    @IBOutlet weak var txtDes: UITextView!
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var heightOFimg: NSLayoutConstraint!
     @IBOutlet weak var heightOFBottomViw: NSLayoutConstraint!
    var kplaceAddress = "What opinion do you wanna Share"
    var finalImgString:String = ""
    var finalVideoDic:String = ""
    
     var cropStyle:TOCropViewCroppingStyle?
    var cropViewController = TOCropViewController()
         let image_picker = UIImagePickerController()
         var imageData:Data!
         var imageName = ""
         var data:NSData?
         var condition = ""
         var videoUrl = ""
       var videoUrlFinal:URL?
        var selectedimage:UIImage!
    typealias Parameters = [String: String]
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdatUI()
        btnDelete.isHidden = true
        imgUserProfile.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
        self.lblname.text = UserData().name
        txtDes.text = kplaceAddress
        txtDes.textColor = UIColor.lightGray
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .up
           self.viwBottomSecion.addGestureRecognizer(swipeRight)

           let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
           swipeDown.direction = .down
           self.viwBottomSecion.addGestureRecognizer(swipeDown)
        
    }
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
          // self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.viwBottomSecion.roundCornersIMG(corners: [.topLeft,.topRight], radius: CGFloat(40))
        self.viwBottomSecion.layer.cornerRadius = 40
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        
        self.viwBottomSecion.layer.shadowColor = UIColor.gray.cgColor
        self.viwBottomSecion.layer.shadowOpacity = 0.2
        self.viwBottomSecion.layer.shadowOffset = CGSize(width: 1, height: -1)
        self.viwBottomSecion.layer.shadowRadius = 1.8
       // self.viwBottomSecion.layer.shadowPath = UIBezierPath(rect: self.viwBottomSecion.bounds).cgPath
        self.viwBottomSecion.layer.shouldRasterize = false
        }
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
              let crossHome    = UIImage(named: "crossHome")!

              let backButton   = UIBarButtonItem(image: crossHome,  style: .plain, target: self, action: #selector(CancelBack(sender:)))
              backButton.tintColor = UIColor.red
              navigationItem.leftBarButtonItem = backButton
              
               let rightButton   = UIBarButtonItem(title: "Post",  style: .done, target: self, action: #selector(PostButton(sender:)))
              rightButton.tintColor = UIColor.unilifeButtonBlueColor
              navigationItem.rightBarButtonItem = rightButton
              navigationItem.title = "What opinion"
        
        
       }

    
    @objc func CancelBack(sender: AnyObject){
            self.navigationController?.popViewController(animated: true)
       }

    @objc func PostButton(sender: AnyObject){
       
        var captio:String = self.txtDes.text ?? ""
        if(captio == kplaceAddress)
        {
            captio = ""
        }
        if(captio.count == 0)
        {
            self.showDefaultAlert(Message: msgMediaDes)
            return
        }
        
        
        self.connection_Poll()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
            case .down:
                //print("Swiped down")
                heightOFBottomViw.constant = 80
                UIView.animate(withDuration: 0.4) {
                    self.view.layoutIfNeeded()
                    self.viwBottomInnerOption.isHidden = true
                }
            case .left:
                print("Swiped left")
            case .up:
                //print("Swiped up")
                heightOFBottomViw.constant = 266
                viwBottomInnerOption.isHidden = false
                UIView.animate(withDuration: 0.4) {
                    self.view.layoutIfNeeded()
                    
                }
            default:
                break
            }
        }
    }
    
   @objc func keyboardWillShow(notification: NSNotification) {
    self.viwBottomSecion.isHidden = true
    }

    @objc func keyboardWillHide(notification: NSNotification){
         self.viwBottomSecion.isHidden = false
    }
    
//    @IBAction func click_Back()
//       {
//           self.navigationController?.popViewController(animated: true)
//       }
    
    func UpdatUI()
          {
              
              imgUserProfile.layer.cornerRadius = 50/2
              imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
              imgUserProfile.layer.borderWidth = 2.0
            
            
            let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            numberToolbar.barStyle = .default
            let image = UIImage(named: "ic_panorama_24px")?.withRenderingMode(.alwaysOriginal)

            let cametaBarBTN = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(cameraToolbar))
                //UIBarButtonItem(title: "Photo/Video", style: .plain, target: self, action: #selector(cameraToolbar))
            
            let doneBarBTN = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneToolbar))
          //  cametaBarBTN.tintColor = UIColor.black
          //  doneBarBTN.tintColor = UIColor.black
            
            
            numberToolbar.items = [
            cametaBarBTN,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneBarBTN]
            numberToolbar.sizeToFit()
            txtDes.inputAccessoryView = numberToolbar
            
            cametaBarBTN.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
                NSAttributedString.Key.foregroundColor : UIColor.black,
            ], for: .normal)
            
            
            doneBarBTN.setTitleTextAttributes(
            [
                NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),
                NSAttributedString.Key.foregroundColor : UIColor.black,
            ], for: .normal)
       }
    
    
    @objc func cameraToolbar() {
        self.optionForImagePicker()
    }
    @objc func doneToolbar() {
        self.txtDes.resignFirstResponder()
    }
    @IBAction func click_TopEventPoll(_ sender: UIButton) {
           
           if(sender.tag == 0)  ////.. media
           {
               let vc = kHomeStoryBoard.instantiateViewController(withIdentifier: "MediaVC") as! MediaVC
                self.navigationController?.pushViewController(vc, animated: true)
           }else if(sender.tag == 1) ////.. Event
           {
               let vc = kHomeStoryBoard.instantiateViewController(withIdentifier: "EventVC") as! EventVC
                self.navigationController?.pushViewController(vc, animated: true)
           }else if(sender.tag == 2) ////.. Poll
           {
               let vc = kHomeStoryBoard.instantiateViewController(withIdentifier: "PollVC") as! PollVC
                self.navigationController?.pushViewController(vc, animated: true)
           }
                    
       }
    
//    @IBAction func click_post()
//       {
//
//           var captio:String = self.txtDes.text ?? ""
//           if(captio == kplaceAddress)
//           {
//               captio = ""
//           }
//           if(captio.count == 0)
//           {
//               self.showDefaultAlert(Message: msgMediaDes)
//               return
//           }
//
//
//           self.connection_Poll()
//       }
    
    
    
    
    
    
    
    
    
    
    func addPostAttahment( type: String) {
        
        if  type == "video"{
           
            self.Connection_UploadVideo()
        }else {
            
         self.Connection_UploadImage()
            
        }
        
    }
    
     func generateThumbnailOFVideo(path: URL) -> UIImage {
               do {
                   let asset = AVURLAsset(url: path, options: nil)
                   let imgGenerator = AVAssetImageGenerator(asset: asset)
                   imgGenerator.appliesPreferredTrackTransform = true
                   let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                   
                   // cgImage = self.GenerateUniqueImageName() as! CGImage
                   
                   let   thumbnail = UIImage(cgImage: cgImage)
                   return thumbnail
                   //self.imageArray.insert(thumbnail, at: selectedIndex)
                   //            self.selectImage_CollectionView.reloadData()
                   
    //               let data = thumbnail.jpegData(compressionQuality: 0.8)
    //
    //
    //               return data
               } catch let error {
                   print("*** Error generating thumbnail: \(error.localizedDescription)")
                   return UIImage()
               }
           }
    
    func compressImage() ->Int
    {
        // img_selected.image = resizeImage(img_selected.image!);
        var ReturnValue:Int = 0
        
        for _ in 0 ..< 10
        {
            
            
            let imageData = self.selectedimage.pngData()
            let formatted_kb = ByteCountFormatter.string(
                fromByteCount: Int64(imageData!.count),
                countStyle: ByteCountFormatter.CountStyle.file
            )
            print(formatted_kb)
            let getkb_array = formatted_kb.components(separatedBy: " ")
            //split(formatted_kb) {$0 == " "}
            
            let get_mb_kb = getkb_array[1]
            
            if(get_mb_kb == "MB")
            {
                
                let image_MEMORY_MB = (getkb_array[0] as NSString).floatValue
                
                // print("image_MEMORY == \(image_MEMORY_MB)")
                if(image_MEMORY_MB < 6)
                {
                    ReturnValue = 1
                    break;
                }else if (image_MEMORY_MB > 6  && image_MEMORY_MB <= 9)
                {
                    self.selectedimage = self.selectedimage.resized(withPercentage: 0.7)
                }else if (image_MEMORY_MB > 9  && image_MEMORY_MB <= 15)
                {
                    self.selectedimage = self.selectedimage.resized(withPercentage: 0.5)
                }else
                {
                    self.selectedimage = self.selectedimage.resized(withPercentage: 0.1)
                }
                ReturnValue = 0
            }else if(get_mb_kb == "KB")
            {
                
                ReturnValue = 1
                break;
                
                
                
            }
            else
            {
                ReturnValue = 1
                break;
            }
            
        }
        return ReturnValue
    }
    
    
    func Connection_UploadImage()
    {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            
            Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
            return
        case .online(.wwan):
            print("")
        case .online(.wiFi):
            print("")
        }
        
        
        Indicator.shared.showProgressView(self.view)
        
        //  ZKProgressHUD.show(NSLocalizedString("Loading"))
        if(selectedimage != nil)
        {
            //            var getitn = self.compressImage()
            //            if(getitn == 1)
            //            {
            //                getitn = self.compressImage()
            //            }
        }
        
        
        
        let parameters = ["type":"image"]
        // print(parameters)
        
        
        guard let mediaImage = Media(withImage: selectedimage ?? UIImage(), forKey: "")else{return}
        
        // guard let url = URL(string: kURL_UPLOADIMAGE + "?data={'userdata':{'user_id': '\(ApplicationManager.instance.user_id)'}}") else {return}
        
        let url = URL(string: ConstantsHelper.upload_post_images)
        //print(url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue(kAPIversion, forHTTPHeaderField: "app-version")
        request.addValue(UserData().userId, forHTTPHeaderField: "Token")
        
        
        let dataBody =  createDataBody(withParameters: parameters, media: [mediaImage], boundary:  boundary)
        request.httpBody = dataBody
        
        let session =  URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            
            
            if let data = data{
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                //        print(json)
                    let getDic:NSDictionary = json as! NSDictionary
                    let getStatus:Bool = (getDic.value(forKey: "status") as? Bool )!
                    if(getStatus == true)
                    {
                        
                        let getImageURL:String = getDic.value(forKey: "data") as? String ?? ""
                        // self.userImageURL = getImageURL
                      //   print("-------------__----------__----->",getImageURL)
                        DispatchQueue.main.async { [unowned self] in
                            
                            if(self.condition == "image")
                            {
                                self.finalImgString = getImageURL
                                self.finalVideoDic = ""
                            }else
                            {
                                self.finalVideoDic =  self.finalVideoDic + "," + getImageURL
                                self.finalImgString = ""
                                self.imgEvent.image = self.selectedimage
                                self.updatehightofImageview(getimg: self.selectedimage)
                                self.btnDelete.isHidden = false
                            }
                           // print("-------------__----------__----->",self.getImageProfileURL)
                          
                            //     ZKProgressHUD.dismiss()
                            Indicator.shared.hideProgressView()
                            
                        }
                        
                        // return
                        
                        
                    }else
                    {
                        let getmessage =  getDic.value(forKey: "message") as? String ?? ""
                        Singleton.sharedInstance.customAlert(getMSG: getmessage)
                        
                    }
                    
                    DispatchQueue.main.async { [unowned self] in
                        
                        //   ZKProgressHUD.dismiss()
                        
                        Indicator.shared.hideProgressView()
                    }
                }catch{
                    //  print(error)
                    DispatchQueue.main.async { [unowned self] in
                        
                        
                        //  ZKProgressHUD.dismiss()
                        
                        Indicator.shared.hideProgressView()
                    }
                }
            }
            
        }.resume()
    }
    
    
    func Connection_UploadVideo()
    {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            
            Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
            return
        case .online(.wwan):
            print("")
        case .online(.wiFi):
            print("")
        }
        
        
        Indicator.shared.showProgressView(self.view)
        
        //  ZKProgressHUD.show(NSLocalizedString("Loading"))
        if(selectedimage != nil)
        {
            //            var getitn = self.compressImage()
            //            if(getitn == 1)
            //            {
            //                getitn = self.compressImage()
            //            }
        }
        
        
        
        let parameters = ["type":"video"]
        print(self.videoUrl)
        
        
        guard let mediaImage = MediaVideo(withImage: self.videoUrlFinal as! URL, forKey: "")else{return}
        
        // guard let url = URL(string: kURL_UPLOADIMAGE + "?data={'userdata':{'user_id': '\(ApplicationManager.instance.user_id)'}}") else {return}
        
        let url = URL(string: ConstantsHelper.upload_post_images)
        //print(url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue(kAPIversion, forHTTPHeaderField: "app-version")
        request.addValue(UserData().userId, forHTTPHeaderField: "Token")
        
        
        let dataBody =  createVideoDataBody(withParameters: parameters, media: [mediaImage], boundary:  boundary)
        request.httpBody = dataBody
        
        let session =  URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            
            
            if let data = data{
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                   //     print(json)
                    let getDic:NSDictionary = json as! NSDictionary
                    let getStatus:Bool = (getDic.value(forKey: "status") as? Bool )!
                    if(getStatus == true)
                    {
                        
                        let getImageURL:String = getDic.value(forKey: "data") as? String ?? ""
                        // self.userImageURL = getImageURL
                      //   print("-------------__----------__----->",getImageURL)
                        DispatchQueue.main.async { [unowned self] in
                            
                          
                           self.finalVideoDic = getImageURL
                           // print("-------------__----------__----->",self.getImageProfileURL)
                            
                            //     ZKProgressHUD.dismiss()
                            Indicator.shared.hideProgressView()
                            self.selectedimage = self.generateThumbnailOFVideo(path: self.videoUrlFinal as! URL)
                            self.Connection_UploadImage()
                        }
                        
                        // return
                        
                        
                    }else
                    {
                        let getmessage =  getDic.value(forKey: "message") as? String ?? ""
                        Singleton.sharedInstance.customAlert(getMSG: getmessage)
                        
                    }
                    
                    DispatchQueue.main.async { [unowned self] in
                        
                        //   ZKProgressHUD.dismiss()
                        
                        Indicator.shared.hideProgressView()
                    }
                }catch{
                    //  print(error)
                    DispatchQueue.main.async { [unowned self] in
                        
                        
                        //  ZKProgressHUD.dismiss()
                        
                        Indicator.shared.hideProgressView()
                    }
                }
            }
            
        }.resume()
    }
    
    
    func generateBoundary()->String{
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func  createDataBody(withParameters params:Parameters?, media:[Media]?, boundary:String) -> Data {
        let lineBreak = "\r\n"
        var body  = Data()
        if let parameters = params{
            for(key, value) in parameters{
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            for photo in media{
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("COntent-Type: \(photo.mime + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
            
        }
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    func  createVideoDataBody(withParameters params:Parameters?, media:[MediaVideo]?, boundary:String) -> Data {
           let lineBreak = "\r\n"
           var body  = Data()
           if let parameters = params{
               for(key, value) in parameters{
                   
                   body.append("--\(boundary + lineBreak)")
                   body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                   body.append("\(value + lineBreak)")
               }
           }
           if let media = media {
               for photo in media{
                   
                   body.append("--\(boundary + lineBreak)")
                   body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                   body.append("COntent-Type: \(photo.mime + lineBreak + lineBreak)")
                   body.append(photo.data)
                   body.append(lineBreak)
               }
               
           }
           body.append("--\(boundary)--\(lineBreak)")
           
           return body
       }
    
    
    
    
   @IBAction  func showAttachFileOptions()
   {
    self.txtDes.becomeFirstResponder()
    //self.optionForImagePicker()
    }
    @IBAction  func clickDeletePic()
    {
        self.heightOFimg.constant = 0
        self.btnDelete.isHidden = true
        self.self.finalImgString = ""
    }
    
    func optionForImagePicker()
    {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = UIColor(red: 99/255, green: 137/255, blue: 172/255, alpha: 1.0)
        
        
        //Check device has a camera or not
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //Captrue picture uisng camera
            
            let takePhoto_Action = UIAlertAction(title: "Capture Image ", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.camera()
                

                
            })
            
            let takeVideo_Action = UIAlertAction(title: "Capture Video", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                
                    self.openVideoCamera()
                
            })
            
            optionMenu.addAction(takePhoto_Action)
          //  optionMenu.addAction(takeVideo_Action)
           
        }
        
        //Picture coose from library
        let choosePhoto_Action = UIAlertAction(title: "Upload Media", style: .default, handler: {(alert:UIAlertAction) -> Void in
            
            self.photolibrary()
            
        })
        
        let uploadVideo_Action = UIAlertAction(title: "Upload Video", style: .default, handler: {(alert:UIAlertAction) -> Void in
            
            self.videoLibrary()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(choosePhoto_Action)
        //optionMenu.addAction(uploadVideo_Action)
        //        optionMenu.addAction(uploadPdf_Action)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]) {
            
            
            if (String(describing: info[UIImagePickerController.InfoKey.mediaType]!) == "public.image"){
                
                
                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                self.condition = "image"
                self.selectedimage = image
                self.addPostAttahment(type: "image")
                self.dismiss(animated: true, completion: nil)
                self.imgEvent.image = image
                self.updatehightofImageview(getimg: image)
                self.btnDelete.isHidden = false
                
                /*
                self.cropViewController.customAspectRatio = CGSize(width: self.view.frame.width, height: self.view.frame.width)
                
                self.cropStyle = TOCropViewCroppingStyle.default
                
                self.cropViewController = TOCropViewController(croppingStyle: self.cropStyle!, image: selectedImage)
                
                self.cropViewController.toolbar.clampButtonHidden = true
                
                cropViewController.toolbar.rotateClockwiseButtonHidden = true
                
                cropViewController.cropView.setAspectRatio(CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width), animated: true)
                
                cropViewController.cropView.aspectRatioLockEnabled = true
                
                cropViewController.toolbar.rotateButton.isHidden = true
                
                cropViewController.toolbar.resetButton.isHidden = true
                
                cropViewController.delegate = self
                
                self.dismiss(animated: true, completion: nil)
               
                self.navigationController?.present(cropViewController, animated: true, completion: nil)
                self.condition = "image"
                
                */
            }else{
                
                self.imageName = self.GenerateUniqueImageName().replacingOccurrences(of: ".jpeg", with: ".mp4")
                let videoUrl1 = info[UIImagePickerController.InfoKey.mediaURL]
                self.condition = "video"
                self.videoUrl = String(describing:  info[UIImagePickerController.InfoKey.mediaURL]!)
                self.videoUrlFinal = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                
                
                //generateThumbnail(path: videoUrl1 as! URL)
                
    //            do {
    //                try
    //                    self.imageData = Data(contentsOf: videoUrl1 as! URL)
    //
    //            } catch {
    //                return
    //            }
    //
                //            let messageDist = [["Name" : self.imageName,
                //                                "Size" : self.imageData.count,
                //                                "room_id" : self.rooomId]] as [[String  : AnyObject]]
                //
                //            self.socket.emitWithAck("uploadFileStart", messageDist).timingOut(after: 0){data in
                //
                //            }
                self.addPostAttahment(type: "video")
               
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }
        
        func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
            
            self.imageName = self.GenerateUniqueImageName()
            
           // self.imageData = (image.jpegData(compressionQuality: 0.8))
            
            self.condition = "image"
            
           
            self.selectedimage = image
            // self.selectImage_CollectionView.reloadData()
            
            self.addPostAttahment(type: "image")
            
            self.dismiss(animated: true, completion: nil)
            self.imgEvent.image = image
            self.updatehightofImageview(getimg: image)
            self.btnDelete.isHidden = false
        }
        
        func camera(){
            
            self.image_picker.sourceType = .camera
            
            self.image_picker.delegate = self
            
            present(image_picker, animated: true, completion: nil)
            
        }
        
        func openVideoCamera() {
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                let image_pickerVideo = UIImagePickerController()
            
           image_pickerVideo.sourceType = .camera
           image_pickerVideo.mediaTypes = [kUTTypeMovie as String]
           image_pickerVideo.delegate = self
           present(image_pickerVideo, animated: true, completion: nil)
                
            }
            
        }
        
        func photolibrary(){
            
            self.image_picker.sourceType = .photoLibrary
            
            self.image_picker.delegate = self
            
            self.image_picker.mediaTypes = ["public.image"]//["public.image","public.movie"]
            
            present(image_picker, animated: true, completion: nil)
            
        }
        
        func videoLibrary(){
            
            self.image_picker.mediaTypes = ["public.movie"]
            self.image_picker.delegate = self
            present(image_picker, animated: true, completion: nil)
            
        }
    
    
    func updatehightofImageview(getimg:UIImage)
    {
        let ratio = getimg.size.width / getimg.size.height
        let newHeight = imgEvent.frame.width / ratio
        self.heightOFimg.constant = newHeight
             
    }
    
}




extension OpinionShareVC:UITextViewDelegate
{
func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
        textView.text = nil
        textView.textColor = UIColor.black
    }
}

func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = kplaceAddress
        textView.textColor = UIColor.lightGray
    }
}
}
//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension OpinionShareVC
{
    func connection_Poll()
        {
            //.... check inter net
            
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                //print("Not connected")
                
               Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
                
                return
            case .online(.wwan):
                print("")
            case .online(.wiFi):
                print("")
            }
            let captio:String = self.txtDes.text ?? ""
            var dic:[String:Any] = [String:Any]()
            if(self.finalVideoDic.count > 0)
            {
              dic["1"] = self.finalVideoDic
            }
            
            let params = [
                "caption":captio,
                "group_id":"",
                "event_images":self.finalImgString,
                "event_video":dic,
                ] as [String : Any]
            
            
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
            print(params)
            print(UserData().userId)
            print(ConstantsHelper.HomeCreate_opinion)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.HomeCreate_opinion, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
          
                if(response is NSDictionary)
                {
                 //  print(response)
                    let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                    if(status == true)
                    {
                        self.navigationController?.popViewController(animated: true)
                         let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                        Singleton.sharedInstance.customAlert(getMSG: getMessage)
                    }else
                    {
                        let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                       Singleton.sharedInstance.customAlert(getMSG: getMessage)
                    }
                }else
                {
                    Indicator.shared.hideProgressView()
                    Singleton.sharedInstance.customAlert(getMSG: API_FAILED)
                }
                
                
            }
            
        }
    
}



extension UIView {
     func roundCornersIMG(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
