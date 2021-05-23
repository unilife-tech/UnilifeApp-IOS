//
//  Media.swift
//  URLSessionDemo
//
//  Created by l on 7/13/17.
//  Copyright © 2017 l. All rights reserved.
//

import UIKit

struct MediaVideo {
    let key:String
    let fileName:String
    let data:Data
    let mime:String
     let type:String
    init?(withImage videoURL:URL, forKey key:String) {
        self.key = "club_image"//key
        self.mime = "video/mp4"
        self.fileName = "\(arc4random()).mp4"
         self.type = "video"
    
       
        let video3 = NSData(contentsOf: videoURL)
       // print(video3)
        self.data = video3 as! Data
                   
        
       // guard let data = Data(contentsOf: videoURL, options: .mappedIfSafe) else {return nil}
       // guard let data = image.jpegData(compressionQuality: 0.75) else {return nil}
        
    }
}
