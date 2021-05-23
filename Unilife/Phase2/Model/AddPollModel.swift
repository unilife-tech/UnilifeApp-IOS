//
//  File.swift
//  SimpleChatFirebase
//
//  Created by lhouch mohamed on 2/3/20.
//  Copyright © 2020 Mohamed Lhouch. All rights reserved.
//

import UIKit


class AddPollModel: NSObject {

    var optionName: String?

    
    init(dictionary: [String: Any]) {
        self.optionName = dictionary["optionName"] as? String ?? ""
        
        
        
    }
    
    
    
}
