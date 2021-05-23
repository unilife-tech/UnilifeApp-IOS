//
//  Singleton.swift
//  Unilife
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import Foundation
import UIKit

class Singleton {
    
    static let sharedInstance = Singleton()
    
    var connection = webservices()
    
    var universityName: String?
    
    var loginAsType = ""
    
    init() {
        
    }
    
    
    
    func checkDevices(){
        if UI_USER_INTERFACE_IDIOM() == .phone {
            let screenSize: CGSize = UIScreen.main.bounds.size
             //print(screenSize)
            if screenSize.height == 480 {
                kDeviceType = "4"
            }else if screenSize.height == 568 {
                kDeviceType = "5"
            }else if screenSize.height == 667 {
                kDeviceType = "6"
            }else if screenSize.height == 736 {
                kDeviceType = "+"
            }else if screenSize.height >= 812 {
                kDeviceType = "x"
            }
            else{
                kDeviceType = ""
            }
        }else{
            kDeviceType = "ipad"
        }
    }
    
    
    func customAlert(getMSG:String)
       {
         let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        let alert = UIAlertController(title: "Unilife", message: getMSG, preferredStyle: UIAlertController.Style.alert)
              //         alert.setValue(NSAttributedString(title: ""!, attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Regular", size: 14) as Any,NSAttributedStringKey.foregroundColor : UIColor(red: 168/255, green: 12/255, blue: 94/255, alpha: 1.0)]), forKey: "attributedTitle")
              alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              //        alert.addAction(title: "Ok".UIColor(red: 168/255, green: 12/255, blue: 94/255, alpha: 1.0))
              alert.view.tintColor = UIColor.appSkyBlue
              //self.present(alert, animated: true, completion: nil)
        appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
 
    
}





