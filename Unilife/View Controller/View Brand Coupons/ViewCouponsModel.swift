// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let viewCouponsModel = try? newJSONDecoder().decode(ViewCouponsModel.self, from: jsonData)

import Foundation

// MARK: - OfferUserView
struct OfferUserView: Codable {
    let id, brandID: Int?
    let title: String?
    let startDate, expDate, type, discountType: String?
    let discountPercent: Int?
    let discountCode, offerUserViewDescription, termCondition, image: String?
    let slider, status, createdAt, updatedAt: String?
    let brandNameData: BrandNameData?
    let offerSaved: ViewCouponsModelElement?
    
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
        case offerUserViewDescription = "description"
        case termCondition = "term_condition"
        case image, slider, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case brandNameData = "brand_name_data"
        case offerSaved = "offer_saved"
    }
}

// MARK: - ViewCouponsModelElement
class ViewCouponsModelElement: Codable {
    let id, viewCouponsModelOfferID, userID: Int?
    let createdAt, updatedAt: String?
    let offerID: Int?
    let offerUserView: OfferUserView?
    
    enum CodingKeys: String, CodingKey {
        case id
        case viewCouponsModelOfferID = "offer_id"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case offerID = "Offer_id"
        case offerUserView = "offer_user_view"
    }
    
    init(id: Int?, viewCouponsModelOfferID: Int?, userID: Int?, createdAt: String?, updatedAt: String?, offerID: Int?, offerUserView: OfferUserView?) {
        self.id = id
        self.viewCouponsModelOfferID = viewCouponsModelOfferID
        self.userID = userID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.offerID = offerID
        self.offerUserView = offerUserView
    }
}


typealias ViewCouponsModel = [ViewCouponsModelElement]

// MARK: - Encode/decode helpers

