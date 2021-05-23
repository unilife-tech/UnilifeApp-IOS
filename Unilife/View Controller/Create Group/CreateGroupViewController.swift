//
//  CreateGroupViewController.swift
//  Unilife
//
//  Created by Apple on 27/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import TOCropViewController
import SDWebImage

class CreateGroupViewController: UIViewController {
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var groupListing_TableView: UITableView!
    
    @IBOutlet weak var selectCamera_btn: UIButton!
    
    @IBOutlet weak var group_ImageView: SetImage!
    
    @IBOutlet weak var groupListingTableView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var groupName_textField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var footer_View: UIView!
    
    @IBOutlet weak var createGroup_btn: SetButton!
    
    @IBOutlet weak var searchFriendName_textField: UITextField!
    
    // MARK : - Variable
    
    var cropStyle:TOCropViewCroppingStyle?
    
    var cropViewController = TOCropViewController()
    
    let image_picker = UIImagePickerController()
    
    var friendsListingArray = [[String: AnyObject]]()
    
    var condition = ""
    
    var selectedIndex = [Int]()
    
    var friendIdArray = [String]()
    
    var friendId = ""
    
    var storeDataArray : FriendListingModel?
    
    var newFriendListing: FriendListingModel?
    
    
    
    
    // MARK: - Default View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        //        self.navigationController?.navigationBar.prefersLargeTitles = false
        //
        //        self.navigationItem.largeTitleDisplayMode = .automatic
        
        
        //        navigationItem.searchController = UISearchController(searchResultsController: nil)
        //        navigationItem.hidesSearchBarWhenScrolling = false
        
        // defaultSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Create Group", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            
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
        
        self.groupListing_TableView.tableFooterView = self.footer_View
        
        self.createGroup_btn.isHidden = false
        
//        friendListing()
        
        newFriendList()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK : - Update Table View Height
    
    func updateTableHeight(){
        var frame = self.groupListing_TableView.frame
        frame.size.height = self.groupListing_TableView.contentSize.height
        self.groupListing_TableView.frame = frame
        self.groupListing_TableView.reloadData()
        self.groupListing_TableView.layoutIfNeeded()
        self.groupListingTableView_Height.constant = CGFloat(self.groupListing_TableView.contentSize.height)
    }
    
    deinit {
        print(#file)
    }
    
    
    // MARK: - TextField Delegate
    
    @IBAction func searchGroupEditing_Changed(_ sender: UITextField) {
        
     
        
        if self.searchFriendName_textField.text! == "" {
            
            self.newFriendListing = self.storeDataArray
            
            
        }else {
            
//            let filterArray = self.friendsListingArray.filter({((($0["userfriend"] as! [String:AnyObject])["username"] as? String ?? "").lowercased()).contains(sender.text!.lowercased())})
            
            let newfilterData = self.newFriendListing?.filter({(($0.username ?? "")).lowercased().contains(sender.text ?? "")
            })
            
            self.newFriendListing = newfilterData
            
        }
        
        self.groupListing_TableView.reloadDataWithAutoSizingCellWorkAround()
        
    }
    // MARK: - Button Action
    
    
    
    @IBAction func tapFriendList_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FriendsListingViewController") as! FriendsListingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func tapSelectImage_btn(_ sender: Any) {
        
        self.showPicker()
    }
    
    
    @IBAction func tapCreate_btn(_ sender: Any) {
        
        if self.groupName_textField.text! == "" {
            
            self.showDefaultAlert(Message: "Please enter group name")
        }else if self.friendIdArray.count == 0 {
            
            self.showDefaultAlert(Message: "Plesae select friend to add in the group")
        }else {
            
           self.createGroup()
        }
        
        
    }
    
    
}

// MARK: - Table View Delegate

extension CreateGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newFriendListing?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.groupListing_TableView.dequeueReusableCell(withIdentifier: "ChatListingTableViewCell") as! ChatListingTableViewCell
        
        cell.userMessageCount_btn.isHidden = true
        cell.chatListingUser_btn.isHidden = false
        
        cell.chatListingUser_btn.backgroundColor = UIColor.clear
        
       // if self.newFriendListing?[indexPath.row].u == "<null>" {
