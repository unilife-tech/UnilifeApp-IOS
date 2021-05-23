//
//  LikesViewController.swift
//  Unilife
//
//  Created by Apple on 05/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class LikesViewController: UIViewController {
    
    // MARK: - Outlet

    @IBOutlet weak var likes_TableView: UITableView!
    
    // MARK: - Variable
    
    var url = ""
    
    var condition = ""
    
    var Id = ""
    
    var likeArray = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Likes", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        if self.condition == "Reply" {
            
//        self.url =
            
             self.ViewAlllikes(url: "view_all_post_reply_like/\(Id)")
            
            
        }else if self.condition == "Comment" {
            
       // self.url = "view_all_post_comment_like/\(Id)"
            
        
            self.ViewAlllikes(url: "view_all_post_comment_like/\(Id)")
            
            
        }else {
            
        //self.url = "view_all_post_like/\(Id)"
            
             self.ViewAlllikes(url: "view_all_post_like/\(Id)")
        }
        
       
       
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        
        print(#file)
    }
    
}

extension LikesViewController : UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likeArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.likes_TableView.dequeueReusableCell(withIdentifier: "LikesTableViewCell") as! LikesTableViewCell
        
        
        if self.condition == "Reply" {
            
            if String(describing: ((self.likeArray[indexPath.row])["user_post_comment_like"]!)) == "<null>" {
                
                cell.userProfile_ImageView.image = UIImage(named: "noimage_icon")
                
                cell.userName_lbl.text! = ""
                
                
            }else {
                
                if String(describing: (((self.likeArray[indexPath.row])["user_post_comment_like"] as! [String: AnyObject]))["profile_image"]!) == "<null>" {
                    
                    
                }else {
                    
                    
                    cell.userProfile_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: (((self.likeArray[indexPath.row])["user_post_comment_like"] as! [String: AnyObject]))["profile_image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
                }
                
                
                cell.userName_lbl.text! = String(describing: (((self.likeArray[indexPath.row])["user_post_comment_like"] as! [String: AnyObject]))["username"]!)
                
                
            }
            
            
        
            
            
            
            
        }else if self.condition == "Comment" {
            
            
            if String(describing: ((self.likeArray[indexPath.row])["user_post_comment_like"]!)) == "<null>" {
                
                cell.userProfile_ImageView.image = UIImage(named: "noimage_icon")
                
                cell.userName_lbl.text! = ""
                
                
            }else {
                
                if String(describing: (((self.likeArray[indexPath.row])["user_post_comment_like"] as! [String: AnyObject]))["profile_image"]!) == "<null>" {
                    
                    
                }else {
                    
                    
                    cell.userProfile_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: (((self.likeArray[indexPath.row])["user_post_comment_like"] as! [String: AnyObject]))["profile_image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
                }
                
                
                cell.userName_lbl.text! = String(describing: (((self.likeArray[indexPath.row])["user_post_comment_like"] as! [String: AnyObject]))["username"]!)
                
                
            }
            
            
            
            
        }else {
            
            if String(describing: ((self.likeArray[indexPath.row])["user_post_comment_like"]!)) == "<null>" {
                
            cell.userProfile_ImageView.image = UIImage(named: "noimage_icon")
                
            cell.userName_lbl.text! = ""
                
                
            }else {
                
                if String(describing: (((self.likeArray[indexPath.row])["user_post_comment_like"] as! [String: AnyObject]))["profile_image"]!) == "<null>" {
                    
                    
                }else {
                    
                    
            cell.userProfile_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: (((self.likeArray[indexPath.row])["user_post_comment_like"] as! [String: AnyObject]))["profile_image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
                }
                
                
             cell.userName_lbl.text! = String(describing: (((self.likeArray[indexPath.row])["user_post_comment_like"] as! [String: AnyObject]))["username"]!)
                
                
            }
            
        
            
            
        }
        
        return cell
        
        
      
    }
    
    
    
    
    
}

extension LikesViewController {
    
    func ViewAlllikes(url: String) {
        
    Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: url) {[weak self] (receviedData) in
     print(receviedData)
            
     Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.likeArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self?.likes_TableView.delegate = self
                    
                    self?.likes_TableView.dataSource = self
                    
                self?.likes_TableView.reloadData()
                    
                    
                }else {
                    
                    
         self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                
                
        self?.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
            
        }
    }
}
