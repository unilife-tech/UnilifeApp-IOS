//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class HighlightProfileVC: UIViewController {

    @IBOutlet weak var txtWorking: UITextField!
    @IBOutlet weak var txtStudying: UITextField!
    @IBOutlet weak var txtGraduated: UITextField!
    @IBOutlet weak var txtHighSchool: UITextField!
    @IBOutlet weak var txtLives: UITextField!
    @IBOutlet weak var txtFrom: UITextField!
    
    
    @IBOutlet weak var btnWorking: UIButton!
       @IBOutlet weak var btnStudying: UIButton!
       @IBOutlet weak var btnGraduated: UIButton!
       @IBOutlet weak var btnHighSchool: UIButton!
       @IBOutlet weak var btnLives: UIButton!
       @IBOutlet weak var btnFrom: UIButton!
    var getUserHighlight:NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        LoadUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func click_Back(_ sender: Any) {
              
              self.navigationController?.popViewController(animated: true)
          }
    
    @IBAction func click_StartText(_ sender: UIButton)
    {
        ShowButton()
        
        if(sender.tag == 0)
        {
            self.txtWorking.becomeFirstResponder()
            self.btnWorking.isHidden = true
        }else if (sender.tag == 1)
        {
            self.txtStudying.becomeFirstResponder()
             self.btnStudying.isHidden = true
        }else if (sender.tag == 2)
        {
            self.txtGraduated.becomeFirstResponder()
             self.btnGraduated.isHidden = true
        }else if (sender.tag == 3)
        {
            self.txtHighSchool.becomeFirstResponder()
             self.btnHighSchool.isHidden = true
        }else if (sender.tag == 4)
        {
            self.txtLives.becomeFirstResponder()
             self.btnLives.isHidden = true
        }else if (sender.tag == 5)
        {
            self.txtFrom.becomeFirstResponder()
             self.btnFrom.isHidden = true
        }
    }
    
    
    func LoadUI()
       {
           var currently_working = ""
           var study = ""
           var lives = ""
           var fromValue = ""
           var addValue = ""
           
           if(self.getUserHighlight.count > 0)
           {
               currently_working = self.getUserHighlight.value(forKey: "currently_working") as? String ?? ""
               study = self.getUserHighlight.value(forKey: "currently_studying") as? String ?? ""
               lives = self.getUserHighlight.value(forKey: "lives_in") as? String ?? ""
               fromValue = self.getUserHighlight.value(forKey: "from") as? String ?? ""
               addValue = self.getUserHighlight.value(forKey: "graduated_from") as? String ?? ""
            let hight = self.getUserHighlight.value(forKey: "complete_highschool_at") as? String ?? ""
            self.txtFrom.text = fromValue
            self.txtLives.text = lives
            self.txtWorking.text = currently_working
            self.txtStudying.text = study
            self.txtGraduated.text = addValue
            self.txtHighSchool.text = hight
            
            
           }
           
    }
    
    
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
           ShowButton()
    }
    
    func ShowButton()
    {
        self.btnWorking.isHidden = false
        self.btnStudying.isHidden = false
        self.btnHighSchool.isHidden = false
        self.btnFrom.isHidden = false
        self.btnLives.isHidden = false
        self.btnGraduated.isHidden = false
    }
    
    func HideButton()
    {
        self.btnWorking.isHidden = true
        self.btnStudying.isHidden = true
        self.btnHighSchool.isHidden = true
        self.btnFrom.isHidden = true
        self.btnLives.isHidden = true
        self.btnGraduated.isHidden = true
    }
    
    @IBAction func click_Update()
    {
        self.connection_UpdateProfile()
    }

}



extension HighlightProfileVC:UITextFieldDelegate
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        ShowButton()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       // let nsString = NSString(string: textField.text!)
       // let newText = nsString.replacingCharacters(in: range, with: string)
        
       
          let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._ ").inverted
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
    
}



//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension HighlightProfileVC
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
           
            let params = [
                "currently_working":self.txtWorking.text ?? "",
                "currently_studying":self.txtStudying.text ?? "",
                "graduated_from":self.txtGraduated.text ?? "",
                "complete_highschool_at":self.txtHighSchool.text ?? "",
                "lives_in":self.txtLives.text ?? "",
                "from":self.txtFrom.text ?? "",
                "personal_information":""
            ]
            
            
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
        print(params)
        print(ConstantsHelper.Profile_highlight)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.Profile_highlight, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                
              
                
                if(response is NSDictionary)
                {
                    
                   print(response)
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
