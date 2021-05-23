//
//  ViewSavedMultiMediaViewController.swift
//  Unilife
//
//  Created by Apple on 28/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewSavedMultiMediaViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var audio_btn: UIButton!
    
    @IBOutlet weak var video_btn: UIButton!
    
    @IBOutlet weak var image_btn: UIButton!
    
    @IBOutlet weak var document_btn: UIButton!
    
    // MARK: - Variable
    var type = ""
    var user_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
          self.navigationItem.largeTitleDisplayMode = .automatic
    
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "View Saved Multimedia", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Button Action
    
    
    @IBAction func tapAudio_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AudioListingViewController") as! AudioListingViewController
        
        vc.type = self.type
        vc.user_id = self.user_id
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func tapVideo_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowVideoAndImagesInMultimediaViewController") as! ShowVideoAndImagesInMultimediaViewController
        
        vc.mediaType = ""
        vc.type = self.type
        vc.user_id = self.user_id
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    @IBAction func tapImage_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowVideoAndImagesInMultimediaViewController") as! ShowVideoAndImagesInMultimediaViewController
        vc.mediaType = "image"
        vc.type = self.type
        vc.user_id = self.user_id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tapDocument_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowVideoAndImagesInMultimediaViewController") as! ShowVideoAndImagesInMultimediaViewController
        vc.mediaType = "document"
        vc.type = self.type
        vc.user_id = self.user_id
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
