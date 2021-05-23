//
//  OpenFullImageViewController.swift
//  Unilife
//
//  Created by Apple on 06/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class OpenFullImageViewController: UIViewController, EFImageViewZoomDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var product_ImageView: EFImageViewZoom!
    
    @IBOutlet weak var postVideo: AvpVideoPlayer!
    
    // MARK: - Variable
    
    var productImageUrl = ""
    
    var condition = ""
    
    var videoUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        product_ImageView._delegate = self
        product_ImageView.contentMode = .left
        
        if condition == "video" {
            
        self.postVideo.isHidden = false
            
        self.product_ImageView.isHidden = true
            
        self.postVideo.configure(url: videoUrl)
            
        self.postVideo.isLoop = false
            
        self.postVideo.play()
            
        }else {
            
            self.postVideo.isHidden = true
            
            self.product_ImageView.isHidden = false

        self.product_ImageView.imageView.sd_setImage(with: URL(string: self.productImageUrl), placeholderImage: UIImage(named: "noimage_icon"))
            
        }
    }
    
    
    
    
    @IBAction func tapCross_btn(_ sender: Any) {
        
    self.dismiss(animated: true, completion: nil)
    }
    
    

    

}
