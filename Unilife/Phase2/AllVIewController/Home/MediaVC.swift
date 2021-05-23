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

class MediaVC: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var txtDes: UITextView!
    
    var kplaceAddress = "Write a Caption"
    var cropStyle:TOCropViewCroppingStyle?
      var cropViewController = TOCropViewController()
      let image_picker = UIImagePickerController()
      var imageData:Data!
      var imageName = ""
      var data:NSData?
      var condition = ""
      var videoUrl = ""
    var videoUrlFinal:URL?
      var isImageUploaded = false
    var selectedIndex:Int = -1
    var postDataArray = [[String: AnyObject]]()
    var postId = [String]()
    var selectedimage:UIImage!
     var imageArray = [UIImage(named: "add-post"), UIImage(named: "add-post"), UIImage(named: "add-post"), UIImage(named: "add-post"), UIImage(named: "add-post"), UIImage(named: "add-post")]
    
    typealias Parameters = [String: String]
    var isGroup:Bool = false
    @IBOutlet weak var imgCheckBox: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtDes.text = kplaceAddress
               txtDes.textColor = UIColor.lightGray
               txtDes.layer.cornerRadius = 5
               txtDes.layer.borderWidth = 1.0
               txtDes.layer.borderColor =  UIColor.unilifeBorderColor.cgColor
        UpdateGroupUI()
        for _ in 0..<6 {
                   
                   self.postDataArray.append([:])
               }
        
        

               
    }
    
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
              let crossHome    = UIImage(named: "crossHome")!

              let backButton   = UIBarButtonItem(image: crossHome,  style: .plain, target: self, action: #selector(CancelBack(sender:)))
              backButton.tintColor = UIColor.red
              navigationItem.leftBarButtonItem = backButton
              
               let rightButton   = UIBarButtonItem(title: "Post",  style: .done, target: self, action: #selector(PostButton(sender:)))
              rightButton.tintColor = UIColor.unilifeButtonBlueColor
              navigationItem.rightBarButtonItem = rightButton
              navigationItem.title = "Add Post"
       }
//    @IBAction func click_Back()
//       {
//           self.navigationController?.popViewController(animated: true)
//       }
  
    
    @objc func CancelBack(sender: AnyObject){
            self.navigationController?.popViewController(animated: true)
       }

    @objc func PostButton(sender: AnyObject)
    {
        var isempty:Bool = true
        for i in 0..<self.postDataArray.count
        {
            if !self.postDataArray[i].isEmpty {
                isempty = false
            }
        }
       
        

        if isempty == true{
            self.showDefaultAlert(Message: msgMediaImage)
            return
        }
        
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
        
        
        self.connection_PostMediaCreated()
    }
    
    @IBAction func click_group()
       {
           if(isGroup == true)
           {
               isGroup = false
           }else
           {
               isGroup = true
           }
           UpdateGroupUI()
       }
       
       func UpdateGroupUI()
       {
           if(isGroup == true)
           {
               imgCheckBox.image = UIImage.init(named: "isselected")
           }else
           {
               imgCheckBox.image = UIImage.init(named: "isnotselected")
           }
       }
    
    @IBAction func click_DeleteImage(sender:UIButton)
    {
        self.postDataArray[sender.tag] = [:]
        self.collection.reloadData()
    }
    /*
    @IBAction func click_post()
    {
        var isempty:Bool = true
        for i in 0..<self.postDataArray.count
        {
            if !self.postDataArray[i].isEmpty {
                isempty = false
            }
        }
       
        

        if isempty == true{
            self.showDefaultAlert(Message: msgMediaImage)
            return
        }
        
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
        
        
        self.connection_PostMediaCreated()
    }
    */
}


//------------------------------------------------------
// MARK: Collection View   ------
//------------------------------------------------------


extension MediaVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return self.postDataArray.count
        
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImagePropertyCollectionCell", for: indexPath as IndexPath) as! AddImagePropertyCollectionCell
        cell.btnDelete.tag = indexPath.row
        if self.postDataArray[indexPath.row].isEmpty {
                       
                       cell.btnDelete.isHidden = true
                       
                       cell.img.image = UIImage(named: "NoImageMedia")
                   }else {
                       
                       // o8e3bids.png
                       
                       if String(describing: (self.postDataArray[indexPath.row])["type"]!) == "video" {
                           
                           cell.img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                           
                           cell.img.sd_setImage(with: URL(string: postImageUrl + String(describing: (self.postDataArray[indexPath.row])["img"]!)), placeholderImage:UIImage(named: "NoImageMedia"))
                           
                       }else {
                           
                           cell.img.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                           cell.img.sd_setImage(with: URL(string: postImageUrl + String(describing: (self.postDataArray[indexPath.row])["img"]!)), placeholderImage:UIImage(named: "add-post"))
                           
                       }
                       
                       cell.btnDelete.isHidden = false
                   }
       
            return cell
                
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: self.view.bounds.size.width/4, height: collectionView.frame.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
       showAttachFileOptions()
    }
}


