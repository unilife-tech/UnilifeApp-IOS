//
//  ViewAllBlogsCategoryViewController.swift
//  Unilife
//
//  Created by Apple on 02/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewAllBlogsCategoryViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet weak var viewAllblogsCategory_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
     var navigationTitle = ""
    
    var blogCategoriesData : Blog?
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    self.viewAllblogsCategory_CollectionView.delegate = self
        
    self.viewAllblogsCategory_CollectionView.dataSource = self
        
 self.viewAllblogsCategory_CollectionView.register(UINib(nibName: "ViewBlogs", bundle: nil), forCellWithReuseIdentifier: "ViewSavedBlogsCollectionViewCell")

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
         self.addNavigationBar(left: .Back, titleType: .Normal, title: self.navigationTitle, titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
    }
 
}

extension ViewAllBlogsCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.blogCategoriesData?.categoriesBlog?.count ?? 0
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
        let cell = self.viewAllblogsCategory_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewSavedBlogsCollectionViewCell", for: indexPath) as! ViewSavedBlogsCollectionViewCell
        
        cell.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.blogCategoriesData?.categoriesBlog?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
       cell.blogDescription_lbl.text! = self.blogCategoriesData?.categoriesBlog?[indexPath.row].title ?? ""
        
        cell.viewBlog_btn.tag = indexPath.row
        cell.viewBlog_btn.addTarget(self, action: #selector(tapViewblog_btn(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print(self.viewAllblogsCategory_CollectionView.bounds)
        
        print(self.viewAllblogsCategory_CollectionView.frame)
        
        return CGSize(width: self.viewAllblogsCategory_CollectionView.bounds.width / 2 - 10, height: 220)
       
        
    }
    
    // MARK: - button Action
    
    @objc func tapViewblog_btn(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
        
        vc.condition = "blogs"
        
        vc.blogsData = self.blogCategoriesData?.categoriesBlog?[sender.tag]
        
        vc.navigationTitle = self.blogCategoriesData?.categoriesName ?? ""
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
   
}
