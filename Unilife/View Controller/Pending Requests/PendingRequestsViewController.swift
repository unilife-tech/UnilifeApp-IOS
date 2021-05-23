//
//  PendingRequestsViewController.swift
//  Unilife
//
//  Created by Apple on 30/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

protocol getAceptRejectDetailProtocol: class {
    func isrequested()
    
}

extension PendingRequestsViewController:getAceptRejectDetailProtocol
{
    func isrequested()
    {self.navigationController?.popViewController(animated: true)}
}

class PendingRequestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlet
    
    @IBOutlet weak var pendingRequest_TableView: UITableView!
    
    // MARK: - Variable
    
    var pendingRequestData :PendingRequestModel?
    var aryRequest:NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Request Received", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            /*
            guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
            
            popoverContent.controller = self
            
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            
            popoverContent.preferredContentSize = CGSize(width: 200, height: 200)
            
            let popOver = popoverContent.popoverPresentationController
            
            popOver?.delegate = self
            //
            popOver?.sourceView = self.navigationItem.rightBarButtonItem?.customView  as! UIView
            //
            popOver?.sourceRect = (self.navigationItem.rightBarButtonItem?.customView  as AnyObject).bounds
            //
            popOver?.permittedArrowDirections = [.up, .right]
            
            
            self.present(popoverContent, animated: true, completion: nil)
            */
        })
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Accept Or Rejected"), object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Accept Or Rejected"), object: nil, queue: nil) { (Notification) in
            
            
            self.RequestRecevied()
            
            
        }
        
        RequestRecevied()
        
          self.tabBarController?.tabBar.isHidden = true
        
    }
    
 
    
}

extension PendingRequestsViewController:  UIPopoverPresentationControllerDelegate {
    
    
    // MARK: - Pop Over Delegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryRequest.count
        //return pendingRequestData?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.pendingRequest_TableView.dequeueReusableCell(withIdentifier: "ChatListingTableViewCell") as! ChatListingTableViewCell
        
        
        cell.userMessageCount_btn.isHidden = true
        cell.chatListingUser_btn.isHidden = false
        let getDic:NSDictionary = self.aryRequest.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
        let getGroupID:String = getDic.value(forKey: "group_id") as? String ?? ""
        if(getGroupID.count > 0)
        {
            let getGroupImg:String = getDic.value(forKey: "group_image") as? String ?? ""
            let getName:String = getDic.value(forKey: "group_name") as? String ?? ""
            cell.chatListingUser_ImageView.sd_setImage(with: URL(string: getGroupImg), placeholderImage: UIImage(named: "noimage_icon"))
            cell.chatListingUserName_lbl.text! = getName
        }else
        {
            let getUserIMG:String = getDic.value(forKey: "user_profile_image") as? String ?? ""
            let getName:String = getDic.value(forKey: "user_username") as? String ?? ""
            cell.chatListingUser_ImageView.sd_setImage(with: URL(string: getUserIMG), placeholderImage: UIImage(named: "noimage_icon"))
            cell.chatListingUserName_lbl.text! = getName
        }
        
        cell.chatListingUser_btn.setTitle("Respond", for: .normal)
              
              cell.chatListingUser_btn.tag = indexPath.row
              
