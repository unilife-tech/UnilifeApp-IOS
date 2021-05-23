//
//  EventsCollectionCell.swift
//  RUNDOWN
//
//  Created by developer on 14/07/19.
//  Copyright © 2019 RUNDOWN. All rights reserved.
//

import UIKit

class PollAddOptionsCell: UITableViewCell {

    @IBOutlet weak var txtOption: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
     override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }
   
       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
   
           // Configure the view for the selected state
       }

}




extension PollAddOptionsCell:UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        
        if(ApplicationManager.instance.aryPoll.count > textField.tag)
        {
           let getobj:AddPollModel = ApplicationManager.instance.aryPoll[textField.tag]
           getobj.optionName = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // this method get called when you tap "Go"
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        
            if(newText.count > 50)
            {
                return false;
            }
            let aSet = NSCharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if( string == numberFiltered)
            {
              
                return true
            }else
            {
                return false
            }
            
            
            
        
        
        
        
        
    }
    
}
