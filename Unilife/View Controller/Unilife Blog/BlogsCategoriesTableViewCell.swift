//
//  BlogsCategoriesTableViewCell.swift
//  Unilife
//
//  Created by Apple on 27/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class BlogsCategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var blogsCategoriesCell_TableView: UITableView!
    
    @IBOutlet weak var blogCategoriesTableView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var categoriesHeader_View: UIView!
    
    @IBOutlet weak var categoriesName_lbl: UILabel!
    
    @IBOutlet weak var categoriesView_btn: SetButton!
    
    //MARK:- Outlet's
    
    var BlogCategoryData : [Blog]? {
        didSet{
            self.setData()
        }
    }
    
    var showAllCategoriesOpen: Bool = true
    
    var limit: Int = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.blogsCategoriesCell_TableView.delegate = self
        
        self.blogsCategoriesCell_TableView.dataSource = self
        
        self.blogsCategoriesCell_TableView.tableHeaderView = categoriesHeader_View
        
        self.blogsCategoriesCell_TableView.register(UINib(nibName: "categoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableViewCellTableViewCell")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK:- Set Data
    
    func setData() {
        
        if((self.BlogCategoryData?.count ?? 0) > self.limit){
            
            if(self.showAllCategoriesOpen){
                
                self.blogCategoriesTableView_Height.constant = CGFloat(130 * (self.BlogCategoryData?.count ?? 0))
                
            }else{
                
                self.blogCategoriesTableView_Height.constant = CGFloat(130 * self.limit)
                
            }
            
        }else{
            
            self.blogCategoriesTableView_Height.constant = CGFloat(130 * (self.BlogCategoryData?.count ?? 0))
        }
        
        self.blogsCategoriesCell_TableView.reloadData()
    }
    
}

extension BlogsCategoriesTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if((self.BlogCategoryData?.count ?? 0) > self.limit){
            
            if(self.showAllCategoriesOpen){
                
                return self.BlogCategoryData?.count ?? 0
                
            }else{
                
                return self.limit
                
            }
            
        }else{
            
            return self.BlogCategoryData?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.blogsCategoriesCell_TableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCellTableViewCell") as! CategoriesTableViewCellTableViewCell
        
        cell.categoryName_lbl.text = self.BlogCategoryData?[indexPath.row].categoriesName ?? ""
        
        cell.categoryImage_ImgView.sd_setImage(with: URL(string: blogImageUrl + (self.BlogCategoryData?[indexPath.row].categoriesImage ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.viewContainingController()?.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
        vc.navigationTitle = self.BlogCategoryData?[indexPath.row].categoriesName ?? ""
        vc.isUserFromCategory = true
        vc.categoryId = self.BlogCategoryData?[indexPath.row].id ?? -11
        self.viewContainingController()?.navigationController?.pushViewController(vc
            , animated: true)
        
    }
    
}

extension BlogsCategoriesTableViewCell: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}




