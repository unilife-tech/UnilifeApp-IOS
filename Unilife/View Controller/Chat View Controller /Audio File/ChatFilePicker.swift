//
//  ChatFilePicker.swift
//  Unilife
//
//  Created by Apple on 11/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import Foundation
import UIKit
import Photos
import SocketIO
import MobileCoreServices

enum Flag: String {
    case old = "old"
    case new = "new"
}

enum FileTypeText : String {
    
    case file = "sent a file"
    case video = "sent a video"
    case image = "sent an image"
    
}

struct UploadableChat {
    
    var auth_image: String
    var file_type: String
    var file_type_text: FileTypeText
    var message_type: String = "audio"
    var receiver_id: String
    var room_id: String
    var sender_id: String
    var name: String
    var size: Int
    var basedata: String
    var flag: Flag
    
}
