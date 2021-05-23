//
//  AuthenticationHeader.swift
//  WebServiceDemo
//
//  Created by Ravi Dhorajiya on 02/05/18.
//  Copyright © 2018 Ravi Dhorajiya. All rights reserved.
//

import UIKit

protocol AuthenticationHeaderOtherUserID {
  var headers: [String: String] { get }
}

extension AuthenticationHeaderOtherUserID {
  var headers_otherUserID: [String: String] {
    return [
        "Token": "\(ConstantsHelper.OtherUserID)",
      "Content-Type": "application/json"
    ]
  }
}
