// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let listRedeemedBrandCouponModel = try? newJSONDecoder().decode(ListRedeemedBrandCouponModel.self, from: jsonData)

import Foundation

// MARK: - ListRedeemedBrandCouponModelElement
struct ListRedeemedBrandCouponModelElement: Codable {
    let id, userID, couponID: Int?
    let type, createdAt, updatedAt: String?
    let offerRedeem: OfferRedeem?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case couponID = "coupon_id"
        case type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case offerRedeem = "offer_redeem"
    }
}

// MARK: - OfferRedeem
struct OfferRedeem: Codable {
    let id, brandID: Int?
    let title: String?
    let startDate, expDate, type, discountType: String?
    let link: String?
    let discountPercent: Int?
    let discountCode, offerRedeemDescription, termCondition, image: String?
    let slider, status, createdAt, updatedAt: String?
    let brandNameData: BrandNameData?
    let offerSaved: OfferSaved?
    
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
        case offerRedeemDescription = "description"
        case termCondition = "term_condition"
        case image, slider, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brandNameData = "brand_name_data"
        case offerSaved = "offer_saved"
    }
}



typealias ListRedeemedBrandCouponModel = [ListRedeemedBrandCouponModelElement]

