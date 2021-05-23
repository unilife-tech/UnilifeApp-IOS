//
//  Media.swift
//  URLSessionDemo
//
//  Created by l on 7/13/17.
//  Copyright © 2017 l. All rights reserved.
//

import UIKit

struct Media {
    let key:String
    let fileName:String
    let data:Data
    let type:String
    let mime:String
    
    init?(withImage image:UIImage, forKey key:String) {
        self.key = "club_image"//key
        self.mime = "image/jpeg"
        self.fileName = "\(arc4random()).jpeg"
        self.type = "image"
         
       // guard let data = UIImageJPEGRepresentation(image,0.7) else {return nil}
        guard let data = image.jpegData(compressionQuality: 0.75) else {return nil}
        self.data = data
    }
}
