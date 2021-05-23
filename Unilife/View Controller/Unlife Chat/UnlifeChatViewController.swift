//
//  UnlifeChatViewController.swift
//  Unilife
//
//  Created by promatics on 23/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class UnlifeChatViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var friendList_btn: SetButton!
    
    @IBOutlet weak var viewMoreSuggestion_btn: SetButton!
    
    @IBOutlet weak var chatListing_TableView: UITableView!
    
    @IBOutlet weak var onlineUsers_CollectionView: UICollectionView!
    
    @IBOutlet weak var onlineUserView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var friendButtonView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var onlineUser_View: UIViewShadow!
    
    @IBOutlet weak var friendButton_View: UIView!
    @IBOutlet weak var viwSearchVC: UIView!
    @IBOutlet weak var topSpaceConstant: NSLayoutConstraint!
    @IBOutlet weak var viwNoRecord: UIView!
    
   
    // MARK: - Variable
    
    var condition = ""
    
    var viewSuggestionListingArray = [[String: AnyObject]]()
    
    var filterDataArray = [[String: AnyObject]]()
    
    var serviceUrl = ""
    
    var onlineUserdata: OnlineUsersModel?
    
    var allMessageUserData : ChatWithUsersMessages?
    
    var filterchatData: ChatWithUsersMessages?
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSearchBar()
        
        //means -> viwSearchVC.isHidden = true
        topSpaceConstant.constant = 1000
        NotificationCenter.default.addObserver(forName: Notification.Name("ChatNotification"), object: nil, queue: nil){ (Notification) in
            
            self.onlineUsersService()
            self.allchatwithUsers()
            
        }
        
        
    //    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
         self.viwNoRecord.isHidden = true
    }
    
    
    deinit {
        
        print(#file, "destructor called")
    }
    
    
    // MARK: - Serach Bar Function
    
    
      func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
           // self.view.endEditing(true)
            
        
            topSpaceConstant.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
    //        let VC = kPhase2toryBoard.instantiateViewController(withIdentifier: "SearchChatVC") as! SearchChatVC
    //        self.navigationController?.pushViewController(VC, animated: true)
        }
    
    func defaultSearchBar() {
        
        if #available(iOS 11.0, *) {
            let sc = UISearchController(searchResultsController: nil)
            sc.delegate = self
            sc.searchResultsUpdater = self
            let scb = sc.searchBar
            scb.tintColor = UIColor.appDarKGray
            scb.barTintColor = UIColor.white
            scb.placeholder = "Search Here"
            
            if let textfield = scb.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.blue
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            
            if let navigationbar = self.navigationController?.navigationBar {
                navigationbar.barTintColor = UIColor.white
            }
            navigationItem.searchController = sc
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController?.searchBar.delegate = self
            self.definesPresentationContext = true
            
            sc.hidesNavigationBarDuringPresentation = false
            sc.dimsBackgroundDuringPresentation = false
            
        }
        
    }
    
  
    
    
    // MARK: - serach Bar delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
                   topSpaceConstant.constant = 1000
                   UIView.animate(withDuration: 0.3) {
                       self.view.layoutIfNeeded()
                       
                   }
    }
    func fn_viewwillApper()
    {
         self.viwNoRecord.isHidden = true
       self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
        if self.condition == "RequestRecevied" {
            
            self.onlineUser_View.isHidden = true
            self.onlineUserView_Height.constant = 0
            self.friendButtonView_Height.constant = 0
            self.friendButton_View.isHidden = true
            
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: "Request Received", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "dots_icon", bgColor: .White, barTintColor: UIColor.white, navigationBarStyle: .default, rightFunction: {
                
                
                guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
                
                popoverContent.controller = self
                
                popoverContent.delegate = self
                
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
                
            })
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Accept Or Rejected"), object: nil)
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Accept Or Rejected"), object: nil, queue: nil) { (Notification) in
                
                
                self.RequestRecevied()
                
                
            }
            
            RequestRecevied()
            
            
            
        }
        else {
            
            self.onlineUserView_Height.constant = 90
            self.friendButtonView_Height.constant = 50
            self.onlineUser_View.isHidden = false
            self.friendButton_View.isHidden = false
            
            //dots_icon
            
            self.addNavigationBar(left: .Profile, titleType: .Normal, title: "Chat", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "dots_icon", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
                
                
                
                guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
                
                popoverContent.controller = self
                
                 popoverContent.delegate = self
                
                popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
                
                popoverContent.preferredContentSize = CGSize(width: 250, height: 210)
                
                let popOver = popoverContent.popoverPresentationController
                
                popOver?.delegate = self
                
                popOver?.sourceView = self.navigationItem.rightBarButtonItem?.customView  as! UIView
                
                popOver?.sourceRect = (self.navigationItem.rightBarButtonItem?.customView  as AnyObject).bounds
                //
                popOver?.permittedArrowDirections = [.up, .right]
                
                
                self.present(popoverContent, animated: true, completion: nil)
                
            })
            
            
            
            
            self.onlineUsers_CollectionView.delegate = self
            
            self.onlineUsers_CollectionView.dataSource = self
            
            self.chatListing_TableView.delegate = self
            self.chatListing_TableView.dataSource = self
            
            
            self.chatListing_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
            chatListing_TableView?.tableFooterView = UIView()
                  chatListing_TableView?.estimatedRowHeight = 44.0
                  chatListing_TableView?.rowHeight = UITableView.automaticDimension
            onlineUsersService()
            allchatwithUsers()
            self.defaultSearchBar()
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        topSpaceConstant.constant = 1000
        fn_viewwillApper()
    }
    
    // MARK: - Button Action
    
    @IBAction func tapFriendList_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FriendsListingViewController") as! FriendsListingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func tapGroup_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupListingViewController") as! GroupListingViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapViewMoreSuggestion_btn(_ sender: Any) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewMoreFriendSuggestionViewController") as! ViewMoreFriendSuggestionViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}


