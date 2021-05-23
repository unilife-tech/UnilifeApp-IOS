//
//  CircleImage.swift
//  E-Patient
//
//  Created by Akash Gupta on 5/22/17.
//  Copyright © 2017 Promatics. All rights reserved.
//

import UIKit


class CircleImage: UIImageView {
    
    @IBInspectable
    open var bColor:UIColor? {
        didSet {
            self.updateBorder()
        }
    }
    
    @IBInspectable
    open var bWidth:CGFloat = 2 {
        didSet {
            
             self.updateBorder()
        }
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.size.width / 2
        
        self.clipsToBounds = true
        
    }
    
   func updateBorder(){
    
    if bColor != nil {
        
        self.layer.borderWidth = bWidth
        
        self.layer.borderColor = bColor?.cgColor
        
    }
    }
}
