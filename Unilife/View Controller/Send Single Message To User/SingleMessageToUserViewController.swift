//
//  SingleMessageToUserViewController.swift
//  Unilife
//
//  Created by Promatics on 2/14/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import UIKit

class SingleMessageToUserViewController: UIViewController {
    
    // MARK: - Variable
    
    var userName = ""
    var receiver_id = ""
    var controller = UIViewController()
    var groupId = ""
    
    
    // MARK: - Outlet
    
    @IBOutlet weak var sendMessage_btn: UIButton!
    
    
    @IBOutlet weak var removeMarkHenry_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sendMessage_btn.setTitle("Send Message To \(self.userName) ", for: .normal)
        
        self.removeMarkHenry_btn.setTitle("Remove  \(self.userName)", for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func tapSendMesage_btn(_ sender: Any) {
        
        self.createRoom(receiver_id: self.receiver_id)
     
    }
    
    @IBAction func tapRemove_btn(_ sender: Any) {
        
        removeUsers()
    }
    
    
    @IBAction func tapBack_btn(_ sender: Any) {
        
      self.dismiss(animated: true, completion: nil)
    }
    
}

extension SingleMessageToUserViewController{
    
    // MARK: - Create Room Service
    
    func createRoom(receiver_id: String){
        Indicator.shared.showProgressView(self.view)
        let param = ["sender_id": UserData().userId ,"receiver_id":receiver_id] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "chat-room", params: param as [String: AnyObject]) { [weak self] (receviedData) in
            
            print(receviedData)
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                    
                    vc.rooomId = (((receviedData as? [String: AnyObject])?["data"] as? [String: AnyObject])?["room_id"] as? String ?? "")
                    
                    vc.senderId = ((((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["sender_id"] as? String ?? ""))
                    
                    vc.receiverId = ((((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["receiver_id"] as? String ?? ""))
                    
                    vc.groupId = (((receviedData as? [String: AnyObject])?["body"] as? [String: AnyObject])?["group_id"] as? String ?? "")
                    
                    
                    self?.controller.navigationController?.pushViewController(vc, animated: true)
                    
                    self?.dismiss(animated: true, completion: nil)
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
                
            }
            
            
        }
        
        
        
    }
    
    
    // Delete Users
    func removeUsers(){
        
        var selectedIdArray = [String]()
        
        selectedIdArray.append(self.receiver_id)
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id":selectedIdArray,
                     "group_id": self.groupId] as [String: AnyObject]
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "remove_participant", params: param as [String: AnyObject]) {[weak self] (recevieData) in
            print(recevieData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if recevieData["response"] as? Bool == true {
                    
                    
                    self?.showAlertWithAction(Title: "Unilife", Message: ((recevieData as? [String: AnyObject])? ["message"] as? String ?? ""), ButtonTitle: "Ok"){
                        
                        NotificationCenter.default.post(name: Notification.Name("singleUserDeleted"), object: nil, userInfo: nil)
                        self?.controller.navigationController?.popViewController(animated: true)
                        self?.dismiss(animated: true, completion: nil)
                    }
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: recevieData["message"] as! String)
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: recevieData["Error"] as! String)
                
            }
            
        }
    }
}
