//
//  InviteViewController.swift
//  Unilife
//
//  Created by Promatics on 1/21/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import UIKit

class InviteViewController: UIViewController {
    
    
    // MARK: - Outlet
    
    
    @IBOutlet weak var invite_btn: SetButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//    self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Invite", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: { [weak self] in
            
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "NotificationListingViewController") as! NotificationListingViewController
            
            self?.navigationController?.pushViewController(vc, animated: true)
            })
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
         self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Button Action
    
    
    @IBAction func invite_btn(_ sender: Any) {
        //let text =  appURL
        let text =  kInviteMessage
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    

    

}
