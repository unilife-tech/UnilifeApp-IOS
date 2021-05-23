//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit
import Photos

class SelfIntroProfileVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var imgUserProfile: UIImageView!
    
    let pickerController = UIImagePickerController()
       var asset: PHAsset?
       var selectedimage:UIImage!
    
    @IBOutlet weak var txtFname: UITextField!
   // @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var txtOrganization: UITextField!
    var getUserData:NSDictionary = NSDictionary()
    var getImageProfileURL:String = ""
    var getImageHeader:String = ""
    
    typealias Parameters = [String: String]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imgUserProfile.layer.cornerRadius = 128/2
               imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
               imgUserProfile.layer.borderWidth = 2.0
        
        loadUI()
       
    }


    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
       }
    
    func loadUI()
    {
   //  print(self.getUserData)
        if(self.getUserData.count > 0)
               {
                   let getimg:String = self.getUserData.value(forKey: "profile_image") as? String ?? ""
                   let getName:String = self.getUserData.value(forKey: "username") as? String ?? ""
                   let getStatus:String = self.getUserData.value(forKey: "designation") as? String ?? ""
                    let getOrgani:String = self.getUserData.value(forKey: "organisation") as? String ?? ""
                   self.imgUserProfile.sd_setImage(with: URL(string: getimg), placeholderImage: UIImage(named: "noimage_icon"))
                   self.txtFname.text = getName
                self.txtOrganization.text = getOrgani
                self.txtStatus.text = getStatus
                
                
                
                self.getImageProfileURL = self.getUserData.value(forKey: "profile_logo") as? String ?? ""
                   
               }
    }
    @IBAction func click_Back(_ sender: Any) {
              
              self.navigationController?.popViewController(animated: true)
          }
    
    @IBAction func click_update()
    {
        connection_UpdateProfile()
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
    
}



//------------------------------------------------------
// MARK: Image Picker   ------------------------------------------------------
//------------------------------------------------------



extension SelfIntroProfileVC
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
        
        
        self.imgUserProfile.image = self.selectedimage
        
        
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
                            
                            self.getImageProfileURL = getImageURL
                            print("-------------__----------__----->",self.getImageProfileURL)
                            
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

extension SelfIntroProfileVC
{
    func connection_UpdateProfile()
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
            
            let fname:String = txtFname.text ?? ""
        //    let lname:String = txtLname.text ?? ""
            
            let params = [
               "full_name":fname,
               //"email":"",
                "designation":txtStatus.text ?? "",
                "organisation":txtOrganization.text ?? "",
                "profile_image":self.getImageProfileURL,
              //  "profile_banner_image":""
            ]
            
            
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
      print(params)
          //  print(ConstantsHelper.Profile_highlight)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.profile_update, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                
              
                
                if(response is NSDictionary)
                {
                    
                   print(response)
                    let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                    if(status == true)
                    {
                        var userData:[String: AnyObject] = NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.value(forKey: "userData"))as! Data) as! [String: AnyObject]
                               
                               userData["username"] = fname as AnyObject
                               userData["profile_image"] = self.getImageProfileURL as AnyObject
                               UserDefaults.standard.setValue((NSKeyedArchiver.archivedData(withRootObject: userData  as! [String: AnyObject])), forKey: "userData")
                               
                        let getStatus = self.txtStatus.text ?? ""
                        let getOrgani = self.txtOrganization.text ?? ""
                        UserDefaults.standard.set(getStatus + " at " + getOrgani, forKey: "_heading")
                      
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









extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


extension Data{
    mutating func append(_ string: String){
        if let data = string.data(using: .utf8){
            append(data)
        }
    }
    
}
