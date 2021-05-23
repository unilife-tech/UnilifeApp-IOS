//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class RegistrationVC_New5: UIViewController {
    
    
    
    @IBOutlet weak var img1: UIImageView!
       @IBOutlet weak var img2: UIImageView!
       
       
       @IBOutlet weak var txtFname: UITextField!
       @IBOutlet weak var txtLname: UITextField!
       
       
       
       override func viewDidLoad() {
           super.viewDidLoad()
           UpdateUI()
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
                   
                  
                   
                   txtFname.attributedPlaceholder = NSAttributedString(string: "First",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor])
                   
                   txtLname.attributedPlaceholder = NSAttributedString(string: "Last",
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
                     self.gotoNext()
                   }
            
            
         }
    
    func gotoNext()
       {
           ApplicationManager.instance.reg_Dic["fname"] = self.txtFname.text ?? ""
           ApplicationManager.instance.reg_Dic["lname"] = self.txtLname.text ?? ""
        
           let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New6") as! RegistrationVC_New6
           self.navigationController?.pushViewController(vc, animated: true)
       }
    func validateTxtFields() -> String {
                 var msg: String = ""
                 if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtFname?.text!)!)
                 {
                    msg = kmsgFname
                 }else if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtLname?.text!)!)
                 {
                    msg = kmsgLname
                 }
                
              
                 return msg;
                 
                 
             }
}

extension RegistrationVC_New5:UITextFieldDelegate
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        if (textField == txtFname) || (textField == txtLname) {
            if(newText.count > 150)
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
