// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let friendListingModel = try? newJSONDecoder().decode(FriendListingModel.self, from: jsonData)

import Foundation

// MARK: - FriendListingModelElement
struct FriendListingModelElement: Codable {
    let id: Int?
    let userType: String?
    let isOnline: IsOnline?
    let username: String?
    let completeProfile: String?
    let profileImage: String?
    let universitySchoolID: Int?
    let universitySchoolEmail: String?
    let status: String?
    let profileStatus: String?
    let password, decodedPassword: String?
    let otp: Int?
    let otpVerify: String?
    let resetPassword, rememberToken: String?
    let createdAt, updatedAt: String?
    var selectIndex = false
    
    mutating func selectUser(){
        
        if   self.selectIndex == false{
            
            self.selectIndex = true
            
        }else {
            self.selectIndex = false
            
        }
        
        
    }
    
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

//enum CompleteProfile: String, Codable {
//    case no = "no"
//    case yes = "yes"
//}

enum IsOnline: String, Codable {
    case offline = "offline"
    case online = "online"
}

enum ProfileStatus: String, Codable {
    case profileStatusPrivate = "private"
    case profileStatusPublic = "public"
}

//enum Status: String, Codable {
//    case active = "active"
//}

typealias FriendListingModel = [FriendListingModelElement]

//// var selectIndex = false
//mutating func selectUser(){
//
//    if   selectIndex == false{
//
//        self.selectIndex = true
//
//    }else {
//        self.selectIndex = false
//
//    }
//
//
//}