//
//            cell.chatListingUserName_lbl.text! = ""
//
//            cell.chatListingUser_ImageView.image = UIImage(named: "noimage_icon")
        
       // }else {
            
            cell.chatListingUserName_lbl.text! = self.newFriendListing?[indexPath.row].username ?? ""
            
            cell.chatListingUser_ImageView.sd_setImage(with: URL(string:  profileImageUrl + (self.newFriendListing?[indexPath.row].profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
       // }
        
        
        
        
        
        if self.selectedIndex[indexPath.row] == 0 {
            
            cell.chatListingUser_btn.setTitle("Add", for: .normal)
            cell.chatListingUserDescription_lbl.textColor = UIColor.white
            cell.chatListingUser_btn.backgroundColor = UIColor.appLightGreyColor
            
        }else {
            
            cell.chatListingUser_btn.setTitle("Selected", for: .normal)
            cell.chatListingUserDescription_lbl.textColor = UIColor.white
            cell.chatListingUser_btn.backgroundColor = UIColor.appSkyBlue
            
        }
        
        cell.chatListingUser_btn.tag = indexPath.row
        cell.chatListingUser_btn.addTarget(self, action: #selector(tapSelect_btn(_:)), for: .touchUpInside)
        cell.chatListingUserDescription_lbl.text! = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    // MARK: - Button Action
    
    @objc func tapSelect_btn(_ sender: UIButton) {
        
        if self.selectedIndex[sender.tag] == 0 {
            
            self.selectedIndex[sender.tag] = 1
            
            // self.friendId.append(String(describing: (self.friendsListingArray[sender.tag])["friend_id"]!))
            
        }else {
            
            self.selectedIndex[sender.tag] = 0
            
            //  self.friendId.remove(at: sender.tag)
        }
        
        
        if    self.friendIdArray.contains(String(self.newFriendListing?[sender.tag].id ?? -1)) {
            
            self.friendIdArray.index(of: String(self.newFriendListing?[sender.tag].id ?? -1))
            self.friendIdArray.remove(at: (self.friendIdArray.index(of: String(self.newFriendListing?[sender.tag].id ?? -1)))!)
            
        }else {
            self.friendIdArray.append(String(self.newFriendListing?[sender.tag].id ?? -1))
        }
        
        var friendData = ""
        
        for i in 0..<self.friendIdArray.count {
            
            friendData +=  "\(friendIdArray[i]),"
            
        }
        
        self.friendId = friendData
        
        print(friendIdArray)
        
        self.groupListing_TableView.reloadData()
    }
}

// MARK: - Image Picker Delegate

extension CreateGroupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        
        cropStyle = TOCropViewCroppingStyle.default
        
        cropViewController.customAspectRatio = CGSize(width: self.group_ImageView.frame.size.width, height: self.group_ImageView.frame.size.height)
        
        
        cropViewController = TOCropViewController(croppingStyle: cropStyle!, image: selectedImage)
        
        cropViewController.toolbar.clampButtonHidden = true
        
        
        cropViewController.toolbar.rotateClockwiseButtonHidden = true
        
        cropViewController.cropView.setAspectRatio(CGSize(width: self.group_ImageView.frame.size.width, height: self.group_ImageView.frame.size.height  ), animated: true)
        
        
        cropViewController.cropView.aspectRatioLockEnabled = true
        
        cropViewController.toolbar.rotateButton.isHidden = true
        
        
        
        cropViewController.toolbar.resetButton.isHidden = true
        
        
        
        cropViewController.delegate = self
        
        
        
        dismiss(animated: true, completion: nil)
        
        
        
        self.navigationController?.present(cropViewController, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        self.group_ImageView.contentMode = .scaleToFill
        
        self.group_ImageView.image = image
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func showPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.camera()
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: {(alert:UIAlertAction) -> Void in
                
                self.photolibrary()
                
            }))
            
        }else{
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: {(alert:UIAlertAction) -> Void in
                
                self.photolibrary()
                
            }))
            
        }
        
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            let popUp = UIPopoverController(contentViewController: actionSheet)
            
            popUp.present(from: CGRect(x: 15, y: self.view.frame.height - 150, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
        }else{
            
            self.present(actionSheet, animated: true, completion: nil)
            
        }
        
    }
    
    func camera(){
        
        self.image_picker.sourceType = .camera
        
        self.image_picker.delegate = self
        
        present(image_picker, animated: true, completion: nil)
        
    }
    
    func photolibrary(){
        
        self.image_picker.sourceType = .photoLibrary
        
        self.image_picker.delegate = self
        
        present(image_picker, animated: true, completion: nil)
        
    }
    
}


extension CreateGroupViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

extension CreateGroupViewController {
    
    // MARK: - Friend Listing Response
    
    func friendListing() {
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_user_friends/\(UserData().userId)") {[weak self] (recevieData) in
            print(recevieData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    
                    self.friendsListingArray = recevieData["data"] as! [[String: AnyObject]]
                    
                  //  self.storeDataArray = self.friendsListingArray
                    
                    for _ in 0..<self.friendsListingArray.count {
                        
                        self.selectedIndex.append(0)
                    }
                    
                    self.groupListing_TableView.delegate = self
                    
                    self.groupListing_TableView.dataSource = self
                    
                    self.groupListing_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                    
                    self.groupListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                    
                    //  self.updateTableHeight()
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: recevieData["message"] as! String)
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: recevieData["Error"] as! String)
                
            }
            
        }
    }
    
    // MARK: - New Service Array
    
    func newFriendList(){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id":UserData().userId,
                     "group_id": ""]
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
                        
                        self?.newFriendListing = try JSONDecoder().decode(FriendListingModel.self, from: jsonata!)
                        
                     self?.storeDataArray = self?.newFriendListing
                        
                        for _ in 0..<(self?.newFriendListing?.count ?? 0) {
                            
                            self?.selectedIndex.append(0)
                        }
                        
                        self?.groupListing_TableView.delegate = self
                        
                        self?.groupListing_TableView.dataSource = self
                        
                        self?.groupListing_TableView.register(UINib(nibName: "ChatListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatListingTableViewCell")
                        
                        self?.groupListing_TableView.reloadDataWithAutoSizingCellWorkAround()
                        
//                        if (self?.friendListData?.count ?? 0) == 0{
//                            self?.addParticipants_btn.isHidden = true
//
//                        }else {
//
//                            self?.addParticipants_btn.isHidden = false
//                        }
                        
                    }catch{
                        
                        print(error.localizedDescription)
                    }
                    
                    self?.groupListing_TableView.delegate = self
                    
                    self?.groupListing_TableView.dataSource = self
                    
                    
