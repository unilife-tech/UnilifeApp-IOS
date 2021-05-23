//
//  ImageCache.swift
//  BubbleBud
//
//  Created by Apple on 21/08/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation

fileprivate let ONE_HUNDRED_MEGABYTES = 1024 * 1024 * 100

class IGCache: NSCache<AnyObject, AnyObject> {
    static let shared = IGCache()
    private override init() {
        super.init()
        self.setMaximumLimit()
    }
}

extension IGCache {
    func setMaximumLimit(size: Int = ONE_HUNDRED_MEGABYTES) {
        totalCostLimit = size
    }
}
