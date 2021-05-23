//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

protocol updateUnivercityProtocol: class {
    func selectedUnivercity(getName:String,getid:String,getSchoolname:String)
    
}

class RegistrationVC_New3: UIViewController,UITextViewDelegate {

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCEmail: UITextField!
    @IBOutlet weak var txtViewTerms: UITextView!
    
    var getOTP:String = ""
    var getiD:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func UpdateUI()
    {
    img1.layer.cornerRadius = 10
    img2.layer.cornerRadius = 10
    img3.layer.cornerRadius = 10
    
    img1.layer.borderColor = UIColor.white.cgColor
    img2.layer.borderColor = UIColor.white.cgColor
    img3.layer.borderColor = UIColor.white.cgColor
    
    img1.layer.borderWidth = 2
    img2.layer.borderWidth = 2
    img3.layer.borderWidth = 2
        
        
        let placeHolderColor:UIColor = UIColor(red: 157/255.0, green: 157/255.0, blue: 157/255.0, alpha: 1.0)
               
              
               
               txtName.attributedPlaceholder = NSAttributedString(string: "Enter School Name..",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
               
               txtEmail.attributedPlaceholder = NSAttributedString(string: "Enter Academic Email..",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        txtCEmail.attributedPlaceholder = NSAttributedString(string: "Confirm Academic Email..",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
        
        
        
         let normalText2 = "By registering, you indicate that you have read and accept our Terms and Conditions"
                let boldText2  = "Terms and Conditions"
                txtViewTerms.addHyperLinksToText(originalText: normalText2, hyperLinks: [boldText2: "url1"])
                txtViewTerms.textColor = UIColor.white
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        
          print(URL.absoluteString)
          if(URL.absoluteString == "url1")
          {
              
                     let _TermsConditionVC:TermsConditionVC = kLoginStoryBoard.instantiateViewController(withIdentifier: "TermsConditionVC") as! TermsConditionVC
                      
                     self.navigationController?.pushViewController(_TermsConditionVC, animated: true)
          }
          
          return false
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
                self.connection_EmailVerify()
              }
       
    }
    func gotoNext()
    {
        let getEmial:String = self.txtCEmail.text ?? ""
        let splitEmail = getEmial.split(separator: "@")
        var domain:String = ""
        if(splitEmail.count > 0)
        {
            domain = String(splitEmail[1])
        }
        
        
        ApplicationManager.instance.reg_Dic = [String:String]()
        ApplicationManager.instance.reg_Dic["schoolName"] = self.txtName.text ?? ""
        ApplicationManager.instance.reg_Dic["email"] = self.txtCEmail.text ?? ""
        ApplicationManager.instance.reg_Dic["universityid"] = self.getiD
        ApplicationManager.instance.reg_Dic["domain"] = domain
        
        let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New4") as! RegistrationVC_New4
        vc.getOTP = self.getOTP
               self.navigationController?.pushViewController(vc, animated: true)
        
        Singleton.sharedInstance.customAlert(getMSG: "Otp send successfully")
    }
    
    func validateTxtFields() -> String {
        /*
        let getUniversityEmail:String = self.txtEmail?.text ?? ""
        let getUserEditEmail:String = self.txtCEmail?.text ?? ""
        var finalUserAttheRate:String = ""
        //....check email has @ or not
        if(getUserEditEmail.contains("@"))
        {
            print("yes")
            let getSplitEmail = getUserEditEmail.split(separator: "@")
            print(getSplitEmail.count)
            if(getSplitEmail.count > 1)
            {
              finalUserAttheRate = getSplitEmail[1] as? String ?? ""
            }
        }
        
        print("----->",finalUserAttheRate)
        
        */
              var msg: String = ""
              if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtName?.text!)!)
              {
                 msg = kmsgSchool
              }else if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtEmail?.text!)!)
              {
                 msg = kmsgEmail
              }else if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtCEmail?.text!)!)
             {
                  msg = kmsgCEmail
             }else if textFieldValidation.instance.isEnteredInvalidEmail(text: (self.txtCEmail?.text!)!)
             {
                 msg = kmsgValidEmail
             }else if ((self.txtEmail?.text!) != (self.txtCEmail?.text!))
             {
                  msg = kmsgValidCEmail
             }
           
              return msg;
              
              
          }
    
    @IBAction func click_search_email()
    {
        let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationSearchPropertyVC") as! RegistrationSearchPropertyVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegistrationVC_New3:updateUnivercityProtocol
{
    func selectedUnivercity(getName:String,getid:String,getSchoolname:String)
     {
        self.txtName.text = getSchoolname
        self.txtEmail.text = getName
        self.txtCEmail.text = getName
        self.getiD = getid
     }
}


extension RegistrationVC_New3:UITextFieldDelegate
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        if (textField == txtEmail) || (textField == txtCEmail) {
            if(newText.count > 150)
            {
                return false;
            }
            let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._+-").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if( string == numberFiltered)
            {
              
                return true
            }else
            {
                return false
            }
            
            
            
        }
        else if (textField == txtName)
        {
            if(newText.count > 250)
            {
                return false;
            }
            let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._+- *&^%$#@!();:?.>,<").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if( string == numberFiltered)
            {
              
                return true
            }else
            {
                return false
            }
            
            
            
        }
        else {
            return  newText.count <= 50
        }
        
    }
    
}


//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension RegistrationVC_New3
{
    func connection_EmailVerify()
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
            "email":self.txtCEmail.text ?? ""
        ]
        Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
        print(params)
        print(ConstantsHelper.email_verify)
        WebServiceManager.shared.callWebService_OtherAuth(ConstantsHelper.email_verify, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
            
            
            
            if(response is NSDictionary)
            {
                
              //  print(response)
                let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                if(status == true)
                {
                    self.getOTP = (response as! NSDictionary).value(forKey: "otp") as? String ?? ""
                //    print(self.getOTP)
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




extension UITextView {

  func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
    let style = NSMutableParagraphStyle()
    style.alignment = .left
    let attributedOriginalText = NSMutableAttributedString(string: originalText)
    for (hyperLink, urlString) in hyperLinks {
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15.0), range: fullRange)
    }

    self.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
    ]
    self.attributedText = attributedOriginalText
  }
}
