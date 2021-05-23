// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let savedBrandCoupon = try? newJSONDecoder().decode(SavedBrandCoupon.self, from: jsonData)

import Foundation

// MARK: - SavedBrandCouponElement
struct SavedBrandCouponElement: Codable {
    let id, savedBrandCouponOfferID, userID: Int?
    let createdAt, updatedAt: String?
    let offerID: Int?
    let offerUserSaved: OfferUserSaved?
    
    enum CodingKeys: String, CodingKey {
        case id
        case savedBrandCouponOfferID = "offer_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case offerID = "Offer_id"
        case offerUserSaved = "offer_user_saved"
    }
}

// MARK: - OfferUserSaved
struct OfferUserSaved: Codable {
    let id, brandID: Int?
    let title: String?
    let startDate, expDate, type, discountType: String?
    let discountPercent: Int?
    let discountCode, offerUserSavedDescription, termCondition, image: String?
    let slider, status, createdAt, updatedAt: String?
    let brandNameData: BrandNameData?
    
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
        case offerUserSavedDescription = "description"
        case termCondition = "term_condition"
        case image, slider, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brandNameData = "brand_name_data"
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

typealias SavedBrandCoupon = [SavedBrandCouponElement]
