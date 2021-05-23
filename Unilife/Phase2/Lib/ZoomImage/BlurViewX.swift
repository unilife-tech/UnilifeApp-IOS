//
//  BluredViewX.swift
//  BluredViewX
//
//  Created by Mohammed Altoobi on 4/15/18.
//  Copyright © 2018 Mohammed Altoobi. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    func blurViewX() {
        //  Blur out the current view
        let blurView = UIVisualEffectView(frame: self.view.frame)
        self.view.addSubview(blurView)
        UIView.animate(withDuration:0.25) {
            blurView.alpha = 1
            blurView.effect = UIBlurEffect(style: .dark)
        }
        
//        //dismiss blur and card tapping anywhere using func animateOut!
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VenueDetailVC.animateOut))
//        blurView.isUserInteractionEnabled = true
//        blurView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func unblurViewX() {
        
        for childView in view.subviews {
            guard let effectView = childView as? UIVisualEffectView else { continue }
            UIView.animate(withDuration: 0.25, animations: {
                effectView.effect = nil
            }) {
                didFinish in
                effectView.removeFromSuperview()
            }
        }
    }
}
