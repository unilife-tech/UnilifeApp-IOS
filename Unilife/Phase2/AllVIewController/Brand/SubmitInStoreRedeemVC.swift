//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class SubmitInStoreRedeemVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!

    
    
    @IBOutlet weak var txtOTPChar1: UITextField!
    @IBOutlet weak var txtOTPChar2: UITextField!
    @IBOutlet weak var txtOTPChar3: UITextField!
    @IBOutlet weak var txtOTPChar4: UITextField!
    @IBOutlet weak var txtOTPChar5: UITextField!
    @IBOutlet weak var txtOTPChar6: UITextField!
    
    
    var getTitle:String = ""
    var getID:Int = 0
    var getDic:NSDictionary = NSDictionary()
    var code:String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         lblTitle.text = self.getTitle
        
        let discount_message = getDic.value(forKey: "discount_message") as? String ?? ""
       self.code = getDic.value(forKey: "code") as? String ?? ""
        self.lblDiscount.text = discount_message
        imgUserProfile.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
        self.lblEmail.text = UserData().email
        self.lblName.text = UserData().name
        
        [txtOTPChar1, txtOTPChar2, txtOTPChar3, txtOTPChar4, txtOTPChar5, txtOTPChar6].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
               
               txtOTPChar1.layer.cornerRadius = 5
               txtOTPChar2.layer.cornerRadius = 5
               txtOTPChar3.layer.cornerRadius = 5
               txtOTPChar4.layer.cornerRadius = 5
               txtOTPChar5.layer.cornerRadius = 5
               txtOTPChar6.layer.cornerRadius = 5
               
               
               
        
    }
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
           
           
       }

    @IBAction func click_Back()
       {
           self.navigationController?.popViewController(animated: true)
       }
    
   @objc func editingChanged(_ textField: UITextField) {
          if(textField.text == "")
          {
              self.GoToBackt(gett: textField)
          }
    /*
          if textField.text?.count == 1 {
              if textField.text?.characters.first == " " {
                  textField.text = ""
                  return
              }
          }
    */
          guard
              let firstChar = txtOTPChar1.text, !firstChar.isEmpty,
              let secondChar = txtOTPChar2.text, !secondChar.isEmpty,
              let thirdChar = txtOTPChar3.text, !thirdChar.isEmpty,
              let fourthChar = txtOTPChar4.text, !fourthChar.isEmpty,
              let fifthChar = txtOTPChar5.text, !fifthChar.isEmpty,
              let sixthChar = txtOTPChar6.text, !sixthChar.isEmpty
              else {
                  //self.fnbtnDisable()
                  if(textField.text != "")
                  {
                      self.GoToNext(gett: textField)
                  }
                  
                  
                  return
          }
          
         // self.fnbtnEable()
          
      }
    
    @IBAction func click_Submit()
        {
           self.view.endEditing(true)
            let msg: String = self.validateTxtFields()
                         if !(msg == "") {
                             self.view.endEditing(true)
                             self.showDefaultAlert(Message: msg)
                         }
                         else {
                           let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "EnterRedeemDetailsVC") as! EnterRedeemDetailsVC
                                  vc.getID = getID
                                  vc.getTitle = getTitle
                                  vc.getDic = getDic
                                  self.navigationController?.pushViewController(vc, animated: true)
                         }
            
           
       }
    
    func validateTxtFields() -> String {
    
         let text:String  = "\(txtOTPChar1.text!)\(txtOTPChar2.text!)\(txtOTPChar3.text!)\(txtOTPChar4.text!)\(txtOTPChar5.text!)\(txtOTPChar6.text!)"
        
        
        
          var msg: String = ""
          if textFieldValidation.instance.isTextFieldHasEmptyText(text: (text))
          {
             msg = kmsgCode
          }else if text.lowercased() != self.code.lowercased()
          {
             msg = kmsgVCode
          }
  
          return msg;
      }
    

        func GoToNext(gett:UITextField){
            if(gett == txtOTPChar1){
                if(txtOTPChar2.text?.count == 0){
                    txtOTPChar2.becomeFirstResponder()
                }else if(txtOTPChar3.text?.count == 0){
                    txtOTPChar3.becomeFirstResponder()
                }else if(txtOTPChar4.text?.count == 0){
                    txtOTPChar4.becomeFirstResponder()
                }else if(txtOTPChar5.text?.count == 0){
                    txtOTPChar5.becomeFirstResponder()
                }else if(txtOTPChar6.text?.count == 0){
                    txtOTPChar6.becomeFirstResponder()
                }
                
            }else if (gett == txtOTPChar2){
                if(txtOTPChar3.text?.count == 0){
                    txtOTPChar3.becomeFirstResponder()
                }else if(txtOTPChar4.text?.count == 0){
                    txtOTPChar4.becomeFirstResponder()
                }else if(txtOTPChar5.text?.count == 0){
                    txtOTPChar5.becomeFirstResponder()
                }else if(txtOTPChar6.text?.count == 0){
                    txtOTPChar6.becomeFirstResponder()
                }
            }else if (gett == txtOTPChar3){
                if(txtOTPChar4.text?.count == 0){
                    txtOTPChar4.becomeFirstResponder()
                }else if(txtOTPChar5.text?.count == 0){
                    txtOTPChar5.becomeFirstResponder()
                }else if(txtOTPChar6.text?.count == 0){
                    txtOTPChar6.becomeFirstResponder()
                }
            }else if (gett == txtOTPChar4){
                if(txtOTPChar5.text?.count == 0){
                    txtOTPChar5.becomeFirstResponder()
                }else if(txtOTPChar6.text?.count == 0){
                    txtOTPChar6.becomeFirstResponder()
                }
            }else if (gett == txtOTPChar5){
                txtOTPChar6.becomeFirstResponder()
            }
        }
        
        func GoToBackt(gett:UITextField){
            if(gett == txtOTPChar6){
                if(txtOTPChar5.text?.count != 0){
                    txtOTPChar5.becomeFirstResponder()
                }else if(txtOTPChar4.text?.count != 0){
                    txtOTPChar4.becomeFirstResponder()
                }else if(txtOTPChar3.text?.count != 0){
                    txtOTPChar3.becomeFirstResponder()
                }else if(txtOTPChar2.text?.count != 0){
                    txtOTPChar2.becomeFirstResponder()
                }else{
                    txtOTPChar1.becomeFirstResponder()
                }
            }else if (gett == txtOTPChar5){
                if(txtOTPChar4.text?.count != 0){
                    txtOTPChar4.becomeFirstResponder()
                }else if(txtOTPChar3.text?.count != 0){
                    txtOTPChar3.becomeFirstResponder()
                }else if(txtOTPChar2.text?.count != 0){
                    txtOTPChar2.becomeFirstResponder()
                }else{
                    txtOTPChar1.becomeFirstResponder()
                }
            }else if (gett == txtOTPChar4){
                if(txtOTPChar3.text?.count != 0){
                    txtOTPChar3.becomeFirstResponder()
                }else if(txtOTPChar2.text?.count != 0){
                    txtOTPChar2.becomeFirstResponder()
                }else{
                    txtOTPChar1.becomeFirstResponder()
                }
            }else if (gett == txtOTPChar3){
                if(txtOTPChar2.text?.count != 0){
                    txtOTPChar2.becomeFirstResponder()
                }else{
                    txtOTPChar1.becomeFirstResponder()
                }
            }else if (gett == txtOTPChar2){
                txtOTPChar1.becomeFirstResponder()
            }
        }
            
            
            
            
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                // this method get called when you tap "Go"
                textField.resignFirstResponder()
                return true
            }
            
            func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                let nsString = NSString(string: textField.text!)
                let newText = nsString.replacingCharacters(in: range, with: string)
                if(textField == txtOTPChar1 || textField == txtOTPChar2 || textField == txtOTPChar3 || textField == txtOTPChar4 || textField == txtOTPChar5 || textField == txtOTPChar6){
                    if(newText.count > 1){
                        return false;
                    }
                    let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@ ").inverted
                    let compSepByCharInSet = string.components(separatedBy: aSet)
                    let numberFiltered = compSepByCharInSet.joined(separator: "")
                    if( string == numberFiltered){
//                        let isBackSpace = strcmp(string, "\\b")
//                        if (isBackSpace == -92) {
    //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
    //                            self.GoToBackt(gett: textField)
    //                        })
//                        }else{
    //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
    //                            self.GoToNext(gett: textField)
    //                        })
//                        }
                        return true
                    }else{
                        return false
                    }
                }else{
                    return false
                }
            }
       
    
    
}

