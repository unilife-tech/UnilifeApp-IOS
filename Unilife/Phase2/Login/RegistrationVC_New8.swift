//
//  ViewController.swift
//  BMPG
//
//  Created by developer on 07/05/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class RegistrationVC_New8: UIViewController {

    @IBOutlet weak var img1: UIImageView!
        @IBOutlet weak var img2: UIImageView!
        
        
        @IBOutlet weak var txtPassword: UITextField!
        @IBOutlet weak var txtCpassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
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
       
         
         }
    func gotoNext()
    {
        ApplicationManager.instance.reg_Dic["password"] = self.txtPassword.text ?? ""
                let vc = kLoginStoryBoard.instantiateViewController(withIdentifier: "RegistrationVC_New9") as! RegistrationVC_New9
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
                         self.gotoNext()
                       }
                
                
             }
     func validateTxtFields() -> String {
        var msg: String = ""
        if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtPassword?.text!)!)
        {
            msg = kmsgPass
        }else if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtCpassword?.text!)!)
        {
            msg = kmsgCpass
        }else if(self.txtPassword?.text ?? "") != (self.txtCpassword?.text ?? "")
        {
             msg = kmsgPassNotMatch
        }
                  
                
        return msg;
                   
                   
    }
}

