// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let redeemCoupon = try? newJSONDecoder().decode(RedeemCoupon.self, from: jsonData)

import Foundation

// MARK: - RedeemCoupon
struct RedeemCoupon: Codable {
    let response: Bool?
    let offers: Offers?
    let brand: Brand?
}

// MARK: - Brand
struct Brand: Codable {
    let id, categoriesID: Int?
    let brandName, image, type, brandDescription: String?
    let status, createdAt, updatedAt: String?
    let brandOffer: [Offers]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case categoriesID = "categories_id"
        case brandName = "brand_name"
        case image, type
        case brandDescription = "description"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brandOffer = "brand_offer"
    }
}

// MARK: - Offers
struct Offers: Codable {
    let id, brandID: Int?
    let title: String?
    let startDate, expDate, type, discountType: String?
    let link: String?
    let discountPercent: Int?
    let discountCode: String?
    let offersDescription, termCondition: String?
    let image, slider, status, createdAt: String?
    let updatedAt: String?
    let offerSaved: OfferSaved?
    let offerRedeemUser: OfferRedeemUser?
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brand_id"
        case title
        case startDate = "start_date"
        case expDate = "exp_date"
        case type
        case discountType = "discount_type"
        case link
        case discountPercent = "discount_percent"
        case discountCode = "discount_code"
        case offersDescription = "description"
        case termCondition = "term_condition"
        case image, slider, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case offerSaved = "offer_saved"
        case offerRedeemUser = "offer_redeem_user"
    }
}

// MARK: - OfferRedeemUser
struct OfferRedeemUser: Codable {
    let id, userID, couponID: Int?
    let type, createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case couponID = "coupon_id"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - OfferSaved
struct OfferSaved: Codable {
    let id, offerSavedOfferID, userID: Int?
    let createdAt, updatedAt: String?
    let offerID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case offerSavedOfferID = "offer_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case offerID = "Offer_id"
    }
}

