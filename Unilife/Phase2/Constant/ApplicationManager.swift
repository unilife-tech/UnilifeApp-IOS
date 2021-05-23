//
//  ApplicationManager.swift
//  Finaureus
//
//  Created by developer on 18/01/19.
//  Copyright © 2019 Finaureus. All rights reserved.
//

import UIKit





class ApplicationManager: NSObject {
    
    static let instance = ApplicationManager()
  var aryPoll:[AddPollModel] = [AddPollModel]()
    
    ///... registraion
    var reg_Dic:[String:String] = [String:String]()
   
    
    
    // MARK: - Calculate Total days
    
    func dateCalculator(createdDate : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = Date()
        let create = dateFormatter.date(from: createdDate)
        if create != nil{
            let calendar = Calendar.current
            let createdComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: create!, to: now)
            let year = createdComponents.year!
            let month = createdComponents.month!
            let day = createdComponents.day!
            let hour = createdComponents.hour!
            let minutes = createdComponents.minute!
            let seconds = createdComponents.second!
            if(year ==  0){
                
                if(month == 0){
                    if (day == 0){
                        if(hour == 0){
                            if(minutes == 0){
                                return ("\(seconds) sec ago ")
                            }
                            else if (minutes == 1){
                                return ("\(minutes) min ago")
                            }
                            else{
                                return ("\(minutes) min ago")
                            }
                        }
                        else if(hour == 1){
                            return ("\(hour) hr ago ")
                        }
                        else{
                            return ("\(hour) hr ago")
                        }
                    }
                    else if (day == 1){
                        return ("\(day) day ago ")
                    }
                    else{
                        return ("\(day) days ago")
                    }
                }
                else if (month == 1){
                    //return ("\(year) \(month) \(day)")
                    dateFormatter.dateFormat = "EEEE MMM dd"
                    let convertedDate = dateFormatter.string(from: create as! Date)
                    return convertedDate
                }
                else{
                    dateFormatter.dateFormat = "dd MMM yyyy"
                    let convertedDate = dateFormatter.string(from: create as! Date)
                    return convertedDate
                    //return ("\(year) \(month) \(day)")
                }
            }
            else  if(year ==  1){
                //return ("\(year) \(month) \(day)")
                dateFormatter.dateFormat = "dd MMM yyyy"
                let convertedDate = dateFormatter.string(from: create as! Date)
                return convertedDate
            }
            else{
                dateFormatter.dateFormat = "dd MMM yyyy"
                let convertedDate = dateFormatter.string(from: create as! Date)
                return convertedDate
                //return ("\(year) \(month) \(day)")
            }
        }
            
        else{
            return ""
        }
        
    }
    
    
    
  
}
