//
//  AcceptAndRejectPopupViewController.swift
//  Unilife
//
//  Created by Apple on 04/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class AcceptAndRejectPopupViewController: UIViewController {
    
    // MARK: - Variable
    
    @IBOutlet weak var accept_btn: SetButton!
    
    var delegate:getAceptRejectDetailProtocol?
    
    @IBOutlet weak var tapReject_btn: SetButton!
    
    @IBOutlet weak var back_btn: UIButton!
    
    // MARK: - Variable
    
    var controller = UIViewController()
    var type = ""
    var friendId = ""
    var groupId = ""
    var getIdInPendingRequest = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print(#file)
    }
    
    // MARK: - Button Action
    
    
    @IBAction func tapAccept_btn(_ sender: Any) {
        
        if self.type == "group"{
            
            //addGroupParticipants()
            self.connection_GroupAcceptReject(getType: "accept")
        }else {
            
            self.AcceptFriendRequest(accept_id: self.friendId)
            
        }
        
    }
    
    
    
    @IBAction func tapReject_btn(_ sender: Any) {
        if self.type == "group"{
                   
                   //addGroupParticipants()
                   self.connection_GroupAcceptReject(getType: "reject")
               }else {
                   
                  self.RejectFriendRequest(reject_id: self.friendId)
                   
               }
        
        
    }
    
    
    
    @IBAction func tapBack_btn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AcceptAndRejectPopupViewController {
    
    // MARK: - Accept Friend Request
    
    func AcceptFriendRequest(accept_id: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"accept_id": accept_id] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "accept_friend_request", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: ((receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found"), ButtonTitle: "Ok", outputBlock: {
                        
                        self?.dismiss(animated: true, completion: nil)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Accept Or Rejected"), object: nil, userInfo: nil)
                    })
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
            
        }
    }
    
    
    // MARK: - Reject Friend Request
    
    
    func RejectFriendRequest(reject_id: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"reject_id": reject_id, "group_id": self.groupId] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "reject_friend_request", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: ((receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found"), ButtonTitle: "Ok", outputBlock: {
                        
                        self?.dismiss(animated: true, completion: nil)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Accept Or Rejected"), object: nil, userInfo: nil)
                    })
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
            
        }
    }
    
    func addGroupParticipants(){
        
        Indicator.shared.showProgressView(self.view)
        
        var selectedIdArray = [String]()
        
        selectedIdArray.append(UserData().userId)
        
        let param = ["group_id": groupId,
                     "user_id": selectedIdArray] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "add_participant", params: param as [String: AnyObject]) {[weak self] (recevieData) in
            print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: ((recevieData as? [String: AnyObject])? ["message"] as? String ?? ""), ButtonTitle: "Ok"){
                        
                        selectedIdArray = []
                         self?.dismiss(animated: true, completion: nil)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Accept Or Rejected"), object: nil, userInfo: nil)
                        self?.navigationController?.popViewController(animated: true)
                    }
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: recevieData["message"] as! String)
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: recevieData["Error"] as! String)
                
            }
            
        }
    }
    
    
}


extension AcceptAndRejectPopupViewController
{
    func connection_GroupAcceptReject(getType:String)
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
              "type":getType,
              "request_id":self.getIdInPendingRequest
          ]
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
    
          print(ConstantsHelper.friend_req_accept_reject)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.friend_req_accept_reject, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                    self.dismiss(animated: true, completion:
                        {
                            if(self.delegate != nil)
                            {self.delegate?.isrequested()}
                    })
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