              cell.chatListingUser_btn.addTarget(self, action: #selector(tapAcceptOrReject_btn(_:)), for: .touchUpInside)
           //   cell.selectUserImage_btn.isHidden = false
           //   cell.selectUserImage_btn.tag = indexPath.row
           //   cell.selectUserImage_btn.addTarget(self, action: #selector(getGroupDetail(_:)), for: .touchUpInside)
        
        /*
        if (self.pendingRequestData?[indexPath.row].type ?? "") == "group"{
            
            
            cell.chatListingUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.pendingRequestData?[indexPath.row].groupDtl?.usergroup?.groupImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            
            cell.chatListingUserName_lbl.text! = (self.pendingRequestData?[indexPath.row].groupDtl?.usergroup?.groupName ?? "")
        }else {
            
            cell.chatListingUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.pendingRequestData?[indexPath.row].requestfriend?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            
            cell.chatListingUserName_lbl.text! = (self.pendingRequestData?[indexPath.row].requestfriend?.username ?? "")
            
        }
        
        cell.chatListingUser_btn.setTitle("Respond", for: .normal)
        
        cell.chatListingUser_btn.tag = indexPath.row
        
        cell.chatListingUser_btn.addTarget(self, action: #selector(tapAcceptOrReject_btn(_:)), for: .touchUpInside)
        cell.selectUserImage_btn.isHidden = false
        cell.selectUserImage_btn.tag = indexPath.row
        cell.selectUserImage_btn.addTarget(self, action: #selector(getGroupDetail(_:)), for: .touchUpInside)
        */
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    // MARK: - Button Action
    
    @objc func tapAcceptOrReject_btn(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AcceptAndRejectPopupViewController") as! AcceptAndRejectPopupViewController
        
        vc.controller = self
        
        let getDic:NSDictionary = self.aryRequest.object(at: sender.tag) as? NSDictionary ?? NSDictionary()
        
        let getGroupID:String = getDic.value(forKey: "group_id") as? String ?? ""
        let userID:String = getDic.value(forKey: "user_id") as? String ?? ""
        let getRequestID:String = getDic.value(forKey: "id") as? String ?? ""
             vc.friendId = userID
             vc.groupId = getGroupID
            ////... its need for new api create by girish
            vc.getIdInPendingRequest = getRequestID
            vc.delegate = self
        if(getGroupID.count > 0)
        {
        
                vc.type = "group"
              
        }else
        {
              vc.type = "user"
        }
        
        
        /*
        if self.pendingRequestData?[sender.tag].type == "group"{
            
            vc.type = self.pendingRequestData?[sender.tag].type ?? ""
            vc.friendId = String(self.pendingRequestData?[sender.tag].userID ?? -1)
            
            vc.groupId =
                String(self.pendingRequestData?[sender.tag].groupDtl?.id ?? -1)
            
            ////... its need for new api create by girish
            vc.getIdInPendingRequest = String(self.pendingRequestData?[sender.tag].id ?? -1)
            vc.delegate = self
        }else {
            
            vc.type = self.pendingRequestData?[sender.tag].type ?? ""
            vc.friendId = String(self.pendingRequestData?[sender.tag].userID ?? -1)
            vc.groupId = ""
            
        }
        */
        
        self.presentedViewController?.definesPresentationContext = true
        self.presentedViewController?.providesPresentationContextTransitionStyle = true
        
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    @objc func getGroupDetail(_ sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
        
        vc.groupId = String(self.pendingRequestData?[sender.tag].groupDtl?.groupID ?? -1)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: - Service Response
    func RequestRecevied()
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
              "":""
          ]
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
        print(params)
          print(ConstantsHelper.getNew_group)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.getNew_group, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
            
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                    self.aryRequest = (response as! NSDictionary).value(forKey: "data") as? NSArray ?? NSArray()
                    self.pendingRequest_TableView.delegate = self
                    self.pendingRequest_TableView.dataSource = self
                    self.pendingRequest_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                    self.pendingRequest_TableView.reloadDataWithAutoSizingCellWorkAround()
                  }else
                  {
                    //  let getMessage = (response as! NSDictionary).value(forKey: "message") as? String ?? ""
                    // Singleton.sharedInstance.customAlert(getMSG: getMessage)
                      
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
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_Requested_friends/\(UserData().userId)") {[weak self] (receviedData) in
            
            print(receviedData)
            //            guard let self = self else {
            //                return
            //            }
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    guard let data  = receviedData["data"] as? [[String: AnyObject]] else {
                        
                        return
                    }
                    
                    do {
                        
                        let jsondata = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        print(jsondata)
                        self?.pendingRequestData = try JSONDecoder().decode(PendingRequestModel.self, from: jsondata!)
                        
                        self?.pendingRequest_TableView.delegate = self
                        
                        self?.pendingRequest_TableView.dataSource = self
                        
                        self?.pendingRequest_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                        
                        self?.pendingRequest_TableView.reloadDataWithAutoSizingCellWorkAround()
                        
                    }catch {
                        
                        print(error.localizedDescription)
                    }
                  
                }else {
                    
                    
                    self?.pendingRequestData = []
                    
                    self?.pendingRequest_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
        
    }
 */
}
