//
//  AddParticipantsViewController.swift
//  Unilife
//
//  Created by Promatics on 2/11/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import UIKit

class AddParticipantsViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var showAdddedParticipants_CollectionView: UICollectionView!
    
    @IBOutlet weak var addParticipants_TableView: UITableView!
    
    @IBOutlet weak var showAddedCollectionView_height: NSLayoutConstraint!
    
    @IBOutlet weak var addParticipants_btn: UIButton!
    
    // MARK: - Variable
    
    var groupUserData: [UsersInGroup]?
    
    var addedRemoveParticipant = [UsersInGroup]()
    
    var friendListData: FriendListingModel?
    
    var addedParticipants = [FriendListingModelElement]()
    
    var checkStatus = [Int]()
    
    var condition = ""
    
    var groupId = ""
    
    var selectedIdArray = [String]()
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if condition == "remove"{
            
            addNavigationBar(left: .Back, titleType: .Normal, title: "Remove Participant" , titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
                
                
            })
            
            if (groupUserData?.count ?? 0) == 0{
                self.addParticipants_btn.isHidden = true
                
            }else {
                
                addParticipants_btn.isHidden = false
            }
            
            for _ in 0..<(groupUserData?.count ?? 0) {
                
                checkStatus.append(0)
            }
            
            
        }else {
            
            addNavigationBar(left: .Back, titleType: .Normal, title: "Add Participant", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
                
                
            })
            friendListing()
            
        }
        
        self.showAddedCollectionView_height.constant = 0
        self.showAdddedParticipants_CollectionView.isHidden = true
        
        self.addParticipants_TableView.delegate = self
        
        self.addParticipants_TableView.dataSource = self
        self.showAdddedParticipants_CollectionView.delegate = self
        self.showAdddedParticipants_CollectionView.dataSource = self
    }
    
    @IBAction func tapAdd_participant_btn(_ sender: Any) {
        
        if self.condition != "remove"{
            self.addUsers()
            
        }else {
            
            self.removeUsers()
        }
        
    }
    
}

// MARK: - Table View Delegate And Service Response

