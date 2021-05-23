//
//  RequestReceviedPopUpViewController.swift
//  Unilife
//
//  Created by Apple on 30/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

protocol setToastMessage {
    
    func setToastData(message: String)
}

class RequestReceviedPopUpViewController: UIViewController {
   
    // MARK: - outlet
    
    @IBOutlet weak var differentOptions_TableView: UITableView!
    
    // MARK: - Variable
    
    var optionArray = ["Change Chat Wallpaper", "status", "Request Recevied", "Change Mode"]
    
    var controller: UIViewController?
    
    var conditionChatController = ""
    
    var optionArrayChatArray = ["Block User", "ChangeMode"]
    
    var optionChatGroup = ["Leave Group", "ChangeMode"]
    
    var blockId = ""
    
    var backGroundType = ""
    
    var actuallBackGroundCheck = ""
    
    var groupId = ""
    
    var userStataus = ""
    
    var delegate:setToastMessage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getModeStatus()
    }
    
}

// MARK : - Block User

extension RequestReceviedPopUpViewController {
    
    // MARK: - Block User Service
    
    func blockUser() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param  = ["user_id": UserData().userId,"block_id": self.blockId] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "block_user", params: param as [String: AnyObject]) { (receviedData) in
            
           // print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if  Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.showAlertWithAction(Title: "Unilife", Message: " User Blocked Successfully", ButtonTitle: "Ok", outputBlock:{
                        
                        self.dismiss(animated: true, completion: nil)
                        //self.controller?.navigationController?.popViewController(animated: true)
                        self.controller?.navigationController?.popToRootViewController(animated: true)
                    })
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
            }else {
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
            }
            
            
        }
        
        
    }
    
    
    // MARK: - Change  Background Mode
    
    func changeBackGroundMode() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId, "type": self.backGroundType] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "", params: param as [String: AnyObject]){ (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
            
        }
        
        
    }
    
}



// MARK: - Table View Controller Delegate

