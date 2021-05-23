//
//  UserData.swift
//  Unilife
//
//  Created by Apple on 05/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import Foundation

class UserData {
    
    var userData = [String: AnyObject]()
    
    init() {
        
        if UserDefaults.standard.value(forKey: "userData") != nil {
            
            self.userData = NSKeyedUnarchiver.unarchiveObject(with: (UserDefaults.standard.value(forKey: "userData"))as! Data) as! [String: AnyObject]
            
        }else {
            
            self.userData = [:]
        }
        
    }
    
    var userId: String {
        
        get {
            
            if (userData)["id"] as? String != nil {
                return (userData)["id"] as! String
            }else if (userData)["id"] as? Int != nil {
                return String(describing: (userData)["id"]!)
            }else {
                return ""
            }
        }
    }
    
    var name :String{
        
        get{
            if let userName = userData["username"] as? String{
                
                return userName
                
            }else{
                
                return ""
                
            }
        }
        
    }
    var mobileCode :String{
        
        get{
            if userData["country_code"] as? String != nil || userData["country_code"] as? Int != nil{
                
                return String(describing:  userData["country_code"]!)
                
            }else{
                
                return ""
                
            }
        }
        
    }
    
    var mobileNumber :String{
        
        get{
            if userData["mobile_no"] as? String != nil || userData["mobile_no"] as? Int != nil{
                
                return String(describing:  userData["mobile_no"]!)
                
            }else{
                
                return ""
                
            }
        }
        
    }
    var email :String{
        
        get{
            if let mail = userData["university_school_email"] as? String{
                
                return mail
                
            }else{
                
                return ""
                
            }
        }
        
    }
    
    
    var image :String{
        
        get{
            if let img = userData["profile_image"] as? String{
                
                return img.replacingOccurrences(of: " ", with: "")
                
            }else{
                
                return ""
                
            }
        }
        
    }
    
    var houseStreet :String{
        
        get{
            if let house_street = userData["house_street"] as? String{
                
                return house_street
                
            }else{
                
                return ""
                
            }
        }
        
    }
    
    var address :String{
        
        get{
            if let addrs = userData["address"] as? String{
                
                return addrs
                
            }else{
                
                return ""
                
            }
        }
        
    }
    
    var latitude :String{
        
        get{
            if userData["latitude"] as? String != nil || userData["latitude"] as? Double != nil{
                
                return String(describing:  userData["latitude"]!)
                
            }else{
                
                return ""
                
            }
        }
        
    }
    
    var longitude :String{
        
        get{
            if userData["longitude"] as? String != nil || userData["longitude"] as? Double != nil{
                
                return String(describing:  userData["longitude"]!)
                
            }else{
                
                return ""
                
            }
        }
        
    }
    var cardNumber :String{
        
        get{
            if userData["card_no"] as? String != nil || userData["card_no"] as? Int != nil{
                
                return String(describing:  userData["card_no"]!)
                
            }else{
                
                return ""
                
            }
        }
        
    }
    var cardHolderName :String{
        
        get{
            if let cardName = userData["card_holder_name"] as? String{
                
                return cardName
                
            }else{
                
                return ""
                
            }
        }
        
    }
    var user_type :String{
        
        get{
            if userData["user_type"] as? String != nil || userData["user_type"] as? Int != nil{
                
                return String(describing:  userData["user_type"]!)
                
            }else{
                
                return ""
                
            }
        }
        
    }
    var expiryDate :String{
        
        get{
            if let date = userData["mm_yy"] as? String{
                
                return date
                
            }else{
                
                return ""
                
            }
        }
        
    }
    
    
}

