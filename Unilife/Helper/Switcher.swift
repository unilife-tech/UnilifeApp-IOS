//
//  Switcher.swift
//  AZY Fetcher
//
//  Created by Apple on 01/08/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation
import UIKit

class Switcher  {
    
    private static var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
        
        print(status)
    
        if(status == true){
            rootVC = self.storyBoard.instantiateViewController(withIdentifier: "EventAndPostViewController") as! EventAndPostViewController
        }else{
            rootVC = self.storyBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
    static func afterLogin(){
        
        let rootVc = self.storyBoard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        let navVc = self.storyBoard.instantiateViewController(withIdentifier: "RootNavigationViewController") as! RootNavigationViewController
        
        navVc.viewControllers = [rootVc]
        
        UIApplication.shared.keyWindow?.rootViewController = navVc
        
    }
    
    
    static func clickOnChat(){
    
        let rootVc = self.storyBoard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        
//        let stVc1 = self.storyBoard.instantiateViewController(withIdentifier: "UnlifeChatViewController") as! UnlifeChatViewController
//        
//        let stVc2 = self.storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        
        rootVc.selectedIndex = 1
        
   // ((rootVc.viewControllers?[1] as? UINavigationController))?.viewControllers = [stVc1, stVc2]
        
      //  rootVc.selectedInde
        
        UIApplication.shared.keyWindow?.rootViewController = rootVc
        
    }
    
    static func clickOnPost(){
        
    let rootVc = self.storyBoard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        
     rootVc.selectedIndex = 0
        
     UIApplication.shared.keyWindow?.rootViewController = rootVc
       
    }
    
    static func clickOnBrand() {
        
        let rootVc = self.storyBoard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        
        rootVc.selectedIndex = 2
        
        UIApplication.shared.keyWindow?.rootViewController = rootVc
        
        
    }
    
    static func clickOnBlogs() {
        
        let rootVc = self.storyBoard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        
        rootVc.selectedIndex = 3
        
        UIApplication.shared.keyWindow?.rootViewController = rootVc
        
    }
    
    static func afterLogout(){
        
//        let rootVc = self.storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        let navVc = self.storyBoard.instantiateViewController(withIdentifier: "RootNavigationViewController") as! RootNavigationViewController
//
//        navVc.viewControllers = [rootVc]
//
//        UIApplication.shared.keyWindow?.rootViewController = navVc
        
    }
    
    static func friendRequest(){
        
        let rootVc = self.storyBoard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        
        let stVc1 = self.storyBoard.instantiateViewController(withIdentifier: "UnlifeChatViewController") as! UnlifeChatViewController
       // stVc1.condition = "RequestRecevied"
        
    let stVc2 = self.storyBoard.instantiateViewController(withIdentifier: "PendingRequestsViewController") as! PendingRequestsViewController
        
        rootVc.selectedIndex = 1
        
      ((rootVc.viewControllers?[1] as? UINavigationController))?.viewControllers = [stVc1, stVc2]
        
        //  rootVc.selectedInde
        
        UIApplication.shared.keyWindow?.rootViewController = rootVc
       
    }
    
    
    static func pushFromnavigationWindow(window : UIWindow) {
     
    }
    
    static func changeRoot(rootVc: UIViewController){
        
        let navVc = self.storyBoard.instantiateViewController(withIdentifier: "RootNavigationViewController") as! RootNavigationViewController
        
        navVc.viewControllers = [rootVc]
        
        UIApplication.shared.keyWindow?.rootViewController = navVc
        
    }
    
    static func changeRootToTabViewController(){
        
        let rootVc = self.storyBoard.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
        
        UIApplication.shared.keyWindow?.rootViewController = rootVc
        
    }
    
}