extension MediaVC:UITextViewDelegate
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




// MARK: - Image Picker Controller

extension MediaVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    func showAttachFileOptions(){
        
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
            optionMenu.addAction(takeVideo_Action)
           
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
        // optionMenu.addAction(uploadVideo_Action)
        //        optionMenu.addAction(uploadPdf_Action)
        optionMenu.addAction(cancelAction)
        self.isImageUploaded = true
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]) {
        
        
        if (String(describing: info[UIImagePickerController.InfoKey.mediaType]!) == "public.image"){
            
            
            let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
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
            self.isImageUploaded = true
            self.navigationController?.present(cropViewController, animated: true, completion: nil)
            self.condition = "image"
            */
            
            self.imageName = self.GenerateUniqueImageName()
             
            // self.imageData = (image.jpegData(compressionQuality: 0.8))
             
             self.condition = "image"
             
             self.imageArray.insert(selectedImage, at: self.selectedIndex)
             self.selectedimage = selectedImage
            self.addPostAttahment(type: "image")
            self.dismiss(animated: true, completion: nil)
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
            self.isImageUploaded = true
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        self.imageName = self.GenerateUniqueImageName()
        
       // self.imageData = (image.jpegData(compressionQuality: 0.8))
        
        self.condition = "image"
        
        self.imageArray.insert(image, at: self.selectedIndex)
        
        print(self.selectedIndex)
        self.selectedimage = image
        // self.selectImage_CollectionView.reloadData()
        
        self.addPostAttahment(type: "image")
        
        self.dismiss(animated: true, completion: nil)
        
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
        
        self.image_picker.mediaTypes = ["public.image","public.movie"]
        
        present(image_picker, animated: true, completion: nil)
        
    }
    
    func videoLibrary(){
        
        self.image_picker.mediaTypes = ["public.movie"]
        self.image_picker.delegate = self
        present(image_picker, animated: true, completion: nil)
        
    }
    
   
    //
    //    func GenerateUniqueImageName() -> String {
    //
    //        let milisec = Int((Date().timeIntervalSince1970 * 1000).rounded())
    //        return ("Unilife_" + "\(milisec)" + "\(UserData().userId)" + ".jpeg")
    //
    //    }
    
    // MARK: -  Func Genearting Thumb Nail
    
    func generateThumbnail(path: URL) -> Data? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            
            // cgImage = self.GenerateUniqueImageName() as! CGImage
            
            let   thumbnail = UIImage(cgImage: cgImage)
            
            //self.imageArray.insert(thumbnail, at: selectedIndex)
            //            self.selectImage_CollectionView.reloadData()
            
            let data = thumbnail.jpegData(compressionQuality: 0.8)
            
            
            return data
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
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
    
    
    func addPostAttahment( type: String) {
        
        if  type == "video"{
           print(self.videoUrl)
            self.Connection_UploadVideo()
        }else {
            
         self.Connection_UploadImage()
            
        }
        
        
        /*
        
        
        var param = [String: AnyObject]()
        
        
        if  self.condition != "video"{
            param = ["attachment_type": type, "thumbnail":"", "device_type": "ios"] as [String: AnyObject]
            
        }else {
            
            param = ["attachment_type": type, "thumbnail":(self.generateThumbnail(path: NSURL(string: self.videoUrl)! as URL)!).base64EncodedString(options: .endLineWithLineFeed), "device_type": "ios"] as [String: AnyObject]
            
        }
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithSingleFile(FileData: self.imageData, FileName: self.imageName, FileType: type, FileParam: "attachment", getUrlString: "add_post_attachment", params: param as [String: AnyObject]) { (receviedData,responseCode) in
            
            print(receviedData)
            if responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.imageData = nil
                    self.imageName = ""
                    self.isImageUploaded = false
                    self.videoUrl = ""
                    
                    self.postId.append(String(describing: (receviedData["data"] as! [String: AnyObject])["id"]!))
                    
                    
                    self.postDataArray[self.selectedIndex] = receviedData["data"] as! [String: AnyObject]
                    
                    
                    
                    print(self.postDataArray)
                    self.collection.reloadData()
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    
                }
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
        */
        
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
            print("get_mb_kb==\(get_mb_kb)")
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
                                var dic:[String:AnyObject] = [String:AnyObject]()
                                dic["type"] = "image" as AnyObject
                                dic["img"] = getImageURL as AnyObject
                                self.postDataArray[self.selectedIndex] = dic
                            }else
                            {
                                let getDic:[String:AnyObject] = self.postDataArray[self.selectedIndex]
                                let getVideo:String = getDic["vid"] as? String ?? ""
                                //print(getVideo)
                                var dic:[String:AnyObject] = [String:AnyObject]()
                                dic["type"] = "video" as AnyObject
                                dic["img"] = getImageURL as AnyObject
                                dic["vid"] = getVideo as AnyObject
                                self.postDataArray[self.selectedIndex] = dic
                                
                            }
                           // print("-------------__----------__----->",self.getImageProfileURL)
                            print(self.postDataArray)
                            //     ZKProgressHUD.dismiss()
                            Indicator.shared.hideProgressView()
                            self.collection.reloadData()
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
                            
                          
                            var dic:[String:AnyObject] = [String:AnyObject]()
                            dic["type"] = "video" as AnyObject
                            dic["vid"] = getImageURL as AnyObject
                            self.postDataArray[self.selectedIndex] = dic
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
/*
    func  createVideoDataBody(withParameters params:Parameters?, media:[MediaVideo]?, boundary:String) -> Data {
        let lineBreak = "\r\n"
        var body  = Data()
        if let parameters = params{
            for(key, value) in parameters{
              print(key,"----",value)
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            for photo in media{
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"; type=\"\(photo.type)\"\(lineBreak)")
                body.append("COntent-Type: \(photo.mime + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
            
        }
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    */
}



