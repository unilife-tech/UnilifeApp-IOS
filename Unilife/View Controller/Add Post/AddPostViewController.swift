//
//  AddPostViewController.swift
//  Unilife
//
//  Created by Apple on 30/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import TOCropViewController
import AVFoundation
import GoogleMaps
import  GooglePlaces
import SDWebImage
import MobileCoreServices

class AddPostViewController: UIViewController {
    
    // MARK: - outlet
    
    @IBOutlet weak var selectImage_CollectionView: UICollectionView!
    
    @IBOutlet weak var writeCaption_textView: GrowingTextView!
    
    @IBOutlet weak var tagPeople_textField: UITextField!
    
    @IBOutlet weak var addLocation_textField: UITextField!
    
    @IBOutlet weak var friendNameListing_CollectionView: UICollectionView!
    
    @IBOutlet weak var joinedGroupList_textField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var postThroughGroup_btn: UISwitch!
    
    @IBOutlet weak var addLocation_TableView: UITableView!
    
    @IBOutlet weak var addLocationTableView_height: NSLayoutConstraint!
    
    @IBOutlet weak var friendNameListingCollectionView_height: NSLayoutConstraint!
    
    @IBOutlet weak var tagPeople_TableView: UITableView!
    
    @IBOutlet weak var tagPeopleTableView_height: NSLayoutConstraint!
    
    @IBOutlet weak var groupName_TableView: UITableView!
    
    @IBOutlet weak var groupNameTableView_height: NSLayoutConstraint!
    
    @IBOutlet weak var selectGroupName_btn: UIButton!
    
    @IBOutlet weak var selectTagPeople_btn: UIButton!
    
    
    // MARK: - Variable
    
    var cropStyle:TOCropViewCroppingStyle?
    var cropViewController = TOCropViewController()
    let image_picker = UIImagePickerController()
    var imageData:Data!
    var imageName = ""
    var data:NSData?
    var condition = ""
    var videoUrl = ""
    var isImageUploaded = false
    var imageArray = [UIImage(named: "add-post"), UIImage(named: "add-post"), UIImage(named: "add-post"), UIImage(named: "add-post"), UIImage(named: "add-post"), UIImage(named: "add-post")]
    var selectedIndex:Int = -1
    
    var postId = [String]()
    
    var postDataArray = [[String: AnyObject]]()
    
    var storePostData = [[String: AnyObject]]()
    
    var searchArray = [[String: AnyObject]]()
    
    let geoCoder = CLGeocoder()
    
    var locationdataArray = [String]()
    
    var friendsListingArray = [[String: AnyObject]]()
    
    var selectFrindListArray = [String]()
    
    var storedDataArray = [[String: AnyObject]]()
    
    var groupListingArray = [[String: AnyObject]]()
    
    var groupListingStoredArray = [[String: AnyObject]]()
    
    var selectedGroupIndexArray = [Int]()
    
    var groupNameArray = [String]()
    
    var selectFriendIndexArray = [Int]()
    
    var selectFriendIdArray = [String]()
    
    var friendNameArray = [String]()
    
    var selectGroupIdArray = [String]()
    
    var post_through_group = ""
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupName_TableView.layer.borderColor = UIColor.appDarKGray.cgColor
        self.groupName_TableView.layer.borderWidth = 1
        
        self.selectImage_CollectionView.delegate = self
        
        self.selectImage_CollectionView.dataSource = self
        
        self.addLocation_TableView.delegate = self
        
        self.addLocation_TableView.dataSource = self
        
        self.addLocation_TableView.layer.borderColor = UIColor.darkGray.cgColor
        
        self.addLocation_TableView.layer.borderWidth = 1
        
        //    self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        for _ in 0..<6 {
            
