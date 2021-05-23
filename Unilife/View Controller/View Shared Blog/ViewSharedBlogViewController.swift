//
//  ViewSharedBlogViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewSharedBlogViewController: UIViewController {

    @IBOutlet weak var viewShared_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var blogImageArray = [UIImage(named: "blog-1"), UIImage(named: "blog-2"), UIImage(named: "blog-3"), UIImage(named: "blog-4"),UIImage(named: "blog-5")]
    
    
    var blogNameArray = ["6 Tech gadget every college students must have", "How game of thrones should have ended", "Heathy living habbits for UniStudents", "How to prepare for next summer vacation", "9Cities you visit before you graduate from college"]
    
    var blogSharedList = [[String: AnyObject]]()
    
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    var nav: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewShared_CollectionView.delegate = self
        
        self.viewShared_CollectionView.dataSource = self
        
        self.viewShared_CollectionView.register(UINib(nibName: "ViewBlogs", bundle: nil), forCellWithReuseIdentifier: "ViewSavedBlogsCollectionViewCell")
        
        
    }
    
    deinit {
        print(#file)
        
        self.blogSharedList = [[:]]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "View Shared Blogs", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        sharedBlogList()
        
         self.tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension ViewSharedBlogViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return blogSharedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.viewShared_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewSavedBlogsCollectionViewCell", for: indexPath) as! ViewSavedBlogsCollectionViewCell
        
       
        cell.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + String(describing: ((self.blogSharedList[indexPath.row])["blog_user_shared"] as! [String: AnyObject])["image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
        
        cell.blogDescription_lbl.text = String(describing: ((self.blogSharedList[indexPath.row])["blog_user_shared"] as! [String: AnyObject])["description"]!)
        
        cell.viewBlog_btn.tag = indexPath.row
        
        cell.viewBlog_btn.addTarget(self, action: #selector(tapViewAll_btn(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
//
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.viewShared_CollectionView.bounds.width / 2 - 10, height: 220)
    }
    
    @objc func tapViewAll_btn(_ sender: UIButton) {
        
        let vc = self.storyBoard.instantiateViewController(withIdentifier: "BlogDetailViewController")as! BlogDetailViewController
        
        do {
            
            let bc = try JSONSerialization.data(withJSONObject: (self.blogSharedList[sender.tag])["blog_user_shared"] as! [String: AnyObject], options: .prettyPrinted)
            
            vc.blogsData = try newJSONDecoder().decode(Slider.self, from: bc)
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }catch {
            
            self.showDefaultAlert(Message: error.localizedDescription)
        }
        
    }
    
    
}

// MARK: - Service Response
extension ViewSharedBlogViewController{
    
    
    func sharedBlogList() {
    
    Indicator.shared.showProgressView(self.view)
    
    Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "user_list_shared_blog/\(UserData().userId)") {[weak self] (receviedData) in
    
    print(receviedData)
    
    Indicator.shared.hideProgressView()
    
    if Singleton.sharedInstance.connection.responseCode == 1 {
    
    if receviedData["response"] as? Bool == true {
    
    self?.blogSharedList = receviedData["data"] as! [[String: AnyObject]]
    
        self?.viewShared_CollectionView.reloadData()
    
    }else {
    
    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
    
    }
    
    }else {
    
    self?.showDefaultAlert(Message: receviedData["Error"] as! String)
    
    }
    
    
    }
    }
}
