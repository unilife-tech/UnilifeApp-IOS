//
//  SingleUserChatInfoViewController.swift
//  Unilife
//
//  Created by Promatics on 2/14/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import UIKit

class SingleUserChatInfoViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var userImage_View: UIImageView!
    
    // MARK: - Variable
    
    var userImage = ""
    
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    self.userImage_View.sd_setImage(with: URL(string: profileImageUrl + (self.userImage)), placeholderImage: UIImage(named: "noimage_icon"))
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: userName, titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
           
        })
   
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
        vc.userType = ""
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    

}
