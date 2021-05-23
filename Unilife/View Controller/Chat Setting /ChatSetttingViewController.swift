//
//  ChatSetttingViewController.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ChatSetttingViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var dailySelected_btn: UIButton!
    
    @IBOutlet weak var weekly_btn: UIButton!
    
    @IBOutlet weak var monthly_btn: UIButton!
    
    @IBOutlet weak var never_btn: UIButton!
    
    @IBOutlet weak var deleteChat_btn: UIButton!
    
    @IBOutlet weak var archiveChat_btn: UIButton!
    
    @IBOutlet weak var viewSavedMultimedia_btn: UIButton!
    
    @IBOutlet weak var viewBlockedUsers_btn: UIButton!
    
    
    @IBOutlet weak var chatBackUp_btn: UISwitch!
    
    
    // MARK: - Variable
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "checkArchiveStatus"), object: nil)
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "checkArchiveStatus"), object: nil, queue: nil){ (Notification) in
            
            
            self.checkChatArchived()
            
            
        }
        
        self.checkChatArchived()
        
        GetBackUpStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.appSkyBlue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Chat Settings", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            
//            guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestReceviedPopUpViewController") as? RequestReceviedPopUpViewController else {return}
//
//            popoverContent.controller = self
//
//            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
//
//            popoverContent.preferredContentSize = CGSize(width: 250, height: 200)
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
        
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print(#file)
    }
    
    
    // MARK:- Button Action
    
    
    @IBAction func tapSelectBackUpType_btn(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            if self.dailySelected_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.dailySelected_btn.setImage(UIImage(named: "circleWithInnerCircle"), for: .normal)
                
            }
                
            else if dailySelected_btn.currentImage == UIImage(named: "circleWithInnerCircle") {
                self.dailySelected_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
            }
            
        }
        
        if sender.tag == 1 {
            
            if self.weekly_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.weekly_btn.setImage(UIImage(named: "circleWithInnerCircle"), for: .normal)
                
            }
                
            else if weekly_btn.currentImage == UIImage(named: "circleWithInnerCircle") {
                self.weekly_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
            }
            
        }
        
        if sender.tag == 2 {
            
            if self.monthly_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.monthly_btn.setImage(UIImage(named: "circleWithInnerCircle"), for: .normal)
                
            }
                
            else if monthly_btn.currentImage == UIImage(named: "circleWithInnerCircle") {
                self.monthly_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
            }
            
        }
        
        
        if sender.tag == 3 {
            
            if self.never_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.never_btn.setImage(UIImage(named: "circleWithInnerCircle"), for: .normal)
                
            }
                
            else if never_btn.currentImage == UIImage(named: "circleWithInnerCircle") {
                self.never_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
            }
            
        }
        
        
    }
    
    
    
    @IBAction func tapDeleteChat_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDeleteViewController") as! ChatDeleteViewController
        
        
        vc.controller = self
        
        vc.condition = "delete"
        self.presentedViewController?.definesPresentationContext = true
        self.presentedViewController?.providesPresentationContextTransitionStyle = true
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func tapAcrhiveChat_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDeleteViewController") as! ChatDeleteViewController
        
        vc.controller = self
        self.presentedViewController?.definesPresentationContext = true
        self.presentedViewController?.providesPresentationContextTransitionStyle = true
        
        self.present(vc, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func addViewSavedMultimedia_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewSavedMultiMediaViewController") as! ViewSavedMultiMediaViewController
        vc.type = "single"
        vc.user_id = UserData().userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func tapViewBlockedUser_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlockedUserListingViewController") as! BlockedUserListingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func tapChatBackUp_btn(_ sender: Any) {
        
        if self.chatBackUp_btn.isOn{
            
            self.setBackUp(status: "yes")
        }else {
            
           self.setBackUp(status: "no")
        }
    }
    
}

extension ChatSetttingViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    // MARK: - Check Whether Chat is Archived or not
    
    // get_back_up
    
    func checkChatArchived(){
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_archieve_user/\(UserData().userId)"){[weak self] (recevieData) in
            
            print(recevieData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    
                    self.archiveChat_btn.setTitle("UnArchive Chat", for: .normal)
                    
                }else {
                    
                    self.archiveChat_btn.setTitle("Archive Chat", for: .normal)
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: (recevieData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
    }
    
    // MARK: get BackUp Status
    
    func GetBackUpStatus(){
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "get_back_up/\(UserData().userId)"){[weak self] (recevieData) in
            
            print(recevieData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    if (((recevieData as? [String: AnyObject])? ["message"] as? [String: AnyObject])?["status"] as? String ?? "") == "no"{
                        
                   self.chatBackUp_btn.isOn = false
                    }
                    
                    
                }else {
                    
                    self.chatBackUp_btn.isOn = true
                   
                }
                
            }else {
                
                self.showDefaultAlert(Message: (recevieData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
    }
    
    
    // MARK: - Make Back Up Service
    
    func setBackUp(status: String){
        
        let param = ["user_id": UserData().userId,"status": status] as [String: AnyObject]
        
        print(param)
         Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "back_up", params: param as [String: AnyObject]){[weak self] (receviedData) in
            
    print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            if Singleton.sharedInstance.connection.responseCode == 1{
                
                    if receviedData["response"] as? Bool == true {
                        
                        if (((receviedData as? [String: AnyObject])? ["message"] as? [String: AnyObject])?["status"] as? String ?? "") == "no"{
                            
                            self.showDefaultAlert(Message: "Chat backup turned off")
                            
                            self.chatBackUp_btn.isOn = false
                        }else {
                            
                            self.showDefaultAlert(Message: "Chat backup turned on")
                            
                            self.chatBackUp_btn.isOn = true
                        }
                        
                    }
                    else {
                        self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                        
                    }
                    }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
            
        }
        
    
        
        
    }
    
    
    
    
    
    
}