//                    let count = self?.friendListData?.count ?? 0
//
//                    for _ in 0..<count {
//
//                        self?.checkStatus.append(0)
//                    }
//
//
//
//                    print(self?.friendListData)
                    
                }else {
                    
                    self?.showDefaultAlert(Message: recevieData["message"] as! String)
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: recevieData["Error"] as! String)
                
            }
            
        }
    }
    
    // MARK: - Create Group
    
    func createGroup()
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
          let getServices = self.friendIdArray.joined(separator: ",")
          let params = [
            "group_image":"",
            "friend_id":getServices,
            "group_name":self.groupName_textField.text ?? ""
            ] as [String : Any]
          Indicator.shared.showProgressView(self.view)
      //ApplicationManager.instance.startloading()
          print(params)
          print(ConstantsHelper.create_group)
          WebServiceManager.shared.callWebService_Home(ConstantsHelper.create_group, parameters: params, method: .post) { (response: Any, error, errorMessage)  in
              
              if(response is NSDictionary)
              {
                  
                 print(response)
                  let status = (response as! NSDictionary).value(forKey: "status") as? Bool ?? false
                  if(status == true)
                  {
                   self.showAlertWithAction(Title: "Unilife", Message: "Group Created Successfully", ButtonTitle: "Ok", outputBlock: {
                                            
                                            self.navigationController?.popViewController(animated: true)
                                            
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
    /*
    {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId, "group_name": self.groupName_textField.text!, "request_id": friendIdArray, "group_id": ""] as [String: AnyObject]
        
        print(param)
        
        if group_ImageView.image == UIImage(named: "userProfile_ImageView") {
            Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_multiuser_friend_request", params: param as [String: AnyObject]) {[weak self] (receviedData) in
                
                print(receviedData)
                
                guard let self = self else {
                    return
                }
                
                
                Indicator.shared.hideProgressView()
                
                if Singleton.sharedInstance.connection.responseCode == 1 {
                    
                    if receviedData["response"] as? Bool == true {
                        
//                        self.createGroupWithRoom(group_id: String((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["group_id"] as? Int ?? 0)))
                        //                         UnlifeChatViewController().createGroupRoom(group_id: )
                        
                        self.showAlertWithAction(Title: "Unilife", Message: "Group Created Successfully", ButtonTitle: "Ok", outputBlock: {
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        })
                        
                        
                    }else {
                        
                        self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                        
                    }
                    
                }else {
                    
                    self.showDefaultAlert(Message: receviedData["Error"] as! String)
                    
                }
                
                
            }
            
            
        }else {
            
            let name = String(describing: Date().toMillis()!) + UserData().userId + "image.jpeg"
            
            Singleton.sharedInstance.connection.startConnectionWithSingleFile(FileData:self.group_ImageView.image?.jpegData(compressionQuality: 0.8) as! Data , FileName: name, FileType: "image/jpg", FileParam: "group_image", getUrlString: "send_multiuser_friend_request", params: param as [String: AnyObject]) { (receviedData, responseCode) in
                
                print(receviedData)
                
                Indicator.shared.hideProgressView()
                
                if responseCode == 1 {
                    
                    if receviedData["response"] as? Bool == true {
                        
//                        self.createGroupWithRoom(group_id: String((((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["group_id"] as? Int ?? 0)))
                        
                        self.showAlertWithAction(Title: "Unilife", Message: "Group Created Successfully", ButtonTitle: "Ok", outputBlock: {
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        })
                        
                        
                    }else {
                        
                        self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                        
                    }
                    
                    
                }else {
                    
                    
                    self.showDefaultAlert(Message: receviedData["Error"] as! String)
                }
                
                
            }
            
        }
        
    }
    */
    
    // MARK: - Create Group Room
    
    func createGroupWithRoom(group_id: String){
        Indicator.shared.showProgressView(self.view)
        let param = ["sender_id": UserData().userId ,"group_id": group_id ] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "chat-room-group", params: param as [String: AnyObject]) { (receviedData) in
            
            print(receviedData)
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    //
                    //                    vc.rooomId = (((receviedData as? [String: AnyObject])?["data"] as? [String: AnyObject])?["room_id"] as? String ?? "")
                    //
                    //                    vc.senderId = (((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["sender_id"] as? String ?? "")
                    //
                    //                    vc.receiverId = (((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["receiver_id"] as? String ?? "")
                    //
                    //                    vc.groupId = (((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["group_id"] as? String ?? "")
                    //
                    //                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
                
            }
            
            
        }
        
        
        
    }
    
}



extension UITableView {
    func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
        
    }
}



