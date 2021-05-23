//
//  AppDefaultTextField.swift
//  BubbleBud
//
//  Created by Sourabh Mittal on 25/06/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation
import  UIKit

class AppDefaultTextField: SkyFloatingLabelTextFieldWithIcon {
    
    convenience public override init(frame: CGRect) {
        self.init(frame: frame)
        self.addDefaultDesign()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addDefaultDesign()
    }
    
    func addDefaultDesign() {
        
        self.placeholderColor = UIColor.appDarKGray
        
        self.textColor = UIColor.appSkyBlue
        self.selectedLineColor = UIColor.appDarKGray
        
        
        self.titleColor = UIColor.clear
       self.selectedTitleColor = UIColor.clear
        
//        self.rightPaddingForTitle = 4
//        self.leftPaddingForTitle = 4
        
//        self.rightPaddingForTextAndPlaceholder = 4
//        self.leftPaddingForTextAndPlaceholder = 4
        
        self.selectedLineHeight = 1
        self.lineHeight = 0.5
        
        self.bottomPaddingToLine = 4

    }
    
}
