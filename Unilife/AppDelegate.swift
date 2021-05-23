//
//  AppDelegate.swift
//  Unilife
//
//  Created by promatics on 21/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Firebase
import UserNotifications
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var nav: UINavigationController!
    let storyBorad = UIStoryboard(name: "Main", bundle: nil)
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       // Thread.sleep(forTimeInterval: 3.0)
       // print("Application Launched")
        internerConnectionInit()
        Singleton.sharedInstance.checkDevices()
        IQKeyboardManager.shared.disabledToolbarClasses = [CommentVC.self]
        IQKeyboardManager.shared.disabledTouchResignedClasses = [CommentVC.self]
        
        
       
        GMSServices.provideAPIKey("AIzaSyBeCVFvwFvaICi3gt-B7bRJUBXeBNfunFs")
        
        IQKeyboardManager.shared.enable = true
        
        GMSPlacesClient.provideAPIKey("AIzaSyBeCVFvwFvaICi3gt-B7bRJUBXeBNfunFs")
        
        UserDefaults.standard.set(UIDevice.current.identifierForVendor!.uuidString, forKey: "deviceId")
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        fcmConfiguration(application)
        
        
        let osVersion = ProcessInfo().operatingSystemVersion.majorVersion
                     if(osVersion >= 13)
                     {
                                //IQKeyboardManager.shared.toolbarTintColor = UIColor.white
                         if #available(iOS 13.0, *) {
                                         window?.overrideUserInterfaceStyle = .light
                             
                                    } else {
                                        // Fallback on earlier versions
                                    }
                     }
        
        
        
           
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if ((notification.request.content.userInfo as! [String: AnyObject])["gcm.notification.type"] as? String ?? "") == "Chat"{
            
            //            completionHandler([.alert,.badge,UNNotificationPresentationOptions.sound])
            
            //            NotificationCenter.default.post(name: Notification.Name("ChatNotification"), object: nil, userInfo: nil)
            
            
        }else {
            
            completionHandler([.alert,.badge,UNNotificationPresentationOptions.sound])
        }
        
    }
    
    @available(iOS 10.0, *)
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response.notification.request.content.body )
        print(response.notification.request.content.categoryIdentifier)
        
        print(response.notification.request.content)
        
        if ((response.notification.request.content.userInfo as! [String : AnyObject])["gcm.notification.type"] as? String ?? "") == "Chat"{
            
            NotificationCenter.default.post(name: Notification.Name("ChatNotification"), object: nil, userInfo: nil)
            
            Switcher.clickOnChat()
            
        }else if   ((response.notification.request.content.userInfo as! [String : AnyObject])["gcm.notification.type"] as? String ?? "") == "Post"{
            
            Switcher.clickOnPost()
            
        }else if ((response.notification.request.content.userInfo as! [String : AnyObject])["gcm.notification.type"] as? String ?? "") == "Offer"{
            
            Switcher.clickOnBrand()
            
            
        }else if ((response.notification.request.content.userInfo as! [String : AnyObject])["gcm.notification.type"] as? String ?? "")  == "Blog"{
            
            Switcher.clickOnBlogs()
            
            
        }else if ((response.notification.request.content.userInfo as! [String : AnyObject])["gcm.notification.type"] as? String ?? "") == "Friend Request" {
            
            Switcher.friendRequest()
            
        }else if ((response.notification.request.content.userInfo as! [String : AnyObject])["gcm.notification.type"] as? String ?? "") == "Accept Request" ||  ((response.notification.request.content.userInfo as! [String : AnyObject])["gcm.notification.type"] as? String ?? "") == "Group" || ((response.notification.request.content.userInfo as! [String : AnyObject])["gcm.notification.type"] as? String ?? "") == "Reject Request" {
            
            Switcher.clickOnChat()
            
            
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print(userInfo)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        print("Resgin From Active")
        
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("Enter Background")
        
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        print("Enter ForeGround")
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        print("become Active")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        print("Application Terminate")
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        let token = Messaging.messaging().fcmToken
        
        print(token)
        
        UserDefaults.standard.set(token, forKey: "fcmToken")
        
        
    }
    
    
    func fcmConfiguration(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        
    }
    
    
    func internerConnectionInit(){
            NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
            Reach().monitorReachabilityChanges()
        }
        
       
       
        @objc func networkStatusChanged(_ notification: Notification) {
            let userInfo = (notification as NSNotification).userInfo
            
            let getstatus = userInfo!["Status"] as! String
            if(getstatus == "Offline"){
                
            }else{
                
            }
        }
       
    
}

extension AppDelegate {
    static var visibleViewController: UIViewController? {
        var currentVc = UIApplication.shared.keyWindow?.rootViewController
        
        while let presentedVc = currentVc?.presentedViewController {
            if let navVc = (presentedVc as? UINavigationController)?.viewControllers.last {
                currentVc = navVc
            } else if let tabVc = (presentedVc as? UITabBarController)?.selectedViewController {
                currentVc = tabVc
            } else {
                currentVc = presentedVc
            }
        }
        
        if let rootNav = (currentVc as? UINavigationController){
            
            if let taBarNav = (rootNav.visibleViewController as? UITabBarController)?.selectedViewController as? UINavigationController{
                
                return taBarNav.visibleViewController
                
                
            }else{
                
                return rootNav.visibleViewController
            }
            
        }
        
        return currentVc
    }
}