            self.postDataArray.append([:])
        }
        
        if friendNameArray.count == 0 {
            
            self.friendNameListingCollectionView_height.constant = 0
            self.friendNameListing_CollectionView.isHidden = true
        }else {
            
            self.friendNameListingCollectionView_height.constant = 60
            self.friendNameListing_CollectionView.isHidden = false
        }
        
        
        friendListing()
        
        groupListing()
        
        print(postDataArray)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Add Post ", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        
    }
    
    deinit {
        print(#file)
    }
    
    
    // MARK: - TextView Delegate
    
    @IBAction func addLocationTextField_EditingChanged(_ sender: UITextField) {
        
        let txt = sender.text!.replacingOccurrences(of: " ", with: "")
        
        if txt != "" {
            
            let text1 = self.addLocation_textField.text!
            
            let text = text1.replacingOccurrences(of: " ", with: "%20")
            
            let str = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyA5Y_zfzyS0nUc5kLDavaqlQoz6N4k9PCU&input=\(text)"
            
            print(str)
            Singleton.sharedInstance.connection.startConnectionWithGoogleGetType(getUrlString: str) { (receviedData) in
                
                self.searchArray = []
                
                print(receviedData)
                
                if Singleton.sharedInstance.connection.responseCode == 1 {
                    
                    if String(describing: (receviedData as! NSDictionary).value(forKey: "status")!)  == "OK" {
                        
                        self.searchArray = receviedData["predictions"] as! [[String : AnyObject]]
                        
                        if self.searchArray.count != 0{
                            
                            if self.searchArray.count < 5{
                                
                                self.addLocationTableView_height.constant = CGFloat(self.searchArray.count * 30)
                                
                                self.addLocation_TableView.isHidden = false
                                
                                
                            }else{
                                self.addLocationTableView_height.constant = 150
                                
                                self.addLocation_TableView.isHidden = false
                                
                            }
                            
                            self.addLocation_TableView.reloadData()
                            
                        }
                        
                        
                    }else {
                        
                        self.addLocation_TableView.reloadData()
                        
                    }
                    
                    
                }else {
                    
                    self.addLocation_TableView.reloadData()
                }
                
            }
            
        }else {
            
            self.addLocation_TableView.isHidden = true
        }
        
    }
    
    
    // MARK: - Text Field Delegate
    
    
    @IBAction func tagPeopleTextFiled_EditingChanged(_ sender: UITextField) {
        
        let  text = sender.text!.replacingOccurrences(of: " ", with: "")
        
        if  text != "" {
            
            let txt = self.tagPeople_textField.text!
            
            if txt.contains("@") {
                
                self.tagPeople_TableView.isHidden = false
                
                if   self.friendsListingArray.count ==  5 {
                    
                    self.tagPeopleTableView_height.constant = 150
                }else {
                    
                    
                    self.tagPeopleTableView_height.constant = CGFloat(self.friendsListingArray.count * 30)
                }
                
            }
                
            else {
                
                let filterArray = self.friendsListingArray.filter({((($0 ["userfriend"] as! [String: AnyObject])["username"] as? String ?? "").lowercased()).contains(sender.text!.lowercased())})
                
                
                if   filterArray.count ==  5 {
                    
                    self.tagPeopleTableView_height.constant = 150
                }else {
                    
                    
                    self.tagPeopleTableView_height.constant = CGFloat(filterArray.count * 30)
                }
                
                
                
                self.friendsListingArray = filterArray
                
                //  print(filterArray)
                
                self.tagPeople_TableView.reloadData()
                
                self.tagPeople_TableView.isHidden = false
            }
            
        }else {
            
            
            
            self.tagPeople_TableView.isHidden = false
            
            self.friendsListingArray = self.storedDataArray
            
            if   self.friendsListingArray.count ==  5 {
                
                self.tagPeopleTableView_height.constant = 150
            }else {
                
                
                self.tagPeopleTableView_height.constant = CGFloat(self.friendsListingArray.count * 30)
            }
            //
            self.tagPeople_TableView.reloadData()
            
        }
        
    }
    
    
    @IBAction func selectGroupTextField_EditingChanged(_ sender: UITextField) {
        
        if sender.text! == "" {
            
            
            self.groupListingArray = self.groupListingStoredArray
            
            if groupListingArray.count == 0 {
                
                self.groupName_TableView.isHidden = true
                
                self.groupNameTableView_height.constant = 0
            }else {
                
                if self.groupListingArray.count == 5 {
                    
                    self.groupName_TableView.isHidden = false
                    
                    self.groupNameTableView_height.constant = CGFloat(self.groupListingArray.count * 30)
                }else {
                    
                    self.groupName_TableView.isHidden = false
                    
                    self.groupNameTableView_height.constant = CGFloat(self.groupListingArray.count * 30)
                }
            }
            
            self.groupName_TableView.reloadData()
            
            
        }else {
            
            let filterGroupName = self.groupListingArray.filter({((($0 ["usergroup"] as! [String: AnyObject])["group_name"] as? String ?? "").lowercased()).contains(sender.text!.lowercased())})
            
            print(filterGroupName)
            
            self.groupListingArray = filterGroupName
            
            if groupListingArray.count == 0 {
                
                self.groupName_TableView.isHidden = true
                
                self.groupNameTableView_height.constant = 0
            }else {
                
                if self.groupListingArray.count == 5 {
                    
                    self.groupName_TableView.isHidden = false
                    
                    self.groupNameTableView_height.constant = CGFloat(self.groupListingArray.count * 30)
                }else {
                    
                    self.groupName_TableView.isHidden = false
                    
                    self.groupNameTableView_height.constant = CGFloat(self.groupListingArray.count * 30)
                }
            }
            
            self.groupName_TableView.reloadData()
            
        }
        
    }
    
    // MARK: - Button Action
    
    @IBAction func tapPost_btn(_ sender: Any) {
        
        if self.postId.count == 0 {
            
            self.showDefaultAlert(Message: "Please add images in the post  ")
            
            
        }
        else if self.postId.count == 0 && self.writeCaption_textView.text! == ""  {
            
            
            self.showDefaultAlert(Message: "Please add something in the post ")
            
        }else {
            
            addPost()
            
        }
    }
    
    
    @IBAction func tapSelectGroupName_btn(_ sender: Any) {
        
        if self.groupListingArray.count == 0 {
            
            self.groupName_TableView.isHidden = true
            self.postThroughGroup_btn.isUserInteractionEnabled = false
            self.post_through_group = "no"
            
        }else {
            
            if self.groupName_TableView.isHidden {
                
                self.groupName_TableView.isHidden = false
                
                if self.groupListingArray.count > 10 {
                    
                    self.groupNameTableView_height.constant = 300
                }else {
                    
                    self.groupNameTableView_height.constant = CGFloat(self.groupListingArray.count * 30)
                    
                }
                
            }else {
                
                self.groupName_TableView.isHidden = true
                
            }
        }
    }
    
    
    @IBAction func tapSelectTagPeople_btn(_ sender: Any) {
        
        if  self.tagPeople_TableView.isHidden {
            
            self.tagPeople_TableView.isHidden = false
            
            if self.friendsListingArray.count > 10 {
                
                self.tagPeopleTableView_height.constant = 300
            }else {
                self.tagPeopleTableView_height.constant = CGFloat(self.friendsListingArray.count * 30)
                
            }
            
            
            
        }else {
            
            self.tagPeople_TableView.isHidden = true
            
            self.tagPeopleTableView_height.constant = 0
            
        }
        
    }
    
    
    @IBAction func tapPostThrougGroup_btn(_ sender: Any) {
        
        if self.selectGroupIdArray.count == 0 {
            
            self.postThroughGroup_btn.isUserInteractionEnabled = false
            
            self.postThroughGroup_btn.isOn = false
        }else {
            
            self.postThroughGroup_btn.isUserInteractionEnabled = true
            
            if self.postThroughGroup_btn.isOn {
                
                self.post_through_group = "yes"
                
                print("yes")
            }else {
                
                self.post_through_group = "no"
                
                print("no")
                
            }
            
        }
        
    }
    
}

