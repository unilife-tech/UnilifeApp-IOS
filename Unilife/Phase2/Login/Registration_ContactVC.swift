//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class Registration_ContactVC: UIViewController {

    let countryData: CountryDataType = .phoneCode
    @IBOutlet weak var img1: UIImageView!
        @IBOutlet weak var img2: UIImageView!
        
        
        @IBOutlet weak var txtCountryCode: UITextField!
        @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var viwCountryCode: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
        self.lblCountryCode.text = "+971"
        self.txtCountryCode.text = "United Arab Emirates"
        self.viwCountryCode.roundCornersIMG(corners: [.topLeft,.bottomLeft], radius: CGFloat(5))
    }

    @IBAction func click_Back()
       {
           self.navigationController?.popViewController(animated: true)
       }
    
    
         func UpdateUI()
         {
         img1.layer.cornerRadius = 5
         img2.layer.cornerRadius = 5
         
         
         img1.layer.borderColor = UIColor.white.cgColor
         img2.layer.borderColor = UIColor.white.cgColor
         
         
         img1.layer.borderWidth = 2
         img2.layer.borderWidth = 2
       
            let placeHolderColor:UIColor = UIColor(red: 157/255.0, green: 157/255.0, blue: 157/255.0, alpha: 1.0)
                   
                  
                   
                   txtCountryCode.attributedPlaceholder = NSAttributedString(string: "Select Country..",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
                   
                   txtMobile.attributedPlaceholder = NSAttributedString(string: "Mobile Number..",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
            
         
         }
    func gotoNext()
    {
      let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "AddNewContact_New11") as! AddNewContact_New11
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func click_next()
             {

                 let msg: String = self.validateTxtFields()
                       if !(msg == "") {
                           self.view.endEditing(true)
                           self.showDefaultAlert(Message: msg)
                       }
                       else {
                        self.connection_UpdateProfile()
                       }
                
                
             }
     func validateTxtFields() -> String {
        var msg: String = ""
        if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.lblCountryCode?.text!)!)
               {
                   msg = kmsgCountryCode
               }
        else if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtMobile?.text!)!)
        {
            msg = kmsgMobi
        }else if (self.txtMobile?.text?.count ?? 0) < 9
        {
            msg = kmsgMobiValid
        }
              
        return msg;
                   
                   
    }
}



extension Registration_ContactVC: CounterySelectorDelegate {
    
    func selectCountery(regionCode: String, country: Country?) {
        if let country = country {
            self.lblCountryCode.text = country.phoneCode
            self.txtCountryCode.text = country.name
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func selectCountery(country: Country) {
        
     self.lblCountryCode.text = country.phoneCode
      self.txtCountryCode.text = country.name
        self.dismiss(animated: true, completion: nil)
    }
}

extension Registration_ContactVC:UITextFieldDelegate
{

func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if(textField == txtCountryCode)
    {
        let counterySelectorSearchBar  = CounterySelectorSearchBar()
        counterySelectorSearchBar.showAlertViewController(parent:self,countryDataType: countryData,actionSheetStyle: .actionSheet)
        return false
    }
    
    return true
}
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // this method get called when you tap "Go"
    textField.resignFirstResponder()
    
    return true
}

func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let nsString = NSString(string: textField.text!)
    let newText = nsString.replacingCharacters(in: range, with: string)
    /*
    if (textField == txt_email) {
        if(newText.count > 50)
        {
            return false;
        }
        let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if( string == numberFiltered)
        {
            
            return true
        }else
        {
            return false
        }
        
        
        
    }else
        */
        if (textField == txtMobile) {
        if(newText.count > 15)
        {
            return false;
        }
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        if( string == numberFiltered)
        {
            
            return true
        }else
        {
            return false
        }
        
        
        
    }else
        {
            return true
    }
}
}


extension Registration_ContactVC
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
        let getCountryCOde:String = self.lblCountryCode.text ?? ""
        let getMobile:String = self.txtMobile.text ?? ""
          let params = [
            "phone":getCountryCOde + getMobile
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
                    
                     //  let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                     // Singleton.sharedInstance.customAlert(getMSG: getMessage)
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




