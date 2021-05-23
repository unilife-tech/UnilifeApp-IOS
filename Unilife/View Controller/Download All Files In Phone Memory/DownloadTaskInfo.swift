//
//  DownloadTaskInfo.swift
//  Unilife
//
//  Created by Apple on 25/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import Foundation
class DownloadTaskInfo: NSObject {
    var name:String?;
    var url:String?;
    var isDownload:Bool = false;
    var progress:Float = 0.0;
    
    var downloadTask:URLSessionDownloadTask?;
    var downloadTaskId:Int?;
    var downloadedData:NSData?;

}
