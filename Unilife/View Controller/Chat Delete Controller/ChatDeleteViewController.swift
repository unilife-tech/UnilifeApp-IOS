//
//  ChatDeleteViewController.swift
//  Unilife
//
//  Created by Apple on 04/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ChatDeleteViewController: UIViewController {
    
    // MARK: - Outlet
    
    var delegate:gotoChatScreenProtocol?
    @IBOutlet weak var back_btn: UIButton!
    
    @IBOutlet weak var chatTitle_lbl: UILabel!
    
    @IBOutlet weak var chatDescription_lbl: UILabel!
    
    // MARK: - Variable
    
    var condition = ""
    
    var controller = UIViewController()
    
    var archiveStatus = ""
    
    var userType = ""
    
    var room_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.userType == "group" {
            
            setLabeldata()
            
        }else {
            
            self.checkChatArchived()
            
        }
        
    }
    
    deinit {
        print(#file)
    }
    
    func setLabeldata(){
        
        if condition == "delete" {
            
            self.chatTitle_lbl.text = "Chat Delete"
            
            self.chatDescription_lbl.text = "There will be no backup of chat available once deleted"
        }else {
            
            if self.archiveStatus == "" {
                
                self.chatTitle_lbl.text = "Chat UnArchive"
                
                self.chatDescription_lbl.text = "Last saved backup of chat will be available when once Unarchived"
                
            }else {
                self.chatTitle_lbl.text = "Chat Archive"
                
                self.chatDescription_lbl.text = "Last saved backup of chat will be available once archived"
                
            }
            
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func tapBack_btn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapChatDeleteYes_btn(_ sender: Any) {
        
        if  condition == "delete" {
            
            if self.userType == "group"{
                
                self.deleteChatGroup()
                
            }else {
                
                self.deleteChat()
                
            }
            
        }else {
            
            if userType == "group"{
                
                self.archiveGroupChat()
                
            }else {
                
                if  self.archiveStatus == ""{
                    
                    self.charArchive(url: "unarchieve_user_group/\(UserData().userId)")
                    
                }else {
                    
                    self.charArchive(url: "archieve_user_group/\(UserData().userId)")
                    
                }
                
            }
        }
        
        
    }
    
    @IBAction func tapChatDeleteNo_btn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ChatDeleteViewController{
    
    
    // MARK: - Delete Full Chat
    
    func deleteChat(){
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "delete_full_chat_data/\(UserData().userId)"){[weak self] (recevieData) in
            
            print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: "Chat Deleted Successfully", ButtonTitle: "Ok"){
                        
                                               
                        
                       
                        
                      
                            self?.dismiss(animated: true, completion: {
                                
                                if(self?.delegate != nil)
                                {
                                    self?.delegate?.gotoChatViws()
                                }
                                
                                
                                
                            })
                        
                        
                        
                    }
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (recevieData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: (recevieData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
            
        }
    }
    
    // MARK: - Archive Chat
    
    func charArchive(url:String){
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: url){[weak self] (recevieData) in
            
            print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    if  self?.archiveStatus == "" {
                        
                        self?.showAlertWithAction(Title: "Unilife", Message: "Chat UnArchive Successfully", ButtonTitle: "Ok"){
                            
                            self?.dismiss(animated: true, completion: nil)
                            
                            NotificationCenter.default.post(name: Notification.Name("checkArchiveStatus"), object: nil, userInfo: nil)
                        }
                        
                    }else {
                        self?.showAlertWithAction(Title: "Unilife", Message: "Chat Archive Successfully", ButtonTitle: "Ok"){
                            
                            self?.dismiss(animated: true, completion: nil)
                            
                            NotificationCenter.default.post(name: Notification.Name("checkArchiveStatus"), object: nil, userInfo: nil)
                        }
                        
                    }
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (recevieData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: (recevieData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
            
        }
    }
    
    
    // MARK: - Check Whether Chat is Archived or not
    
    func checkChatArchived(){
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_archieve_user/\(UserData().userId)"){[weak self] (recevieData) in
            
            print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    self?.archiveStatus = ""
                    
                    self?.setLabeldata()
                    
                }else {
                    
                    self?.archiveStatus = "unarchive"
                    
                    self?.setLabeldata()
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (recevieData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
    }
    
    
    // MARK: - Archive Chat
    
    func archiveGroupChat(){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"chat_room_id": self.room_id] as [String: AnyObject]
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "archive_chat", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard self == self else {
                
                return
            }
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                //                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //
                //                appDelegate.window?.rootViewController?.children
                
                
                if receviedData["response"] as? Bool == true {
                    
                    //let controllers = self?.controller.navigationController?.viewControllers
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: "Chat Archived  Successfully", ButtonTitle: "Ok", outputBlock: {
                        self?.dismiss(animated: true, completion: {
                            
                            if(self?.delegate != nil)
                            {
                                self?.delegate?.gotoChatViws()
                            }
                        })
                                             
                                                      
                        
                        /*
                        if let viewControllers = self?.controller.navigationController?.viewControllers {
                            for viewController in viewControllers {
                                if viewController.isKind(of: UnlifeChatViewController.self){
                                    
                                    self?.dismiss(animated: true, completion: {
                                        self?.controller.navigationController?.popToViewController(viewController, animated: true)
                                    })
                                }
                            }
                        }
                        
                        
                        */
                     
                        
                        
                    })
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
    }
    
    // MARK: - Delete Chat
    
    func deleteChatGroup(){
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"chat_room_id": self.room_id] as [String: AnyObject]
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "delete_chat", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                
                return
            }
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    NotificationCenter.default.post(name: Notification.Name("groupChatDeleted"), object: nil, userInfo: nil)
                    self.showAlertWithAction(Title: "Unilife", Message: "Chat Deleted Successfully", ButtonTitle: "Ok", outputBlock: {
                        
                        self.dismiss(animated: true, completion: {
                                               
                            if(self.delegate != nil)
                                               {
                                                self.delegate?.gotoChatViws()
                                               }
                                           })
                        
                        /*
                        if let viewControllers = self.navigationController?.viewControllers {
                            for viewController in viewControllers {
                                if viewController.isKind(of: UnlifeChatViewController.self){
                                    
                                    self.dismiss(animated: true, completion: {
                                     //   self.controller.navigationController?.popToViewController(viewController, animated: true)
                                        self.navigationController?.popToViewController(viewController, animated: true)
                                    })
                                }
                            }
                        }
                        
                        */
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
