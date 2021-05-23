// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let completeProfile = try CompleteProfile(json)

import Foundation

// MARK: - CompleteProfile
class CompleteProfile: Codable {
    let count: Int
    let rows: [Row]
    
    init(count: Int, rows: [Row]) {
        self.count = count
        self.rows = rows
    }
}

// MARK: CompleteProfile convenience initializers and mutators

extension CompleteProfile {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CompleteProfile.self, from: data)
        self.init(count: me.count, rows: me.rows)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        count: Int? = nil,
        rows: [Row]? = nil
        ) -> CompleteProfile {
        return CompleteProfile(
            count: count ?? self.count,
            rows: rows ?? self.rows
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Row
class Row: Codable {
    let id: Int
    let question, questionType, status, createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, question
        case questionType = "question_type"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int, question: String, questionType: String, status: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.question = question
        self.questionType = questionType
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: Row convenience initializers and mutators

extension Row {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Row.self, from: data)
        self.init(id: me.id, question: me.question, questionType: me.questionType, status: me.status, createdAt: me.createdAt, updatedAt: me.updatedAt)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        id: Int? = nil,
        question: String? = nil,
        questionType: String? = nil,
        status: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil
        ) -> Row {
        return Row(
            id: id ?? self.id,
            question: question ?? self.question,
            questionType: questionType ?? self.questionType,
            status: status ?? self.status,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