extension AddParticipantsViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.condition != "remove"{
            return self.friendListData?.count ?? 0
        }else {
            return self.groupUserData?.count ?? 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.addParticipants_TableView.dequeueReusableCell(withIdentifier: "SelectAddParticipantTableViewCell") as! SelectAddParticipantTableViewCell
        
        if self.condition != "remove"{
            
            cell.user_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.friendListData?[indexPath.row].profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.userName_lbl.text = self.friendListData?[indexPath.row].username ?? ""
            
            if self.friendListData?[indexPath.row].selectIndex == true {
                
                cell.selectedTick_icon.isHidden = false
                
            }else{
                
                cell.selectedTick_icon.isHidden = true
                
            }
            
        }else {
            
            cell.user_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.groupUserData?[indexPath.row].groupUserDetail?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.userName_lbl.text = (self.groupUserData?[indexPath.row].groupUserDetail?.username ?? "")
            
            if self.checkStatus[indexPath.row] == 1 {
                
                cell.selectedTick_icon.isHidden = false
                
            }else{
                
                cell.selectedTick_icon.isHidden = true
                
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.condition == "remove"{
            
            if self.groupUserData?[indexPath.row].selectIndex == true {
                
                
            }else{
                
                self.checkStatus[indexPath.row] = 1
                
                groupUserData?[indexPath.row].selectUser()
                
                self.addedRemoveParticipant.append(((self.groupUserData?[indexPath.row])!))
                
                self.selectedIdArray.append(String(self.groupUserData?[indexPath.row].userID ?? -1))
                
                self.showAdddedParticipants_CollectionView.reloadData()
                
                self.showAddedCollectionView_height.constant = 120
                
                self.showAdddedParticipants_CollectionView.isHidden = false
                
                
            }
            
        }else {
            
            if self.friendListData?[indexPath.row].selectIndex == true {
                
                
            }else{
                
                self.checkStatus[indexPath.row] = 1
                
                friendListData?[indexPath.row].selectUser()
                
                self.addedParticipants.append(((self.friendListData?[indexPath.row])!))
                
                self.selectedIdArray.append(String(self.friendListData?[indexPath.row].id ?? -1))
                
                self.showAdddedParticipants_CollectionView.reloadData()
                
                self.addParticipants_TableView.reloadData()
                
                self.showAddedCollectionView_height.constant = 120
                
                self.showAdddedParticipants_CollectionView.isHidden = false
                
            }
            
        }
        
        
        
    }
    
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //
    //        self.groupUserData?[indexPath.row].selectIndex = false
    //    }
    
    
    
    // MARK: - Collection View Delegate
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.condition == "remove" {
            
            return self.addedRemoveParticipant.count
            
        }else {
            return addedParticipants.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.showAdddedParticipants_CollectionView.dequeueReusableCell(withReuseIdentifier: "ShowAddParticipantCollectionViewCell", for: indexPath) as! ShowAddParticipantCollectionViewCell
        
        if self.condition == "remove" {
            
            cell.userName_lbl.text! = self.addedRemoveParticipant[indexPath.row].groupUserDetail?.username ?? ""
            
            cell.user_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.addedRemoveParticipant[indexPath.row].groupUserDetail?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.removeUser_btn.tag = indexPath.row
            cell.removeUser_btn.addTarget(self, action: #selector(delete_btn(_:)), for: .touchUpInside)
            
        }else {
            cell.userName_lbl.text! = (self.addedParticipants[indexPath.row].username ?? "")
            cell.user_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.addedParticipants[indexPath.row].profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.removeUser_btn.tag = indexPath.row
            cell.removeUser_btn.addTarget(self, action: #selector(delete_btn(_:)), for: .touchUpInside)
            
        }
        
        return cell 
    }
    
    // MARK: - Button Action
    
    
    @objc func delete_btn(_ sender: UIButton){
        
        if self.condition == "remove" {
            
            self.checkStatus[sender.tag] = 1
            
            groupUserData?[sender.tag].selectUser()
            
            //            self.selectTestArray.remove(at: (self.selectTestArray.index(of: String(describing: (self.recommendedTestArray[sender.tag])["id"]!)))!)
            
            self.addedRemoveParticipant.remove(at: sender.tag)
            
            self.selectedIdArray.remove(at: sender.tag)
            
            self.showAdddedParticipants_CollectionView.reloadData()
            
            self.addParticipants_TableView.reloadData()
            
            if self.addedRemoveParticipant.count == 0 {
                self.showAddedCollectionView_height.constant = 0
                self.showAdddedParticipants_CollectionView.isHidden = true
                
            }else {
                
                self.showAddedCollectionView_height.constant = 120
                
                self.showAdddedParticipants_CollectionView.isHidden = false
            }
            
        }else {
            
            self.checkStatus[sender.tag] = 0
            
            friendListData?[sender.tag].selectUser()
            
            self.addedParticipants.remove(at: sender.tag)
            
            self.selectedIdArray.remove(at: sender.tag)
            
            self.showAdddedParticipants_CollectionView.reloadData()
            
            self.addParticipants_TableView.reloadData()
            
            if self.addedParticipants.count == 0 {
                self.showAddedCollectionView_height.constant = 0
                self.showAdddedParticipants_CollectionView.isHidden = true
                
            }else {
                
                self.showAddedCollectionView_height.constant = 120
                
                self.showAdddedParticipants_CollectionView.isHidden = false
            }
            
        }
        
    }
    
}

// MARK: - Service Response

extension AddParticipantsViewController{
    
    // MARK: - Friend Listing Response
    
    func friendListing() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id":UserData().userId,
                     "group_id": self.groupId]
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "show_friend_user", params: param as [String: AnyObject]) {[weak self] (recevieData) in
            print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    guard let data = recevieData["data"] as? [[String: AnyObject]] else {
                        
                        return
                    }
                    
                    do {
                        
                        let jsonata = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self?.friendListData = try? JSONDecoder().decode(FriendListingModel.self, from: jsonata!)
                        
                        self?.addParticipants_TableView.reloadData()
                        
                        if (self?.friendListData?.count ?? 0) == 0{
                            self?.addParticipants_btn.isHidden = true
                            
                        }else {
                            
                            self?.addParticipants_btn.isHidden = false
                        }
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                    
                    self?.addParticipants_TableView.delegate = self
                    
                    self?.addParticipants_TableView.dataSource = self
                    
                    
                    let count = self?.friendListData?.count ?? 0
                    
                    for _ in 0..<count {
                        
                        self?.checkStatus.append(0)
                    }
                    
                    
                    
                    print(self?.friendListData)
                    
                }else {
                    
                    self?.showDefaultAlert(Message: recevieData["message"] as! String)
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: recevieData["Error"] as! String)
                
            }
            
        }
    }
    
    // MARK: - Add Participants
    
    func addUsers(){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,
                     "request_id": self.selectedIdArray, "group_id": self.groupId] as [String: AnyObject]
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_multiuser_friend_request", params: param as [String: AnyObject]) {[weak self] (recevieData) in
            print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: ((recevieData as? [String: AnyObject])? ["message"] as? String ?? ""), ButtonTitle: "Ok"){
                        
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
    
    // MARK: - Remove  Users
    
    func removeUsers(){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id":self.selectedIdArray,
                     "group_id": self.groupId] as [String: AnyObject]
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "remove_participant", params: param as [String: AnyObject]) {[weak self] (recevieData) in
            
            print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: ((recevieData as? [String: AnyObject])? ["message"] as? String ?? ""), ButtonTitle: "Ok"){
                        
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