extension MediaVC
{
    
    func connection_CreatePost()
    {
        
        Indicator.shared.showProgressView(self.view)
        var isUpdateGroupPost:String = "no"
        
        if(isGroup == true)
        {
            isUpdateGroupPost = "yes"
        }
        
        var captio:String = self.txtDes.text ?? ""
        if(captio == kplaceAddress)
        {
            captio = ""
        }
        
       // let param = ["user_id": UserData().userId, "caption": captio, "post_attachment_ids": self.postId, "post_through_group": isUpdateGroupPost,"tag_user": "","tag_group": "","location_name": ""] as [String: AnyObject]
        
         let param = ["user_id": UserData().userId, "caption": captio, "post_attachment_ids": ["981"], "post_through_group": isUpdateGroupPost,"tag_user": [],"tag_group": [],"location_name": ""] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "add_post", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.showAlertWithAction(Title: "Unilife", Message: ((receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found"), ButtonTitle: "Ok", outputBlock: {
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    
    func connection_PostMediaCreated()
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
        var aryVideo:[String] = [String]()
        var aryImg:[String] = [String]()
        for i in 0..<self.postDataArray.count
        {
            if !self.postDataArray[i].isEmpty {
                if String(describing: (self.postDataArray[i])["type"]!) == "video" {
                    let thambnail:String = self.postDataArray[i]["img"] as? String ?? ""
                    let video = self.postDataArray[i]["vid"] as? String ?? ""
                    let FinalURl = video + "," + thambnail
                    aryVideo.append(FinalURl)
                }else
                {
                    let image:String = self.postDataArray[i]["img"] as? String ?? ""
                    aryImg.append(image)
                }
            }
        }
        
        var finalImgString:String = ""
        for i in 0..<aryImg.count
        {
            if(i == 0)
            {
                finalImgString = aryImg[i]
            }else
            {
                finalImgString = "," + aryImg[i]
            }
        }
          
        var finalVideoDic:[String:Any] = [String:Any]()
        for j in 0..<aryVideo.count
        {
            finalVideoDic["\(j)"] = aryVideo[j]
        }
        
          let params = [
             "caption":captio,
             "group_id":"",
              "event_images":finalImgString,
              "event_video":finalVideoDic,
              
            ] as [String : Any]
          /*
         {"caption":"Lorem Ipsum is simply" ,"event_images":"asd.png" , "group_id" :"" , "event_video":{"1":"a50a159a2ce9523cb225cffbec11c0bb.mp4,hci5ckb2Unilife_156904749141570.jpeg","2":"a50a159a2ce9523cb225cffbec11c0bb.mp4,hci5ckb2Unilife_156904749141570.jpeg"}}
         */
          
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
   // print(params)
        print(ConstantsHelper.HomeMEdiaURL)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.HomeMEdiaURL, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                 print(response)
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
