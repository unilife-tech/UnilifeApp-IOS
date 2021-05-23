// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let chatWithUsersMessages = try? newJSONDecoder().decode(ChatWithUsersMessages.self, from: jsonData)

import Foundation

// MARK: - ChatWithUsersMessage
struct ChatWithUsersMessage: Codable {
    let id: Int?
    let roomID: String?
    let senderID: Int?
    let receiverID, groupID: Int?
    let lastMessage, lastMessageTime: String?
    let status, messageType, createdAt, updatedAt: String?
    let chatGroup: ChatGroup?
    let senderUser: ErUser?
    let receiverUser: ErUser?
    let roomChat: [RoomChat]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomID = "room_id"
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case groupID = "group_id"
        case lastMessage = "last_message"
        case lastMessageTime = "last_message_time"
        case status
        case messageType = "message_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case chatGroup = "chat_group"
        case senderUser = "sender_user"
        case receiverUser = "receiver_user"
        case roomChat = "room_chat"
    }
}

// MARK: - ChatGroup
struct ChatGroup: Codable {
    let id: Int?
    let groupName: String?
    let groupImage: String?
    let groupUserSeen: [RoomChat]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "group_name"
        case groupImage = "group_image"
        case groupUserSeen = "group_user_seen"
    }
}

// MARK: - RoomChat
struct RoomChat: Codable {
    let id: Int?
}

// MARK: - ErUser
struct ErUser: Codable {
    let id: Int?
    let username: String?
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case profileImage = "profile_image"
    }
}

typealias ChatWithUsersMessages = [ChatWithUsersMessage]

