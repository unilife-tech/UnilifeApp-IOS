//
//  UIColor+Extesion.swift
//  WafiApps
//
//  Created by Museer Ansari on 01/07/2018.
//  Copyright © 2018 Museer Ansari. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    
    open class var unilifeblueDark: UIColor { get{
           return UIColor.colorWith(hexString: "1EB1ED")
           }}
    
    
   open class var unilifeButtonBlueColor: UIColor { get{
             return UIColor.colorWith(hexString: "0098da")
             }}
    
    open class var unilifeBorderColor: UIColor { get{
               return UIColor.colorWith(hexString: "ECECEC")
               }}
    
    
    open class var unilifeYesColor: UIColor { get{
                  return UIColor.colorWith(hexString: "01B0F1")
                  }}
//    open class var unilifeNoColor: UIColor { get{
//                  return UIColor.colorWith(hexString: "ff5454")
//                  }}
    
    
    
    open class var unilifeSwipeCloseColor: UIColor { get{
                  return UIColor.colorWith(hexString: "818181")
                  }}
    
    open class var unilifeSwipeRedDelete: UIColor { get{
                     return UIColor.colorWith(hexString: "FC5558")
                     }}
    
    open class var unilifeSwipeBlueEdit: UIColor { get{
                       return UIColor.colorWith(hexString: "0098da")
                       }}
    
    open class var unilifeAdminChatColor: UIColor { get{
                          return UIColor.colorWith(hexString: "808080")
                          }}
    
    open class var unilifeRemoveChatColor: UIColor { get{
                          return UIColor.colorWith(hexString: "763030")
                          }}
    
    open class var unilifegrayButtonInvite: UIColor { get{
                             return UIColor.colorWith(hexString: "585858")
                             }}
    

 
    
    class func colorWith(hexString: String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
