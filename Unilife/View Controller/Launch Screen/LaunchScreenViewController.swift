//
//  LaunchScreenViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    // MARK: - Outlet
    
    
    @IBOutlet weak var gif_ImageView: UIImageView!
    
    // MARK: - Variable
    
   
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if UserDefaults.standard.value(forKey: "userData") != nil {
                           Switcher.afterLogin()
                       }else {
                       
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectSinInOrSignUpViewController") as! SelectSinInOrSignUpViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
                           
                       }
        
        
        // Do any additional setup after loading the view.
    }
   
//    override var prefersStatusBarHidden: Bool {
//        
//        if #available(iOS 13, *) {
//            
//             return false
//            
//        }else {
//        return false
//            
//        }
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //.... remove this animation 
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//          self.timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timeaction), userInfo: nil, repeats: false)
//
//         self.gif_ImageView.loadGif(name: "splash")
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // MARK: - Button  Action
    
    
    @objc func timeaction(){
        
        if UserDefaults.standard.value(forKey: "userData") != nil {
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
//
//            self.navigationController?.pushViewController(vc, animated: true)
            
            Switcher.afterLogin()
        }else {
        
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectSinInOrSignUpViewController") as! SelectSinInOrSignUpViewController
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        }
        
    
    
    
    
}
