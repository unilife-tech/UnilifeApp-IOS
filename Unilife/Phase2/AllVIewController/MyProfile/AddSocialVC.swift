//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit


class AddSocialVC: UIViewController {

   
    
    @IBOutlet weak var txtFb: UITextField!
    @IBOutlet weak var txtInsta: UITextField!
    @IBOutlet weak var txtSnap: UITextField!
    @IBOutlet weak var txtTwi: UITextField!
    @IBOutlet weak var txtLinkedin: UITextField!
    var getSocialData:NSDictionary = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

        if(getSocialData.count > 0)
        {
            self.txtFb.text = self.getSocialData.value(forKey: "facebook") as? String ?? ""
            self.txtInsta.text = self.getSocialData.value(forKey: "instagram") as? String ?? ""
            self.txtSnap.text = self.getSocialData.value(forKey: "snapchat") as? String ?? ""
            self.txtTwi.text = self.getSocialData.value(forKey: "twitter") as? String ?? ""
            self.txtLinkedin.text = self.getSocialData.value(forKey: "linkedIn") as? String ?? ""
        }
      
    }


    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
           //self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
       }
    
  
    @IBAction func click_Back(_ sender: Any) {
              
              self.navigationController?.popViewController(animated: true)
          }
    
    @IBAction func click_update()
    {
        connection_UpdateSocial()
    }
    
   
}








//------------------------------------------------------
// MARK: API     ------------------------------------------------------
//------------------------------------------------------

extension AddSocialVC
{
    func connection_UpdateSocial()
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
            
            let fb:String = txtFb.text ?? ""
            let inst:String = txtInsta.text ?? ""
            let snap:String = txtSnap.text ?? ""
            let twi:String = txtTwi.text ?? ""
            let link:String = txtLinkedin.text ?? ""
        
            
            let params = [
                "facebook":fb.trim(),
               "instagram":inst.trim(),
               "snapchat":snap.trim(),
                "twitter":twi.trim(),
                "linkedIn": link.trim()
            ]
            
            
            Indicator.shared.showProgressView(self.view)
        //ApplicationManager.instance.startloading()
      //print(params)
          //  print(ConstantsHelper.Profile_highlight)
            WebServiceManager.shared.callWebService_Home(ConstantsHelper.user_social_profile, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
                
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


extension AddSocialVC:UITextFieldDelegate
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        return true
    }
}
