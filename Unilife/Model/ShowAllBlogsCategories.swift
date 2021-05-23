//
//  ShowAllBlogsCategories.swift
//  Unilife
//
//  Created by promatics on 15/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import Foundation

struct AllBlogsCategories {
    var blogsList = [BlogsData]()
    
    init(_ data:[String:AnyObject]) {
        if let newData = data["data"] as? [[String:AnyObject]]{
            for items in newData{
                self.blogsList.append(BlogsData(items))
            }
        }
    }
}

struct BlogsData{
    let id : Int
    let categoriesName: String
    let categoriesImage:String
    let status:String
    let createdAt:String
    let updatedAt:String
    var categoryBlog = [BlogCategoryData]()
    
    init(_ data:[String:AnyObject]) {
        self.id = data["id"] as? Int ?? -11
        self.categoriesName = (data["categories_name"] as? String ?? "")
        self.categoriesImage = data["categories_image"] as? String ?? ""
        self.status = data["status"]  as? String ?? ""
        self.createdAt = data["created_at"] as? String ?? ""
        self.updatedAt = data["updated_at"] as? String ?? ""

        if let  categoriesData = data["categories_blog"] as? [[String : AnyObject]] {
            
            for items in categoriesData {
              
                self.categoryBlog.append(BlogCategoryData(items))
                
            }
        }
        
    }
    
}

struct BlogCategoryData {
    let id : Int
    let categoriesId: Int
    let title:String
    let description:String
    let image:String
    let shared_by:String
    let video_link:String
    
    init(_ categoryData:[String:AnyObject]) {
        self.id = categoryData["id"] as? Int ?? -11
        self.categoriesId = categoryData["categories_id"] as? Int ?? -11
        self.title = categoryData["title"] as? String ?? ""
        self.description = categoryData["description"]  as? String ?? ""
        self.image = categoryData["image"] as? String ?? ""
        self.shared_by = categoryData["shared_by"] as? String ?? ""
         self.video_link = categoryData["video_link"] as? String ?? ""
    }
    
}


