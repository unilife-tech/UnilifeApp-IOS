//
//  LikedBlogsViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class LikedBlogsViewController: UIViewController {
    
    // MARK: - oulet
    
    @IBOutlet weak var likedBlog_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var blogImageArray = [UIImage(named: "blog-1"), UIImage(named: "blog-2"), UIImage(named: "blog-3"), UIImage(named: "blog-4"),UIImage(named: "blog-5")]
    
    
    var blogNameArray = ["6 Tech gadget every college students must have", "How game of thrones should have ended", "Heathy living habbits for UniStudents", "How to prepare for next summer vacation", "9Cities you visit before you graduate from college"]
    
    var likeBlogArray = [[String: AnyObject]]()
    
    
    // MARK: - default View
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    deinit {
        print(#file)
        self.likeBlogArray = [[:]]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "View Liked Blogs", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.likedBlog_CollectionView.register(UINib(nibName: "ViewBlogs", bundle: nil), forCellWithReuseIdentifier: "ViewSavedBlogsCollectionViewCell")
        
        likedBlogs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
}

extension LikedBlogsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return likeBlogArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.likedBlog_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewSavedBlogsCollectionViewCell", for: indexPath) as! ViewSavedBlogsCollectionViewCell
        
        cell.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + String(describing: ((self.likeBlogArray[indexPath.row])["blog_user_like"] as! [String: AnyObject])["image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.blogDescription_lbl.text! = String(describing: ((self.likeBlogArray[indexPath.row])["blog_user_like"] as! [String: AnyObject])["description"]!)
        
        cell.viewBlog_btn.tag = indexPath.row
        
        cell.viewBlog_btn.addTarget(self, action: #selector(tapViewLikeBlog_btn(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.likedBlog_CollectionView.bounds.width / 2 - 10, height: 220)
    }

    // MARK: - Button Action
    
    @objc func tapViewLikeBlog_btn(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
        
        vc.condition = "blogs"
        
        do {
            
            let bc = try JSONSerialization.data(withJSONObject: ((self.likeBlogArray[sender.tag])["blog_user_like"] as! [String: AnyObject]
                ), options: .prettyPrinted)
            
            vc.blogsData = try newJSONDecoder().decode(Slider.self, from: bc)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }catch {
            
            self.showDefaultAlert(Message: error.localizedDescription)
            
        }
        
    }
    
}

// MARK: - Service Response


extension LikedBlogsViewController {
    
    func likedBlogs() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "user_list_like_blog/\(UserData().userId)") {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                    self?.likeBlogArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    
                    self?.likedBlog_CollectionView.delegate = self
                    
                    self?.likedBlog_CollectionView.dataSource = self
                    
                    self?.likedBlog_CollectionView.reloadData()
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
                
            }else {
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
    }
}

