//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class RegistrationVC_New4: UIViewController {

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var txtName: UITextField!
   // var getEmail:String = ""
    var getOTP:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
     
    }

    func UpdateUI()
       {
       img1.layer.cornerRadius = 5
       img1.layer.borderColor = UIColor.white.cgColor
       img1.layer.borderWidth = 2
        
        
        let placeHolderColor:UIColor = UIColor(red: 157/255.0, green: 157/255.0, blue: 157/255.0, alpha: 1.0)
                   
                  
                   
                   txtName.attributedPlaceholder = NSAttributedString(string: "Enter OTP..",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])

       
       }
    @IBAction func click_Back()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func click_next()
       {
        
        let msg: String = self.validateTxtFields()
                     if !(msg == "") {
                         self.view.endEditing(true)
                         self.showDefaultAlert(Message: msg)
                     }
                     else {
                       //self.gotoNext()
                        connection_EmailVerify_server()
                     }
              
        
     
       }
    
    func gotoNext()
    {
        
       // Singleton.sharedInstance.customAlert(getMSG: "Otp varified successfully")
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Unilife" , message: "Otp varified successfully", preferredStyle: .alert)
              
               
              
             
               let galleryAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action -> Void in
                  
                   let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New5") as! RegistrationVC_New5
                          self.navigationController?.pushViewController(vc, animated: true)
               }
       
        actionSheetController.addAction(galleryAction)
                   self.present(actionSheetController, animated: true, completion: nil)
        
        
  
    }
      func validateTxtFields() -> String {
                  var msg: String = ""
                  if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtName?.text!)!)
                  {
                     msg = kmsgOTP
                  }
                  
                  /*else if (self.txtName.text! != self.getOTP)
                  {
                    msg = kmsgValidOTP
                  }
*/
                
               
                  return msg;
                  
                  
              }
}

extension RegistrationVC_New4
{
    func connection_EmailVerify_server()
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
        
        let params = [
            "email":ApplicationManager.instance.reg_Dic["email"] ?? "",
            "otp":self.txtName.text ?? ""
        ]
        Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
        print(params)
        print(ConstantsHelper.otp_verify)
        WebServiceManager.shared.callWebService_OtherAuth(ConstantsHelper.otp_verify, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
            if(response is NSDictionary)
            {
                
                print(response)
                let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                if(status == true)
                {
                   
                    self.gotoNext()
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
