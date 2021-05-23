//
//  textFieldValidation.swift
//  FbTwGThirdparty
//
//  Created by Sipl on 26/07/17.
//  Copyright © 2017 Systematix. All rights reserved.
//

// Utility of Validation 

import UIKit

class textFieldValidation: NSObject {

    
     static let instance = textFieldValidation()
    
    
    func isTextFieldHasEmptyText(text:String) -> Bool {
        let trimmedString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if (trimmedString.count == 0)  {
            return true
        }
        return false
    }
    
    func isEnteredInvalidEmail(text:String) -> Bool
    {
        let stricterFilter: Bool = false
        let stricterFilterString: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,63}"
        //"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let laxString: String = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let emailRegex: String = stricterFilter ? stricterFilterString : laxString
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if emailTest.evaluate(with: text) {
            
//            let spaceCount = text.characters.filter{$0 == " "}.count
//            if(spaceCount == 0)
//            {
//                 return false
//            }else
//            {
//                return true
//            }
            
            let array = text.map( { String($0) })
                       var tc = 0
                       for item in array {
                           if item == "@"
                           {
                               tc = tc + 1
                           }
                       }
                       if tc > 1
                       {
                           return true
                       }
                       return false
        }
        else {
            return true
        }
        
        
        
        
        
        
        
    }
    func isMobileNumberLength(text:String) -> Bool
    {
        let trimmedString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if (trimmedString.count > 15) && (trimmedString.count < 20) {
             return false
            let whiteSpace = " "
            if let hasWhiteSpace = trimmedString.range(of: whiteSpace) {
                //has whitespace
                return true
            } else {
                //no whitespace
                return false
            }
            
            
            //return false
        }
        
        /*if (trimmedString.characters.count == 10)
        {
          return false
        }
        */
        return true
    }
    func isPasswwordNumberLength(text:String) -> Bool
    {
        let trimmedString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if (trimmedString.count >= 6)  {
            return false
        }
        return true
    }
    func isPassmatch(textPass:String,textCPass:String) -> Bool
    {
        let trimmedPass = textPass.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCPass = textCPass.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (trimmedPass == trimmedCPass)  {
            return false
        }
        return true
    }
}
