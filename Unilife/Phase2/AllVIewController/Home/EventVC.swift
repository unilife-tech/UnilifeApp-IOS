//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import Photos

class EventVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var imgUserEvent: UIImageView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var txtDes: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtlink: UITextField!
     @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var heightOFImageEvent: NSLayoutConstraint!
    
    var kplaceAddress = "Enter Description"
    let pickerController = UIImagePickerController()
          var asset: PHAsset?
          var selectedimage:UIImage!
    var getImageURL:String = ""
    var isGroup:Bool = false
    typealias Parameters = [String: String]
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdatUI()
         UpdateGroupUI()
        txtDes.text = kplaceAddress
        txtDes.textColor = UIColor.lightGray
        txtDes.layer.cornerRadius = 5
        txtDes.layer.borderWidth = 1.0
        txtDes.layer.borderColor =  UIColor.unilifeBorderColor.cgColor
        imgUserProfile.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
        self.lblname.text = UserData().name
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
       // self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.heightOFImageEvent.constant = self.view.frame.size.width - 80
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let crossHome    = UIImage(named: "crossHome")!

        let backButton   = UIBarButtonItem(image: crossHome,  style: .plain, target: self, action: #selector(CancelBack(sender:)))
        backButton.tintColor = UIColor.red
        navigationItem.leftBarButtonItem = backButton
        
         let rightButton   = UIBarButtonItem(title: "Post",  style: .done, target: self, action: #selector(PostButton(sender:)))
        rightButton.tintColor = UIColor.unilifeButtonBlueColor
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.title = "Event"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @objc func CancelBack(sender: AnyObject){
            self.navigationController?.popViewController(animated: true)
       }

       @objc func PostButton(sender: AnyObject){
               
               let getQuestion:String = self.txtTitle.text ?? ""
               if(getQuestion.trim().count > 0)
               {
       //            let link:String = self.txtlink.text ?? ""
       //            if(link.trim().count > 0)
       //            {
                       var des:String = self.txtDes.text ?? ""
                       if(des.trim() == kplaceAddress)
                       {
                           des = ""
                       }
                       if(des.count > 0)
                       {
                           if(getImageURL.count > 0)
                           {
                               self.connection_Event()
                           }else
                           {
                               Singleton.sharedInstance.customAlert(getMSG: msgEnterEventImage)
                           }
                       }else
                       {
                         Singleton.sharedInstance.customAlert(getMSG: msgEnterEventDes)
                       }
       //            }else
       //            {
       //                Singleton.sharedInstance.customAlert(getMSG: msgEnterEventLink)
       //            }
               }else
               {
                   Singleton.sharedInstance.customAlert(getMSG: msgEnterEventTitle)
               }
           }
    
    @IBAction func click_Back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func UpdatUI()
    {
           imgUserProfile.layer.cornerRadius = 78/2
           imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
           imgUserProfile.layer.borderWidth = 2.0
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
    @IBAction func Click_SelectImage(sender:UIButton)
    {
       
        let actionSheetController: UIAlertController = UIAlertController(title: "" , message: "Set profile image", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
        }
        
       
      
        let galleryAction: UIAlertAction = UIAlertAction(title: "Choose from gallery", style: .default) { action -> Void in
           
            self.openImagePicker()
        }
        let cameraAction: UIAlertAction = UIAlertAction(title: "Take a picture", style: .default) { action -> Void in
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.delegate = self
            vc.modalPresentationStyle = .pageSheet
            
            if(kDeviceType == "ipad")
            {
                //                vc.modalPresentationStyle = .popover
                //                vc.popoverPresentationController?.delegate = self
                //                vc.popoverPresentationController?.sourceView = self.view
                vc.modalPresentationStyle = .pageSheet
            }else
            {
                vc.modalPresentationStyle = .pageSheet
                
            }
            self.present(vc, animated: true, completion: nil)
            
        }
        
      
       
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(galleryAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func click_save()
    {
        
        let getQuestion:String = self.txtTitle.text ?? ""
        if(getQuestion.trim().count > 0)
        {
//            let link:String = self.txtlink.text ?? ""
//            if(link.trim().count > 0)
//            {
                var des:String = self.txtDes.text ?? ""
                if(des.trim() == kplaceAddress)
                {
                    des = ""
                }
                if(des.count > 0)
                {
                    if(getImageURL.count > 0)
                    {
                        self.connection_Event()
                    }else
                    {
                        Singleton.sharedInstance.customAlert(getMSG: msgEnterEventImage)
                    }
                }else
                {
                  Singleton.sharedInstance.customAlert(getMSG: msgEnterEventDes)
                }
//            }else
//            {
//                Singleton.sharedInstance.customAlert(getMSG: msgEnterEventLink)
//            }
        }else
        {
            Singleton.sharedInstance.customAlert(getMSG: msgEnterEventTitle)
        }
    }
}


extension EventVC:UITextViewDelegate
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
// MARK: Image Picker   ------------------------------------------------------
//------------------------------------------------------



extension EventVC
{
    
    func openImagePicker(){
        
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage else {
                self.dismiss(animated: true, completion: nil)
                return
        }
        
        self.selectedimage = image
        var getitn = self.compressImage()
        if(getitn == 1)
        {
            getitn = self.compressImage()
        }
        
        
        self.imgUserEvent.image = self.selectedimage
        
        
        //   self.imgUserProfile.image = self.selectedimage
        self.dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.Connection_UploadImage()
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
    
    
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {self.dismiss(animated: true, completion: nil)
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
                    //    print(json)
                    let getDic:NSDictionary = json as! NSDictionary
                    let getStatus:Bool = (getDic.value(forKey: "status") as? Bool )!
                    if(getStatus == true)
                    {
                        
                        let getImageURL:String = getDic.value(forKey: "data") as? String ?? ""
                        // self.userImageURL = getImageURL
                        // print("-------------__----------__----->",getImageURL)
                        DispatchQueue.main.async { [unowned self] in
                            
                            self.getImageURL = getImageURL
                            print("-------------__----------__----->",self.getImageURL)
                            
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
}


//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension EventVC
{
    func connection_Event()
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
           
            let params = [
                "event_title":self.txtTitle.text ?? "",
                "event_link":self.txtlink.text ?? "",
                "event_description" :self.txtDes.text ?? "",
                "event_images":self.getImageURL
                ] as [String : Any]
            
            
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
         print(params)
            
            print(ConstantsHelper.create_eventURL)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.create_eventURL, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
          
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
