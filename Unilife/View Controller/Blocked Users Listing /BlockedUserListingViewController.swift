//
//  BlockedUserListingViewController.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class BlockedUserListingViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var blockedUserListig_TableView: UITableView!
    
    // MARK: - Variable
    
    var blockUserListingData : BlockedUserModel?
    
    var BlockUserGroupListingData: BlockUserGroupListing?
    
    // MARK: - Variable
    
    var group_id = ""
    
    var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blockedUserListig_TableView.delegate = self
        
        self.blockedUserListig_TableView.dataSource = self
        self.blockedUserListig_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Blocked Users", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        if self.userType == "group"{
            
        self.getBlockUserGroupListing()
            
        }else {
        
        blockUserListing()
            
        }
       
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print(#file)
    }
    
    
}

extension BlockedUserListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.userType == "group" {
            
        return self.BlockUserGroupListingData?.count ?? 0
            
            
        }else {
        
        return self.blockUserListingData?.count ?? 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.blockedUserListig_TableView.dequeueReusableCell(withIdentifier: "ChatListingTableViewCell") as! ChatListingTableViewCell
        
        cell.userMessageCount_btn.isHidden = true
        cell.chatListingUser_btn.isHidden = false
        
        if self.userType == "group" {
            
            cell.chatListingUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.BlockUserGroupListingData?[indexPath.row].profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            //        if blockUserListingData?[indexPath.row].status ?? "" == "block" {
            
            cell.chatListingUser_btn.setTitle("Unblock", for: .normal)
            
            //        }else {
            //
            //           cell.chatListingUser_btn.setTitle("Unblock", for: .normal)
            //        }
            
            cell.chatListingUserName_lbl.text! = (self.BlockUserGroupListingData?[indexPath.row].username ?? "")
            
            cell.chatListingUserDescription_lbl.text! = ""
            
        }
        
        else {
        
        cell.chatListingUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.blockUserListingData?[indexPath.row].blockuser?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
//        if blockUserListingData?[indexPath.row].status ?? "" == "block" {
        
            cell.chatListingUser_btn.setTitle("Unblock", for: .normal)
            
//        }else {
//
//           cell.chatListingUser_btn.setTitle("Unblock", for: .normal)
//        }
        
        cell.chatListingUserName_lbl.text! = (self.blockUserListingData?[indexPath.row].blockuser?.username ?? "")
        
        cell.chatListingUserDescription_lbl.text! = ""
        }
        cell.chatListingUser_btn.tag = indexPath.row
        cell.chatListingUser_btn.addTarget(self, action: #selector(tapBlockUser_btn), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    // MARK: - Button Action
    
    @objc func tapBlockUser_btn(_ sender: UIButton) {
        
        if self.userType == "group"{
            
        self.unblockUser(block_id: String(self.BlockUserGroupListingData?[sender.tag].id ?? 0))
            
        }else{
        
        self.unblockUser(block_id: String(self.blockUserListingData?[sender.tag].blockUserID ?? 0))
        }
        
        
    }
}

extension BlockedUserListingViewController {
    
    // MARK: - Block User Listing
    func blockUserListing() {
        
    Indicator.shared.showProgressView(self.view)
         Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_block_list/\(UserData().userId)") {[weak self] (recevieData) in
            
        print(recevieData)
            
            guard let self = self else {
                return
            }
            
            
        Indicator.shared.hideProgressView()
    
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    guard let data = recevieData["data"] as? [[String: AnyObject]]else {
                        
                        return
                    }
                    
                    do{
                    
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                      self.blockUserListingData = try JSONDecoder().decode(BlockedUserModel.self, from: jsonData!)
                        
                        self.blockedUserListig_TableView.reloadData()
                        
                        
                    }catch {
                    
                        print(error.localizedDescription)
                        
                    }
                }else {
                    
                    self.blockUserListingData = []
                    self.blockedUserListig_TableView.reloadData()
                    self.showDefaultAlert(Message: (recevieData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
               
            }else {
                self.showDefaultAlert(Message: (recevieData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
            }
            
            }
       
    }
    
    // MARK: - Unblock User
    
    func unblockUser(block_id: String){
        
    Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"block_id": block_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "unblock_user", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
        print(receviedData)
            guard let self = self else {
                return
            }
            
            
        Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    if self.userType == "group"{
                        
                        self.getBlockUserGroupListing()
                        
                    }else {
                    
                    
                self.blockUserListing()
                        
                    }
                    
                    
                }else {
                    
                  
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
            }
            
            
        }
        
        
    }
    
    // MARK: - get Block User Group Listing Data
    
    func getBlockUserGroupListing() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"group_id": self.group_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "block_list", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else {
                        
                        return
                        }
                    
                    let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    
                    self.BlockUserGroupListingData = try? JSONDecoder().decode(BlockUserGroupListing.self, from: jsonData!)
                    
                    self.blockedUserListig_TableView.reloadData()
                    
                    
                }else {
                    
                    
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
            }
            
            
        }
        
        
    }
    
    
}

