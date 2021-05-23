//
//  circleLabel.swift
//  E-Doctor
//
//  Created by Sourabh Mittal on 02/04/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation

import UIKit

class CircleLabel: UILabel {
    
    override func layoutSubviews() {
        
        self.layer.cornerRadius = self.frame.size.width / 2
        
        self.clipsToBounds = true
    }
    
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}

extension UIViewController {
    
    enum NavLeftSide {
        case Back
        case Profile
        case ProfileWithBack
        case None
        case Camera
    }
    
    enum TitlePosition {
        case Middle
    }
    
    enum NavRightSide {
        case None
        case Icon
        case Title
        case OnlineOffline
        case Camera
        case notification
        case chat
    }
    
    enum BGColor {
        case Clear
        case Default
        case White
    }
    
    enum TitleType {
        
        case Large
        
        case Normal
    }
    
    public typealias MethodHandler = () -> Void
    
    func addNavigationBar(left leftBarType: NavLeftSide = .None,titleType: TitleType, title: String = "", titlePosition : TitlePosition = .Middle, right rightBarType: NavRightSide = .None, rightButtonIconOrTitle : String = "", bgColor : BGColor = .Clear, barTintColor : UIColor = .appSkyBlue, navigationBarStyle: UIBarStyle = .default, rightFunction:@escaping MethodHandler){
        
        //        self.navigationController?.navigationBar.prefersLargeTitles = true
        //
        //        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.topItem?.title = ""
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: barTintColor, .font: UIFont(name: "SoinSansNeue-Bold", size: 20)!]
        
        self.navigationController?.navigationBar.tintColor = barTintColor
        