extension RequestReceviedPopUpViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.conditionChatController == "ChatController" {
            return optionArrayChatArray.count
            
        }else if self.conditionChatController == "ChatGroupController"{
            
            return 2
        }
        else {
            
            return optionArray.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.differentOptions_TableView.dequeueReusableCell(withIdentifier: "RequestReceivedPopUpTableViewCell") as!RequestReceivedPopUpTableViewCell
        
        if self.conditionChatController == "ChatController" {
            
            cell.differentName_lbl.text! = self.optionArrayChatArray[indexPath.row]
            
            if indexPath.row == 1 {
                
                if self.actuallBackGroundCheck == "black"{
                    cell.select_btn.isOn = true
                    
                }else {
                    
                    cell.select_btn.isOn = false
                }
                
                cell.select_btn.isHidden = false
                
                cell.select_btn.tag = indexPath.row
                cell.select_btn.addTarget(self, action: #selector(tapSwitch_btn(_:)), for: .valueChanged)
            }else {
                
                cell.select_btn.isHidden = true
            }
            
        }else if self.conditionChatController == "ChatGroupController" {
            
            cell.differentName_lbl.text! = self.optionChatGroup[indexPath.row]
            
            if indexPath.row == 1 {
                
                if self.actuallBackGroundCheck == "black"{
                    cell.select_btn.isOn = true
                    
                }else {
                    
                    cell.select_btn.isOn = false
                }
                
                cell.select_btn.isHidden = false
                
                cell.select_btn.tag = indexPath.row
                cell.select_btn.addTarget(self, action: #selector(tapSwitch_btn(_:)), for: .valueChanged)
            }else {
                
                cell.select_btn.isHidden = true
            }
            
        }
            
        else {
            
            cell.differentName_lbl.text = self.optionArray[indexPath.row]
            
            if indexPath.row == 1 || indexPath.row == 3 {
                
                if indexPath.row == 3 {
                    if self.actuallBackGroundCheck == "black"{
                        cell.select_btn.isOn = true
                        
                    }else {
                        
                        cell.select_btn.isOn = false
                    }
                }else if indexPath.row == 1 {
                    
                    if self.userStataus == "yes"{
                        
                    cell.select_btn.isOn = false
                    }else {
                    
                    cell.select_btn.isOn = true
                    }
                }
                
                cell.select_btn.isHidden = false
                cell.select_btn.tag = indexPath.row
                cell.select_btn.addTarget(self, action: #selector(tapSwitch_btn(_:)), for: .valueChanged)
            }else {
                
                cell.select_btn.isHidden = true
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.conditionChatController == "ChatController" {
            
            if indexPath.row == 0 {
                
                blockUser()
            }else {
                
            }
            
        }else if self.conditionChatController == "ChatGroupController"{
            
            if indexPath.row == 0 {
                
                self.unjoinGroup(group_id: self.groupId)
                
            }else{
                
                
            }
           
            
        }else {
            
//            if indexPath.row == 0 {
//
//                self.dismiss(animated: true, completion: nil)
//
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "GroupListingViewController") as! GroupListingViewController
//
//                self.controller?.navigationController?.pushViewController(vc, animated: true)
//
//
//            }
            
             if indexPath.row == 0 {
                
                self.dismiss(animated: true, completion: nil)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeWallpaperViewController") as! ChangeWallpaperViewController
                
                self.controller?.navigationController?.pushViewController(vc, animated: true)
                
                
            }
            else if indexPath.row == 2 {
                
                self.dismiss(animated: true, completion: nil)
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PendingRequestsViewController") as! PendingRequestsViewController
                
                
                //vc.condition = "RequestRecevied"
                
                self.controller?.navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.row == 4 {
                
                
            }
        }
        
    }
    
    // MARK: - button Action
    
    @objc func tapSwitch_btn(_ sender: UISwitch){
        
        if self.conditionChatController == "ChatController" {
            
            if sender.tag == 1 {
                if sender.isOn{
                    
                    self.changeMode(type: "black")
                    
                   // self.showToastMessageMessage(message: "mode is changed to black")
                    
                    self.delegate?.setToastData(message: "mode is changed to black")
                }else {
                    
                    self.changeMode(type: "white")
                    
                   // self.showToastMessageMessage(message: "mode is changed to white")
                    
                    self.delegate?.setToastData(message: "mode is changed to white")
                }
                
            }
            
        }else if self.conditionChatController == "ChatGroupController"{
            
            if sender.tag == 1 {
                if sender.isOn{
                    
                    self.changeMode(type: "black")
                    
                    // self.showToastMessageMessage(message: "mode is changed to black")
                    
                    self.delegate?.setToastData(message: "mode is changed to black")
                }else {
                    
                    self.changeMode(type: "white")
                    
                    // self.showToastMessageMessage(message: "mode is changed to white")
                    
                    self.delegate?.setToastData(message: "mode is changed to white")
                }
                
            }
            // self.unjoinGroup(group_id: self.groupId)
        }else {
            
            if sender.tag == 1 {
                
                if sender.isOn {
                    
                self.changeStatus(status: "show")
                    
                    //self.showToastMessageMessage(message: "your status is online")
                    
                     //self.showCustomToast(withMessage: "your status is online")
                    
                     self.delegate?.setToastData(message: "your status is online")
                    
                }else {
                    
                 self.changeStatus(status: "hide")
                    
                    //self.showToastMessageMessage(message: "your status is offline")
                    
                    // self.showCustomToast(withMessage: "your status is offline")
                    
                      self.delegate?.setToastData(message: "your status is offline")
                }
               
            }else if sender.tag == 3 {
                
                if sender.isOn{
                    
                    self.changeMode(type: "black")
                    
                  //  self.showToastMessageMessage(message: "mode is changed to black")
                    
                      self.delegate?.setToastData(message: "mode is changed to black")
                }else {
                    
                    self.changeMode(type: "white")
                    
                    self.showToastMessageMessage(message: "mode is changed to white")
                }
                
            }else {
                
                
            }
            
            
        }
        
    }
    
}

extension RequestReceviedPopUpViewController{
    
    
    // MARK: - Show Toast
    
    func showToastMessageMessage(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: 20, y: self.view.frame.size.height-20, width: 350, height: 35))
        toastLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Arcon-Regular", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 15;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    
    
    // MARK: - Change Mode Service
    
    func changeMode(type: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId, "type": type] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "user_chat_wallpaper", params: param as [String: AnyObject]){[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                
                return
            }
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
//                    self.showAlertWithAction(Title: "Unilife", Message: "Mode Changed Successfully", ButtonTitle: "Ok", outputBlock: {
                    
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeMode"), object: nil, userInfo: nil)
                        
                        self.dismiss(animated: true, completion: nil)
                   // })
                    
                    
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "")
                    
                }
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "")
                
            }
            
        }
        
        
    }
    
    
    // MARK: - Get change Mode Status or Get Private Status
    
    func getModeStatus(){
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_user_chat_wallpaper/\(UserData().userId)"){[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                
                return
            }
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    if (((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["type"] as? String ?? "") == "black" {
                        
                        self.actuallBackGroundCheck = "black"
                        
                    }else {
                        
                        self.actuallBackGroundCheck = ""
                    }
                    
                    if (((receviedData as? [String: AnyObject])? ["status"] as? [String: AnyObject])) != nil {
                        
                        if ((((receviedData as? [String: AnyObject])? ["status"] as? [String: AnyObject]))? ["status"] as? String ?? "") == "show" {
                             self.userStataus = ""
                            
                        }else if ((((receviedData as? [String: AnyObject])? ["status"] as? [String: AnyObject]))? ["status"] as? String ?? "") == "hide"{
                            
                             self.userStataus = "yes"
                        }else {
                            
                           self.userStataus = ""
                        }
                        
                    }else {
                        
                        self.userStataus = ""
                    }
                    
                    self.differentOptions_TableView.delegate = self
                    
                    self.differentOptions_TableView.dataSource = self
                    
                    self.differentOptions_TableView.reloadData()
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "")
                    
                    
                }
                
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "")
                
                
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
                    
                    self.showAlertWithAction(Title: "Unilife", Message: "Group Leaved  Successfully", ButtonTitle: "Ok", outputBlock: {
                        
                        self.dismiss(animated: true, completion: nil)
                         self.controller?.navigationController?.popViewController(animated: true)
                    })
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
    }
    
    // MARK: - Change User Status
    
    func changeStatus(status: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId, "status": status] as [String: AnyObject]
        
        print(param)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "hide_user_status", params: param as [String: AnyObject]){[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                
                return
            }
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
//                    self.showAlertWithAction(Title: "Unilife", Message: "Status Changed Successfully", ButtonTitle: "Ok", outputBlock: {
                    
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeMode"), object: nil, userInfo: nil)
                        
                        self.dismiss(animated: true, completion: nil)
                  //  })
                    
                    
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "")
                    
                }
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "")
                
            }
            
        }
        
        
    }
    
    
}








extension UIViewController {
    
    /**
        This method is used to show custom toast at the bottom of the screen
     
     - get custom message to show on screen
     */
    func showCustomToast(withMessage message : String) {
        
        var label : UILabel? = UILabel()
        
        label?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        label?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(label!)
        
        label?.layoutIfNeeded()
        label?.alpha = 0
        
        label?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        label?.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        label?.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        label?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        label?.text = message
        label?.textColor = .white
        label?.textAlignment = .center
        label?.backgroundColor = .lightGray
        label?.layer.cornerRadius = 10
        
        
        UIView.animate(withDuration: 2,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseInOut,
                       animations: {
                        label?.alpha = 1
                        print("label showing \(label?.alpha)")
                        
        }) { (isSuccess) in
            if isSuccess {
                UIView.animate(withDuration: 2, animations: {
                    label?.alpha = 0
                    label?.removeFromSuperview()
                    label = nil
                })
            }
        }
    }
    
}


