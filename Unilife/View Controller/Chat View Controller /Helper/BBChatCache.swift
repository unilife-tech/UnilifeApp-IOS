//
//  IGVideoCacheManager.swift
//  BubbleBud
//
//  Created by Apple on 21/08/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation
import Alamofire

class BBVideoCacheManager {
    
    enum VideoError: Error, CustomStringConvertible {
        case downloadError
        case fileRetrieveError
        var description: String {
            switch self {
            case .downloadError:
                return "Can't download audio"
            case .fileRetrieveError:
                return "File not found"
            }
        }
    }
    
    static let shared = BBVideoCacheManager()
    private init(){}
    typealias Response = IGResult<URL, Error>
    
    private let fileManager = FileManager.default
    private lazy var mainDirectoryUrl: URL? = {
        let documentsUrl = URL.createFolder(folderName: BBAudioFolderName)
        return documentsUrl
    }()
    
    func getFile(for stringUrl: String, vc: UIViewController, completionHandler: @escaping (Response) -> Void) {
        
        DownloadProgressor.shared.showProgressView(vc.view)
        
        if let file = directoryFor(stringUrl: stringUrl) {
            
            //return file path if already exists in cache directory
            
            guard !fileManager.fileExists(atPath: file.path) else {
                DispatchQueue.main.async {
                    DownloadProgressor.shared.hideProgressView()
                }
                completionHandler(Response.success(file))
                return
            }
            
            self.downloadUsingAlamofire(url: URL(string: stringUrl)!, fileName: file, vc: vc, completion: {
                url in
                
                if let newUrl = url {
                    DispatchQueue.main.async {
                        DownloadProgressor.shared.hideProgressView()
                    }
                    completionHandler(Response.success(newUrl))
                }else{
                    DispatchQueue.main.async {
                        DownloadProgressor.shared.hideProgressView()
                    }
                    completionHandler(Response.failure(VideoError.fileRetrieveError))
                }
                
            })
            
        }else{
            DispatchQueue.main.async {
                DownloadProgressor.shared.hideProgressView()
            }
            completionHandler(Response.failure(VideoError.fileRetrieveError))
            
        }
        
    }
    
    func getFileIfLocallyExists(for stringUrl: String) -> URL? {
        
        guard let file = directoryFor(stringUrl: stringUrl) else {
            return nil
        }
        
        //return file path if already exists in cache directory
        guard !fileManager.fileExists(atPath: file.path) else {
            return file
        }
        
        return nil
    }
    
    func clearCache(for urlString: String? = nil) {
        guard let cacheURL =  mainDirectoryUrl else { return }
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
            if let string = urlString, let url = URL(string: string) {
                do {
                    try fileManager.removeItem(at: url)
                }
                catch let error as NSError {
                    debugPrint("Unable to remove the item: \(error)")
                }
            }else {
                for file in directoryContents {
                    do {
                        try fileManager.removeItem(at: file)
                    }
                    catch let error as NSError {
                        debugPrint("Unable to remove the item: \(error)")
                    }
                }
            }
        } catch let error as NSError {
            debugPrint(error.localizedDescription)
        }
    }
    
    private func directoryFor(stringUrl: String) -> URL? {
        guard let fileURL = URL(string: stringUrl)?.lastPathComponent, let mainDirURL = self.mainDirectoryUrl else { return nil }
        let file = mainDirURL.appendingPathComponent(fileURL)
        return file
    }
    
    // MARK: - Load URL
    func downloadUsingAlamofire(url: URL, fileName: URL, vc: UIViewController, completion: @escaping(_ url: URL?) -> Void) {
        
        let manager = Alamofire.SessionManager.default
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            return (fileName, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        manager.download(url, to: destination)
            
            .downloadProgress(queue: .main, closure: { (progress) in
                //progress closure
                DispatchQueue.main.async(execute: {
                    DownloadProgressor.shared.progressValue = progress.fractionCompleted
                })
                print(progress.fractionCompleted)
            })
            .validate { request, response, temporaryURL, destinationURL in
                // Custom evaluation closure now includes file URLs (allows you to parse out error messages if necessary)
                completion(url)
                return .success
            }.responseData { response in
                if response.destinationURL != nil {
                    
                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                        print("Success: \(statusCode)")
                        completion(nil)
                    }

                } else {
                    completion(nil)
            }
        }
    }
}



extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}
