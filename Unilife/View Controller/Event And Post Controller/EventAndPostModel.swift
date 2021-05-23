//
//  EventAndPostModel.swift
//  Unilife
//
//  Created by Apple on 25/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let eventAndPostModel = try EventAndPostModel(json)

import Foundation


// MARK: - EventAndPostModelElement
struct EventAndPostModelElement: Codable {
    let id, userID: Int?
    let adminID: Int?
    let groupID: Int?
    let universityPostID: Int?
    let caption, locationName: String?
    let postThroughGroup: String?
    let status: Status?
    let createdAt, updatedAt: String?
    let userUploadingPost: UserUploadingPost?
    let postAttachments: [PostAttachment]?
    let postComments: [Post]?
    var postLikes, userPostLike, totalPostLike: [PostLike]?
    let postTagGroup: [PostTagGroup]?
    let postTagUser: [Post]?
    let offers: Offers2?
    let blogs: Blogs?
    let adminUploadingPost: AdminUploadingPost?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case adminID = "admin_id"
        case groupID = "group_id"
        case universityPostID = "university_post_id"
        case caption
        case locationName = "location_name"
        case postThroughGroup = "post_through_group"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userUploadingPost = "user_uploading_post"
        case postAttachments = "post_attachments"
        case postComments = "post_comments"
        case postLikes = "post_likes"
        case userPostLike = "user_post_like"
        case totalPostLike = "total_post_like"
        case postTagGroup = "post_tag_group"
        case postTagUser = "post_tag_user"
        case adminUploadingPost = "admin_uploading_post"
        case offers, blogs
    }
}

// MARK: EventAndPostModelElement convenience initializers and mutators

