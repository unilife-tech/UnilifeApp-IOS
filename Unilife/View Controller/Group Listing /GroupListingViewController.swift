//
//  GroupListingViewController.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class GroupListingViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    // MARK: - Outlet
    
    
    @IBOutlet weak var groupList_lbl: UILabel!
    
    @IBOutlet weak var createNewGroup_lbl: SetButton!
    
    @IBOutlet weak var groupListing_TableView: UITableView!
    
    // MARK: - Variable
    
    var groupListingArray = [[String: AnyObject]]()
    
    var filterSearchGroupArray = [[String: AnyObject]]()
    
    
    // MARK: - Variable
    
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
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Groups", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            
            //            guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
            //
            //            popoverContent.controller = self
            //
            //            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            //
            //            popoverContent.preferredContentSize = CGSize(width: 250, height: 250)
            //
            //            let popOver = popoverContent.popoverPresentationController
            //
            //            popOver?.delegate = self
            //            //
            //            popOver?.sourceView = self.navigationItem.rightBarButtonItem?.customView  as! UIView
            //            //
            //            popOver?.sourceRect = (self.navigationItem.rightBarButtonItem?.customView  as AnyObject).bounds
            //            //
            //            popOver?.permittedArrowDirections = [.up, .right]
            //
            //
            //            self.present(popoverContent, animated: true, completion: nil)
            
        })
        
        groupListing()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print(#file)
    }
    
    // MARK: - Set Default Serach Bar
    func defaultSearchBar() {
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
        
        //            sc.hidesNavigationBarDuringPresentation = false
        sc.dimsBackgroundDuringPresentation = false
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    
    // MARK: - serach Bar delegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    
    
    // MARK: - Button Action
    
    @IBAction func tapCreateGroup_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupViewController") as! CreateGroupViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}

extension GroupListingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.groupListingArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.groupListing_TableView.dequeueReusableCell(withIdentifier: "ChatListingTableViewCell") as! ChatListingTableViewCell
        
        cell.userMessageCount_btn.isHidden = true
        cell.chatListingUser_btn.isHidden = false
        
        cell.chatListingUserName_lbl.text! = String(describing: ((self.groupListingArray[indexPath.row])["usergroup"] as! [String: AnyObject])["group_name"]!)
        
        cell.chatListingUserDescription_lbl.text! = String(describing: (((self.groupListingArray[indexPath.row])["usergroup"] as! [String: AnyObject])["users_in_group"] as! [[String: AnyObject]]).count) + " Users"
        
        
        if String(describing: ((self.groupListingArray[indexPath.row])["usergroup"] as! [String: AnyObject])["group_image"]!) == "<null>" {
            
            cell.chatListingUser_ImageView.image = UIImage(named: "userProfile_ImageView")
        }else {
            
            cell.chatListingUser_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: ((self.groupListingArray[indexPath.row])["usergroup"] as! [String: AnyObject])["group_image"]!)), placeholderImage: UIImage(named: "userProfile_ImageView"))
            
            
        }
        
        cell.chatListingUser_btn.tag = indexPath.row
        cell.chatListingUser_btn.addTarget(self, action: #selector(tapUnjoin_btn(_:)), for: .touchUpInside)
        
        // userProfile_ImageView
        
        cell.chatListingUser_btn.setTitle("Unjoin", for: .normal)
        cell.selectUserImage_btn.isHidden = false
        
        cell.selectUserImage_btn.tag = indexPath.row
        
        cell.selectUserImage_btn.addTarget(self, action: #selector(getGroupDetail(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //    let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
        //
        //        vc.groupId = String(describing: (self.groupListingArray[indexPath.row])["group_id"]!)
        //
        //    self.navigationController?.pushViewController(vc, animated: true)
        
        createGroupRoom(group_id: String(describing: (self.groupListingArray[indexPath.row])["group_id"]!))
    }
    
    // MARK: - Button Action
    
    @objc func tapUnjoin_btn(_ sender: UIButton) {
        
        
        self.unjoinGroup(group_id: String(describing: ((self.groupListingArray[sender.tag])["usergroup"] as! [String: AnyObject])["id"]!))
    }
    
    @objc func getGroupDetail(_ sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupDetailViewController") as! GroupDetailViewController
        
        vc.groupId = String(describing: (self.groupListingArray[sender.tag])["group_id"]!)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
}


// MARK: - Services Response And Search Bar Dekegate

extension GroupListingViewController: UIPopoverPresentationControllerDelegate, UISearchResultsUpdating {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}


// MARK: - Service Response

extension GroupListingViewController {
    
    // MARK: - Group Listing
    
    func groupListing() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_group_list/\(UserData().userId)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.groupListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self.filterSearchGroupArray = self.groupListingArray
                    
                    self.groupListing_TableView.delegate = self
                    
                    self.groupListing_TableView.dataSource = self
                    self.groupListing_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                    
                    self.groupListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
                }else {
                    
                    self.groupListingArray = []
                    
                    self.groupListing_TableView.delegate = self
                    
                    self.groupListing_TableView.dataSource = self
                    self.groupListing_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                    
                    self.groupListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
    }
    
    
    // MARK: -  unjoin group
    
    func unjoinGroup(group_id: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"group_id": group_id] as [String: AnyObject]
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "unjoin_the_group", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.groupListing()
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    
                }
                
                
            }else {
                
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
    }
    
    // MARK: - Serach group with Name
    
    func seacrhGroupName(search: String){
        
        // Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId, "search": search]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_search_user_group", params: param as [String: AnyObject]) {[weak self]
            (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            //Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    
                    
                    self.groupListingArray = receviedData["data"] as! [[String: AnyObject]]
                    // self.defaultSearchBar()
                    
                    self.groupListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    
                }else {
                    
                    self.groupListingArray = []
                    
                    self.groupListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    // self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    // MARK: - Create Room
    
    func createGroupRoom(group_id: String){
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
    
    
    // MARK: - Search Bar Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
        filterSearchData(for: searchController.searchBar.text ?? "")
        
    }
    
    func filterSearchData(for searchText: String) {
        
        if searchText != "" {
            
            seacrhGroupName(search: searchText)
            
        }else {
            
            // self.viewSuggestionListingArray = []
            
            self.groupListingArray =  self.filterSearchGroupArray
            self.groupListing_TableView.reloadDataWithAutoSizingCellWorkAround()
        }
        
        
    }
}
