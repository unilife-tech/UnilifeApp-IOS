//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit


class PersonalMIssionVC: UIViewController
{
    var kplaceAddress = "Enter personal mission statement"
    @IBOutlet weak var txtDes: UITextView!
    var getStatement:String = ""
    override func viewDidLoad() {
           super.viewDidLoad()
        txtDes.text = kplaceAddress
        txtDes.textColor = UIColor.lightGray
        if(getStatement.count > 0)
        {
            txtDes.text = getStatement
            txtDes.textColor = UIColor.black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
             self.tabBarController?.tabBar.isHidden = true
             self.navigationController?.setNavigationBarHidden(true, animated: true)
         }
      
      @IBAction func click_Back(_ sender: Any) {
                self.navigationController?.popViewController(animated: true)
      }
    
    @IBAction func click_Save()
    {
        
        self.connection_UpdateProfile()
        /*
        let getDes:String  = self.txtDes.text ?? ""
        if(getDes.trim().count > 0)
        {
            if(getDes.trim() == kplaceAddress)
            {
                Singleton.sharedInstance.customAlert(getMSG: msgEnterDes)
            }else
            {
                self.connection_UpdateProfile()
            }
        }else
        {
            Singleton.sharedInstance.customAlert(getMSG: msgEnterDes)
        }
        */
    }
}



extension PersonalMIssionVC:UITextViewDelegate
{
func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
        textView.text = nil
        textView.textColor = UIColor.black
    }
}

func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
        textView.text = kplaceAddress
        textView.textColor = UIColor.lightGray
    }
}
}


extension PersonalMIssionVC
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
          
        var des:String = self.txtDes.text ?? ""
      if(des == kplaceAddress)
      {
        des = ""
      }
          
          let params = [
            "personal_mission":des.trim(),
             
             // "profile_banner_image":""
          ]
          
          
          Indicator.shared.showProgressView(self.view)
          //ApplicationManager.instance.startloading()
          print(params)
          print(ConstantsHelper.personal_mission_update)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.personal_mission_update, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
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
