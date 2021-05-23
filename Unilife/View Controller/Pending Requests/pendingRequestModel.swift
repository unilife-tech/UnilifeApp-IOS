// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pendingRequestModel = try? newJSONDecoder().decode(PendingRequestModel.self, from: jsonData)

import Foundation

// MARK: - PendingRequestModelElement
struct PendingRequestModelElement: Codable {
    let id, userID, friendID, groupID: Int?
    let status, type, createdAt, updatedAt: String?
    let requestfriend, rejectfriend: Tfriend?
    let groupDtl: GroupDtl?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case friendID = "friend_id"
        case groupID = "group_id"
        case status, type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case requestfriend, rejectfriend, groupDtl
    }
}

// MARK: - GroupDtl
struct GroupDtl: Codable {
    let id, userID, groupID: Int?
    let groupAdmin, createdAt, updatedAt: String?
    let usergroup: Usergroup?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case groupID = "group_id"
        case groupAdmin = "group_admin"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case usergroup
    }
}

// MARK: - Usergroup
struct Usergroup: Codable {
    let id: Int?
    let groupName: String?
    let groupImage: String?
    let createdBy: String?
    let universityGroupID: Int?
    let status, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "group_name"
        case groupImage = "group_image"
        case createdBy = "created_by"
        case universityGroupID = "university_group_id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Tfriend
struct Tfriend: Codable {
    let id: Int?
    let username: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case profileImage = "profile_image"
    }
}

typealias PendingRequestModel = [PendingRequestModelElement]



