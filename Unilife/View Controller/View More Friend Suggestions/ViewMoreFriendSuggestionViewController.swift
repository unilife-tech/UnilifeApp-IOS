//
//  ViewMoreFriendSuggestionViewController.swift
//  Unilife
//
//  Created by Apple on 09/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewMoreFriendSuggestionViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    // MARK: -  Outlet
    
    @IBOutlet weak var viewMoreFriendSuggestion_TableView: UITableView!
    
    // MARK: - Variable
    
    var condition = ""
    
    var viewSuggestionListingArray = [[String: AnyObject]]()
    
    var storeDataArray = [[String: AnyObject]]()
    
    // MARK: - Default View 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultSearchBar()
    }
    
    deinit {
        
        print(#file , "desconstructure")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Find Friends", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "dots_icon", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            
            guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
            
            popoverContent.controller = self
            
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            
            popoverContent.preferredContentSize = CGSize(width: 250, height: 250)
            
            let popOver = popoverContent.popoverPresentationController
            
            popOver?.delegate = self
            
            popOver?.sourceView = self.navigationItem.rightBarButtonItem?.customView  as! UIView
            
            popOver?.sourceRect = (self.navigationItem.rightBarButtonItem?.customView  as AnyObject).bounds
            //
            popOver?.permittedArrowDirections = [.up, .right]
            
            
            self.present(popoverContent, animated: true, completion: nil)
            
        })
        
        self.defaultSearchBar()
        
        ViewMoreSuggestionListing(serviceUrl: "send_view_more_suggestions_user/\(UserData().userId)")
    }
    
    
    
    
    // MARK: - Serach Bar Function
    
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    
    // MARK: - serach Bar delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
}


//MARK: - Table View Delegate

extension ViewMoreFriendSuggestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.condition == "RequestRecevied" {
            
