//
//  DarkShadowView.swift
//  Finaureus
//
//  Created by developer on 27/03/19.
//  Copyright © 2019 Finaureus. All rights reserved.
//

import UIKit

class DarkShadowView: UIView {

    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
    
    override func awakeFromNib() {
        
    }

}
