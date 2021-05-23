//
//  ViewAllBlogViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewAllBlogViewController: UIViewController {
    
    // MARK: - outlet
    
    @IBOutlet weak var viewAllBlog_CollectionView: UICollectionView!
    
    // MARK: - Variable
    
    var viewAllBlogArray = [[String: AnyObject]]()
    
    var categoryId : Int = -11
    
    var isUserFromCategory : Bool = false
    
    var navigationTitle = ""
    
    var searchBlogData: SearchBlogs?
    
    var seacrhBlogName = ""
    
    var condition = ""
    
    var viewBlogData: Slider?
    
    var brandBlogData : [Blog1]?
    
    var viewallblogs: [Blog]?
    
    //  var showBlogData
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewAllBlog_CollectionView.delegate = self
        self.viewAllBlog_CollectionView.dataSource = self
        self.viewAllBlog_CollectionView.register(UINib(nibName: "ViewBlogs", bundle: nil), forCellWithReuseIdentifier: "ViewSavedBlogsCollectionViewCell")
        
    }
    
    deinit {
        
        print(#file)
        self.searchBlogData = nil
        self.viewallblogs = nil
        self.brandBlogData = nil
        self.viewBlogData = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(self.isUserFromCategory){
            self.ShowAllBlogCategories(categoryId: self.categoryId)
            
            self.navigationItem.largeTitleDisplayMode = .automatic
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: self.navigationTitle, titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
            
        }else if self.condition == "SearchBlog" {
            
            // self.navigationItem.largeTitleDisplayMode = .automatic
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: "Search Blogs Result ", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
            self.searchBlog(search: self.seacrhBlogName)
        }else if self.condition == "fromBrand" {
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: self.navigationTitle, titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
        }
        else if self.condition == "blogData" {
            self.addNavigationBar(left: .Back, titleType: .Normal, title: self.navigationTitle, titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.white, navigationBarStyle: .default, rightFunction: {})
            
        }else if self.condition == "viewAllCategory" {
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: "Category", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            
        }
            
        else{
            
            //self.navigationItem.largeTitleDisplayMode = .automatic
            
            self.addNavigationBar(left: .Back, titleType: .Normal, title: self.navigationTitle, titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
            self.allBlogListing()
            
            
        }
        
    }
    
    
}

extension ViewAllBlogViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.condition == "SearchBlog" {
            
            return self.searchBlogData?.count ?? 0
            
        }else if self.condition == "fromBrand"   {
            
            return brandBlogData?.count ?? 0
            
        }else if self.condition == "viewAllCategory" {
            
            return viewallblogs?.count ?? 0
        }
            
        else {
            
            return viewAllBlogArray.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.viewAllBlog_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewSavedBlogsCollectionViewCell", for: indexPath) as! ViewSavedBlogsCollectionViewCell
        
        if self.condition == "SearchBlog" {
            
            cell.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.searchBlogData?[indexPath.row].image ?? "")) , placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.blogDescription_lbl.text! = self.searchBlogData?[indexPath.row].title ?? ""
            
        } else if self.condition == "fromBrand" {
            
            cell.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.brandBlogData?[indexPath.row].categoriesBlog?.first?.image ?? "")), placeholderImage: UIImage(named: "noimage"))
            
            cell.blogDescription_lbl.text = self.brandBlogData?[indexPath.row].categoriesBlog?.first?.title ?? ""
            
        }else if self.condition == "viewAllCategory" {
            
            cell.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.viewallblogs?[indexPath.row].categoriesImage ?? "")), placeholderImage: UIImage(named: "noimage"))
            
            cell.blogDescription_lbl.text = self.viewallblogs?[indexPath.row].categoriesName ?? ""
            
        }
            
        else {
            
            cell.blog_ImageView.sd_setImage(with: URL(string: blogImageUrl + String(describing: (self.viewAllBlogArray[indexPath.row])["image"]!)), placeholderImage: UIImage(named: "noimage_icon"))
            
            cell.blogDescription_lbl.text! = String(describing: (self.viewAllBlogArray[indexPath.row])["title"]!)
            
        }
        
        cell.viewBlog_btn.isHidden = false
        
        cell.viewBlog_btn.tag = indexPath.row
        
        cell.viewBlog_btn.addTarget(self, action: #selector(self.tapViewAll_btn(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    // MARK: - Collection Table Cell
    
    @objc func tapViewAll_btn(_ sender: UIButton) {
        
        if self.condition == "SearchBlog" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
            
            vc.condition = "SearchBlog"
            
            vc.viewSearchBlogData = self.searchBlogData?[sender.tag]
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if self.condition == "viewAllCategory" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogsCategoryViewController") as! ViewAllBlogsCategoryViewController
            
            // vc.condition = "viewallBlogs"
            
            // vc.condition == "viewAllBlogsAccordingCategory"
            
            //          vc.offerData
            let dataa  = try? JSONEncoder().encode(self.viewallblogs?[sender.tag].categoriesBlog.self)
            
            if dataa != nil {
                let json = try? JSONSerialization.jsonObject(with: dataa!, options: [])
                
                let sliderData = try? JSONSerialization.data(withJSONObject: json as! [[String : AnyObject]], options: .prettyPrinted)
                
                let sliderStruct = try? JSONDecoder().decode([CategoriesBlog].self, from: sliderData!)
                
                vc.blogCategoriesData = self.viewallblogs?[sender.tag]
                
                vc.navigationTitle = self.viewallblogs?[sender.tag].categoriesName ?? ""
                
                //  print(sliderStruct)
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
            
            vc.condition = "blogs"
            
            do {
                
                let bc = try JSONSerialization.data(withJSONObject: (self.viewAllBlogArray[sender.tag]), options: .prettyPrinted)
                
                vc.blogsData = try newJSONDecoder().decode(Slider.self, from: bc)
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }catch {
                
                self.showDefaultAlert(Message: error.localizedDescription)
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.viewAllBlog_CollectionView.bounds.width / 2 - 10, height: 220)
    }
    
}

// MARK: - Service Response

extension ViewAllBlogViewController {
    
    func allBlogListing() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "view_all_latest_blog/\(UserData().userId)") { (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.viewAllBlogArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self.viewAllBlog_CollectionView.delegate = self
                    
                    self.viewAllBlog_CollectionView.dataSource = self
                    
                    self.viewAllBlog_CollectionView.reloadData()
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
    }
    
    func ShowAllBlogCategories(categoryId : Int) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"categories_id": categoryId] as [String : Any]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "show_blog_categories", params: param as [String: AnyObject]) { [weak self]
            (receviedData) in
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    if let blogData = ((((receviedData as? [String: AnyObject])?["data"] as? [[String: AnyObject]])?.first)?["categories_blog"]) as? [[String: AnyObject]] {
                        
                        self?.viewAllBlogArray = blogData
                        
                        self?.viewAllBlog_CollectionView.delegate = self
                        
                        self?.viewAllBlog_CollectionView.dataSource = self
                        
                        self?.viewAllBlog_CollectionView.reloadData()
                        
                    }
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
        }
    }
    
    // MARK: - Seacrh blog Data
    
    func searchBlog(search: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"search": search] as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "send_search_blog", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [[String: AnyObject]]else {
                        
                        return
                    }
                    
                    do {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self?.searchBlogData = try newJSONDecoder().decode(SearchBlogs?.self, from: jsonData)
                        
                        
                    }catch {
                        
                        print(error.localizedDescription)
                        
                        
                    }
                    
                    self?.viewAllBlog_CollectionView.reloadData()
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No Data found" )
                    
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No Data found" )
                
                
            }
            
            
        }
        
    }
    
}
