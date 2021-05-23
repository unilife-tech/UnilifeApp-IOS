//
//  NotificationListingViewController.swift
//  Unilife
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class NotificationListingViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var notificationListing_TableView: UITableView!
    
    // MARK: - Variable
    
    var notificationData : NotificationListingModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notificationListing_TableView.delegate = self
        
        self.notificationListing_TableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Notifications", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        notificationList()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    deinit {
        
        print(#file)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    
    
    @IBAction func tapClear_btn(_ sender: Any) {
        
        deleteNotification()
    }
    
}

extension NotificationListingViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Table View Delegate And DataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notificationData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.notificationListing_TableView.dequeueReusableCell(withIdentifier: "NotificationListingTableViewCell") as! NotificationListingTableViewCell
        
        cell.userName_lbl.text! = self.notificationData?[indexPath.row].notificationUser?.username ?? ""
        
        cell.userNotificationDescription_lbl.text! = self.notificationData?[indexPath.row].message ?? ""
        
        cell.userImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.notificationData?[indexPath.row].notificationUser?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.notificationDate_lbl.text! = dateCalculator(createdDate: self.notificationData?[indexPath.row].createdAt ?? "")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.notificationData?[indexPath.row].type ?? "" == "Post"{
            
           Switcher.clickOnPost()
            
        }else if self.notificationData?[indexPath.row].type ?? "" == "Chat"{
            
           Switcher.clickOnChat()
            
        }else if self.notificationData?[indexPath.row].type ?? ""  == "Blog"{
            
            Switcher.clickOnBlogs()
            
            
        }else if self.notificationData?[indexPath.row].type ?? ""  == "Offer"{
            
           Switcher.clickOnBrand()
            
            
        }else if self.notificationData?[indexPath.row].type == "Friend Request" || self.notificationData?[indexPath.row].type == "Group" {
            
           Switcher.clickOnChat()
            
        }else if self.notificationData?[indexPath.row].type ==  "Accept Request"  || self.notificationData?[indexPath.row].type == "Reject Request" {
            
             Switcher.clickOnChat()
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("Didselect")
        
       
        
        
        
    }
    
    
    
    
    // MARK: - Service Response
    
    func notificationList() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "get_notification/\(UserData().userId)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]] else {
                        
                        return
                    }
                    
                    do{
                        
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self?.notificationData = try JSONDecoder().decode(NotificationListingModel.self, from: jsonData!)
                        
                        self?.notificationListing_TableView.reloadData()
                        
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
    
    func deleteNotification(){
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "delete_notification/\(UserData().userId)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
//                    guard let data = receviedData["data"] as? [[String: AnyObject]] else {
//
//                        return
//                    }
//
//                    do{
//
//                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//
//                        self?.notificationData = try JSONDecoder().decode(NotificationListingModel.self, from: jsonData!)
//
//                        self?.notificationListing_TableView.reloadData()
                    
                    self?.notificationList()
                    
//                    }catch{
//
//                        print(error.localizedDescription)
//                    }
                    
                    
                    
                    
                    
                }else {
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
            
        }
    }
    
}
