//
//  GroupInfoViewController.swift
//  Unilife
//
//  Created by Promatics on 2/11/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import UIKit
import TOCropViewController

class GroupInfoViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var group_ImageView: UIImageView!
    
    @IBOutlet weak var selectImage_btn: SetButton!
    
    @IBOutlet weak var deleteChat_btn: UIButton!
    
    @IBOutlet weak var archiveChat_btn: UIButton!
    
    @IBOutlet weak var viewSavedMultimedia_btn: UIButton!
    
    @IBOutlet weak var viewBlockedUsers_btn: UIButton!
    
    @IBOutlet weak var allParticipant_TableView_height: NSLayoutConstraint!
    
    @IBOutlet weak var allParticipant_TableView: UITableView!
    
    @IBOutlet weak var allParticipantsCount_lbl: UILabel!
    
    @IBOutlet weak var addParticipant_View: UIView!
    
    @IBOutlet weak var addParticipantView_height: NSLayoutConstraint!
    
    // MARK: - Variable
    
    var cropStyle:TOCropViewCroppingStyle?
    
    var cropViewController = TOCropViewController()
    
    let image_picker = UIImagePickerController()
    
    var group_id = ""
    
    var groupData: GroupInfoModel?
    
    var room_id = ""
    
    var checkStatus = false
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Group Info", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            
        })
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "singleUserDeleted"), object: nil)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "singleUserDeleted"), object: nil, queue: nil) { (Notification) in
            
            self.getGroupInfo()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        self.allParticipant_TableView.delegate = self
//
//        self.allParticipant_TableView.dataSource = self
        
        getGroupInfo()
    }
    
    deinit {
        
        print(#file)
    }
    
    // MARK: - Button Action
    
    @IBAction func selectCamera_btn(_ sender: Any) {
        
        self.showPicker()
    }
    
    
    @IBAction func tapDeleteChat_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDeleteViewController") as! ChatDeleteViewController
        
        
        vc.controller = self
        
        vc.condition = "delete"
        
        vc.room_id = self.room_id
        
        vc.userType = "group"
        self.presentedViewController?.definesPresentationContext = true
        self.presentedViewController?.providesPresentationContextTransitionStyle = true
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func tapAcrhiveChat_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDeleteViewController") as! ChatDeleteViewController
        
        vc.controller = self
        
        vc.room_id = self.room_id
        
        vc.userType = "group"
        
        vc.archiveStatus = "oo"
        
        self.presentedViewController?.definesPresentationContext = true
        self.presentedViewController?.providesPresentationContextTransitionStyle = true
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func addViewSavedMultimedia_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewSavedMultiMediaViewController") as! ViewSavedMultiMediaViewController
        vc.type = "group"
        vc.user_id = self.group_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func tapViewBlockedUser_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlockedUserListingViewController") as! BlockedUserListingViewController
        vc.group_id = self.group_id
        vc.userType = "group"
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func addParticipants_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddParticipantsViewController") as! AddParticipantsViewController
        
        vc.condition = ""
        
        vc.groupId = self.group_id
        
        vc.groupUserData = self.groupData?.usersInGroup
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapRemove_btn(_ sender: Any) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddParticipantsViewController") as! AddParticipantsViewController
        
        vc.condition = "remove"
        vc.groupId = self.group_id
        
        vc.groupUserData = self.groupData?.usersInGroup
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    @IBAction func tapExitGroup_btn(_ sender: Any) {
        
        self.leaveGroup()
    }
    
    
    
}



extension GroupInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table View Delegate And DataSouce
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.groupData?.usersInGroup?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.allParticipant_TableView.dequeueReusableCell(withIdentifier: "listParticipantTableViewCell") as! listParticipantTableViewCell
        
        cell.userName_lbl.text! = self.groupData?.usersInGroup?[indexPath.row].groupUserDetail?.username ?? ""
        
        cell.user_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.groupData?.usersInGroup?[indexPath.row].groupUserDetail?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        if self.groupData?.usersInGroup?[indexPath.row].groupAdmin == "no"{
            
            cell.groupAdmin_btn.isHidden = true
            
        }else {
            
            cell.groupAdmin_btn.isHidden = false
            
        }
