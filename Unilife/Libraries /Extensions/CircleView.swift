//
//  CircleView.swift
//  E-Patient
//
//  Created by Akash Gupta on 5/24/17.
//  Copyright © 2017 Promatics. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = self.frame.size.width / 2
        
        self.clipsToBounds = true
    }
}
