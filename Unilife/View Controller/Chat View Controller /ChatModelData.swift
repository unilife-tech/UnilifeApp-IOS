// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let chatModelElement = try? newJSONDecoder().decode(ChatModelElement.self, from: jsonData)

import Foundation

// MARK: - Chat
struct Chat: Codable {
    let id: Int?
    let roomID, message: String?
    let thumb, filepath: String?
    let senderID: Int?
    let receiverID: Int?
    let groupID: Int?
    let chatID: Int?
    let date, seen, isDeleted, deleteChatID: String?
    let messageType, onlyDate, createdAt, updatedAt: String?
    let senderUserChat: SenderUserChat?
    let chatSlide: ChatSlide?
    
    var isPlaying: Bool = false
    var currentDuration: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomID = "room_id"
        case message, thumb, filepath
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case groupID = "group_id"
        case chatID = "chat_id"
        case date, seen
        case isDeleted = "is_deleted"
        case deleteChatID = "delete_chat_id"
        case messageType = "message_type"
        case onlyDate = "only_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case senderUserChat = "sender_user_chat"
        case chatSlide = "chat_slide"
    }
}

// MARK: - SenderUserChat
struct SenderUserChat: Codable {
    let id: Int?
    let username, profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case profileImage = "profile_image"
    }
}

// MARK: - ChatSlide
struct ChatSlide: Codable {
    let id: Int?
    let roomID, message: String?
    let thumb, filepath: String?
    let senderID: Int?
    let receiverID: Int?
    let groupID: Int?
    let chatID: Int?
    let date, seen, isDeleted, deleteChatID: String?
    let messageType, onlyDate, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case roomID = "room_id"
        case message, thumb, filepath
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case groupID = "group_id"
        case chatID = "chat_id"
        case date, seen
        case isDeleted = "is_deleted"
        case deleteChatID = "delete_chat_id"
        case messageType = "message_type"
        case onlyDate = "only_date"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias ChatModelElement = [Chat]

// MARK: - Encode/decode helpers



// typealias ChatModel = [ChatModelElement]

extension Chat: Equatable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
        
    }
}




