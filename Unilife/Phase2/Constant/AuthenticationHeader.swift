//
//  AuthenticationHeader.swift
//  WebServiceDemo
//
//  Created by Ravi Dhorajiya on 02/05/18.
//  Copyright © 2018 Ravi Dhorajiya. All rights reserved.
//

import UIKit

protocol AuthenticationHeader {
  var headers: [String: String] { get }
}

extension AuthenticationHeader {
  var headers: [String: String] {
    return [
        "Token": UserData().userId,
      "Content-Type": "application/json"
    ]
  }
}
