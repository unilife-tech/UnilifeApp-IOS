// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let unilifeBrandModel = try? newJSONDecoder().decode(UnilifeBrandModel.self, from: jsonData)

import Foundation

// MARK: - UnilifeBrandModel
struct UnilifeBrandModel: Codable {
    let response: Bool?
    let slider: [SliderElement1]?
    let offer: [Offer1]?
    let blogs: [Blog1]?
}

// MARK: - Blog
struct Blog1: Codable {
    let id: Int?
    let categoriesName, categoriesImage: String?
    let status: Status?
    let createdAt, updatedAt: String?
    let categoriesBlog: [CategoriesBlog1]?
    
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

// MARK: - CategoriesBlog
struct CategoriesBlog1: Codable {
    let id, categoriesID: Int?
    let title, categoriesBlogDescription, image, sharedBy: String?
    let videoLink: String?
    let slider: SliderEnum?
    let status: Status?
    let createdAt, updatedAt: String?
    let userBlogLike, userBlogSaved: [UserBlog1]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoriesID = "categories_id"
        case title
        case categoriesBlogDescription = "description"
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

enum SliderEnum: String, Codable {
    case no = "no"
    case yes = "yes"
}



// MARK: - UserBlog
struct UserBlog1: Codable {
    let id, blogID, userID: Int?
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
struct Offer1: Codable {
    let id: Int?
    let name, image: String?
    let status: Status?
    let createdAt, updatedAt: String?
    let categoriesBrand: [CategoriesBrand1]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoriesBrand = "categories_brand"
    }
}

// MARK: - CategoriesBrand
struct CategoriesBrand1: Codable {
    let id, categoriesID: Int?
    let brandName, image: String?
    let type: String?
    let categoriesBrandDescription: String?
    let status: Status?
    let createdAt, updatedAt: String?
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

// MARK: - SliderElement
struct SliderElement1: Codable {
    let id, brandID: Int?
    let title: String?
    let startDate, expDate: String?
    let type: String?
    let discountType: DiscountType?
    let discountPercent: Int?
    let discountCode, sliderDescription, termCondition, image: String?
    let slider: SliderEnum?
    let status: Status?
    let createdAt, updatedAt: String?
   // let brandNameData: BrandNameData?
    
    
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
        case sliderDescription = "description"
        case termCondition = "term_condition"
        case image, slider, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        //case brandNameData = "brand_name_data"
    }
}



enum DiscountType: String, Codable {
    case flat = "flat"
    case percentage = "percentage"
}

enum TypeEnum1: String, Codable {
    case instore = "instore"
    case online = "online"
    case onlineInstore = "online_instore"
}