            return viewSuggestionListingArray.count
            
        }else {
            
            return viewSuggestionListingArray.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.viewMoreFriendSuggestion_TableView.dequeueReusableCell(withIdentifier: "ChatListingTableViewCell") as! ChatListingTableViewCell
        
        
        cell.userMessageCount_btn.isHidden = true
        cell.chatListingUser_btn.isHidden = false
        
        if self.condition == "RequestRecevied" {
             cell.chatListingUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: ((self.viewSuggestionListingArray[indexPath.row])["requestfriend"] as! [String: AnyObject])["profile_image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.chatListingUserName_lbl.text! = String(describing: ((self.viewSuggestionListingArray[indexPath.row])["requestfriend"] as! [String: AnyObject])["username"]!)
            
            cell.chatListingUser_btn.setTitle("Respond", for: .normal)
            
            cell.chatListingUser_btn.tag = indexPath.row
            
            cell.chatListingUser_btn.addTarget(self, action: #selector(tapAcceptOrReject_btn(_:)), for: .touchUpInside)
            
            cell.userProfile_btn.tag = indexPath.row
            
            cell.userProfile_btn.addTarget(self, action: #selector(tapUserProfile_btn(_:)), for: .touchUpInside)
            
        }else {
            
            cell.chatListingUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: (self.viewSuggestionListingArray[indexPath.row])["profile_image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.chatListingUserName_lbl.text! = String(describing: (self.viewSuggestionListingArray[indexPath.row])["username"]!)
            
            cell.chatListingUser_btn.setTitle("Send Request", for: .normal)
            
            if String(describing: (self.viewSuggestionListingArray[indexPath.row])["user_friend_request"]!) != "<null>" {
                cell.chatListingUser_btn.setTitle("Cancel request", for: .normal)
                
                cell.chatListingUser_btn.backgroundColor = UIColor.appLightGreyColor
                
            }else {
                
                cell.chatListingUser_btn.setTitle("Send request", for: .normal)
                
                cell.chatListingUser_btn.backgroundColor = UIColor.appSkyBlue
            }
            
            cell.chatListingUser_btn.tag = indexPath.row
            
            cell.chatListingUser_btn.addTarget(self, action: #selector(tapAcceptOrReject_btn(_:)), for: .touchUpInside)
            
            cell.userProfile_btn.tag = indexPath.row
            cell.userProfile_btn.addTarget(self, action: #selector(tapUserProfile_btn(_:)), for: .touchUpInside)
        }
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        //
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        createRoom(receiver_id: String(describing: (self.viewSuggestionListingArray[indexPath.row])["id"]!))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    // MARK: - Button Action
    
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
                
                
                self.CancelSendRequest(reject_id: String(describing: (self.viewSuggestionListingArray[sender.tag])["id"]!))
                
                
            }else {
                
                self.sendRequestService(request_id: String(describing: (self.viewSuggestionListingArray[sender.tag])["id"]!))
                
                
            }
            
        }
        
    }
    
    @objc func tapUserProfile_btn(_ sender: UIButton)
    {
        let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        if self.condition == "RequestRecevied" {
            vc.getUserID = (self.viewSuggestionListingArray[sender.tag])["user_id"] as? Int ?? 0
        }else
        {
            vc.getUserID =  (self.viewSuggestionListingArray[sender.tag])["id"] as? Int ?? 0
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileViewController") as! ViewProfileViewController

        if self.condition == "RequestRecevied" {

            vc.post_id = String(describing: (self.viewSuggestionListingArray[sender.tag])["user_id"]!)

        }else {

                vc.post_id =   String(describing: (self.viewSuggestionListingArray[sender.tag])["id"]!)

        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    */
}


extension ViewMoreFriendSuggestionViewController: UIPopoverPresentationControllerDelegate, UISearchResultsUpdating {
    
    // MARK: - Pop Over Delegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // MARK: - View More Suggestion Service Response
    // "send_view_more_suggestions_user/\(UserData().userId)"
    
    func ViewMoreSuggestionListing(serviceUrl: String) {
        
        Indicator.shared.showProgressView(self.view)
        print(serviceUrl)
        let Url = baseURL + serviceUrl
        print(Url)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: serviceUrl){[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.viewSuggestionListingArray = []
                    
                    self?.viewSuggestionListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self?.storeDataArray = self?.viewSuggestionListingArray ?? [[:]]
                    
                    //                    self.onlineUsers_CollectionView.delegate = self
                    //
                    //                    self.onlineUsers_CollectionView.dataSource = self
                    
                    self?.viewMoreFriendSuggestion_TableView.delegate = self
                    self?.viewMoreFriendSuggestion_TableView.dataSource = self
                    
                    
                    self?.viewMoreFriendSuggestion_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                    
                    self?.viewMoreFriendSuggestion_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
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
        print(param)
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
                    
                    self?.viewMoreFriendSuggestion_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
                }else {
                    
                    self?.viewSuggestionListingArray = []
                    
                    self?.viewMoreFriendSuggestion_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
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
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_Requested_friends/\(UserData().userId)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    self?.viewSuggestionListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    
                    self?.viewMoreFriendSuggestion_TableView.delegate = self
                    
                    self?.viewMoreFriendSuggestion_TableView.dataSource = self
                    
                    //                    self.onlineUsers_CollectionView.delegate = self
                    //
                    //                    self.onlineUsers_CollectionView.dataSource = self
                    
                    self?.viewMoreFriendSuggestion_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                    
                    self?.viewMoreFriendSuggestion_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
                }else {
                    
                    
                    self?.viewSuggestionListingArray = []
                    
                    self?.viewMoreFriendSuggestion_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    //                    self.onlineUsers_CollectionView.delegate = self
                    //
                    //                    self.onlineUsers_CollectionView.dataSource = self
                    
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
        
        
        
        
    }
    
    // MARK: - Cancel Friend Request Service
    
    func CancelSendRequest(reject_id: String) {
        
        // Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id":reject_id ,"reject_id": UserData().userId ]
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "reject_friend_request", params: param as [String: AnyObject]) {[weak self]
            (receviedData) in
            
            print(receviedData)
            
            //Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    self?.ViewMoreSuggestionListing(serviceUrl: "send_view_more_suggestions_user/\(UserData().userId)")
                    
                    
                }else {
                    
                    // self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    // MARK: - Create Room
    
    
    func createRoom(receiver_id: String){
        Indicator.shared.showProgressView(self.view)
        let param = ["sender_id": UserData().userId ,"receiver_id":receiver_id ] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "chat-room", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    
                    vc.rooomId = String((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["room_id"] as? Int ?? 0))
                    
                    vc.senderId = ((((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["sender_id"] as? String ?? ""))
                    
                    vc.receiverId = ((((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["receiver_id"] as? String ?? ""))
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
                
            }
            
            
        }
        
    }
    
    // MARK: - Search Bar Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        filterSearchData(for: searchController.searchBar.text ?? "")
        
    }
    
    func filterSearchData(for searchText: String) {
        
        if searchText != "" {
            
            viewMoreSuggestion(search: searchText)
            
        }else {
            
            // self.viewSuggestionListingArray = []
            
            self.viewSuggestionListingArray =  self.storeDataArray
            self.viewMoreFriendSuggestion_TableView.reloadDataWithAutoSizingCellWorkAround()
        }
       
    }
   
}
