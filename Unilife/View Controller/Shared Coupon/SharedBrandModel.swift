// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let sharedBrandModel = try? newJSONDecoder().decode(SharedBrandModel.self, from: jsonData)

import Foundation

// MARK: - OfferUserShared
struct OfferUserShared: Codable {
    let id, brandID: Int?
    let title: String?
    let startDate, expDate, type, discountType: String?
    let discountPercent: Int?
    let discountCode, offerUserSharedDescription, termCondition, image: String?
    let slider, status, createdAt, updatedAt: String?
    let brandNameData: BrandNameData?
    let offerSaved: SharedBrandModelElement?
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brand_id"
        case title
        case startDate = "start_date"
        case expDate = "exp_date"
        case type
        case discountType = "discount_type"
        case discountPercent = "discount_percent"
        case discountCode = "discount_code"
        case offerUserSharedDescription = "description"
        case termCondition = "term_condition"
        case image, slider, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brandNameData = "brand_name_data"
        case offerSaved = "offer_saved"
    }
}

// MARK: - SharedBrandModelElement
class SharedBrandModelElement: Codable {
    let id, sharedBrandModelOfferID, userID: Int?
    let createdAt, updatedAt: String?
    let offerID: Int?
    let offerUserShared: OfferUserShared?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sharedBrandModelOfferID = "offer_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case offerID = "Offer_id"
        case offerUserShared = "offer_user_shared"
    }
    
    init(id: Int?, sharedBrandModelOfferID: Int?, userID: Int?, createdAt: String?, updatedAt: String?, offerID: Int?, offerUserShared: OfferUserShared?) {
        self.id = id
        self.sharedBrandModelOfferID = sharedBrandModelOfferID
        self.userID = userID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.offerID = offerID
        self.offerUserShared = offerUserShared
    }
}

//// MARK: - BrandNameData
//struct BrandNameData: Codable {
//    let id: Int?
//    let brandName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case brandName = "brand_name"
//    }
//}

typealias SharedBrandModel = [SharedBrandModelElement]

//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