extension EventAndPostModelElement {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EventAndPostModelElement.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int?? = nil,
        userID: Int?? = nil,
        adminID: Int?? = nil,
        groupID: Int?? = nil,
        universityPostID: Int?? = nil,
        caption: String?? = nil,
        locationName: String?? = nil,
        postThroughGroup: String?? = nil,
        status: Status?? = nil,
        createdAt: String?? = nil,
        updatedAt: String?? = nil,
        userUploadingPost: UserUploadingPost?? = nil,
        postAttachments: [PostAttachment]?? = nil,
        postComments: [Post]?? = nil,
        postLikes: [PostLike]?? = nil,
        userPostLike: [PostLike]?? = nil,
        totalPostLike: [PostLike]?? = nil,
        postTagGroup: [PostTagGroup]?? = nil,
        postTagUser: [Post]?? = nil,
        offers: Offers2?? = nil,
        blogs: Blogs?? = nil ,
        adminUploadingPost: AdminUploadingPost?? = nil
        ) -> EventAndPostModelElement {
        return EventAndPostModelElement(
            id: id ?? self.id,
            userID: userID ?? self.userID,
            adminID: adminID ?? self.adminID,
            groupID: groupID ?? self.groupID,
            universityPostID: universityPostID ?? self.universityPostID,
            caption: caption ?? self.caption,
            locationName: locationName ?? self.locationName,
            postThroughGroup: postThroughGroup ?? self.postThroughGroup,
            status: status ?? self.status,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            userUploadingPost: userUploadingPost ?? self.userUploadingPost,
            postAttachments: postAttachments ?? self.postAttachments,
            postComments: postComments ?? self.postComments,
            postLikes: postLikes ?? self.postLikes,
            userPostLike: userPostLike ?? self.userPostLike,
            totalPostLike: totalPostLike ?? self.totalPostLike,
            postTagGroup: postTagGroup ?? self.postTagGroup,
            postTagUser: postTagUser ?? self.postTagUser,
            offers: offers ?? self.offers,
            blogs: blogs ?? self.blogs,
            adminUploadingPost: adminUploadingPost ?? self.adminUploadingPost
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - AdminUploadingPost
struct AdminUploadingPost: Codable {
    let id: Int?
    let username, image: String?
}

// MARK: - Offers2
struct Offers2: Codable {
    let id: Int?
    let name, image, status, createdAt: String?
    let updatedAt: String?
    let categoriesBrand: [CategoriesBrand2]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categoriesBrand = "categories_brand"
    }
}

// MARK: - CategoriesBrand
struct CategoriesBrand2: Codable {
    let id, categoriesID: Int?
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




// MARK: - CategoriesBlog
struct CategoriesBlog: Codable {
    let id, categoriesID: Int?
    let title, categoriesBlogDescription, image, sharedBy: String?
    let videoLink: String?
    let slider: PostThroughGroup?
    let status: Status?
    let createdAt, updatedAt: String?
    let userBlogLike: [UserBlogLike]?
    let userBlogSaved: [UserSaveBlog]?
    
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

// MARK: CategoriesBlog convenience initializers and mutators

extension CategoriesBlog {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CategoriesBlog.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int?? = nil,
        categoriesID: Int?? = nil,
        title: String?? = nil,
        categoriesBlogDescription: String?? = nil,
        image: String?? = nil,
        sharedBy: String?? = nil,
        videoLink: String?? = nil,
        slider: PostThroughGroup?? = nil,
        status: Status?? = nil,
        createdAt: String?? = nil,
        updatedAt: String?? = nil,
        userBlogLike: [UserBlogLike]?? = nil,
        userBlogSaved: [UserSaveBlog]?? = nil
        ) -> CategoriesBlog {
        return CategoriesBlog(
            id: id ?? self.id,
            categoriesID: categoriesID ?? self.categoriesID,
            title: title ?? self.title,
            categoriesBlogDescription: categoriesBlogDescription ?? self.categoriesBlogDescription,
            image: image ?? self.image,
            sharedBy: sharedBy ?? self.sharedBy,
            videoLink: videoLink ?? self.videoLink,
            slider: slider ?? self.slider,
            status: status ?? self.status,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            userBlogLike: userBlogLike ?? self.userBlogLike,
            userBlogSaved: userBlogSaved ?? self.userBlogSaved
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum PostThroughGroup: String, Codable {
    case no = "no"
    case yes = "yes"
}


// MARK: - UserBlogLike
struct UserBlogLike: Codable {
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


struct UserSaveBlog: Codable {
    
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

// MARK: UserBlogLike convenience initializers and mutators

extension UserBlogLike {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserBlogLike.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int?? = nil,
        blogID: Int?? = nil,
        userID: Int?? = nil,
        createdAt: String?? = nil,
        updatedAt: String?? = nil
        ) -> UserBlogLike {
        return UserBlogLike(
            id: id ?? self.id,
            blogID: blogID ?? self.blogID,
            userID: userID ?? self.userID,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}





// MARK: - PostAttachment
struct PostAttachment: Codable {
    let id, postID: Int?
    let attachmentType, attachment: String?
    let thumbnail: String?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case attachmentType = "attachment_type"
        case attachment, thumbnail
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: PostAttachment convenience initializers and mutators

extension PostAttachment {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PostAttachment.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int?? = nil,
        postID: Int?? = nil,
        attachmentType: String?? = nil,
        attachment: String?? = nil,
        thumbnail: String?? = nil,
        createdAt: String?? = nil,
        updatedAt: String?? = nil
        ) -> PostAttachment {
        return PostAttachment(
            id: id ?? self.id,
            postID: postID ?? self.postID,
            attachmentType: attachmentType ?? self.attachmentType,
            attachment: attachment ?? self.attachment,
            thumbnail: thumbnail ?? self.thumbnail,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Post
struct Post: Codable {
    let id, postID, userID: Int?
    let comment, createdAt, updatedAt: String?
    let postuser: Postuser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case userID = "user_id"
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case postuser
    }
}

// MARK: Post convenience initializers and mutators

extension Post {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Post.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int?? = nil,
        postID: Int?? = nil,
        userID: Int?? = nil,
        comment: String?? = nil,
        createdAt: String?? = nil,
        updatedAt: String?? = nil,
        postuser: Postuser?? = nil
        ) -> Post {
        return Post(
            id: id ?? self.id,
            postID: postID ?? self.postID,
            userID: userID ?? self.userID,
            comment: comment ?? self.comment,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            postuser: postuser ?? self.postuser
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Postuser
struct Postuser: Codable {
    let id: Int?
    let username: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case profileImage = "profile_image"
    }
}

// MARK: Postuser convenience initializers and mutators

extension Postuser {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Postuser.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int?? = nil,
        username: String?? = "",
        profileImage: String?? = nil
        ) -> Postuser {
        return Postuser(
            id: id ?? self.id,
            username: username ?? self.username,
            profileImage: profileImage ?? self.profileImage
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - PostLike
struct PostLike: Codable {
    let id, postCommentID, userID: Int?
    let type: TypeEnum?
    let createdAt, updatedAt: String?
    
    init(id: Int?, postCommentID: Int?, userID: Int?, type: TypeEnum?, createdAt: String?, updatedAt: String?){
        
    self.id = id
    self.postCommentID = postCommentID
    self.userID = userID
    self.type = type
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case postCommentID = "post_comment_id"
        case userID = "user_id"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: PostLike convenience initializers and mutators

extension PostLike {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PostLike.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int?? = nil,
        postCommentID: Int?? = nil,
        userID: Int?? = nil,
        type: TypeEnum?? = nil,
        createdAt: String?? = nil,
        updatedAt: String?? = nil
        ) -> PostLike {
        return PostLike(
            id: id ?? self.id,
            postCommentID: postCommentID ?? self.postCommentID,
            userID: userID ?? self.userID,
            type: type ?? self.type,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

enum TypeEnum: String, Codable {
    case p = "P"
}

// MARK: - PostTagGroup
struct PostTagGroup: Codable {
    let id, groupID, postID: Int?
    let createdAt, updatedAt: String?
    let postgroup: Postgroup?
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case postID = "post_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case postgroup
    }
}

// MARK: PostTagGroup convenience initializers and mutators

extension PostTagGroup {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PostTagGroup.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int?? = nil,
        groupID: Int?? = nil,
        postID: Int?? = nil,
        createdAt: String?? = nil,
        updatedAt: String?? = nil,
        postgroup: Postgroup?? = nil
        ) -> PostTagGroup {
        return PostTagGroup(
            id: id ?? self.id,
            groupID: groupID ?? self.groupID,
            postID: postID ?? self.postID,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            postgroup: postgroup ?? self.postgroup
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Postgroup
struct Postgroup: Codable {
    let id: Int?
    let groupName: String?
    let groupImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "group_name"
        case groupImage = "group_image"
    }
}

// MARK: Postgroup convenience initializers and mutators

extension Postgroup {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Postgroup.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int?? = nil,
        groupName: String?? = nil,
        groupImage: String?? = nil
        ) -> Postgroup {
        return Postgroup(
            id: id ?? self.id,
            groupName: groupName ?? self.groupName,
            groupImage: groupImage ?? self.groupImage
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - UserUploadingPost
struct UserUploadingPost: Codable {
    let id: Int?
    let userType: String?
    let isOnline: String?
    let username: String?
    let completeProfile: PostThroughGroup?
    let profileImage: String?
    let universitySchoolID: Int?
    let universitySchoolEmail: String?
    let status: String?
    let profileStatus: String?
    let password: String?
    let decodedPassword: String?
    let resetPassword, rememberToken: String?
    let createdAt: String?
    let updatedAt: String?
    let userUniversitySchool: UserUniversitySchool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userType = "user_type"
        case isOnline = "is_online"
        case username
        case completeProfile = "complete_profile"
        case profileImage = "profile_image"
        case universitySchoolID = "university_school_id"
        case universitySchoolEmail = "university_school_email"
        case status
        case profileStatus = "profile_status"
        case password
        case decodedPassword = "decoded_password"
        case resetPassword = "reset_password"
        case rememberToken = "remember_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userUniversitySchool = "user_university_school"
    }
}



// MARK: - UserUniversitySchool
struct UserUniversitySchool: Codable {
    let id: Int?
    let name: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


typealias EventAndPostModel = [EventAndPostModelElement]

extension Array where Element == EventAndPostModel.Element {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(EventAndPostModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

//class JSONAny: Codable {
//
//    let value: Any
//
//    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//        return DecodingError.typeMismatch(JSONAny.self, context)
//    }
//
//    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//        return EncodingError.invalidValue(value, context)
//    }
//
//    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if container.decodeNil() {
//            return JSONNull()
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if let value = try? container.decodeNil() {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer() {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//        if let value = try? container.decode(Bool.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Double.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(String.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decodeNil(forKey: key) {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//        var arr: [Any] = []
//        while !container.isAtEnd {
//            let value = try decode(from: &container)
//            arr.append(value)
//        }
//        return arr
//    }
//
//    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//        var dict = [String: Any]()
//        for key in container.allKeys {
//            let value = try decode(from: &container, forKey: key)
//            dict[key.stringValue] = value
//        }
//        return dict
//    }
//
//    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//        for value in array {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer()
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//        for (key, value) in dictionary {
//            let key = JSONCodingKey(stringValue: key)!
//            if let value = value as? Bool {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Int64 {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Double {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? String {
//                try container.encode(value, forKey: key)
//            } else if value is JSONNull {
//                try container.encodeNil(forKey: key)
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer(forKey: key)
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//        if let value = value as? Bool {
//            try container.encode(value)
//        } else if let value = value as? Int64 {
//            try container.encode(value)
//        } else if let value = value as? Double {
//            try container.encode(value)
//        } else if let value = value as? String {
//            try container.encode(value)
//        } else if value is JSONNull {
//            try container.encodeNil()
//        } else {
//            throw encodingError(forValue: value, codingPath: container.codingPath)
//        }
//    }
//
//    public required init(from decoder: Decoder) throws {
//        if var arrayContainer = try? decoder.unkeyedContainer() {
//            self.value = try JSONAny.decodeArray(from: &arrayContainer)
//        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//            self.value = try JSONAny.decodeDictionary(from: &container)
//        } else {
//            let container = try decoder.singleValueContainer()
//            self.value = try JSONAny.decode(from: container)
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        if let arr = self.value as? [Any] {
//            var container = encoder.unkeyedContainer()
//            try JSONAny.encode(to: &container, array: arr)
//        } else if let dict = self.value as? [String: Any] {
//            var container = encoder.container(keyedBy: JSONCodingKey.self)
//            try JSONAny.encode(to: &container, dictionary: dict)
//        } else {
//            var container = encoder.singleValueContainer()
//            try JSONAny.encode(to: &container, value: self.value)
//        }
//    }
//}

