//
//  WebServices.swift
//  Butterflies
//
//  Created by Akash Gupta on 22/01/18.
//  Copyright Akash Gupta. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum methodType {
    case POST,GET
}



var baseURL = "http://15.206.103.14:3006/"
//"http://13.235.138.143:3006/" //http://18.222.35.185:3000/

var profileImageUrl = "http://15.206.103.14/public/profile_imgs/"
var categoryImageUrl = "http://15.206.103.14/public/unilife-icons/"
var postImageUrl = "http://15.206.103.14/public/post_imgs/"
var offerImageUrl = "http://15.206.103.14/public/offer_imgs/"
var brandImageUrl = "http://15.206.103.14/public/admin/brand/"
var blogImageUrl = "http://15.206.103.14/public/blog_imgs/"
var chatUrl = "http://15.206.103.14/public/chatdata/"

var imgURL = ""

//http://15.206.103.14/public/profile_imgs/{image_name}

//var keyForgifTreding = "dc6zaTOxFJmzC"

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class webservices {
    init(){}
    var responseCode = 0;
    var connectionError = ""
    func startConnectionWithGetType(getUrlString:String ,outputBlock:@escaping (_ receivedData: AnyObject)->Void) {
        let Url = baseURL + getUrlString
        print(Url)
        Alamofire.request(Url, encoding: JSONEncoding.default).responseJSON { response in
            if response.response != nil {
                if let json = response.result.value {
                    self.responseCode = 1
                    outputBlock(json as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    func startConnectionWithGetTypeWithoutBaseUrl(getUrlString:String ,outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        let Url = getUrlString
        print(Url)
        Alamofire.request(Url, encoding: JSONEncoding.default).responseJSON { response in
            if response.response != nil {
                if let json = response.result.value {
                    self.responseCode = 1
                    outputBlock(json as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func startConnectionWithPostType(getUrlString:String , params getParams:[String: AnyObject],outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        let Url = baseURL + getUrlString
        print(Url)
        Alamofire.request(Url, method: .post, parameters: getParams as Parameters, encoding: JSONEncoding.default).responseJSON { response in
            if response.response != nil {
                if let json = response.result.value {
                    self.responseCode = 1
                    outputBlock(json as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }
    
    func StartConectionWithSingleFile(FileData: Data , FileParam: String , FileName: String , FileMimeType: String , getParams:[String: AnyObject] , getUrlString:String ,outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        
        let url = URL(string: baseURL + getUrlString)!
        
        print(url)
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        let parameters = getParams
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.upload(multipartFormData: { multipart_FormData in
            
            multipart_FormData.append(FileData, withName: FileParam, fileName: FileName, mimeType: FileMimeType)
            
            for (key, value) in parameters {
                
                multipart_FormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
            
        },with: urlRequest,encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if let json = response.result.value {
                        
                        self.responseCode = 1
                        outputBlock(json as AnyObject)
                        
                    }else {
                        
                        self.responseCode = 2
                        outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                        
                    }
                }
            case .failure(let encodingError):
                
                self.responseCode = 2
                
                outputBlock(["Error" : encodingError] as AnyObject)
                
            }
        })
    }
    
    func SartConectionWithMultipleFile(FileDataArr: Array<Data> , FileParamArr: Array<String> , FileNameArr: Array<String> , FileMimeTypeArr: Array<String> , getParams:[String: AnyObject] , getUrlString:String ,outputBlock:@escaping (_ receivedData:AnyObject)->Void) {
        
        let url = URL(string: baseURL + getUrlString)!
        print(url)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        
        let parameters = getParams
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.upload(multipartFormData: { multipart_FormData in
            
            for i in 0..<FileDataArr.count {
                
                multipart_FormData.append(FileDataArr[i], withName: FileParamArr[i], fileName: FileNameArr[i], mimeType: FileMimeTypeArr[i])
                
            }
            
            for (key, value) in parameters {
                multipart_FormData.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        },with: urlRequest,encodingCompletion: { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    
                    if let json = response.result.value {
                        
                        self.responseCode = 1
                        outputBlock(json as AnyObject)
                        
                    }else {
                        
                        self.responseCode = 2
                        outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                        
                    }
                }
            case .failure(let encodingError):
                
                self.responseCode = 2
                
                outputBlock(["Error" : encodingError] as AnyObject)
                
            }
        })
    }
    
    func startConnectionWithGoogleGetType(getUrlString:String ,outputBlock:@escaping (_ receivedData: AnyObject)->Void) {
        let Url =  getUrlString
        print(Url)
        Alamofire.request(Url, encoding: JSONEncoding.default).responseJSON { response in
            if response.response != nil {
                if let json = response.result.value {
                    self.responseCode = 1
                    outputBlock(json as AnyObject)
                }else {
                    self.responseCode = 2
                    outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
                }
            }else {
                self.responseCode = 2
                outputBlock(["Error" : response.error?.localizedDescription] as AnyObject)
            }
        }
    }

    func startConnectionWithSingleFile(FileData: Data,FileName: String,FileType: String,FileParam: String,getUrlString: String,params: [String:AnyObject],outputBlock:@escaping (_ receivedData: AnyObject, _ responceCode: Int) -> Void){
        
        let url = baseURL + getUrlString
        
        print(url)
        
        var requestURL = URLRequest(url: URL(string: url)!)
        
        requestURL.httpMethod = "POST"
        
        let parameters = params
        
        requestURL.timeoutInterval = 20
        
        requestURL.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.upload(multipartFormData: { (multiple_FormData) in
            
            multiple_FormData.append(FileData, withName: FileParam, fileName: FileName, mimeType: FileType)
            
            for (key, value) in parameters {
                
                print(value)
                
                if let _ = value as? [Parameters]{
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
                        multiple_FormData.append(jsonData, withName: key as String)
                    }
                    
                }else if let _ = value as? Parameters {
                    
                    if let jsonData = try? JSONSerialization.data(withJSONObject: value, options:[]) {
                        multiple_FormData.append(jsonData, withName: key as String)
                    }
                    
                } else {
                    multiple_FormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                
            }
            
        }, usingThreshold: UInt64.init(), with: requestURL) { encodingResult in
            
            switch encodingResult {
                
            case .success(let upload,_,_):
                
                upload.responseJSON(completionHandler: { (responce) in
                    
                    if let json = responce.result.value{
                        
                        outputBlock(json as AnyObject,1)
                        
                    }else{
                        
                        outputBlock(["Error": responce.error?.localizedDescription] as AnyObject,2)
                        
                    }
                    
                })
                
            case .failure(let error):
                
                outputBlock(["Error": error.localizedDescription] as AnyObject,3)
                
            }
            
            
        }
    }
    
    
    
    
    
    
    
    
    
}

extension UIImageView {
    
    func downLoadImage(ImageURL: String , PlaceholderImage: UIImage) {
        
        self.image = PlaceholderImage
        
        self.accessibilityHint = (imgURL + ImageURL).replacingOccurrences(of: " ", with: "%20")
        
        //print(imgURL + ImageURL)
        
        Alamofire.request((imgURL + ImageURL).replacingOccurrences(of: " ", with: "%20")).responseData { (response) in
            
            if "\(response.request!)" == self.accessibilityHint {
                
                if response.error == nil {
                    
                    if let data = response.data {
                        
                        if UIImage(data: data) != nil {
                            
                            self.image = UIImage(data: data)
                            
                        }else {
                            
                            self.image = PlaceholderImage
                            
                        }
                    }
                }
            }
        }
    }
    
    func downLoadImageWithoutBaseURL(ImageURL: String , PlaceholderImage: UIImage) {
        
        self.image = PlaceholderImage
        
        self.accessibilityHint = ImageURL.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request(ImageURL.replacingOccurrences(of: " ", with: "%20")).responseData { (response) in
            
            print(ImageURL)
            
            if "\(response.request!)" == self.accessibilityHint {
                
                if response.error == nil {
                    
                    if let data = response.data {
                        
                        if UIImage(data: data) != nil {
                            
                            self.image = UIImage(data: data)
                            
                        }else {
                            
                            self.image = PlaceholderImage
                            
                        }
                    }
                }
            }
        }
    }
    
    func downLoadImage(ImageURL: String) {
        
        self.accessibilityHint = (imgURL + ImageURL).replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request((imgURL + ImageURL).replacingOccurrences(of: " ", with: "%20")).responseData { (response) in
            
            if "\(response.request!)" == self.accessibilityHint {
                
                if response.error == nil {
                    
                    if let data = response.data {
                        
                        if UIImage(data: data) != nil {
                            
                            self.image = UIImage(data: data)
                            
                        }
                    }
                }
            }
        }
    }
}






let kLoginStoryBoard : UIStoryboard = UIStoryboard(name: "Login", bundle:nil)
let kPhase2toryBoard : UIStoryboard = UIStoryboard(name: "Phase2", bundle:nil)
let kProfileEditStoryBoard : UIStoryboard = UIStoryboard(name: "MYProfileEdit", bundle:nil)
let kHomeStoryBoard : UIStoryboard = UIStoryboard(name: "Home", bundle:nil)
let kMainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
var kDeviceType:String = "" // x