// MARK: - Collection View Delegate

extension AddPostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == selectImage_CollectionView {
            return self.postDataArray.count
            
        }else {
            
            return self.friendNameArray.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == selectImage_CollectionView {
            
            let cell = self.selectImage_CollectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
            
            if self.postDataArray[indexPath.row].isEmpty {
                
                cell.cross_btn.isHidden = true
                
                cell.selected_ImageView.image = UIImage(named: "add-post")
            }else {
                
                // o8e3bids.png
                
                if String(describing: (self.postDataArray[indexPath.row])["attachment_type"]!) == "video" {
                    
                    cell.selected_ImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    
                    cell.selected_ImageView.sd_setImage(with: URL(string: postImageUrl + String(describing: (self.postDataArray[indexPath.row])["thumbnail"]!)), placeholderImage:UIImage(named: "add-post"))
                    
                }else {
                    
                    cell.selected_ImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                    cell.selected_ImageView.sd_setImage(with: URL(string: postImageUrl + String(describing: (self.postDataArray[indexPath.row])["attachment"]!)), placeholderImage:UIImage(named: "add-post"))
                    
                }
                
                cell.cross_btn.isHidden = false
            }
            cell.cross_btn.tag = indexPath.row
            
            cell.cross_btn.addTarget(self, action: #selector(tapDelete_btn(_:)), for: .touchUpInside)
            
            return cell
            
            
        }else {
            
            let cell = self.friendNameListing_CollectionView.dequeueReusableCell(withReuseIdentifier: "FriendNameCollectionViewCell", for: indexPath) as! FriendNameCollectionViewCell
            
            cell.friendName_lbl.isHidden = false
            
            cell.friendName_lbl.text! = friendNameArray[indexPath.row]
            
            print("\(cell.friendName_lbl.text!)", "\(indexPath.row)")
            
            return cell
            
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == selectImage_CollectionView {
            
            self.selectedIndex = indexPath.row
            
            showAttachFileOptions()
            
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == friendNameListing_CollectionView {
            
            let lbl = UILabel()
            
            lbl.font = UIFont(name: "Arcon-Regular", size: 15)
            
            if friendNameArray.count == 0 {
                
                return CGSize(width: 0, height: 0)
                
            }else {
                
                lbl.text = self.friendNameArray[indexPath.row]
                
                lbl.sizeToFit()
                
                return CGSize(width: lbl.frame.width + 20 , height: 40)
            }
            
            
        }else {
            
            return CGSize(width: 76, height: 80)
            
        }
    }
    
    
    // MARK: - Button Action
    
    @objc func tapDelete_btn(_ sender: UIButton) {
        
        self.deletePost(post_attachment_id: String(describing: (self.postDataArray[sender.tag])["id"]!), index: sender.tag)
        
        print(self.postDataArray)
        
    }
    
}


// MARK: - Image Picker Controller

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    func showAttachFileOptions(){
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.view.tintColor = UIColor(red: 99/255, green: 137/255, blue: 172/255, alpha: 1.0)
        
        
        //Check device has a camera or not
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //Captrue picture uisng camera
            
            let takePhoto_Action = UIAlertAction(title: "Capture Image ", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                
                self.camera()
                

                
            })
            
            let takeVideo_Action = UIAlertAction(title: "Capture Video", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                
                    self.openVideoCamera()
                
            })
            
            optionMenu.addAction(takePhoto_Action)
            optionMenu.addAction(takeVideo_Action)
           
        }
        
        //Picture coose from library
        let choosePhoto_Action = UIAlertAction(title: "Upload Media", style: .default, handler: {(alert:UIAlertAction) -> Void in
            
            self.photolibrary()
            
        })
        
        let uploadVideo_Action = UIAlertAction(title: "Upload Video", style: .default, handler: {(alert:UIAlertAction) -> Void in
            
            self.videoLibrary()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(choosePhoto_Action)
        // optionMenu.addAction(uploadVideo_Action)
        //        optionMenu.addAction(uploadPdf_Action)
        optionMenu.addAction(cancelAction)
        self.isImageUploaded = true
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]) {
        
        
        if (String(describing: info[UIImagePickerController.InfoKey.mediaType]!) == "public.image"){
            
            
            let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            
            self.cropViewController.customAspectRatio = CGSize(width: self.view.frame.width, height: self.view.frame.width)
            
            self.cropStyle = TOCropViewCroppingStyle.default
            
            self.cropViewController = TOCropViewController(croppingStyle: self.cropStyle!, image: selectedImage)
            
            self.cropViewController.toolbar.clampButtonHidden = true
            
            cropViewController.toolbar.rotateClockwiseButtonHidden = true
            
            cropViewController.cropView.setAspectRatio(CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width), animated: true)
            
            cropViewController.cropView.aspectRatioLockEnabled = true
            
            cropViewController.toolbar.rotateButton.isHidden = true
            
            cropViewController.toolbar.resetButton.isHidden = true
            
            cropViewController.delegate = self
            
            self.dismiss(animated: true, completion: nil)
            self.isImageUploaded = true
            self.navigationController?.present(cropViewController, animated: true, completion: nil)
            
        }else{
            
            self.imageName = self.GenerateUniqueImageName().replacingOccurrences(of: ".jpeg", with: ".mp4")
            let videoUrl1 = info[UIImagePickerController.InfoKey.mediaURL]
            self.condition = "video"
            self.videoUrl = String(describing:  info[UIImagePickerController.InfoKey.mediaURL]!)
            
            //generateThumbnail(path: videoUrl1 as! URL)
            
            do {
                try
                    self.imageData = Data(contentsOf: videoUrl1 as! URL)
                
            } catch {
                return
            }
            
            //            let messageDist = [["Name" : self.imageName,
            //                                "Size" : self.imageData.count,
            //                                "room_id" : self.rooomId]] as [[String  : AnyObject]]
            //
            //            self.socket.emitWithAck("uploadFileStart", messageDist).timingOut(after: 0){data in
            //
            //            }
            self.addPostAttahment(type: "video")
            self.isImageUploaded = true
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        self.imageName = self.GenerateUniqueImageName()
        
        self.imageData = (image.jpegData(compressionQuality: 0.8))
        
        self.condition = ""
        
        self.imageArray.insert(image, at: self.selectedIndex)
        
        print(self.selectedIndex)
        
        // self.selectImage_CollectionView.reloadData()
        
        self.addPostAttahment(type: "image")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func camera(){
        
        self.image_picker.sourceType = .camera
        
        self.image_picker.delegate = self
        
        present(image_picker, animated: true, completion: nil)
        
    }
    
    func openVideoCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let image_pickerVideo = UIImagePickerController()
        
       image_pickerVideo.sourceType = .camera
        
       image_pickerVideo.mediaTypes = [kUTTypeMovie as String]
        
        image_pickerVideo.delegate = self
        
        present(image_pickerVideo, animated: true, completion: nil)
            
        }
        
    }
    
    func photolibrary(){
        
        self.image_picker.sourceType = .photoLibrary
        
        self.image_picker.delegate = self
        
        self.image_picker.mediaTypes = ["public.image","public.movie"]
        
        present(image_picker, animated: true, completion: nil)
        
    }
    
    func videoLibrary(){
        
        self.image_picker.mediaTypes = ["public.movie"]
        self.image_picker.delegate = self
        present(image_picker, animated: true, completion: nil)
        
    }
    
   
    //
    //    func GenerateUniqueImageName() -> String {
    //
    //        let milisec = Int((Date().timeIntervalSince1970 * 1000).rounded())
    //        return ("Unilife_" + "\(milisec)" + "\(UserData().userId)" + ".jpeg")
    //
    //    }
    
    // MARK: -  Func Genearting Thumb Nail
    
    func generateThumbnail(path: URL) -> Data? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            
            // cgImage = self.GenerateUniqueImageName() as! CGImage
            
            let   thumbnail = UIImage(cgImage: cgImage)
            
            //self.imageArray.insert(thumbnail, at: selectedIndex)
            //            self.selectImage_CollectionView.reloadData()
            
            let data = thumbnail.jpegData(compressionQuality: 0.8)
            
            
            return data
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
}
// MARK: - Service Response

