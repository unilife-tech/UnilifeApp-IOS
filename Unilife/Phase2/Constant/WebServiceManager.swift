//
//  WebServiceManager.swift
//  WebServiceDemo
//
//  Created by Ravi Dhorajiya on 02/05/18.
//  Copyright © 2018 Ravi Dhorajiya. All rights reserved.
//

import UIKit
import Foundation
import Alamofire


class WebServiceManager: AuthenticationHeader,AuthenticationHeaderOtherUserID {
  
  
  static let shared = WebServiceManager()
  var alamoFireSessionManager = Alamofire.SessionManager.default
  
    func callWebService(_ url: String, parameters: Parameters, method: HTTPMethod, _ encodingType: ParameterEncoding = JSONEncoding.default, completionHandler: @escaping(Any, _ error: Error?, _ errorMessage: String?) -> Void) {
     //   print(Constants.AUTH_TOKEN)
        let status = Reach().connectionStatus()
               switch status {
               case .unknown, .offline:

                Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
                Indicator.shared.hideProgressView()
                   return
               case .online(.wwan):
                   print("")
               case .online(.wiFi):
                   print("")
               }
       
       // ApplicationManager.instance.startloading()
       
       
    alamoFireSessionManager.request(url, method: method, parameters: parameters, encoding: encodingType, headers: headers).responseJSON { response in
      if let error = response.result.error {
 //       ApplicationManager.instance.stopLoading()
        print(error.localizedDescription)
        Indicator.shared.hideProgressView()
        completionHandler("", error, nil)
      } else {
        switch response.result {
        case .success(_):
          
            completionHandler(response.result.value, nil, nil)
           
            
         //   ApplicationManager.instance.stopLoading()
            
        case .failure(let error):
         // completionHandler("", error, nil)
            
       //     ApplicationManager.instance.stopLoading()
       //     print(error.localizedDescription)
          Indicator.shared.hideProgressView()
            
        }
      }
    }
  }
    
    
      func callWebService_NoLoader(_ url: String, parameters: Parameters, method: HTTPMethod, _ encodingType: ParameterEncoding = JSONEncoding.default, completionHandler: @escaping(Any, _ error: Error?, _ errorMessage: String?) -> Void) {
        
          let status = Reach().connectionStatus()
                 switch status {
                 case .unknown, .offline:
                    Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
                    Indicator.shared.hideProgressView()
                     return
                 case .online(.wwan):
                     print("")
                 case .online(.wiFi):
                     print("")
                 }
         
          
         
         
      alamoFireSessionManager.request(url, method: method, parameters: parameters, encoding: encodingType, headers: headers).responseJSON { response in
        if let error = response.result.error {
   //       ApplicationManager.instance.stopLoading()
          
          completionHandler("", error, nil)
        } else {
          switch response.result {
          case .success(_):
            
              completionHandler(response.result.value, nil, nil)
             
              
              
              
          case .failure(let error):
            completionHandler("", error, nil)
              
              Indicator.shared.hideProgressView()
              
            
              
          }
        }
      }
    }
    
    
    
    func callWebService_Home(_ url: String, parameters: Parameters, method: HTTPMethod, _ encodingType: ParameterEncoding = JSONEncoding.default, completionHandler: @escaping(Any, _ error: Error?, _ errorMessage: String?) -> Void) {
        
          let status = Reach().connectionStatus()
                 switch status {
                 case .unknown, .offline:
                    Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
                     return
                 case .online(.wwan):
                     print("")
                 case .online(.wiFi):
                     print("")
                 }
         
      //    ApplicationManager.instance.startloading()
         
         print( "Token=", UserData().userId)
      alamoFireSessionManager.request(url, method: method, parameters: parameters, encoding: encodingType, headers: headers).responseJSON { response in
        if let error = response.result.error {
      //    ApplicationManager.instance.stopLoading()
          
          completionHandler("", error, nil)
        } else {
          switch response.result {
          case .success(_):
            
              completionHandler(response.result.value, nil, nil)
             
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
   //           ApplicationManager.instance.stopLoading()
                Indicator.shared.hideProgressView()
            }
            
              
          case .failure(let error):
           // completionHandler("", error, nil)
              
    //          ApplicationManager.instance.stopLoading()
              print(error.localizedDescription)
            
              Indicator.shared.hideProgressView()
          }
        }
      }
    }
    
    ////... this is used for if in header we have send another user id 
     func callWebService_OtherAuth(_ url: String, parameters: Parameters, method: HTTPMethod, _ encodingType: ParameterEncoding = JSONEncoding.default, completionHandler: @escaping(Any, _ error: Error?, _ errorMessage: String?) -> Void) {
         
           let status = Reach().connectionStatus()
                  switch status {
                  case .unknown, .offline:
                     Singleton.sharedInstance.customAlert(getMSG: FAILED_INTERNET)
                      return
                  case .online(.wwan):
                      print("")
                  case .online(.wiFi):
                      print("")
                  }
          
       //    ApplicationManager.instance.startloading()
          
          
       alamoFireSessionManager.request(url, method: method, parameters: parameters, encoding: encodingType, headers: headers_otherUserID).responseJSON { response in
         if let error = response.result.error {
       //    ApplicationManager.instance.stopLoading()
           
           completionHandler("", error, nil)
         } else {
           switch response.result {
           case .success(_):
             
               completionHandler(response.result.value, nil, nil)
              
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
    //           ApplicationManager.instance.stopLoading()
                 Indicator.shared.hideProgressView()
             }
             
               
           case .failure(let error):
            // completionHandler("", error, nil)
               
     //          ApplicationManager.instance.stopLoading()
               print(error.localizedDescription)
             
               Indicator.shared.hideProgressView()
           }
         }
       }
     }
    
}






extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
