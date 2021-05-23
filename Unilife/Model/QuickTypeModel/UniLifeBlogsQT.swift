//
//  UniLifeBlogsQT.swift
//  Unilife
//
//  Created by Sourabh Mittal on 10/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//


import Foundation

// MARK: - Blogs
struct Blogs: Codable {
    let slider: [Slider]?
    let blogs: [Blog]?
    let offer: [Offer]?
    let team: [Team]?
}

// MARK: - Blog
struct Blog: Codable {
    let id: Int
    let categoriesName, categoriesImage, status, createdAt: String?
    let updatedAt: String?
    let categoriesBlog: [Slider]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoriesName = "categories_name"
        case categoriesImage = "categories_image"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoriesBlog = "categories_blog"
    }
}

// MARK: - Slider
struct Slider: Codable {
    let id, categoriesID: Int
    let title, sliderDescription, image, sharedBy: String?
    let videoLink: String?
    let slider, status, createdAt, updatedAt: String?
    let userBlogLike, userBlogSaved: [UserBlog]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoriesID = "categories_id"
        case title
        case sliderDescription = "description"
        case image
        case sharedBy = "shared_by"
        case videoLink = "video_link"
        case slider, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userBlogLike = "user_blog_like"
        case userBlogSaved = "user_blog_saved"
    }
}

// MARK: - UserBlog
struct UserBlog: Codable {
    let id, blogID, userID: Int
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case blogID = "blog_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Offer
struct Offer: Codable {
    let id: Int
    let name, status, createdAt, updatedAt: String?
    let categoriesBrand: [CategoriesBrand]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoriesBrand = "categories_brand"
    }
}

// MARK: - CategoriesBrand
struct CategoriesBrand: Codable {
    let id, categoriesID: Int
    let brandName, image, type, categoriesBrandDescription: String?
    let status, createdAt, updatedAt: String?
    let brandOffer: [BrandOffer]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoriesID = "categories_id"
        case brandName = "brand_name"
        case image, type
        case categoriesBrandDescription = "description"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brandOffer = "brand_offer"
    }
}

// MARK: - BrandOffer
struct BrandOffer: Codable {
    let id, brandID: Int
    let title, startDate, expDate, type: String?
    let discountType: String?
    let discountPercent: Int?
    let discountCode, termCondition, image, slider, description: String?
    let status, createdAt, updatedAt: String?
    let brandNameData: BrandNameData?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brand_id"
        case title
        case startDate = "start_date"
        case expDate = "exp_date"
        case type
        case discountType = "discount_type"
        case discountPercent = "discount_percent"
        case discountCode = "discount_code"
        case termCondition = "term_condition"
        case image, slider, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case description = "description"
        case brandNameData = "brand_name_data"
    }
}

// MARK: - Team
struct Team: Codable {
    let id: Int
    let name, image, teamDescription, status: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, image
        case teamDescription = "description"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - BrandNameData
struct BrandNameData: Codable {
    let id: Int?
    let brandName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandName = "brand_name"
    }
}

