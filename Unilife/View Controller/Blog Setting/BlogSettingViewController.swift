//
//  BlogSettingViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class BlogSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.appSkyBlue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    
      self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Blog Settings", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
         self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    
    self.tabBarController?.tabBar.isHidden = false
        
    }
    
    // MARK: - Button Action
    
    
    @IBAction func viewSavedBlogs_btn(_ sender: Any) {
        
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewSavedBlogsViewController") as! ViewSavedBlogsViewController
        
    self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    
    @IBAction func tapSavedReadBlog_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReadBlogsViewController") as! ReadBlogsViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func tapLikeBlog_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikedBlogsViewController") as! LikedBlogsViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func tapViewSharedBlog_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewSharedBlogViewController") as! ViewSharedBlogViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
}
