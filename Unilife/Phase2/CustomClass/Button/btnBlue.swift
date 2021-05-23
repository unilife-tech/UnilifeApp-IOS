//

//

import UIKit

class btnBlue: UIButton {

    override func awakeFromNib() {
        
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor.unilifeButtonBlueColor
       
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font =  UIFont(name: "Nunito-bold", size: self.titleLabel?.font.pointSize ?? 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                   self.layer.masksToBounds = false
                   self.layer.shadowColor = UIColor.black.cgColor
                   self.layer.shadowOpacity = 0.3
                   self.layer.shadowOffset = CGSize(width: 1, height: 1)
                   self.layer.shadowRadius = 0.6
            
          
          
               }
        
        
    }

}
