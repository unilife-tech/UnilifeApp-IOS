//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class EnterRedeemDetailsVC: UIViewController {

    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtReceiptnumner: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    var getTitle:String = ""
    var getID:Int = 0
    var getDic:NSDictionary = NSDictionary()
    var code:String  = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = self.getTitle
        self.code = getDic.value(forKey: "code") as? String ?? ""
    }
    @IBAction func click_Back()
         {
             self.navigationController?.popViewController(animated: true)
         }
    
    @IBAction func clickSubmit()
    {
        self.view.endEditing(true)
        let msg: String = self.validateTxtFields()
                     if !(msg == "") {
                         self.view.endEditing(true)
                         self.showDefaultAlert(Message: msg)
                     }
                     else {
                       self.connection_redeem_voucher()
                     }
    }
    func validateTxtFields() -> String {
       var msg: String = ""
            if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtLocation?.text ?? "")!)
            {
                 msg = kmsgLocation
            }else if textFieldValidation.instance.isTextFieldHasEmptyText(text: (self.txtReceiptnumner?.text ?? "")!)
            {
                msg = kmsgReceiptNumber
            }
            
             return msg;
         }

}



//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension EnterRedeemDetailsVC
{
    func connection_redeem_voucher()
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
                "type":"instore",
                "code":self.code,
                "brand_id":self.getID,
                "receipt_number":self.txtReceiptnumner.text ?? "",
                "branch_name_location" :self.txtLocation.text ?? ""
                ] as [String : Any]
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
      print(params)
            print(ConstantsHelper.redeem_voucher)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.redeem_voucher, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                
              
                
                if(response is NSDictionary)
                {
                    
                   print(response)
                    let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                    if(status == true)
                    {
                        
                    
//                        let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
//                        self.navigationController?.popViewController(animated: true)
//                        Singleton.sharedInstance.customAlert(getMSG: getMessage)
                        
                      let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "OfferRedeemSuccessVC") as! OfferRedeemSuccessVC
                        vc.getID = self.getID
                        vc.getTitle = self.getTitle
                        vc.getDic = self.getDic
                    self.navigationController?.pushViewController(vc, animated: true)
                        
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


extension EnterRedeemDetailsVC:UITextFieldDelegate
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
        if (textField == txtLocation) || (textField == txtReceiptnumner) {
            if(newText.count > 150)
            {
                return false;
            }
            let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._+- ").inverted
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
