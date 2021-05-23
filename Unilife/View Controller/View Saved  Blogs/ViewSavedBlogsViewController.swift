//
//  ViewSavedBlogsViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewSavedBlogsViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var viewBlog_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var blogImageArray = [UIImage(named: "blog-1"), UIImage(named: "blog-2"), UIImage(named: "blog-3"), UIImage(named: "blog-4"),UIImage(named: "blog-5")]
    
    
    var blogNameArray = ["6 Tech gadget every college students must have", "How game of thrones should have ended", "Heathy living habbits for UniStudents", "How to prepare for next summer vacation", "9Cities you visit before you graduate from college"]
    
    var blogSavedArray = [[String: AnyObject]]()
    
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    var nav: UINavigationController!
    
    var controllerName = ""
    
    // MARK: - default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewBlog_CollectionView.delegate = self
        
        self.viewBlog_CollectionView.dataSource = self
        
        self.viewBlog_CollectionView.register(UINib(nibName: "ViewBlogs", bundle: nil), forCellWithReuseIdentifier: "ViewSavedBlogsCollectionViewCell")
        
    }
    
    deinit {
        print(#file)
        self.blogSavedArray = [[:]]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "View Saved Blogs", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        savedBlog()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension ViewSavedBlogsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.blogSavedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.viewBlog_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewSavedBlogsCollectionViewCell", for: indexPath) as! ViewSavedBlogsCollectionViewCell
        
        
        cell.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + String(describing: ((self.blogSavedArray[indexPath.row])["blog_user_saved"] as! [String: AnyObject])["image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.blogDescription_lbl.text = String(describing: ((self.blogSavedArray[indexPath.row])["blog_user_saved"] as! [String: AnyObject])["description"]!)
        
        
        cell.viewBlog_btn.tag = indexPath.row
        
        cell.viewBlog_btn.addTarget(self, action: #selector(tapViewAll_btn(_:)), for: .touchUpInside)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.viewBlog_CollectionView.bounds.width / 2 - 10, height: 220)
    }
    
    @objc func tapViewAll_btn(_ sender: UIButton) {

        let vc = self.storyBoard.instantiateViewController(withIdentifier: "BlogDetailViewController")as! BlogDetailViewController
        
        do {
            
            let bc = try JSONSerialization.data(withJSONObject: (self.blogSavedArray[sender.tag])["blog_user_saved"] as! [String: AnyObject], options: .prettyPrinted)
            
            vc.blogsData = try newJSONDecoder().decode(Slider.self, from: bc)
            
            self.navigationController?.pushViewController(vc, animated: true)

        }catch {
            
            self.showDefaultAlert(Message: error.localizedDescription)
        }

    }

}

// MARK: - Service Response

extension ViewSavedBlogsViewController {
    
    func savedBlog() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "user_list_saved_blog/\(UserData().userId)") {[weak self] (receviedData) in
           
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                   
                    
                    self.blogSavedArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self.viewBlog_CollectionView.reloadData()
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
            
        }
    }
    
}
