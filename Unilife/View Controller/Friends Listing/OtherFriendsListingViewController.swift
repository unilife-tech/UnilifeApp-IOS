//
//  FriendsListingViewController.swift
//  Unilife
//
//  Created by Apple on 27/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class OtherFriendsListingViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var friendListing_TableView: UITableView!
    
    // MARK: - Variable
    
    var storedDataArray = [[String: AnyObject]]()
    
    var friendsListingArray = [[String: AnyObject]]()
    var getUserID:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationController?.navigationBar.prefersLargeTitles = false
        //
        //        self.navigationItem.largeTitleDisplayMode = .automatic
        
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        
        defaultSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Friends", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "dots_icon", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
            
            popoverContent.controller = self
            
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            
            popoverContent.preferredContentSize = CGSize(width: 250, height: 250)
            
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
        
        self.friendListing()
    }
    
    deinit {
        print(#file)
    }
    
    
    // MARK: - Set Default Serach Bar
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
                navigationbar.barTintColor = UIColor.appSkyBlue
            }
            navigationItem.searchController = sc
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController?.searchBar.delegate = self
            self.definesPresentationContext = true
            
            //            sc.hidesNavigationBarDuringPresentation = false
            sc.dimsBackgroundDuringPresentation = false
            
            
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    
}

extension OtherFriendsListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendsListingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.friendListing_TableView.dequeueReusableCell(withIdentifier: "ChatListingTableViewCell") as! ChatListingTableViewCell
        
        if String(describing: ((self.friendsListingArray[indexPath.row])["userfriend"]!)) == "<null>"{
            
           cell.chatListingUserName_lbl.text! = ""
             
        }else {
        
        
        cell.chatListingUserName_lbl.text! = String(describing: ((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject])["username"]!)
            
        }
        
        
        cell.userMessageCount_btn.isHidden = true
        cell.chatListingUser_btn.isHidden = true
        
        cell.chatListingUserDescription_lbl.textColor = UIColor.appDarKGray
        cell.chatListingUserDescription_lbl.tintColor = UIColor.appDarKGray
        
        //   cell.chatListingUser_ImageView
        
        
        if String(describing: ((self.friendsListingArray[indexPath.row])["userfriend"]!)) == "<null>" {
            
            cell.chatListingUser_ImageView.image = UIImage(named: "noimage_icon")
            
            cell.chatListingUserName_lbl.text! = ""
            
            
        }else {
            
            if String(describing: (((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject]))["profile_image"]!) == "<null>" {
                
                cell.chatListingUser_ImageView.image = UIImage(named: "noimage_icon")
                
            }else {
                cell.chatListingUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: (((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject]))["profile_image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
            }
            
            
            cell.chatListingUserName_lbl.text! = String(describing: (((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject]))["username"]!)
            
            cell.userProfile_btn.tag = indexPath.row
            cell.userProfile_btn.addTarget(self, action: #selector(tapUserProfile_btn(_:)), for: .touchUpInside)
            
        }
        
        
        //        cell.chatListingUserDescription_lbl.text! = "when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       createRoom(receiver_id: String(describing: (((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject]))["id"]!))
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    @objc func tapUserProfile_btn(_ sender: UIButton){
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileViewController") as! ViewProfileViewController
//        vc.post_id =   String(describing: (((self.friendsListingArray[sender.tag])["userfriend"] as! [String: AnyObject]))["id"]!)
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let getd:String = String(describing: (((self.friendsListingArray[sender.tag])["userfriend"] as! [String: AnyObject]))["id"]!)
        let vc = kPhase2toryBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        vc.getUserID =  Int(getd) ?? 0
         vc.isComeFromFriend = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

// MARK: - Service Response 

extension OtherFriendsListingViewController: UIPopoverPresentationControllerDelegate, UISearchResultsUpdating {
    
    // MARK: - Friend Listing Response
    
    func friendListing() {
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_user_friends/\(self.getUserID)") {[weak self] (recevieData) in
         //   print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    
                    self?.friendsListingArray = recevieData["data"] as! [[String: AnyObject]]
                    
                    self?.storedDataArray =  self?.friendsListingArray ?? [[:]]
                    
                    
                    self?.friendListing_TableView.delegate = self
                    
                    self?.friendListing_TableView.dataSource = self
                    
                    self?.friendListing_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                    
                    self?.friendListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    //  self.updateTableHeight()
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: recevieData["message"] as! String)
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: recevieData["Error"] as! String)
                
            }
            
        }
    }
    
    
    // MARK: - Search User Service Response
    
    
    func searchFriendName(search: String) {
        
        // Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": self.getUserID, "search": search] as [String : Any]
        
      //  print(param)
         Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_search_user_friend", params: param as [String: AnyObject]) {[weak self]
            (receviedData) in
            
            print(receviedData)
            
            //Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.friendsListingArray = []
                    
                    
                    self?.friendsListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    // self.defaultSearchBar()
                    
                    self?.friendListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
                }else {
                    
                    self?.friendsListingArray = []
                    
                    self?.friendListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    // self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    // MARK: - Create Room
    
    
    func createRoom(receiver_id: String){
        ///... stop this function becuase this is other user profile friend list
        return
        Indicator.shared.showProgressView(self.view)
        let param = ["sender_id": UserData().userId ,"receiver_id":receiver_id ] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "chat-room", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
          //  print(receviedData)
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    
                    vc.rooomId = String(describing:(((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["room_id"] as? String ?? ""))
                    
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
    
    // MARK: - pop Over Delegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // MARK: - Search Bar Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        filterSearchData(for: searchController.searchBar.text ?? "")
        
    }
    
    func filterSearchData(for searchText: String) {
        
        if searchText != "" {
            
            searchFriendName(search: searchText)
            
        }else {
            
            // self.viewSuggestionListingArray = []
            
            self.friendsListingArray =  self.storedDataArray
            self.friendListing_TableView.reloadDataWithAutoSizingCellWorkAround()
        }
        
        
    }
    
}

