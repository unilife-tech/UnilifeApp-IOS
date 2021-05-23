//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit


protocol gotoChatScreenProtocol: class {
    func gotoChatViws()
    
}


class ContactInfoVC: UIViewController,gotoChatScreenProtocol {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblMedia: UILabel!
    @IBOutlet weak var lblConversion: UILabel!
    @IBOutlet weak var lblExitGroup: UILabel!
    
    @IBOutlet weak var viwGroupUsers: UIView!
    @IBOutlet weak var img7Block: UIImageView!
    @IBOutlet weak var heightOfTbl: NSLayoutConstraint!
    @IBOutlet weak var tbl: UITableView!
    var getUserImg:UIImage?
    var getName:String = ""
    var receiverId = ""
    var groupId = ""
    ////... this is for Group
    var group_id = ""
    var groupData: GroupInfoModel?
    var room_id = ""
    var urAdmin:Bool = false
    var aryUsers:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        if(getUserImg != nil)
        {
            imgUser.image = getUserImg
            
        }
        lblName.text = getName
        self.tabBarController?.tabBar.isHidden = true
        
        
        if self.groupId != "" {
            ///... this is group id
            lblMedia.text = "Do not Disturb"
            lblConversion.text = "Delete Conversation"
            lblExitGroup.text = "Exit group"
            img7Block.image = UIImage.init(named: "delet")
            getGroupInfo()
        }else
        {
            viwGroupUsers.isHidden = true
        }
        
        
        tbl?.tableFooterView = UIView()
              tbl?.estimatedRowHeight = 44.0
              tbl?.rowHeight = UITableView.automaticDimension
              self.tbl?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
      override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
               
