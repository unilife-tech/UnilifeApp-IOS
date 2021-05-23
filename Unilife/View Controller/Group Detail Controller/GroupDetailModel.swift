// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let groupDetailModel = try? newJSONDecoder().decode(GroupDetailModel.self, from: jsonData)

import Foundation

// MARK: - GroupDetailModel
struct GroupDetailModel: Codable {
    let id: Int?
    let groupName, groupImage: String?
    var usersInGroup: [UsersInGroup]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "group_name"
        case groupImage = "group_image"
        case usersInGroup = "users_in_group"
    }
}

// MARK: - UsersInGroup
struct UsersInGroup: Codable {
    let id, userID, groupID: Int?
    let groupAdmin, createdAt, updatedAt: String?
    let groupUserDetail: GroupUserDetail?
    var selectIndex = false
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case groupID = "group_id"
        case groupAdmin = "group_admin"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case groupUserDetail = "group_user_detail"
    }
    
   
    mutating func selectUser(){
        
        if   selectIndex == false{
            
            self.selectIndex = true
            
        }else {
            self.selectIndex = false
            
        }
        
        
    }
}

// MARK: - GroupUserDetail
struct GroupUserDetail: Codable {
    let id: Int?
    let userType, isOnline, username, completeProfile: String?
    let profileImage: String?
    let universitySchoolID: Int?
    let universitySchoolEmail, status, profileStatus, password: String?
    let decodedPassword: String?
    let otp: Int?
    let otpVerify: String?
    let resetPassword, rememberToken: JSONNull?
    let createdAt, updatedAt: String?
    
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
        case otp
        case otpVerify = "otp_verify"
        case resetPassword = "reset_password"
        case rememberToken = "remember_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