extension AddPostViewController {
    
    func addPostAttahment( type: String) {
        
        
        var param = [String: AnyObject]()
        
        
        if  self.condition != "video"{
            param = ["attachment_type": type, "thumbnail":"", "device_type": "ios"] as [String: AnyObject]
            
        }else {
            
            param = ["attachment_type": type, "thumbnail":(self.generateThumbnail(path: NSURL(string: self.videoUrl)! as URL)!).base64EncodedString(options: .endLineWithLineFeed), "device_type": "ios"] as [String: AnyObject]
            
        }
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithSingleFile(FileData: self.imageData, FileName: self.imageName, FileType: type, FileParam: "attachment", getUrlString: "add_post_attachment", params: param as [String: AnyObject]) { (receviedData,responseCode) in
            
            print(receviedData)
            if responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.imageData = nil
                    self.imageName = ""
                    self.isImageUploaded = false
                    self.videoUrl = ""
                    
                    self.postId.append(String(describing: (receviedData["data"] as! [String: AnyObject])["id"]!))
                    
                    
                    self.postDataArray[self.selectedIndex] = receviedData["data"] as! [String: AnyObject]
                    
                    
                    
                    print(self.postDataArray)
                    self.selectImage_CollectionView.reloadData()
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    
                }
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    // MARK: - AddPost
    
    func addPost() {
        
        Indicator.shared.showProgressView(self.view)
        
        if self.groupNameArray.count == 0 {
            
            self.postThroughGroup_btn.isUserInteractionEnabled = false
            
            self.post_through_group = "no"
            
        }else{
            
            if postThroughGroup_btn.isOn {
                
                self.post_through_group = "yes"
            }else {
                
                self.post_through_group = "no"
            }
        }
        
        let param = ["user_id": UserData().userId, "caption": self.writeCaption_textView.text!, "post_attachment_ids": self.postId, "post_through_group": post_through_group,"tag_user": self.selectFriendIdArray,"tag_group": self.selectGroupIdArray,"location_name": self.addLocation_textField.text!] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "add_post", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.showAlertWithAction(Title: "Unilife", Message: ((receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found"), ButtonTitle: "Ok", outputBlock: {
                        
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
    
    // MARK: - Delete Post Attachment
    
    func deletePost(post_attachment_id: String, index: Int) {
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "delete_post_attachment/\(post_attachment_id)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.postDataArray[index] = [:]
                    
                    print(self.postDataArray)
                    
                    self.selectImage_CollectionView.reloadData()
                    
                    
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
            
        }
    }
    
    
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
                    
                    self.storedDataArray =  self.friendsListingArray
                    
                    self.tagPeople_TableView.delegate = self
                    
                    self.tagPeople_TableView.dataSource = self
                    
                    self.tagPeople_TableView.reloadData()
                    
                }else {
                    
                    //  self.showDefaultAlert(Message: recevieData["message"] as! String)
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: recevieData["Error"] as! String)
                
            }
            
        }
    }
    
