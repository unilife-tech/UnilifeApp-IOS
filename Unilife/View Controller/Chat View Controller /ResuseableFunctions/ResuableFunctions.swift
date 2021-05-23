//
//  ResuableFunctions.swift
//  Unilife
//
//  Created by Apple on 11/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ReuseableFunctions {
    
    func GenerateUniqueImageName() -> String {
        
        let milisec = (Date().timeIntervalSince1970 * 1000).rounded()
        return ("Unilife" + "\(Int(milisec))" + "\(UserData().userId)" + "\(self.getUniqueCode())" + ".jpeg")
        
    }
    
    func GenerateUniqueVideoName() -> String {
        
        let milisec = (Date().timeIntervalSince1970 * 1000).rounded()
        return ("Unilife" + "\(Int(milisec))" + "\(UserData().userId)" + "\(self.getUniqueCode())" + ".mp4")
        
    }
    
    func GenerateUniquePdfName() -> String {
        
        let milisec = (Date().timeIntervalSince1970 * 1000).rounded()
        return ("Unilife" + "\(Int(milisec))" + "\(UserData().userId)" + "\(self.getUniqueCode())" + ".pdf")
        
    }
    
    func GenerateUniqueAudioName() -> String {
        
        let milisec = (Date().timeIntervalSince1970 * 1000).rounded()
        return ("Unilife" + "\(Int(milisec))" + "\(UserData().userId)" + "\(self.getUniqueCode())")
        
    }
    
    func getUniqueCode() -> String {
        
        let randomNum:UInt32 = arc4random_uniform(10000000)
        
        let uniqueCode = "\(randomNum)\(randomNum)"
        
        return uniqueCode
    }
    
    class func getAttributedString(string: String, color: UIColor, size: CGFloat)-> NSAttributedString{
        
        let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: string, attributes: [NSAttributedString.Key.font:UIFont(name: "GreycliffCF-Regular", size: size)!, NSAttributedString.Key.foregroundColor : color])
        
        return attributedString
        
    }
    
    func getOnlyAlphabetes(text: String) -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        return text.filter {okayChars.contains($0) }
    }
    
    func getOnlyNumbersWithCommaAndDot(text: String) -> String {
        let okayChars = Set("1234567890,.")
        return text.filter {okayChars.contains($0) }
    }
    
    func getOnlyNumbers(text: String) -> String {
        let okayChars = Set("1234567890")
        return text.filter {okayChars.contains($0) }
    }
    
    func dateFormatChange(date : String, oldFormat : String, newFormat : String) ->  String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = oldFormat
        
        guard let dateString = dateFormatter.date(from: date) else {
            return ""
        }
        
        dateFormatter.dateFormat = newFormat
        
        let dateStringToSet = dateFormatter.string(from: dateString)
        
        return dateStringToSet
    }
    
    class func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    class func localToUTC(date:String, format : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format
        
        if let newDate = dt {
            return newDate
        }
        
        return nil
    }
    
    class func UTCToLocal(date:String, format : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        
        if let newDate = dt {
            return newDate
        }
        
        return nil
    }
    
    class func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: NSTimeInterval
    
    class func displayableString(from timeInterval: TimeInterval) -> String {
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.zeroFormattingBehavior = DateComponentsFormatter.ZeroFormattingBehavior.pad
        if (timeInterval >= 60 * 60) {
            dateComponentsFormatter.allowedUnits = [.hour, .minute, .second]
        } else {
            dateComponentsFormatter.allowedUnits = [.minute, .second]
        }
        return dateComponentsFormatter.string(from: timeInterval) ?? "0:00"
    }
    
    
}
