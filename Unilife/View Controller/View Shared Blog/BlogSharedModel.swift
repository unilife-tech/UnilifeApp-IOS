// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let blogSharedModel = try? newJSONDecoder().decode(BlogSharedModel.self, from: jsonData)

import Foundation

// MARK: - BlogUserShared
struct BlogUserShared: Codable {
    let id, categoriesID: Int?
    let title, blogUserSharedDescription, image, sharedBy: String?
    let videoLink: String?
    let slider: Slider?
    let status: Status?
    let createdAt, updatedAt: String?
    let blogCategories: BlogCategories?
    let userBlogLike, userBlogSaved: [BlogSharedModelElement]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoriesID = "categories_id"
        case title
        case blogUserSharedDescription = "description"
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

// MARK: - BlogSharedModelElement
struct BlogSharedModelElement: Codable {
    let id, blogID, userID: Int?
    let createdAt, updatedAt: String?
    let blogUserShared: BlogUserShared?
    
    enum CodingKeys: String, CodingKey {
        case id
        case blogID = "blog_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case blogUserShared = "blog_user_shared"
    }
}


enum CategoriesImage: String, Codable {
    case the1552467653Jpg = "1552467653.jpg"
}

enum CategoriesName: String, Codable {
    case latestNews = "Latest News"
    case sportsUpdate = "Sports Update"
}

enum CreatedAt: String, Codable {
    case the20190913T045939000Z = "2019-09-13T04:59:39.000Z"
    case the20190913T045948000Z = "2019-09-13T04:59:48.000Z"
}


enum UpdatedAt: String, Codable {
    case the20191011T065627000Z = "2019-10-11T06:56:27.000Z"
    case the20191011T065630000Z = "2019-10-11T06:56:30.000Z"
}

typealias BlogSharedModel = [BlogSharedModelElement]
