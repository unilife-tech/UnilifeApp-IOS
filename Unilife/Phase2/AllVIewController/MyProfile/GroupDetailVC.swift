//
//  ViewController.swift
//  Trendy
//
//  Created by developer on 17/04/20.
//  Copyright © 2020 developer. All rights reserved.
//

import UIKit

class GroupDetailVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tbl: UITableView!
    var group_id = ""
    var groupData: GroupInfoModel?
    var getUserImg:UIImage?
    var getName:String = ""
    let image_picker = UIImagePickerController()
    var isHiddenNavigation:Bool = false
    var getGroupUrl:String = ""
    @IBOutlet weak var heightOfTbl: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          getGroupInfo()
        if(getUserImg != nil)
               {
                   imgUser.image = getUserImg
                   
               }
               lblName.text = getName
        
        tbl?.tableFooterView = UIView()
        tbl?.estimatedRowHeight = 44.0
        tbl?.rowHeight = UITableView.automaticDimension
        self.tbl?.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
              
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                  
                      tbl?.layer.removeAllAnimations()
                      heightOfTbl?.constant = self.tbl?.contentSize.height ?? 0.0
                      UIView.animate(withDuration: 0.5) {
                          self.loadViewIfNeeded()
                      
           }
       }
    
    override func viewWillAppear(_ animated: Bool) {
           self.tabBarController?.tabBar.isHidden = true
        if(isHiddenNavigation == true)
        {
            ///...jugad for navigation and group image when come from chatUnilifiView controller 
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            if(getGroupUrl.count > 0)
            {
             self.imgUser.sd_setImage(with: URL(string: profileImageUrl + getGroupUrl), placeholderImage: UIImage(named: "noimage_icon"))
            }
        }
       }
    
    @IBAction func clickBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickImagePicker()
    {
        self.showPicker()
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
    
    
    
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          
          let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
          
        imgUser.image = selectedImage
                 
                 self.setGroupImage()
          
          dismiss(animated: true, completion: nil)
          
          
          
         
          
          
          
      }
 
   

}




extension GroupDetailVC:UITableViewDelegate,UITableViewDataSource
{
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
         return self.groupData?.usersInGroup?.count ?? 0
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
            let cell = tableView.dequeueReusableCell(withIdentifier: "groupAdminCell") as! groupAdminCell
            
            cell.lblName.text = self.groupData?.usersInGroup?[indexPath.row].groupUserDetail?.username ?? ""
            if self.groupData?.usersInGroup?[indexPath.row].groupAdmin == "no"{
                   cell.lblType.text = ""
                   cell.lblType.textColor = UIColor.unilifeRemoveChatColor
            }else {
                   cell.lblType.text = "Admin"
                    cell.lblType.textColor = UIColor.unilifeAdminChatColor
            }
        
        cell.imgUserProfile.sd_setImage(with: URL(string: profileImageUrl + (self.groupData?.usersInGroup?[indexPath.row].groupUserDetail?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        cell.imgUserProfile.layer.cornerRadius = 40/2
        cell.imgUserProfile.layer.borderColor = UIColor.unilifeblueDark.cgColor
        cell.imgUserProfile.layer.borderWidth = 2.0
        
        cell.selectionStyle = .none
            return cell
      
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    
    
}


extension GroupDetailVC
{

        
    func setGroupImage() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["group_id": self.group_id] as [String: AnyObject]
        
        print(param)
        //        if self.group_ImageView.image != UIImage(named: "noimage_icon"){
        
        let name = String(describing: Date().toMillis()!) + UserData().userId + "image.jpeg"
        Singleton.sharedInstance.connection.startConnectionWithSingleFile(FileData:self.imgUser.image?.jpegData(compressionQuality: 0.8) as! Data , FileName: name, FileType: "image/jpg", FileParam: "group_image", getUrlString: "change_group_icon", params: param as [String: AnyObject]) { [weak self](receviedData, responseCode) in
            
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
                           // print(jsondata)
                            self?.groupData = try JSONDecoder().decode(GroupInfoModel.self, from: jsondata!)
                            self?.tbl.reloadData()
                        }catch{
                            print(error.localizedDescription)
                        }
                        
                        
                        
                        
                    }else {
                        
                        self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                        
                    }
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                }
                
            }
            
        }
}