                   tbl?.layer.removeAllAnimations()
                   heightOfTbl?.constant = self.tbl?.contentSize.height ?? 0.0
                   UIView.animate(withDuration: 0.5) {
                       self.loadViewIfNeeded()
                   
        }
    }
    
   @IBAction func clickBack()
   {
      self.navigationController?.popViewController(animated: true)
   }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    ///.. click Three dots
    @IBAction func tapThreeDot_btn(_ sender: UIButton) {
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
        
           popoverContent.conditionChatController = "ChatController"
        popoverContent.controller = self
        popoverContent.blockId = self.receiverId
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        popoverContent.preferredContentSize = CGSize(width: 200, height: 100)
        let popOver = popoverContent.popoverPresentationController
        popOver?.delegate = self
        popOver?.sourceView = sender as! UIButton
        popOver?.sourceRect = (sender as! UIButton).bounds
        popOver?.permittedArrowDirections = [.up, .right]
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @IBAction func click_Video_calling(sender:UIButton)
    {
//        let VC = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as! CommingSoon
//        self.navigationController?.pushViewController(VC, animated: true)
        
        guard let popoverContent = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as? CommingSoon else {return}
                    
                    popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
                      popoverContent.preferredContentSize = CGSize(width: 150, height: 40)
                    let popOver = popoverContent.popoverPresentationController
                    popOver?.delegate = self
                    popOver?.sourceView = sender
                    popOver?.sourceRect = sender.bounds
                    popOver?.permittedArrowDirections = [.up]
        popOver?.backgroundColor = UIColor(red: 106/255, green: 162/255, blue: 185/255, alpha: 1.0)
                    self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    @IBAction func tapDeleteChat_btn(_ sender: Any) {
          
        if self.groupId != "" {
            let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ChatDeleteViewController") as! ChatDeleteViewController
                  
                  vc.delegate = self
                  vc.controller = self
                  vc.condition = "delete"
                  vc.room_id = self.room_id
                  vc.userType = "group"
                  self.presentedViewController?.definesPresentationContext = true
                  self.presentedViewController?.providesPresentationContextTransitionStyle = true
                  
                  self.present(vc, animated: true, completion: nil)
        }else
        {
          let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ChatDeleteViewController") as! ChatDeleteViewController
          vc.controller = self
          vc.condition = "delete"
            vc.delegate = self
          self.presentedViewController?.definesPresentationContext = true
          self.presentedViewController?.providesPresentationContextTransitionStyle = true
          self.present(vc, animated: true, completion: nil)
        }
          
      }
      
      
      ///... in new UI this button is not added 
      @IBAction func tapAcrhiveChat_btn(_ sender: Any) {
          
        if self.groupId != "" {
                   let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ChatDeleteViewController") as! ChatDeleteViewController
                          
                          vc.controller = self
                          
                          vc.room_id = self.room_id
                          
                          vc.userType = "group"
                          
                          vc.archiveStatus = "oo"
                          
                          self.presentedViewController?.definesPresentationContext = true
                          self.presentedViewController?.providesPresentationContextTransitionStyle = true
                          
                          self.present(vc, animated: true, completion: nil)
               }else
               {
          let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ChatDeleteViewController") as! ChatDeleteViewController
          
          vc.controller = self
          self.presentedViewController?.definesPresentationContext = true
          self.presentedViewController?.providesPresentationContextTransitionStyle = true
          
          self.present(vc, animated: true, completion: nil)
        }
          
      }
      
      
      
      @IBAction func addViewSavedMultimedia_btn(_ sender: Any) {
          if self.groupId != "" {
                     let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ViewSavedMultiMediaViewController") as! ViewSavedMultiMediaViewController
                          vc.type = "group"
                          vc.user_id = self.group_id
                          self.navigationController?.pushViewController(vc, animated: true)
                 }else
                 {
          let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "ViewSavedMultiMediaViewController") as! ViewSavedMultiMediaViewController
          
          vc.type = "single"
          vc.user_id = UserData().userId
          self.navigationController?.pushViewController(vc, animated: true)
        }
      }
      
      
      
      @IBAction func tapViewBlockedUser_btn(_ sender: Any) {
          if self.groupId != "" {
            ////....this is exit from this group
                     self.leaveGroup()
//                  let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "BlockedUserListingViewController") as! BlockedUserListingViewController
//                        vc.group_id = self.group_id
//                        vc.userType = "group"
//                        self.navigationController?.pushViewController(vc, animated: true)
            
            
            
                 }else
                 {
                    
                    //block user from here
          let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "BlockedUserListingViewController") as! BlockedUserListingViewController
          vc.userType = ""
          self.navigationController?.pushViewController(vc, animated: true)
        }
          
      }
    
    
    func gotoChatViws()
    {
        var isFound:Bool = false
        
        if (self.navigationController != nil) {
            for vc in  self.navigationController!.viewControllers ?? [UIViewController()] {
                if vc is UnlifeChatViewController {
                    isFound = true
                    self.navigationController?.popToViewController(vc, animated: false)
                    break
                }
            }
        }
        
        
        if(isFound == false)
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    ///... add new member
    
    @IBAction func addParticipants_btn(_ sender: UIButton) {
        if(self.urAdmin == true)
        {
        let vc = kMainStoryBoard.instantiateViewController(withIdentifier: "AddParticipantsViewController") as! AddParticipantsViewController
        
        vc.condition = ""
        
        vc.groupId = self.group_id
        
        vc.groupUserData = self.groupData?.usersInGroup
        
        self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            
            guard let popoverContent = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as? CommingSoon else {return}
                        
                        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
                          popoverContent.preferredContentSize = CGSize(width: 250, height: 40)
                        let popOver = popoverContent.popoverPresentationController
                        popOver?.delegate = self
                        popOver?.sourceView = sender
                        popOver?.sourceRect = sender.bounds
                        popOver?.permittedArrowDirections = [.up]
                    popoverContent.getText = "You are not admin"
            popOver?.backgroundColor = UIColor(red: 106/255, green: 162/255, blue: 185/255, alpha: 1.0)
                        self.present(popoverContent, animated: true, completion: nil)
        }
    }
    
    
     
    @IBAction func click_DeleteUser(sender:UIButton)
    {
        if(self.urAdmin == true)
        {
            self.connection_DeleteUser(getUserID: self.groupData?.usersInGroup?[sender.tag].userID ?? 0, getindex: sender.tag)
        }else
        {
            
            guard let popoverContent = kPhase2toryBoard.instantiateViewController(withIdentifier: "CommingSoon") as? CommingSoon else {return}
                        
                        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
                          popoverContent.preferredContentSize = CGSize(width: 250, height: 40)
                        let popOver = popoverContent.popoverPresentationController
                        popOver?.delegate = self
                        popOver?.sourceView = sender
                        popOver?.sourceRect = sender.bounds
                        popOver?.permittedArrowDirections = [.up]
                    popoverContent.getText = "You are not admin"
            popOver?.backgroundColor = UIColor(red: 106/255, green: 162/255, blue: 185/255, alpha: 1.0)
                        self.present(popoverContent, animated: true, completion: nil)
        }
    }
}

