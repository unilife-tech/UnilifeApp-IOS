// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let showCompleteProfileData = try? newJSONDecoder().decode(ShowCompleteProfileData.self, from: jsonData)

import Foundation

// MARK: - ShowCompleteProfileData
struct ShowCompleteProfileData: Codable {
    let userQuesAns: UserQuesAns
    let userDetail: UserDetail
    
    enum CodingKeys: String, CodingKey {
        case userQuesAns = "user_ques_ans"
        case userDetail = "user_detail"
    }
}

// MARK: - UserDetail
struct UserDetail: Codable {
    let id: Int?
    let userType, isOnline, username, completeProfile: String?
    let profileImage: String?
    let universitySchoolID: Int?
    let universitySchoolEmail: String?
    let status: Status?
    let profileStatus, password, decodedPassword: String?
    let resetPassword, rememberToken: String?
    let createdAt, updatedAt: String?
    let userHobbies, userHobbiesInterests: [UserHobb]?
    let userCourseCovered: [UserCourseCovered]?
    
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
        case userHobbies = "user_hobbies"
        case userHobbiesInterests = "user_hobbies_interests"
        case userCourseCovered = "user_course_covered"
    }
}

enum Status: String, Codable {
    case active = "active"
}

// MARK: - UserCourseCovered
struct UserCourseCovered: Codable {
    let id, userID, courseID: Int?
    let answer, createdAt, updatedAt: String?
    let questionID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case courseID = "course_id"
        case answer
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case questionID = "question_id"
    }
}

// MARK: - UserHobb
struct UserHobb: Codable {
    let id, userID, hobbiesInterestID: Int?
    let type, createdAt, updatedAt: String?
    let hobbies, hobbiesInterests: Hobbies?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case hobbiesInterestID = "hobbies_interest_id"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case hobbies
        case hobbiesInterests = "hobbies_interests"
    }
}

// MARK: - Hobbies
struct Hobbies: Codable {
    let id: Int?
    let name, type, icon: String?
    let status: Status?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, icon, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - UserQuesAns
struct UserQuesAns: Codable {
    let count: Int?
    let rows: [Row1]?
}

// MARK: - Row
struct Row1: Codable {
    let id: Int?
    let image, question, questionType: String?
    let status: Status?
    let createdAt, updatedAt: String?
    let quesAnswers: [UserCourseCovered]?
    
    enum CodingKeys: String, CodingKey {
        case id, image, question
        case questionType = "question_type"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case quesAnswers = "ques_answers"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
