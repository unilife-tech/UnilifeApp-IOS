//
//  Constants.swift
//  Unilife
//
//  Created by Apple on 11/11/19.
//  Copyright © 2019 promatics. All rights reserved.
//


import Foundation

let BBVideoAlbumName = "Unilife"
let BBImageAlbumName = "Unilife"
let BBChatAlbumName = "Unilife"
let BBAudioFolderName = "Unilife"


let kShowDateFormate = "MMM dd, yyyy"
let kSendFormate = "yyyy/MM/dd"


import UIKit




class ConstantsHelper{
    static let BASE_URL = "http://15.206.103.14/api/wsapp/home/"
    static var AUTH_TOKEN = ""
    static var OtherUserID:Int = 0
    static var version:String = "2.1"
    static let Profile_highlight = BASE_URL+"user_highlights"
    static let user_skills = BASE_URL+"user_skills"
    static let user_course = BASE_URL+"user_course"
    
    
    static let user_languages = BASE_URL+"user_languages"
    static let user_interest = BASE_URL+"user_interest"
    
    static let user_experience = BASE_URL+"user_experience"
    static let user_achievements = BASE_URL+"user_achievements"
    static let user_education = BASE_URL+"user_education"
    static let user_social_profile = BASE_URL+"user_social_profile"
    
    static let get_all_profile_data = BASE_URL+"get_all_profile_data"
    static let profile_update = BASE_URL+"profile_update"
    static let UplaodImageURL = BASE_URL+"upload_image"
    static let upload_post_images = BASE_URL+"upload_post_images"
    
    static let create_pollURL = BASE_URL+"create_poll"
    static let create_eventURL = BASE_URL+"create_event"
    static let HomeURL = BASE_URL+"homepage_data"
    static let HomeMEdiaURL = BASE_URL+"create_post"
    static let HomeCreate_opinion = BASE_URL+"create_opinion"
    static let getComments = BASE_URL+"get_post_comment"
    static let select_poll_option = BASE_URL+"select_poll_option"
    static let personal_mission_update = BASE_URL+"personal_mission_update"
    static let delete_post = BASE_URL+"delete_post"
    
    static let reportPost = BASE_URL+"report_post"
    static let report_user = BASE_URL+"report_user"
    static let HeaderImageBrandBlog = BASE_URL+"get_banner"
    static let get_social_media_post = BASE_URL+"get_social_media_post"
    static let friend_req_accept_reject = BASE_URL+"friend_req_accept_reject"
    static let remove_member_from_group = BASE_URL+"remove_member_from_group"
    static let create_group = BASE_URL+"create_group"
    static let getNew_group = BASE_URL+"friend_req_listing"
    static let brand_detail = BASE_URL+"brand_detail"
    static let redeem_voucher = BASE_URL+"redeem_voucher"
    
    static let phone_number_get_univ_wise = BASE_URL+"phone_number_get_univ_wise"
    
    
    //... login
    static let university_schools_list = BASE_URL+"university_schools_list"
    static let email_verify = BASE_URL+"email_verify"
    static let register = BASE_URL+"register"
    static let add_university = BASE_URL+"add_university"
    static let get_uni_id_using_domain = BASE_URL+"get_uni_id_using_domain"
    
    static let categories_wise_offers_data = BASE_URL+"categories_wise_offers_data"
    static let categories_view_all_in_brand = BASE_URL+"categories_view_all_in_brand"
    static let brand_dataList = BASE_URL+"brand_data"
    
    static let event_link_counter_hit = BASE_URL+"event_link_counter_hit"
    static let otp_verify = BASE_URL+"otp_verify"
    

}
let appURL = "https://apps.apple.com/us/app/id1491474131"
let androidURL = "https://apps.apple.com/us/app/id1491474131"
let kInviteMessage = "Hey, let’s connect on Unilife, Unilife allows you to communicate easily in Uni and gives you access to students discounts and contents.\nFor Android: https://play.google.com/store/apps/details?id=unilife.com.unilife \nFor iPhone: https://apps.apple.com/us/app/id1491474131"



let FAILED_INTERNET = "Slow or no internet connections.\nPlease check your internet settings"

let API_FAILED = "Please check your network connection and try again. We could not process your request."


let msgTitle = "Unilife"
let msgInvalid = "Invalid URL"
let msgInvalidSkills = "Please select some skills"
let msgEnterPoll = "Please enter question"
let msgEnterOption = "Please enter option"

let msgEnterDes = "Please enter description"

let msgEnterEventTitle = "Please enter title"
//let msgEnterEventLink = "Please enter registration link"
let msgEnterEventDes = "Please enter description"
let msgEnterEventImage = "Please select event image"

let msgMediaImage = "Please select photo/vidoe"
let msgMediaDes = "Please enter caption"

let mDeleteEducation_message = "Are you sure you want to delete Education?"
let mDeleteAchivement_message = "Are you sure you want to delete Achivement?"
let mDeleteExperience_message = "Are you sure you want to delete Experience?"

let kmsgSchool = "Please enter school name"
let kmsgEmail = "Please enter email address"
let kmsgOTP = "Please enter otp"
let kmsgValidOTP = "Please enter valid otp"
let kmsgCEmail = "Please enter confirm email address"
let kmsgFname = "Please enter first name"
let kmsgLname = "Please enter last name"
let kmsgdob = "Please select date of birth "

let kmsgPass = "Please enter password"
let kmsgCpass = "Please enter confirm password"
let kmsgPassNotMatch = "password does not match"


let kmsgCountryCode = "Please select country"
let kmsgMobi = "Please enter mobile number"
let kmsgMobiValid = "Please enter valid mobile number"

let kmsgValidEmail = "Please enter valid email address"
let kmsgValidCEmail = "Email not match"

let kmsgUniversityname = "Please enter university name"
let kmsgDomain = "Please enter university domain"
let kmsgDomainStartAtTheRate = "Please enter valid domain for example @abc.com"
let kmsgSettingContact = "Please turn on contact settings to found friends with your contact."



let kmsgCode = "Please enter code"
let kmsgVCode = "Please enter valid Code"
let kmsgLocation = "Please enter Location"
let kmsgReceiptNumber = "Please enter Receipt number"
let kExpireVersion = "New version is available in store kindly update"
let VERSION_EX_TITLE = "Update Your App"
let VERSION_EX_MSG = "Looks like we need to put you on the latest version of Unilife."


extension Notification.Name {
    static let receivepaymentSuccess = Notification.Name("receivepaymentSuccess")
    
    

}





extension UIView {
     func roundCornersvg(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

///... this is for delete background color table from swipe view 
extension UIView {
    var allSubViews : [UIView] {
        var array = [self.subviews].flatMap {$0}
        array.forEach { array.append(contentsOf: $0.allSubViews) }
        return array
    }
}

