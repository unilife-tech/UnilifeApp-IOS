//
//  IGErrors.swift
//  BubbleBud
//
//  Created by Apple on 21/08/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation

public enum IGError: Error, CustomStringConvertible {

    case invalidImageURL
    case downloadError

    public var description: String {
        switch self {
        case .invalidImageURL: return "Invalid Image URL"
        case .downloadError: return "Unable to download image"
        }
    }
}
