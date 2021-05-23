//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import Photos

class RegistrationVC_New9: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var lblName: UILabel!
        @IBOutlet weak var userIMage: UIImageView!
        typealias Parameters = [String: String]
    
    let pickerController = UIImagePickerController()
          var asset: PHAsset?
          var selectedimage:UIImage!
      var getImageProfileURL:String = ""
    var university_id:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fname:String = ApplicationManager.instance.reg_Dic["fname"] ?? ""
        let lname:String = ApplicationManager.instance.reg_Dic["lname"] ?? ""
        self.lblName.text =  fname + " " + lname
        
        userIMage.layer.cornerRadius = 300/2
    }

    @IBAction func click_Back()
       {
           self.navigationController?.popViewController(animated: true)
       }
    
    
    
    func gotoNext()
    {
        ApplicationManager.instance.reg_Dic["img"] = getImageProfileURL
                let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New10") as! RegistrationVC_New10
                          self.navigationController?.pushViewController(vc, animated: true)
           
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
  
    func setUPUserDataINKeychain(getId:Int)
    {
        let fname:String = ApplicationManager.instance.reg_Dic["fname"] ?? ""
        let lname:String = ApplicationManager.instance.reg_Dic["lname"] ?? ""
        let getName =  fname + " " + lname
        let email:String = ApplicationManager.instance.reg_Dic["email"] ?? ""
        let password:String = ApplicationManager.instance.reg_Dic["password"] ?? ""
        let universityid:String = ApplicationManager.instance.reg_Dic["universityid"] ?? ""
        
        
          let obj = [
            "complete_profile": "",
            "created_at" : "",
            "decoded_password" : password,
            "id" : "\(getId)",
            "is_online" : "offline",
            "otp" : "",
            "otp_verify" : "yes",
            "password" : "",//"$2a$10$jaHqrAQkhxxNt49UnnpDAOEVktrQ9mGvxJsOHqMNziO7QA.6shpDu",
            "profile_image" : self.getImageProfileURL,
            "profile_status" : "public",
            "remember_token" : "",
            "reset_password" : "",
            "status" : "active",
            "university_school_email" : email,
            "university_school_id" : universityid,
            "updated_at" : "",
            "user_type" : 0,
            "username" : getName
        ] as! [String: AnyObject]
        
         UserDefaults.standard.setValue((NSKeyedArchiver.archivedData(withRootObject: obj as! [String: AnyObject])), forKey: "userData")
        print(UserData().userId)
        
    }
    
    
    @IBAction func click_Next()
    {
         self.connection_University()
    }
}


//------------------------------------------------------
// MARK: Image Picker   ------------------------------------------------------
//------------------------------------------------------



extension RegistrationVC_New9
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
        
        
      //  self.imgUserProfile.image = self.selectedimage
        
        
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
        
        
        
        let parameters = ["":""]
        // print(parameters)
        
        
        guard let mediaImage = Media(withImage: selectedimage ?? UIImage(), forKey: "")else{return}
        
        // guard let url = URL(string: kURL_UPLOADIMAGE + "?data={'userdata':{'user_id': '\(ApplicationManager.instance.user_id)'}}") else {return}
        
        let url = URL(string: ConstantsHelper.UplaodImageURL)
        print(url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let boundary = generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue(kAPIversion, forHTTPHeaderField: "app-version")
        request.addValue("", forHTTPHeaderField: "Token")
        
        
        let dataBody =  createDataBody(withParameters: parameters, media: [mediaImage], boundary:  boundary)
        request.httpBody = dataBody
        
        let session =  URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            
            
            if let data = data{
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print(json)
                    let getDic:NSDictionary = json as! NSDictionary
                    let getStatus:Bool = (getDic.value(forKey: "status") as? Bool )!
                    if(getStatus == true)
                    {
                        
                        let getImageURL:String = getDic.value(forKey: "data") as? String ?? ""
                        // self.userImageURL = getImageURL
                        // print("-------------__----------__----->",getImageURL)
                        DispatchQueue.main.async { [unowned self] in
                            
                            self.getImageProfileURL = getImageURL
                            print("-------------__----------__----->",self.getImageProfileURL)
                            self.userIMage.image = self.selectedimage
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
            }else
            {
                Indicator.shared.hideProgressView()
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

extension RegistrationVC_New9
{
    func connection_registration(getID:String)
        {
            //.... check inter net
            ConstantsHelper.OtherUserID = 625
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
           let fname:String = ApplicationManager.instance.reg_Dic["fname"] ?? ""
           let lname:String = ApplicationManager.instance.reg_Dic["lname"] ?? ""
           let getName =  fname + " " + lname
           
           let email:String = ApplicationManager.instance.reg_Dic["email"] ?? ""
            let type:String = ApplicationManager.instance.reg_Dic["type"] ?? ""
           let password:String = ApplicationManager.instance.reg_Dic["password"] ?? ""
            let dob:String = ApplicationManager.instance.reg_Dic["dob"] ?? ""
          //  let universityid:String = ApplicationManager.instance.reg_Dic["universityid"] ?? ""

            let params = [
                "university_id":getID,"email":email,"username":getName,"gender":type,"date_of_birth":dob,"password":password,"profile_image":self.getImageProfileURL
                ] as [String : Any]
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
          print(params)
            print(ConstantsHelper.register)
            WebServiceManager.shared.callWebService_OtherAuth(ConstantsHelper.register, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                
                if(response is NSDictionary)
                {
                    
                   print(response)
                    let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                    if(status == true)
                    {
                         let getID = (response as! NSDictionary).value(forKey: "id") as? Int ?? 0
                      //  print("----->",getID)
                      //  UserData().userId = "\(getID)"
                        self.setUPUserDataINKeychain(getId: getID)
                       let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                      //  Singleton.sharedInstance.customAlert(getMSG: getMessage)
                        self.localAlertSuccess(getMessage: getMessage)
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
    
    
    func connection_University()
    {
        //.... check inter net
        ConstantsHelper.OtherUserID = 625
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
       let domain:String = ApplicationManager.instance.reg_Dic["domain"] ?? ""
       
        let params = [
            "domain":domain
        ]
        Indicator.shared.showProgressView(self.view)
    //ApplicationManager.instance.startloading()
      print(params)
        print(ConstantsHelper.get_uni_id_using_domain)
        WebServiceManager.shared.callWebService_OtherAuth(ConstantsHelper.get_uni_id_using_domain, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            if(response is NSDictionary)
            {
                
               print(response)
                let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                if(status == true)
                {
                    let getid = (response as! NSDictionary).value(forKey: "university_id") as? String ?? ""
                    print("-------->",getid)
                    self.connection_registration(getID: getid)
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
    
    func localAlertSuccess(getMessage:String)
    {
        let alertController = UIAlertController(title: "Unilife", message: getMessage, preferredStyle: .alert)

           // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
               UIAlertAction in
            self.gotoNext()
           }
          

           // Add the actions
           alertController.addAction(okAction)
        

           // Present the controller
           self.present(alertController, animated: true, completion: nil)
    }
}
