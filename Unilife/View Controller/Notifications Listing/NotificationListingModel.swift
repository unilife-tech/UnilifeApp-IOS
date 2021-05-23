// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let notificationListingModel = try? newJSONDecoder().decode(NotificationListingModel.self, from: jsonData)

import Foundation

// MARK: - NotificationListingModelElement
struct NotificationListingModelElement: Codable {
    let id, senderID, receiverID: Int?
    let adminID: String?
    let message, title, type, createdAt: String?
    let updatedAt: String?
    let notificationUser: NotificationUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case adminID = "admin_id"
        case message, title, type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case notificationUser = "notification_user"
    }
}

// MARK: - NotificationUser
struct NotificationUser: Codable {
    let id: Int?
    let username, profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case profileImage = "profile_image"
    }
}

typealias NotificationListingModel = [NotificationListingModelElement]

// MARK: - Encode/decode helpers

