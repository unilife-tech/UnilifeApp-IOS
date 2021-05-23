// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let searchBrandModel = try? newJSONDecoder().decode(SearchBrandModel.self, from: jsonData)

import Foundation

// MARK: - SearchBrandModelElement
struct SearchBrandModelElement: Codable {
    let id, brandID: Int?
    let image: String?
    let discountType: String?
    let discountPercent: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case brandID = "brand_id"
        case image
        case discountType = "discount_type"
        case discountPercent = "discount_percent"
    }
}

typealias SearchBrandModel = [SearchBrandModelElement]
