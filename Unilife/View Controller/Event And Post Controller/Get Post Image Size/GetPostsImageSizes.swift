//
//  GetPostsImageSizes.swift
//  Unilife
//
//  Created by Promatics on 1/27/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import Foundation

struct  GetPostImageSize {
    
    var imgSize = [Double]()
    
    mutating func setImageViewSize(size : Double) {
        
        self.imgSize.append(size)
        
    }
}
