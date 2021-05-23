// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let blockedUserModel = try? newJSONDecoder().decode(BlockedUserModel.self, from: jsonData)

import Foundation

// MARK: - BlockedUserModelElement
struct BlockedUserModelElement: Codable {
    let id, blockUserID, userID: Int?
    let createdAt, updatedAt: String?
    let blockuser: Blockuser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case blockUserID = "block_user_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case blockuser
    }
}

// MARK: - Blockuser
struct Blockuser: Codable {
    let id: Int?
    let username, profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case profileImage = "profile_image"
    }
}

typealias BlockedUserModel = [BlockedUserModelElement]
