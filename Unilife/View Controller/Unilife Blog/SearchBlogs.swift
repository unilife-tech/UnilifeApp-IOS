//
//  SearchBlogs.swift
//  Unilife
//
//  Created by Apple on 23/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchBlogs = try? newJSONDecoder().decode(SearchBlogs.self, from: jsonData)

import Foundation

// MARK: - SearchBlog
struct SearchBlog: Codable {
    let id, categoriesID: Int?
    let title, searchBlogDescription, image, sharedBy: String?
    let videoLink: String?
    let slider, status, createdAt, updatedAt: String?
    let blogCategories: BlogCategories?
    let userBlogLike, userBlogSaved: [UserBlog]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoriesID = "categories_id"
        case title
        case searchBlogDescription = "description"
        case image
        case sharedBy = "shared_by"
        case videoLink = "video_link"
        case slider, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case blogCategories = "blog_categories"
        case userBlogLike = "user_blog_like"
        case userBlogSaved = "user_blog_saved"
    }
}

// MARK: - BlogCategories
struct BlogCategories: Codable {
    let id: Int?
    let categoriesName, categoriesImage, status, createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoriesName = "categories_name"
        case categoriesImage = "categories_image"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}



typealias SearchBlogs = [SearchBlog]
