//
//  File.swift
//  SimpleChatFirebase
//
//  Created by lhouch mohamed on 2/3/20.
//  Copyright © 2020 Mohamed Lhouch. All rights reserved.
//

import UIKit


class ContactModel: NSObject {

    var name: String?
    var phone: String?
    var type: Int?
    var id: String?

    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
        self.type = dictionary["type"] as? Int ?? 0
        self.id = dictionary["id"] as? String ?? ""
        
        
        
    }
    
    
    
}