//        if checkStatus == true {
//
//
//            self.addParticipant_View.isHidden = false
//
//            self.addParticipantView_height.constant = 113
//
//        }else {
//
//            self.addParticipant_View.isHidden = true
//
//            self.addParticipantView_height.constant = 0
//        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.groupData?.usersInGroup?[indexPath.row].userID == Int(UserData().userId) &&  self.groupData?.usersInGroup?[indexPath.row].groupAdmin == "yes" {
          
            
        }else if  self.groupData?.usersInGroup?[indexPath.row].userID == Int(UserData().userId) {
            
        }else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SingleMessageToUserViewController") as! SingleMessageToUserViewController
            
            vc.userName = self.groupData?.usersInGroup?[indexPath.row].groupUserDetail?.username ?? ""
            
            vc.receiver_id = String(self.groupData?.usersInGroup?[indexPath.row].groupUserDetail?.id ?? -100)
            
            vc.controller = self
            vc.groupId = self.group_id
            self.navigationController?.present(vc, animated: true, completion: nil)
            
        }
            
        }

    
    // MARK: - Image View Delegate
    
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
        
        self.setGroupImage()
        
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
    
    // MARK: - Update Table View height
    
    func updateTableHeight(){
        var frame = self.allParticipant_TableView.frame
        frame.size.height = self.allParticipant_TableView.contentSize.height
        self.allParticipant_TableView.frame = frame
        self.allParticipant_TableView.reloadData()
        self.allParticipant_TableView.layoutIfNeeded()
        self.allParticipant_TableView_height.constant = CGFloat(self.allParticipant_TableView.contentSize.height)
    }
    
}

// MARK: - Service Response

extension GroupInfoViewController{
    
    // MARK: - Set Group Image
    
    func setGroupImage() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["group_id": self.group_id] as [String: AnyObject]
        
        print(param)
        //        if self.group_ImageView.image != UIImage(named: "noimage_icon"){
        
        let name = String(describing: Date().toMillis()!) + UserData().userId + "image.jpeg"
        Singleton.sharedInstance.connection.startConnectionWithSingleFile(FileData:self.group_ImageView.image?.jpegData(compressionQuality: 0.8) as! Data , FileName: name, FileType: "image/jpg", FileParam: "group_image", getUrlString: "change_group_icon", params: param as [String: AnyObject]) { [weak self](receviedData, responseCode) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: "Group Image Added Successfully", ButtonTitle: "Ok", outputBlock: {
                        
                    })
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
            
        }
        
        //}
        
    }
    
    
    // MARK: - Group Info Service
    
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
                        print(jsondata)
                        self?.groupData = try JSONDecoder().decode(GroupInfoModel.self, from: jsondata!)
                        
                        self?.allParticipant_TableView.delegate = self
                        
                        self?.allParticipant_TableView.dataSource = self
                      
                        
                        self?.updateTableHeight()
                        
                        
                        self?.group_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self?.groupData?.groupImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
                        
                        self?.allParticipantsCount_lbl.text! = "  " +  String(self?.groupData?.usersInGroup?.count ?? 0) + "  participants"
                        //self.allParticipant_TableView.reloadData()
                        
                   
                        
                    }catch{
                        
                        print(error.localizedDescription)
                        
                    }
                    
                    let groupCount = (self?.groupData?.usersInGroup?.count ?? 0)
                    
                    for i in 0..<groupCount {
                        
                        if self?.groupData?.usersInGroup?[i].userID == Int(UserData().userId) &&  self?.groupData?.usersInGroup?[i].groupAdmin == "yes"{
                            
                            self?.addParticipant_View.isHidden = false
                            
                            self?.addParticipantView_height.constant = 113
                            
                            break
                            
                        }else {
                            
                            self?.addParticipant_View.isHidden = true
                            
                            self?.addParticipantView_height.constant = 0
                            
                            
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
    
    
}




