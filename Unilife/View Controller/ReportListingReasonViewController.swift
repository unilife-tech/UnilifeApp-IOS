//
//  ReportListingReasonViewController.swift
//  Unilife
//
//  Created by Apple on 18/12/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ReportListingReasonViewController: UIViewController {
    
    // MARK: - Variable
    
    var postId = ""
    
    var postUserId = ""
    
    var condition = ""
    
    
    // MARK: - Outlet
    
    
    
    @IBOutlet weak var spam_btn: UIButton!
    
    @IBOutlet weak var inappoprate_btn: UIButton!
    
    @IBOutlet weak var violence_btn: UIButton!
    
    
    @IBOutlet weak var nudity_btn: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Report", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Button Action
    
    
    @IBAction func selectReason_btn(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            reportPost(description: self.spam_btn.titleLabel?.text ?? "")
            
            
        }else if sender.tag == 1 {
            reportPost(description: self.inappoprate_btn.titleLabel?.text ?? "")
            
            
        }else if sender.tag == 2 {
            
            reportPost(description: self.violence_btn.titleLabel?.text ?? "")
            
            
        }else if sender.tag == 3 {
            
            reportPost(description: self.nudity_btn.titleLabel?.text ?? "")
            
            
        }
    }
    
    
}


// MARK: - Service Response

extension ReportListingReasonViewController {
    
    
    func reportPost(description: String)
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
          
          var params = [
            "":""
          ]
        var APIurl:String = ""
        if self.condition == "postUser" {
            
            APIurl = ConstantsHelper.report_user
             params = [
                "report_user_id":self.postUserId,"type":"Spam","reason":description
            ]
        }else
        {
            APIurl = ConstantsHelper.reportPost
             params = [
                "report_post_id":self.postId,"type":"Spam","reason":description
            ]
        }
    
        Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
     // print(params)
        //  print(ConstantsHelper.Profile_highlight)
          WebServiceManager.shared.callWebService_Home(APIurl, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
           //      print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                    
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
    /*
    {
        
        var param = [String: AnyObject]()
        
        Indicator.shared.showProgressView(self.view)
        
        if self.condition == "postUser" {
            
            param = ["type": "Report","description": description,"user_id": UserData().userId,"subject": "", "report_user_id": self.postUserId] as [String: AnyObject]
            
        }else {
            
            param = ["type": "Report","description": description,"user_id": UserData().userId,"subject": "", "post_id" : self.postId] as [String: AnyObject]
            
        }
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "help", params: param as [String: AnyObject]) { (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1  {
                
                if receviedData["response"] as? Bool == true {
                    
                    //                 self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    self.showAlertWithAction(Title: "Unilife", Message: "Thanks For Reporting Us ", ButtonTitle: "OK", outputBlock: {
                        
                        Switcher.clickOnPost()
                        
                    })
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
            }
            
            
        }
    }
    
    */
}