        self.navigationController?.navigationBar.barStyle = navigationBarStyle
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        if #available(iOS 11.0, *) {
            //            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        } else {
            // Fallback on earlier versions
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: barTintColor, .font: UIFont(name: "SoinSansNeue-Bold", size: 20)!]
        
        switch titleType {
        case .Large:
            
            
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: barTintColor, .font: UIFont(name: "SoinSansNeue-Bold", size: 20)!]
            } else {
                // Fallback on earlier versions
            }
            
        case .Normal:
            
            if #available(iOS 11.0, *) {
                //                self.navigationController?.navigationBar.prefersLargeTitles = false
            } else {
                // Fallback on earlier versions
            }
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: barTintColor, .font: UIFont(name: "SoinSansNeue-Bold", size: 20)!]
            
        }
        
        
        switch bgColor {
        case .Clear:
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            
        case .Default:
            
            self.navigationController?.navigationBar.barTintColor = UIColor.appSkyBlue
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
            self.navigationController?.navigationItem.backBarButtonItem?.tintColor = barTintColor
            
         case .White:
            
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.backgroundColor = UIColor.white
        }
        
        
        switch titlePosition {
        case .Middle:
            
            self.navigationItem.title = title
            
        }
        
        switch rightBarType {
            
            
        case .None:
            self.navigationItem.rightBarButtonItem = nil
        case .Icon:
            self.addRightButtonAction(iconOrTitle: rightButtonIconOrTitle, type: rightBarType, color: barTintColor, function: rightFunction)
        case .Title:
            self.addRightButtonAction(iconOrTitle: rightButtonIconOrTitle, type: rightBarType, color: barTintColor, function: rightFunction)
        case .OnlineOffline:
            self.onlineOfllineSwitch()
        case .Camera:
            self.addCameraButton(color: barTintColor)
        case .notification:
            
            let notification_btn = UIButton()
            
            notification_btn.addTarget(self, action: #selector(self.notification(_:)), for: .touchUpInside)
            //self.notification()
            
        case.chat:
            
            let chat_btn = UIButton()
           
            chat_btn.addTarget(self, action: #selector(chatOption(_:)), for: .touchUpInside)
            
            
        }
        
        switch leftBarType {
        case .None:
            self.navigationController?.navigationItem.hidesBackButton = true
            self.navigationItem.setHidesBackButton(true, animated: false)
        case .Back:
            self.addLeftBack(color: barTintColor)
        case .Profile:
            self.addLeftProfileButton()
        case .ProfileWithBack:
            self.addLeftProfileButtonWithBack(color: barTintColor)
        case .Camera:
            self.addLeftCamerButton(color: barTintColor)
        }
        
        
    }
    
    fileprivate func addRightButtonAction(iconOrTitle : String, type : NavRightSide = .Title , color: UIColor = .black, function:@escaping MethodHandler){
        
        let rightButton = UIButton()
        if(type == .Title){
            
            rightButton.setTitle(iconOrTitle, for: .normal)
            rightButton.setTitleColor(color, for: .normal)
            rightButton.titleLabel?.font =  UIFont(name: "SoinSansNeue-Bold", size: 17)
            
        }else if(type == .Icon){
            
            let image = UIImage(named: iconOrTitle)?.withRenderingMode(.alwaysTemplate)
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = color
            
        }else if (type == .chat) {
            let image = UIImage(named: iconOrTitle)?.withRenderingMode(.alwaysTemplate)
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = color
            
        }
        rightButton.addTarget(self, action: #selector(tapRightNavButton), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightButton.tag = 1
        NavigationHandler.shared.RightNavBarfunction = function
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
    }
    
    fileprivate func addLeftProfileButton(){
        
        let leftButton = UIButton()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        leftButton.setImage(UIImage(named : ""), for: .normal)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.frame.size.height = imageView.frame.width
        imageView.layer.cornerRadius = imageView.frame.width/2
        
        imageView.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
        imageView.layer.cornerRadius = 30/2
        imageView.layer.borderColor = UIColor.unilifeblueDark.cgColor
        imageView.layer.borderWidth = 2.0
        leftButton.addSubview(imageView)
        
        
        leftButton.addTarget(self, action: #selector(tapLeftNavButton), for: .touchUpInside)
        //  leftButton.layer.cornerRadius = 18
        leftButton.clipsToBounds = true
        leftButton.contentMode = .scaleAspectFit
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.tag = 1
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
    }
    
    fileprivate func addLeftProfileButtonWithBack(color: UIColor = .black){
        
        let profileButton = UIButton()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        profileButton.setImage(UIImage(named : ""), for: .normal)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.frame.size.height = imageView.frame.width
        imageView.layer.cornerRadius = imageView.frame.width/2
        
        imageView.sd_setImage(with: URL(string: profileImageUrl + UserData().image), placeholderImage: UIImage(named: "noimage_icon"))
        
        profileButton.addSubview(imageView)
        
        profileButton.addTarget(self, action: #selector(profileBack_btn), for: .touchUpInside)
        profileButton.layer.cornerRadius = 18
        profileButton.clipsToBounds = true
        profileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileButton.tag = 1
        
        //        let backButton = UIButton()
        //        let image = UIImage(named: "left-arrow")?.withRenderingMode(.alwaysTemplate)
        //        backButton.setImage(image, for: .normal)
        //        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        //        backButton.layer.cornerRadius = 18
        //        backButton.tintColor = color
        //        backButton.clipsToBounds = true
        //        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        //        backButton.tag = 1
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: profileButton)]
        
        // UIBarButtonItem(customView: backButton),
        
    }
    
    fileprivate func addLeftBack(color: UIColor = UIColor.white){
        
        let backButton = UIButton()
        let image = UIImage(named: "backWhite_icon")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        backButton.layer.cornerRadius = 18
        backButton.tintColor = color
        backButton.clipsToBounds = true
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        backButton.tag = 1
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backButton)]
        
    }
    
    @objc fileprivate func profileBack_btn() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    fileprivate func addCameraButton(color: UIColor = .black) {
        
        let cameraButton = UIButton()
        let image = UIImage(named: "tab_camera")?.withRenderingMode(.alwaysTemplate)
        cameraButton.setImage(image, for: .normal)
        cameraButton.addTarget(self, action: #selector(tapCameraButton), for: .touchUpInside)
        //        if(self.isKind(of: unlife.self)) || (self.isKind(of: MyFeedViewController.self)){
        //            cameraButton.tintColor = UIColor.appDarkSkyBlue
        //        }else{
        //            cameraButton.tintColor = color
        //        }
        
        cameraButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        cameraButton.tag = 1
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: cameraButton)]
        
    }
    
    fileprivate func addLeftCamerButton(color: UIColor = .black) {
        
        let cameraButton = UIButton()
        let image = UIImage(named: "tab_camera")?.withRenderingMode(.alwaysTemplate)
        cameraButton.setImage(image, for: .normal)
        cameraButton.addTarget(self, action: #selector(tapCameraButton), for: .touchUpInside)
        
        //        if(self.isKind(of: BaseViewController.self)) || (self.isKind(of: MyFeedViewController.self)){
        //            cameraButton.tintColor = UIColor.appDarkSkyBlue
        //        }else{
        //            cameraButton.tintColor = color
        //        }
        
        cameraButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        cameraButton.tag = 1
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: cameraButton)]
        
    }
    
    fileprivate func onlineOfllineSwitch(){
        
        let segment: UISegmentedControl = UISegmentedControl(items: ["Online", "Offline"])
        segment.sizeToFit()
        segment.tintColor = UIColor.appSkyBlue
        segment.selectedSegmentIndex = 0;
        segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "GreycliffCF-Regular", size: 15)!], for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: segment)
    }
    
    @objc fileprivate func notification(_ sender: UIButton) {
       
    }
    
    @objc fileprivate func chatOption(_ sender: UIButton) {
       
    }
    
    
    
    @objc func tapBackButton(_ sender: UIButton){
        
        print("Tap Back Button")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapLeftNavButton(_ sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DrawerViewController") as! DrawerViewController
        vc.moveNext = self
        self.transitionVc(vc: vc, duration: 0.1, type: .fromLeft)
    }
    
    @objc func tapRightNavButton(_ sender: UIButton){
        
        if let x = NavigationHandler.shared.RightNavBarfunction as? () -> Void {
            x()
            
        }
    }
    
    @objc func tapCameraButton(_ sender: UIButton){
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        //        self.presentingViewController?.providesPresentationContextTransitionStyle = true
        //        self.presentingViewController?.definesPresentationContext = true
        //        vc.modalPresentationStyle = .overFullScreen;
        //        self.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc func switchValueDidChange(sender: UISwitch!)
    {
        if sender.isOn {
            print("on")
        } else{
            print("off")
        }
    }
    
    func transitionVc(vc: UIViewController, duration: CFTimeInterval, type: CATransitionSubtype) {
        let customVcTransition = vc
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.fade
        transition.subtype = type
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(customVcTransition, animated: false, completion: nil)
    }
    
    func setAttributedLabelText(string_array : [String] , color_array : [UIColor]  ) -> NSMutableAttributedString {
        
        let combination = NSMutableAttributedString()
        
        for index in 0..<string_array.count {
            
            let qus = NSAttributedString(string: string_array[index] , attributes: [NSAttributedString.Key.foregroundColor : color_array[index] ])
            
            combination.append(qus)
            
            
        }
        
        
        return combination
    }
    
    // MARK: - Default Pop Up
    
    
    func showAlertWithAction(Title: String , Message: String , ButtonTitle: String ,outputBlock:@escaping ()->Void) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.appSkyBlue
        alert.addAction(UIAlertAction(title: ButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
            
            outputBlock()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlert(Title: String , Message: String , ButtonTitle: String) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: ButtonTitle, style: .default, handler: nil))
        alert.view.tintColor = UIColor.appSkyBlue
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlertAction1(Title: String , Message: String , ButtonTitle: String) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.appSkyBlue
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlertWithActionOkandCancel(Title: String , Message: String , OkButtonTitle: String ,CancelButtonTitle: String ,outputBlock:@escaping ()->Void) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.appSkyBlue
        alert.addAction(UIAlertAction(title: CancelButtonTitle, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: OkButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
            
            outputBlock()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showDefaultAlert(Message: String) {
        
        let alert = UIAlertController(title: "Unilife", message: Message, preferredStyle: UIAlertController.Style.alert)
        //         alert.setValue(NSAttributedString(title: ""!, attributes: [NSAttributedStringKey.font : UIFont(name: "Montserrat-Regular", size: 14) as Any,NSAttributedStringKey.foregroundColor : UIColor(red: 168/255, green: 12/255, blue: 94/255, alpha: 1.0)]), forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //        alert.addAction(title: "Ok".UIColor(red: 168/255, green: 12/255, blue: 94/255, alpha: 1.0))
        alert.view.tintColor = UIColor.appSkyBlue
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Calculate Total days
    
    func dateCalculator(createdDate : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let now = Date()
        let create = dateFormatter.date(from: createdDate)
        if create != nil{
            let calendar = Calendar.current
            let createdComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: create!, to: now)
            var year = createdComponents.year!
            var month = createdComponents.month!
            var day = createdComponents.day!
            var hour = createdComponents.hour!
            var minutes = createdComponents.minute!
            var seconds = createdComponents.second!
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
                    return ("\(month) month-\(day) day ago")
                }
                else{
                    return ("\(month) months-\(day) days ago")
                }
            }
            else  if(year ==  1){
                return ("\(year) year-\(month) month-\(day) day ago")
            }
            else{
                return ("\(year) years-\(month) months-\(day) days ago")
            }
        }
            
        else{
            return ""
        }
        
    }
    
 
}

class NavigationHandler {
    
    static var shared = NavigationHandler()
    
    var MiddleNavBarfunction : Any = ()
    var RightNavBarfunction : Any = ()
    var LeftNavBarfunction : Any = ()
    
}


