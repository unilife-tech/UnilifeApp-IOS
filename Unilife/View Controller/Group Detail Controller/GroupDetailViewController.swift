//
//  GroupDetailViewController.swift
//  Unilife
//
//  Created by Apple on 20/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var groupImage_View: UIImageView!

    @IBOutlet weak var groupName_lbl: UILabel!
    
    @IBOutlet weak var groupMemberListing_TableView: UITableView!
    
    // MARK: - Variable
    
    var groupDetailAccordingId : GroupDetailModel?
    var groupId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupMemberListing_TableView.delegate = self
        self.groupMemberListing_TableView.dataSource = self

        groupDetail()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Group Detail", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
    }
    
    deinit {
        
        print(#file)
    }
  
}

// MARK: - Table View delegate

extension GroupDetailViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return self.groupDetailAccordingId?.usersInGroup?.count ?? 0
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        self.groupImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.groupDetailAccordingId?.groupImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        self.groupName_lbl.text! = (self.groupDetailAccordingId?.groupName ?? "")
        
        
        let cell = self.groupMemberListing_TableView.dequeueReusableCell(withIdentifier: "GroupDetailTableViewCell") as! GroupDetailTableViewCell
        
        cell.groupImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.groupDetailAccordingId?.usersInGroup?[indexPath.row].groupUserDetail?.profileImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.groupName_lbl.text! = (self.groupDetailAccordingId?.usersInGroup?[indexPath.row].groupUserDetail?.username ?? "")
        
    return cell
    }
    
    
}

// MARK: -  Group Detail Service Respone

extension GroupDetailViewController{
    
    func groupDetail() {
        
    Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "group_image/\(groupId)"){[weak self] (receviedData) in
            
        print(receviedData)
            
        Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [String: AnyObject]else {
                        
                        return
                        
                    }
                    
                    do {
                        
                        let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self?.groupDetailAccordingId = try JSONDecoder().decode( GroupDetailModel.self, from: jsonData!)
                        
                        self?.groupMemberListing_TableView.reloadData()
                        
                        
                        
                    }catch{
                       
                        print(error.localizedDescription)
                    }
                }else {
                 self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No data found")
                    
                }
                
            }else {
             self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No data found")
                
            }
        
        }
        
        
    }
}


