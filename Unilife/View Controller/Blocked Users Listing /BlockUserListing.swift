// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let blockUserGroupListing = try? newJSONDecoder().decode(BlockUserGroupListing.self, from: jsonData)

import Foundation

// MARK: - BlockUserGroupListingElement
struct BlockUserGroupListingElement: Codable {
    let id: Int?
    let userType, isOnline, username, completeProfile: String?
    let profileImage: String?
    let universitySchoolID: Int?
    let universitySchoolEmail, status, profileStatus, password: String?
    let decodedPassword: String?
    let otp: Int?
    let otpVerify: String?
    let resetPassword, rememberToken: String?
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

typealias BlockUserGroupListing = [BlockUserGroupListingElement]



