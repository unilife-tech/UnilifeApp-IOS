// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let audioListingModel = try? newJSONDecoder().decode(AudioListingModel.self, from: jsonData)

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let audioListingModel = try? newJSONDecoder().decode(AudioListingModel.self, from: jsonData)

import Foundation

// MARK: - AudioListingModelElement
struct AudioListingModelElement: Codable {
    let id: Int?
    let message, thumb, filepath, messageType: String?
    var isPlaying: Bool = false
    var currentDuration: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case id, message, thumb, filepath
        case messageType = "message_type"
    }
}

typealias AudioListingModel = [AudioListingModelElement]

