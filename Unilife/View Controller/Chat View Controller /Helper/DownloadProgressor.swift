//
//  DownloadProgressor.swift
//  Unilife
//
//  Created by Apple on 11/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import Foundation
import UIKit

open class DownloadProgressor {
    
    var containerView = UIView()
    
    var progressView = UIProgressView()
    
    open class var shared: DownloadProgressor {
        
        struct Static {
            
            static let instance: DownloadProgressor = DownloadProgressor()
            
        }
        
        return Static.instance
        
    }
    
    var progressValue : Double = 0 {
        didSet{
            self.progressView.progress = Float(progressValue)
        }
    }
    
    open func showProgressView(_ view: UIView) {
        
        view.endEditing(true)
        
        containerView.frame = view.frame
        
        containerView.frame.origin = CGPoint(x: 0, y: 0)
        
        containerView.backgroundColor = UIColor.appSkyBlue.withAlphaComponent(0.2)
        
        progressView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width - 40, height: 10)
        
        progressView.center = containerView.center
        
        progressView.backgroundColor = UIColor.appLightGreyColor
        
        containerView.addSubview(progressView)
        
        view.addSubview(containerView)
        
    }
    
    open func hideProgressView() {
        
        progressView.progress = 0
        containerView.removeFromSuperview()
        
    }
}
