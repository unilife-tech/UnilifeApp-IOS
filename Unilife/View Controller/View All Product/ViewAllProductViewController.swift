//
//  ViewAllProductViewController.swift
//  Unilife
//
//  Created by Apple on 30/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ViewAllProductViewController: UIViewController {
    
    // MARK: - outlet
    
    @IBOutlet weak var viewAllProduct_TableView: UITableView!
    
    // MARK: - Variable
    
    var controller = UIViewController()
    
    var blogCategoriesDetail : [Blog]?
    
    var condition = ""
    
    var brandCategoriesDetail : [Offer1]?
    var brandCategoriesDetail2 : NSArray = NSArray()
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewAllProduct_TableView.delegate = self
        
        self.viewAllProduct_TableView.dataSource = self
        
    }
    
    deinit {
        print(#file)
    }
    
    // MARK: - button Action
    
    
    @IBAction func tapViewAll_btn(_ sender: Any) {
        
        if condition != "Brand" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
            
            vc.condition = "viewAllCategory"
            
            vc.viewallblogs = self.blogCategoriesDetail
            
            self.controller.navigationController?.pushViewController(vc, animated: true)
            
            self.dismiss(animated: true, completion: nil)
            
        }else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsAccordingToCategoryViewController") as! ViewAllBrandsAccordingToCategoryViewController
            
            vc.allOfferData = self.brandCategoriesDetail
            vc.allOfferData2 = self.brandCategoriesDetail2
            self.controller.navigationController?.pushViewController(vc, animated: true)
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
}

extension ViewAllProductViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if condition != "Brand" {
        
        return self.blogCategoriesDetail?.count ?? 0
            
        }else {
            
        //return self.brandCategoriesDetail?.count ?? 0
            return self.brandCategoriesDetail2.count ?? 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.viewAllProduct_TableView.dequeueReusableCell(withIdentifier: "ViewAllProductTableViewCell") as! ViewAllProductTableViewCell
        
        if condition != "Brand" {
        
        cell.productName_lbl.text = self.blogCategoriesDetail?[indexPath.row].categoriesName ?? ""
        
        }else {
            let getDic:NSDictionary = self.brandCategoriesDetail2.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
            
          //cell.productName_lbl.text! = self.brandCategoriesDetail?[indexPath.row].name ?? ""
            cell.productName_lbl.text! = getDic.value(forKey: "category") as? String ?? ""
        }
        
        return  cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if condition != "Brand" {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
        
        vc.categoryId = self.blogCategoriesDetail?[indexPath.row].id ?? 0
        
        vc.isUserFromCategory = true
        
        vc.navigationTitle = self.blogCategoriesDetail?[indexPath.row].categoriesName ?? ""
        
        self.dismiss(animated: true, completion: nil)
        
        self.controller.navigationController?.pushViewController(vc, animated: true)
        
        } else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
            
            let getOBJ:NSDictionary = self.brandCategoriesDetail2.object(at: indexPath.row) as? NSDictionary ?? NSDictionary()
            // print(getOBJ)
             let getName = getOBJ.value(forKey: "category") as? String ?? ""
             let getid = getOBJ.value(forKey: "categories_id") as? String ?? ""
            
            
            vc.condition = "offers"
            
            vc.categories_id = getid//String(self.brandCategoriesDetail?[indexPath.row].id ?? 0)
            
            vc.navigationTitle = getName//self.brandCategoriesDetail?[indexPath.row].name ?? ""
            
            self.dismiss(animated: true, completion: nil)
            
            self.controller.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}
