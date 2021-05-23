//
//  ChatFilePickerViewController.swift
//  Unilife
//
//  Created by Apple on 15/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ChatFilePickerViewController: UIViewController {
    
    @IBOutlet weak var imageView: SOXPanRotateZoomImageView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var videoViewer: AvpVideoPlayer!
    
    // MARK: - Variable
    
    var fileType = ""
    var filePath = ""
    var fileData:Data?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if filePath != ""{
            
            let fileUrl = self.filePath.replacingOccurrences(of: " ", with: "%20")
            
            let url : URL = URL(string: chatUrl + fileUrl)!
            
            if(self.fileType == "img"){
                
                self.webView.isHidden = true
                self.videoViewer.isHidden = true
                self.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "image"))
                
            }else if(self.fileType == "doc"){
                
                self.imageView.isHidden = true
                self.videoViewer.isHidden = true
                webView.loadRequest(URLRequest(url: url))
                
            }else if(self.fileType == "vid"){
                
                self.imageView.isHidden = true
                self.webView.isHidden = true
                self.videoViewer.configure(url: chatUrl + fileUrl)
                self.videoViewer.isLoop = true
                self.videoViewer.play()
                
            }
            
        }
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tappedMe))
                             imageView.isUserInteractionEnabled = true
                             imageView.addGestureRecognizer(tapGestureRecognizer)
                             
                             
                             
    
    }
    
    @objc func tappedMe()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
         self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    @IBAction func tapcViewDismissButton(_ sender: Any) {
        
  //  self.dismiss(animated: true, completion: nil)
        
        self.navigationController?.popViewController(animated: true)
     
    }
}
