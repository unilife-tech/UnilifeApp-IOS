//
//  setTextField.swift
//  IDOWAZ Driver
//
//  Created by Sourabh Mittal on 20/02/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SetTextFiled: UITextField, UITextFieldDelegate {
    
    @IBInspectable
    open var LeftPadding:CGFloat = 0 {
        didSet {
            self.setLeftPaddingPoints1(LeftPadding)
        }
    }
    
    @IBInspectable
    open var RightPadding:CGFloat = 0 {
        didSet {
            self.setLeftPaddingPoints1(RightPadding)
        }
    }
    
    
    @IBInspectable
    open var BorderColor:UIColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0) {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var BorderWidth:CGFloat = 0.5 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var CornerRadius:CGFloat = 5 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var EnableShadow:Bool = false {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowColor:UIColor = UIColor.lightGray {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowRadius:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOpacity:Float = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetX:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var ShadowOffsetY:CGFloat = 0 {
        didSet {
            self.SetShadow()
        }
    }
    
    @IBInspectable
    open var BounceButton:Bool = false{
        didSet {
            
        }
    }
    
    func UpdateBorder(){
        
        self.layer.borderWidth = BorderWidth
        self.layer.borderColor = BorderColor.cgColor
        self.layer.cornerRadius = CornerRadius
        self.layer.masksToBounds = true
        
    }
    
    func SetShadow(){
        
        if EnableShadow {
            self.layer.masksToBounds = false
            self.layer.shadowColor = ShadowColor.cgColor
            self.layer.shadowOpacity = ShadowOpacity
            self.layer.shadowOffset = CGSize(width: ShadowOffsetX, height: ShadowOffsetY)
            self.layer.shadowRadius = ShadowRadius
        }
        
    }
    
    
    
    
    func setLeftPaddingPoints1(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints1(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}


extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
}