    // MARK: - Group Name Listing
    
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
                    
                    
                    self.selectGroupName_btn.isUserInteractionEnabled = true
                    
                    self.joinedGroupList_textField.isUserInteractionEnabled = true
                    
                    self.groupListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    if self.groupListingArray.count == 0 {
                        
                        self.postThroughGroup_btn.isUserInteractionEnabled = false
                    }else {
                        self.postThroughGroup_btn.isUserInteractionEnabled = true
                        
                    }
                    
                    self.groupListingStoredArray = self.groupListingArray
                    
                    self.groupName_TableView.delegate = self
                    
                    self.groupName_TableView.dataSource = self
                    
                    self.groupName_TableView.reloadData()
                    
                }else {
                    
                    self.selectGroupName_btn.isUserInteractionEnabled = false
                    
                    self.joinedGroupList_textField.isUserInteractionEnabled = false
                    
                    //                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
    }
}

// MARK: - UITableView Delegate
extension AddPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == addLocation_TableView {
            
            return self.searchArray.count
            
        }else if tableView == tagPeople_TableView {
            
            return self.friendsListingArray.count
            
            
        }else {
            
            return groupListingArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == addLocation_TableView {
            
            let cell = self.addLocation_TableView.dequeueReusableCell(withIdentifier: "AddLocationTableViewCell") as! AddLocationTableViewCell
            
            if self.searchArray.count != 0{
                
                if let city = self.searchArray[indexPath.row]["description"] as? String{
                    
                    cell.addLocation_lbl.text = city
                }
                
            }
            
            return cell
            
        }else if tableView == tagPeople_TableView {
            
            let cell = self.tagPeople_TableView.dequeueReusableCell(withIdentifier: "TagPeopleTableViewCell") as! TagPeopleTableViewCell
            
            if (((self.friendsListingArray as? [[String: AnyObject]])?[indexPath.row])? ["userfriend"] as? [String: AnyObject]) == nil {
                cell.tagPeopleUserName_lbl.text! = ""
                
            }else {
                
                cell.tagPeopleUserName_lbl.text! =  String(describing: ((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject])["username"]!)
                
            }
            
            
            cell.selctUserName_btn.tag = indexPath.row
            
            if self.selectFriendIndexArray.contains(indexPath.row) {
                
                cell.selctUserName_btn.setImage(UIImage(named: "check-symbol"), for: .normal)
                
                
            }else {
                
                cell.selctUserName_btn.setImage(UIImage(named: "checkBox"), for: .normal)
            }
            
            return cell
            
        }else {
            
            let cell = self.groupName_TableView.dequeueReusableCell(withIdentifier: "SeacrhGroupNameTableViewCell") as! SeacrhGroupNameTableViewCell
            
            cell.groupName_lbl.text! = String(describing: ((self.groupListingArray[indexPath.row])["usergroup"] as! [String: AnyObject])["group_name"]!)
            cell.selectGroupName_btn.tag = indexPath.row
            
            if self.selectedGroupIndexArray.contains(indexPath.row) {
                
                cell.selectGroupName_btn.setImage(UIImage(named: "check-symbol"), for: .normal)
                
                
            }else {
                
                cell.selectGroupName_btn.setImage(UIImage(named: "checkBox"), for: .normal)
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == addLocation_TableView {
            
            self.addLocation_textField.text = String(describing:  self.searchArray[indexPath.row]["description"]!)
            
            self.addLocation_TableView.isHidden = true
            //
            //            self.getCoodinatesFromAddress(address: String(describing:  self.searchArray[indexPath.row]["description"]!))
            //
            //            if self.locationdataArray.contains(String(describing:  self.searchArray[indexPath.row]["description"]!)) {
            //
            //
            //
            //            }else {
            //
            //                self.locationdataArray.append(String(describing:  self.searchArray[indexPath.row]["description"]!))
            //            }
            //
            //            if locationdataArray.count == 0 {
            //
            //                self.friendNameListingCollectionView_height.constant = 0
            //                self.friendNameListing_CollectionView.isHidden = true
            //            }else {
            //
            //                self.friendNameListingCollectionView_height.constant = 60
            //
            //                self.friendNameListing_CollectionView.isHidden = false
            //
            //                self.friendNameListing_CollectionView.delegate = self
            //
            //                self.friendNameListing_CollectionView.dataSource = self
            //            }
            //
            //            self.addLocation_textField.endEditing(true)
            //
            //            self.addLocation_TableView.isHidden = true
            //
            //            self.friendNameListing_CollectionView.reloadData()
            
        }else if tableView == tagPeople_TableView {
            
            //            let  text = self.tagPeople_textField.text?.replacingOccurrences(of: " ", with: "")
            //
            //            if text?.contains("@") ?? false {
            //
            //
            //                self.tagPeople_textField.text! =  "@ " + String(describing: ((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject])["username"]!)
            //
            //            }else {
            //
            //                self.tagPeople_textField.text! = "@ " + String(describing: ((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject])["username"]!)
            //
            //            }
            
            
            if   selectFriendIndexArray.contains(indexPath.row) {
                
                let index = self.selectFriendIndexArray.index(of: indexPath.row)
                
                //                self.selectFriendIdArray.index(of: String(describing: (self.friendsListingArray[indexPath.row])["friend_id"]!))
                
                self.selectFriendIdArray.remove(at: (self.selectFriendIdArray.index(of: String(describing: (self.friendsListingArray[indexPath.row])["friend_id"]!)))!)
                
                self.friendNameArray.remove(at: (self.friendNameArray.index(of: String(describing: ((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject])["username"]!)))!)
                
                self.selectFriendIndexArray.remove(at: index!)
            }else {
                
                self.selectFriendIdArray.append(String(describing: (self.friendsListingArray[indexPath.row])["friend_id"]!))
                
                self.friendNameArray.append(String(describing: ((self.friendsListingArray[indexPath.row])["userfriend"] as! [String: AnyObject])["username"]!))
                
                self.selectFriendIndexArray.append(indexPath.row)
                
            }
            
            
            if friendNameArray.count == 0 {
                
                self.friendNameListingCollectionView_height.constant = 0
                self.friendNameListing_CollectionView.isHidden = true
            }else {
                
                self.friendNameListingCollectionView_height.constant = 60
                
                self.friendNameListing_CollectionView.isHidden = false
                
                self.friendNameListing_CollectionView.delegate = self
                
                self.friendNameListing_CollectionView.dataSource = self
            }
            
            self.friendNameListing_CollectionView.reloadData()
            
            self.tagPeople_TableView.reloadData()
            
            
            var friendName = ""
            
            
            for i in 0..<friendNameArray.count {
                
                friendName +=  "\(friendNameArray[i]),"
            }
            self.tagPeople_textField.text! = friendName
            
            
            if self.friendNameArray.count != 0 {
                
                self.postThroughGroup_btn.isUserInteractionEnabled = false
                
                self.postThroughGroup_btn.isOn = false
            }else {
                
                self.postThroughGroup_btn.isUserInteractionEnabled = true
                
            }
            
            print(selectFriendIdArray)
            
            
        }else {
            
            if   selectedGroupIndexArray.contains(indexPath.row) {
                
                let index = self.selectedGroupIndexArray.index(of: indexPath.row)
                //                self.groupNameArray.index(of: String(describing: (self.groupListingArray[indexPath.row])["group_id"]!))
                
                self.groupNameArray.remove(at: (self.groupNameArray.index(of: String(describing: ((self.groupListingArray[indexPath.row])["usergroup"] as! [String: AnyObject])["group_name"]!)))!)
                
                self.selectGroupIdArray.remove(at: (self.selectGroupIdArray.index(of: String(describing: ((self.groupListingArray[indexPath.row])["usergroup"] as! [String: AnyObject])["id"]!)))!)
                
                
                
                self.selectedGroupIndexArray.remove(at: index!)
                
                
                
            }else {
                
                self.selectGroupIdArray.append(String(describing: ((self.groupListingArray[indexPath.row])["usergroup"] as! [String: AnyObject])["id"]!))
                
                
                self.groupNameArray.append(String(describing: ((self.groupListingArray[indexPath.row])["usergroup"] as! [String: AnyObject])["group_name"]!))
                
                
                self.selectedGroupIndexArray.append(indexPath.row)
                
            }
            
            var groupName = ""
            
            for i in 0..<groupNameArray.count {
                
                groupName +=  "\(groupNameArray[i]),"
            }
            self.joinedGroupList_textField.text! = groupName
            
            print(groupNameArray)
            
            self.groupName_TableView.reloadData()
            
            if self.selectGroupIdArray.count == 0 {
                
                self.postThroughGroup_btn.isUserInteractionEnabled = false
                
                self.postThroughGroup_btn.isOn = false
            }else {
                
                self.postThroughGroup_btn.isUserInteractionEnabled = true
                
            }
            
        }
        
    }
    
    
    func getCoodinatesFromAddress(address : String){
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                
                let placemarks = placemarks,
                
                let location = placemarks.first?.location
                
                else {
                    // handle no location found
                    return
            }
            
            //            self.myleti = String(describing: location.coordinate.latitude)
            //
            //            self.mylong = String(describing: location.coordinate.longitude)
            
        }
        
        
    }
}
