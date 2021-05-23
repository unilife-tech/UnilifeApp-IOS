//
//  TopNavigation.swift
//  Justdiidz
//
//  Created by developer on 16/03/18.
//  Copyright © 2018 ITworks. All rights reserved.
//

import UIKit

class TopNavigationClearColor: UIView {

    @IBOutlet weak var lbl_title:UILabel?
    @IBOutlet weak var btnBack:UIButton?
    @IBOutlet weak var navigationBar_height_layout: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        self.lbl_title?.textColor = UIColor.white
      //  self.lbl_title?.font = UIFont(name: "MyriadPro-bold", size: 18)
        if(kDeviceType == "x")
        {
            navigationBar_height_layout.constant = 85
            // lbl_title?.font = knavigationBarFont
            
        }else if(kDeviceType == "ipad")
        {
           navigationBar_height_layout.constant = 85
           // lbl_title?.font = knavigationBarFontIPAD
            
        }else
        {
            // lbl_title?.font = knavigationBarFont
            
        }
        
        
       
    }
    
   

}