extension ContactInfoVC: UIPopoverPresentationControllerDelegate
{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
          return .none
      }
}





extension ContactInfoVC:UITableViewDelegate,UITableViewDataSource
{
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
         return self.groupData?.usersInGroup?.count ?? 0
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupAdminCell") as! groupAdminCell
            
            cell.lblName.text = self.groupData?.usersInGroup?[indexPath.row].groupUserDetail?.username ?? ""
            if self.groupData?.usersInGroup?[indexPath.row].groupAdmin == "no"{
                   cell.lblType.text = "Remove"
                   cell.lblType.textColor = UIColor.unilifeRemoveChatColor
                cell.btnDelete.isHidden = false
            }else {
                   cell.lblType.text = "Admin"
                    cell.lblType.textColor = UIColor.unilifeAdminChatColor
                cell.btnDelete.isHidden = true
            }
        cell.btnDelete.tag = indexPath.row
        cell.imgUserProfile.sd_setImage(with: URL(string: profileImageUrl + (self.groupData?.usersInGroup?[indexPath.row].groupUserDetail?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        cell.imgUserProfile.layer.cornerRadius = 40/2
        cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
        cell.imgUserProfile.layer.borderWidth = 2.0
        
        cell.selectionStyle = .none
            return cell
      
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    
    
}


extension ContactInfoVC
{
        // MARK: - Leave Group
        
        func leaveGroup(){
            
            Indicator.shared.showProgressView(self.view)
            
            let param = ["user_id": UserData().userId,"group_id": self.group_id] as [String: AnyObject]
            
            print(param)
            Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "unjoin_the_group", params: param as [String: AnyObject]) {[weak self] (receviedData) in
                
                print(receviedData)
                
    //            if let self = self else {
    //
    //                return
    //            }
                
                Indicator.shared.hideProgressView()
                
                if Singleton.sharedInstance.connection.responseCode == 1 {
                    
                    if receviedData["response"] as? Bool == true {
                        
                        self?.showAlertWithAction(Title: "Unilife", Message: "Group Leaved  Successfully", ButtonTitle: "Ok", outputBlock: {
                            
                            self?.navigationController?.popViewController(animated: true)
                        })
                        
                        
                    }else {
                        
                        self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                        
                    }
                    
                }else {
                    
                    
                    self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                    
                }
                
                
            }
        }
    
    
        func getGroupInfo() {
            
            Indicator.shared.showProgressView(self.view)
            
            Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "group_detail/\(self.group_id)"){ [weak self] (receviedData) in
                
                Indicator.shared.hideProgressView()
                
    //            guard let self = self else {
    //
    //                return
    //            }
                
                if Singleton.sharedInstance.connection.responseCode == 1 {
                    
                    if receviedData["response"] as? Bool == true {
                        guard let data = receviedData["data"] as? [String: AnyObject]else {
                            return
                        }
                        
                        do {
                            
                            let jsondata = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                           // print(jsondata)
                            self?.groupData = try JSONDecoder().decode(GroupInfoModel.self, from: jsondata!)
                            self?.tbl.reloadData()
                        }catch{
                            print(error.localizedDescription)
                        }
                        
                        let groupCount = (self?.groupData?.usersInGroup?.count ?? 0)
                        self?.urAdmin = false
                        for i in 0..<groupCount {
                            
                            if self?.groupData?.usersInGroup?[i].userID == Int(UserData().userId) &&  self?.groupData?.usersInGroup?[i].groupAdmin == "yes"{
                                self?.urAdmin = true
//                                self?.addParticipant_View.isHidden = false
//                                self?.addParticipantView_height.constant = 113
                                break
                                
                            }else {
                                
//                                self?.addParticipant_View.isHidden = true
//                                self?.addParticipantView_height.constant = 0
                            }
                            
                        }
                        
                    }else {
                        
                        self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                        
                    }
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                }
                
            }
            
        }
    
    
    func connection_DeleteUser(getUserID:Int,getindex:Int)
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
            "group_id":self.groupId,
              "remove_user_id":getUserID
            ] as [String : Any]
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
    //print(params)
          print(ConstantsHelper.remove_member_from_group)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.remove_member_from_group, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                    self.groupData?.usersInGroup?.remove(at: getindex)
                    self.tbl.reloadData()
                      
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