//MARK: - Table View Delegate
extension UnlifeChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.condition == "RequestRecevied" {
            
            return viewSuggestionListingArray.count
            
        }else {
            
            return self.allMessageUserData?.count ?? 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.chatListing_TableView.dequeueReusableCell(withIdentifier: "ChatListingTableViewCell") as! ChatListingTableViewCell
        
        
        cell.userMessageCount_btn.isHidden = true
        cell.chatListingUser_btn.isHidden = false
        
        if self.condition == "RequestRecevied" {
            
            if String(describing: ((self.viewSuggestionListingArray[indexPath.row])["requestfriend"]!)) == "<null>" {
                 cell.chatListingUser_ImageView.image = UIImage(named: "noimage_icon")
                
                 cell.chatListingUserName_lbl.text = ""
            }else {
            
            cell.chatListingUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: ((self.viewSuggestionListingArray[indexPath.row])["requestfriend"] as! [String: AnyObject])["profile_image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.chatListingUserName_lbl.text! = String(describing: ((self.viewSuggestionListingArray[indexPath.row])["requestfriend"] as! [String: AnyObject])["username"]!)
                
            }
            
            cell.chatListingUser_btn.setTitle("Respond", for: .normal)
            
            cell.chatListingUser_btn.tag = indexPath.row
            
            cell.chatListingUser_btn.addTarget(self, action: #selector(tapAcceptOrReject_btn(_:)), for: .touchUpInside)
            cell.userProfile_btn.tag = indexPath.row
            cell.userProfile_btn.addTarget(self, action: #selector(tapUserProfile_btn(_:)), for: .touchUpInside)
            
            
        }else {
            
            //        cell.chatListingUser_btn.frame = CGRect(x: cell.chatListingUser_btn.frame.minX, y: cell.chatListingUser_btn.frame.minY, width: 30, height: 30)
            //
            //         cell.chatListingUser_btn.CornerRadius = cell.chatListingUser_btn.frame.height / 2
            //
            //        cell.chatListingUser_btn.setTitle("50", for: .normal)
            
            
            cell.userMessageCount_btn.isHidden = false
            cell.chatListingUser_btn.isHidden = true
            
           // cell.chatListingUserDescription_lbl.textColor = UIColor.red
            cell.chatListingUserDescription_lbl.tintColor = UIColor.appDarKGray
            
            let getLastMessage:String = self.allMessageUserData?[indexPath.row].lastMessage ?? ""
            if(getLastMessage.contains(".jpg")) || (getLastMessage.contains(".jpeg")) || (getLastMessage.contains(".png")) || getLastMessage.contains(".m4a") || getLastMessage.contains(".gif") || getLastMessage.contains(".mp4")
            {
                cell.chatListingUserDescription_lbl.text! = self.allMessageUserData?[indexPath.row].messageType ?? ""
            }else{
                
                let getMessage:String = self.allMessageUserData?[indexPath.row].lastMessage ?? ""
                 cell.chatListingUserDescription_lbl.text! = getMessage.removingPercentEncoding ?? ""
            }
//            if(self.allMessageUserData?[indexPath.row].messageType == "text")
//            {
//                 cell.chatListingUserDescription_lbl.text! = self.allMessageUserData?[indexPath.row].lastMessage ?? ""
//            }else
//            {
//                 cell.chatListingUserDescription_lbl.text! = self.allMessageUserData?[indexPath.row].messageType ?? ""
//            }
            
            cell.userProfile_btn.tag = indexPath.row
            cell.userProfile_btn.addTarget(self, action: #selector(tapUserProfile_btn(_ :)), for: .touchUpInside)
            
            
            if self.allMessageUserData?[indexPath.row].chatGroup != nil {
                
                cell.chatListingUserName_lbl.text! = self.allMessageUserData?[indexPath.row].chatGroup?.groupName ?? " "
                
                cell.chatListingUser_ImageView.sd_setImage(with: URL(string:profileImageUrl + (self.allMessageUserData?[indexPath.row].chatGroup?.groupImage ?? " ")), placeholderImage: UIImage(named: "noimage_icon"))
                
                if self.allMessageUserData?[indexPath.row].chatGroup?.groupUserSeen?.count == 0  {
                    
                    cell.userMessageCount_btn.isHidden = true
                    
                    
                }else {
                    
                    cell.userMessageCount_btn.isHidden = false
                    
                    cell.userMessageCount_btn.setTitle("\(self.allMessageUserData?[indexPath.row].chatGroup?.groupUserSeen?.count ?? 0)", for: .normal)
                    
                }
                
                
                
            }else {
                
                if (self.allMessageUserData?[indexPath.row].senderUser?.id ?? 0) == Int(UserData().userId) {
                    
                    cell.chatListingUserName_lbl.text! = self.allMessageUserData?[indexPath.row].receiverUser?.username ?? ""
                    
                    cell.chatListingUser_ImageView.sd_setImage(with: URL(string:profileImageUrl + (self.allMessageUserData?[indexPath.row].receiverUser?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                    
                }else {
                    cell.chatListingUserName_lbl.text! = self.allMessageUserData?[indexPath.row].senderUser?.username ?? ""
                    
                    cell.chatListingUser_ImageView.sd_setImage(with: URL(string:profileImageUrl + (self.allMessageUserData?[indexPath.row].senderUser?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                    
                }
                
                if self.allMessageUserData?[indexPath.row].roomChat?.count == 0 {
                    
                    cell.userMessageCount_btn.isHidden = true
                    
                    
                }else {
                    
                    cell.userMessageCount_btn.isHidden = false
                    cell.userMessageCount_btn.setTitle("\(self.allMessageUserData?[indexPath.row].roomChat?.count ?? 0)", for: .normal)
                    
                }
                
            }
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.condition == "RequestRecevied" {
            
            
        }else {
            if self.allMessageUserData?[indexPath.row].chatGroup != nil{
                
                createGroupRoom(group_id: String(self.allMessageUserData?[indexPath.row].chatGroup?.id ?? 0))
                
            }else {
                
                if (self.allMessageUserData?[indexPath.row].senderUser?.id ?? 0) == Int(UserData().userId) {
                    
                    createRoom(receiver_id: String(self.allMessageUserData?[indexPath.row].receiverUser?.id ?? 0))
                    
                }else {
                    
                    createRoom(receiver_id: String(self.allMessageUserData?[indexPath.row].senderUser?.id ?? 0))
                    
                }
                
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    // MARK: - Button Action
    
    @objc func tapUserProfile_btn(_ sender: UIButton)
    {
       
        let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        if self.condition == "RequestRecevied" {
            vc.getUserID = (self.viewSuggestionListingArray[sender.tag])["user_id"] as? Int ?? 0
            vc.isComeFromFriend = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            if(self.allMessageUserData?[sender.tag].chatGroup == nil)
            {
            if (self.allMessageUserData?[sender.tag].senderUser?.id ?? 0) == Int(UserData().userId) {
                vc.getUserID =   self.allMessageUserData?[sender.tag].receiverUser?.id ?? 0
            }else {
                vc.getUserID =  self.allMessageUserData?[sender.tag].senderUser?.id ?? 0
                }
                
                vc.isComeFromFriend = true
                       self.navigationController?.pushViewController(vc, animated: true)
            }else
            {
                //.... Group
                let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "GroupDetailVC") as! GroupDetailVC
                          // vc.getUserImg = self.UserImage.image
                vc.getName = self.allMessageUserData?[sender.tag].chatGroup?.groupName ?? ""
                vc.group_id = String(self.allMessageUserData?[sender.tag].groupID ?? 0) ?? "0"
                vc.isHiddenNavigation = true
                vc.getGroupUrl = self.allMessageUserData?[sender.tag].chatGroup?.groupImage ?? ""
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
       
    }
    
    /*
    {
        
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileViewController") as! ViewProfileViewController
        
        if self.condition == "RequestRecevied" {
            
            vc.post_id = String(describing: (self.viewSuggestionListingArray[sender.tag])["user_id"]!)
            
        }else {
            
            if (self.allMessageUserData?[sender.tag].senderUser?.id ?? 0) == Int(UserData().userId) {
                
                vc.post_id =   String(self.allMessageUserData?[sender.tag].receiverUser?.id ?? 0)
                
            }else {
                
                vc.post_id =  String(self.allMessageUserData?[sender.tag].senderUser?.id ?? 0)
                
            }
            
            // vc.post_id = String(self.allMessageUserData?[sender.tag].senderID ?? -1 )
            
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
 */
    
    @objc func tapAcceptOrReject_btn(_ sender: UIButton) {
        
        if self.condition == "RequestRecevied" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AcceptAndRejectPopupViewController") as! AcceptAndRejectPopupViewController
            
            vc.controller = self
            
            vc.friendId = String(describing: (self.viewSuggestionListingArray[sender.tag])["user_id"]!)
            
            self.presentedViewController?.definesPresentationContext = true
            self.presentedViewController?.providesPresentationContextTransitionStyle = true
            
            self.present(vc, animated: true, completion: nil)
            
        }else {
            
            if String(describing: (self.viewSuggestionListingArray[sender.tag])["user_friend_request"]!) != "<null>" {
                
                
                //                self.CancelSendRequest(reject_id: String(describing: (self.viewSuggestionListingArray[sender.tag])["id"]!))
                
                
            }else {
                
                self.sendRequestService(request_id: String(describing: (self.viewSuggestionListingArray[sender.tag])["id"]!))
                
                
            }
            
        }
        
    }
    
}

// MARK: - Collection View Delegate


extension UnlifeChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.onlineUserdata?.count ?? 0
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.onlineUsers_CollectionView.dequeueReusableCell(withReuseIdentifier: "OnlineUsersCollectionViewCell", for: indexPath) as! OnlineUsersCollectionViewCell
        
        cell.onlineUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.onlineUserdata?[indexPath.row].userfriend?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.onlineUserName_lbl.text! = self.onlineUserdata?[indexPath.row].userfriend?.username ?? ""
        cell.onlineUser_ImageView.layer.cornerRadius = 50/2
        cell.onlineUser_ImageView.layer.borderColor = UIColor.unilifeblueDark.cgColor
        cell.onlineUser_ImageView.layer.borderWidth = 2.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        //
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        self.createRoom(receiver_id: String(self.onlineUserdata?[indexPath.row].friendID ?? 0))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 60 , height: 90)
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    
}

extension UnlifeChatViewController: UIPopoverPresentationControllerDelegate, UISearchResultsUpdating {
    
    
    // MARK: - Pop Over Delegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // MARK: - View More Suggestion Service Response
    // "send_view_more_suggestions_user/\(UserData().userId)"
    
    func ViewMoreSuggestionListing(serviceUrl: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: serviceUrl){[weak self](receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.viewSuggestionListingArray = []
                    
                    self?.viewSuggestionListingArray = receviedData["data"] as! [[String: AnyObject]]
                    self?.onlineUsers_CollectionView.delegate = self
                    self?.onlineUsers_CollectionView.dataSource = self
                    
                    self?.chatListing_TableView.delegate = self
                    self?.chatListing_TableView.dataSource = self
                    
                    
                    self?.chatListing_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                    
                    self?.chatListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
    }
    
    
    // MARK: - Send Friend Request Service
    
    
    func sendRequestService(request_id: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"request_id": request_id ]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_friend_request", params: param as [String: AnyObject]) {[weak self]
            (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    self?.ViewMoreSuggestionListing(serviceUrl: "send_view_more_suggestions_user/\(UserData().userId)")
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    // MARK: - Search User Service Response
    
    
    func viewMoreSuggestion(search: String) {
        
        // Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId, "search": search]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_search_more_suggestions_user", params: param as [String: AnyObject]) {[weak self]
            (receviedData) in
            
            print(receviedData)
            
            //Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.viewSuggestionListingArray = []
                    
                    
                    self?.viewSuggestionListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    // self.defaultSearchBar()
                    
                    self?.chatListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
                }else {
                    
                    // self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    // MARK: -  Request Recevied Service Response
    
    func RequestRecevied() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_Requested_friends/\(UserData().userId)") { [weak self](receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    self?.viewSuggestionListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self?.chatListing_TableView.delegate = self
                    
                    self?.chatListing_TableView.dataSource = self
                    
                    self?.onlineUsers_CollectionView.delegate = self
                    
                    self?.onlineUsers_CollectionView.dataSource = self
                    
                    self?.chatListing_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                    
                    self?.chatListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
                }else {
                    
                    
                    self?.viewSuggestionListingArray = []
                    
                    self?.chatListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    self?.onlineUsers_CollectionView.delegate = self
                    
                    self?.onlineUsers_CollectionView.dataSource = self
                    
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
        
        
        
        
    }
    
    // MARK: - Cancel Friend Request Service
    
    //    func CancelSendRequest(reject_id: String) {
    //
    //        // Indicator.shared.showProgressView(self.view)
    //
    //        let param = ["user_id":reject_id ,"reject_id": UserData().userId ]
    //
    //        print(param)
    //        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "reject_friend_request", params: param as [String: AnyObject]) {
    //            (receviedData) in
    //
    //            print(receviedData)
    //
    //            //Indicator.shared.hideProgressView()
    //
    //            if Singleton.sharedInstance.connection.responseCode == 1 {
    //
    //                if receviedData["response"] as? Bool == true {
    //
    //
    //                    self.ViewMoreSuggestionListing(serviceUrl: "send_view_more_suggestions_user/\(UserData().userId)")
    //
    //
    //                }else {
    //
    //                    // self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
    //                }
    //
    //
    //            }else {
    //
    //                self.showDefaultAlert(Message: receviedData["Error"] as! String)
    //
    //            }
    //
    //        }
    //
    //    }
    
    // MARK: - Online Friends Service
    
    func onlineUsersService() {
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_friends_online/\(UserData().userId)") { [weak self](receviedData) in
            
            Indicator.shared.hideProgressView()
            
        //    print(receviedData)
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else {
                        
                        return
                    }
                    
                    do {
                        
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self?.onlineUserdata = try JSONDecoder().decode(OnlineUsersModel.self, from: jsonData!)
                        
                        self?.onlineUsers_CollectionView.reloadData()
                        
                    }catch {
                        
                        print(error.localizedDescription)
                        
                    }
                    
                }else {
                    
                    self?.onlineUser_View.isHidden = true
                    self?.onlineUserView_Height.constant = 0
                    
                  //  self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
            }
            
        }
        
    }
    
    // MARK: - Create Room Service
    
    func createRoom(receiver_id: String){
        Indicator.shared.showProgressView(self.view)
        let param = ["sender_id": UserData().userId ,"receiver_id":receiver_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "chat-room", params: param as [String: AnyObject]) { [weak self] (receviedData) in
            
            print(receviedData)
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    
                    vc.rooomId = (((receviedData as? [String: AnyObject])?["data"] as? [String: AnyObject])?["room_id"] as? String ?? "")
                    
                    vc.senderId = ((((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["sender_id"] as? String ?? ""))
                    
                    vc.receiverId = ((((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["receiver_id"] as? String ?? ""))
                    
                    vc.groupId = (((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["group_id"] as? String ?? "")
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
                
            }
            
            
        }
        
        
        
    }
    
    
    // MARK: - Create Group room
    
    public func createGroupRoom(group_id: String){
        Indicator.shared.showProgressView(self.view)
        let param = ["sender_id": UserData().userId ,"group_id": group_id ] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "chat-room-group", params: param as [String: AnyObject]) { [weak self](receviedData) in
            
            print(receviedData)
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    
                    vc.rooomId = (((receviedData as? [String: AnyObject])?["data"] as? [String: AnyObject])?["room_id"] as? String ?? "")
                    
                    vc.senderId = (((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["sender_id"] as? String ?? "")
                    
                    vc.receiverId = (((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["receiver_id"] as? String ?? "")
                    
                    vc.groupId = (((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["group_id"] as? String ?? "")
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
                
            }
            
            
        }
        
        
        
    }
    
    
    // MARK: - All chat Messages
    
    func allchatwithUsers(){
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_user_group_with_last_message/\(UserData().userId)"){ [weak self](receviedData) in
            print("send_user_group_with_last_message/\(UserData().userId)")
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true{
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else {
                        self?.viwNoRecord.isHidden = false
                        return
                    }
                    self?.viwNoRecord.isHidden = true
                    do{
                        
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self?.allMessageUserData = try JSONDecoder().decode(ChatWithUsersMessages.self, from: jsonData!)
                        
                        self?.filterchatData = self?.allMessageUserData
                        
                        self?.chatListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                        
                    }catch {
                        
                        print(error.localizedDescription)
                    }
                    
                }else {
                    
                  //  self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
        
    }
    
    
    
    // MARK: - Search Messages Services
    
    func searchWithMessages(search: String) {
        
        
        let param = ["user_id": UserData().userId,"search": search] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "search_user_group_with_last_message", params: param as [String: AnyObject]){ [weak self] (receviedData) in
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    if receviedData["response"] as? Bool == true{
                        
                        guard let data = receviedData["data"] as? [[String: AnyObject]]else {
                            
                            return
                        }
                        
                        do{
                            
                            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            
                            self?.allMessageUserData = try JSONDecoder().decode(ChatWithUsersMessages.self, from: jsonData!)
                            
                            self?.chatListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                            
                        }catch {
                            
                            print(error.localizedDescription)
                        }
                        
                        
                    }else {
                        
                        self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                        
                    }
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                    
                }
                
                
            }
            
        }
        
        
    }
    
   
    
    

    

    
    func updateSearchResults(for searchController: UISearchController) {
       // stop this searching and show new screen
      //  filterSearchData(for: searchController.searchBar.text ?? "")
        
    }
    
    
    
    func filterSearchData(for searchText: String) {
        
        
        
        if searchText != "" {
            
            searchWithMessages(search: searchText)
            
        }else {
            
            // self.viewSuggestionListingArray = []
            
            self.allMessageUserData = filterchatData
            self.chatListing_TableView.reloadDataWithAutoSizingCellWorkAround()
        }
        
        
    }
    
}

// MARK: - Show Toast

extension UnlifeChatViewController: setToastMessage{

    func setToastData(message: String) {
        
        
        self.showCustomToast(withMessage: message)
        
        
    }
}






