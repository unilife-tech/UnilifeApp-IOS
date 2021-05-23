//
//  setLabel.swift
//  IDOWAZ Driver
//
//  Created by Sourabh Mittal on 26/02/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class setLabel : UILabel{
    
    @IBInspectable
    open var LineSpace : CGFloat = 2 {
        didSet {
            self.UpdateLineSpace()
        }
    }
    
    
    func UpdateLineSpace(){
        
        let attributedString = NSMutableAttributedString(string: self.text!)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineSpacing = self.LineSpace
        

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
        
    }
}
