
//  SetImageViewImage.swift
//  IDOWAZ Restaurant
//
//  Created by Sourabh Mittal on 16/04/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import UIKit

@IBDesignable
class SetImage: UIImageView {
    
    @IBInspectable
    open var BorderColor:UIColor = UIColor.lightGray {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var BorderWidth:CGFloat = 0 {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var isCircle:Bool = false {
        didSet {
            self.UpdateBorder()
        }
    }
    
    @IBInspectable
    open var CornerRadius:CGFloat = 0 {
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
    
    override func layoutSubviews() {
        if isCircle {
            self.layer.cornerRadius = self.frame.size.width/2
            self.clipsToBounds = true
        }else {
            self.layer.cornerRadius = CornerRadius
        }
    }
    
    func UpdateBorder(){
        
        self.layer.borderWidth = BorderWidth
        self.layer.borderColor = BorderColor.cgColor
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
}
