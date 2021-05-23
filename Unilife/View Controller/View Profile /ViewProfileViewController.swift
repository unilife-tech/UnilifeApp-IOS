//
//  ViewProfileViewController.swift
//  Unilife
//
//  Created by promatics on 21/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit


struct  sectionData {
    
    let title: [String]
    
    let Image: [String]
    
    let data: [String]
    
    var numberOfItems:Int {
        
        return data.count
    }
    
    subscript(index:Int) -> String{
        return data[index]
    }
}

extension sectionData {
    init(title: String, data: String, image: String) {
        self.title = [title]
        self.data  = [data]
        self.Image = [image]
        
        
    }
    
}

class ViewProfileViewController: UIViewController {
    
    // MARK: - Outlet
    
    @IBOutlet var topBackground_ImageView: UIImageView!
    
    @IBOutlet var profile_ImageView: UIImageView!
    
    @IBOutlet var nameValue_lbl: UILabel!
    
    @IBOutlet var educationValue_lbl: UILabel!
    
    @IBOutlet var bioTitle_lbl: UILabel!
    
    @IBOutlet var bioValue_lbl: UILabel!
    
    @IBOutlet var selectCommericalSkills_CollectionView: UICollectionView!
    
    @IBOutlet var hobbies_CollectionView: UICollectionView!
    
    @IBOutlet var interest_CollectionView: UICollectionView!
    
    @IBOutlet var aboutInformationDetail_TableView: UITableView!
    
    @IBOutlet var aboutInformationFooter_View: UIView!
    
    @IBOutlet var secondLastQuestionName_lbl: UILabel!
    
    @IBOutlet var lastQuestionsName_lbl: UILabel!
    
    @IBOutlet weak var header_View: UIView!
    
    @IBOutlet weak var hoobiesCollectionView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var intersetsCollectionView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var selectCommericalSkillsCollectionView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var profileStatus_lbl: UILabel!
    
    @IBOutlet weak var onlyMe_btn: UIButton!
    
    @IBOutlet weak var private_btn: UIButton!
    
    @IBOutlet weak var public_btn: UIButton!
    
    @IBOutlet weak var selectProfileStatus_View: UIStackView!
    
    @IBOutlet weak var aboutInformationTableView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var profileStatusLabel_height: NSLayoutConstraint!
    
    @IBOutlet weak var profileStatusStack_Height: NSLayoutConstraint!
    
    @IBOutlet weak var edit_btn: UIButton!
    
    @IBOutlet weak var NavigationHeader_lbl: UILabel!
    
    @IBOutlet weak var loginAsUser_lbl: UILabel!
    
    @IBOutlet weak var front_View: UIView!
    
    
    // MARK: - Varibale
    
    //    var aboutInformationDetailImageArray = [UIImage(named: "education_Icon"), UIImage(named: "expirence_Icon"), UIImage(named: "skill_Icon"), UIImage(named: "Achivement_Icon"), UIImage(named: "langauge_Icon")]
    
    var aboutInformationDetailImageArray = [String]()
    
    //    var aboutInformationDetailSectionNameArray = ["Education", "Expirence", "Skills", "Achievements", "languages"] // "Hobbies", "Intersets"
    
    var aboutInformationDetailSectionNameArray = [String]()
    
    //    var aboutInformationArray = ["Studying at University of Dubai", "joined Beta Gamma Sigma (BGS) UD Chapter", "Started BBA at University of Dubai", "Gradurated from  Glisten International Academy", "Attend... School", "Lives In Dubai", "More"]
    
    var aboutInformationArray = [String]()
    
    //    var aboutInformationImageArray = [UIImage(named: "study_Icon"), UIImage(named: "blackCap_icon"), UIImage(named: "blackCap_icon"), UIImage(named: "homeBlack_Icon"), UIImage(named: "mapmarkerBlack_Icon"), UIImage(named: "destination_Icon"), UIImage(named: "more_Icon")]
    
    var aboutInformationImageArray = [String]()
    
    //    var aboutInformationDetailAnswerArray = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500"]
    
    var aboutInformationDetailAnswerArray = [String]()
    
    
    lazy var mySections:[sectionData] = {
        
        let section0 = sectionData(title: [], Image: aboutInformationImageArray, data: aboutInformationArray)
        
        let section1 = sectionData(title: aboutInformationDetailSectionNameArray, Image: aboutInformationDetailImageArray , data: aboutInformationDetailAnswerArray)
        let section2 = sectionData(title: aboutInformationDetailSectionNameArray, Image: aboutInformationDetailImageArray , data: aboutInformationDetailAnswerArray)
        let section3 = sectionData(title: aboutInformationDetailSectionNameArray, Image: aboutInformationDetailImageArray , data: aboutInformationDetailAnswerArray)
        let section4 = sectionData(title: aboutInformationDetailSectionNameArray, Image: aboutInformationDetailImageArray , data: aboutInformationDetailAnswerArray)
        let section5 = sectionData(title: aboutInformationDetailSectionNameArray, Image: aboutInformationDetailImageArray, data: aboutInformationDetailAnswerArray)
        
        
        return [section0, section1, section2, section3, section4, section5]
    }()
    
    var selectCommericalSkillsNameArray = ["Entrepreneurship", "Capstone", "Finace", "Communication Skills"]
    
    var selectCommericalSkillsArray = [[String: AnyObject]]()
    
    var selectHobbiesArray = [[String: AnyObject]]()
    
    var selectInterestsArray = [[String: AnyObject]]()
    
    var viewProfileData : ShowCompleteProfileData?
    
    var userId = ""
    
    var condition = ""
    
    var filterArray = [Row1]()
    
    var post_id = ""
    
    var postUser_id = ""
    
    var viewUserProfile = ""
    
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.selectCommericalSkills_CollectionView.register(UINib(nibName: "ViewProfileCollectionView", bundle: nil), forCellWithReuseIdentifier: "ViewProfileCollectionViewCell")
        
        self.hobbies_CollectionView.register(UINib(nibName: "ViewProfileCollectionView", bundle: nil), forCellWithReuseIdentifier: "ViewProfileCollectionViewCell")
        
        self.interest_CollectionView.register(UINib(nibName: "ViewProfileCollectionView", bundle: nil), forCellWithReuseIdentifier: "ViewProfileCollectionViewCell")
        
        if self.post_id != "" {
            
            self.PostUserProfileData()
            
            self.NavigationHeader_lbl.text! = " Account "
            
            self.loginAsUser_lbl.isHidden = true
            
        }else {
            
            profileData()
            
            self.NavigationHeader_lbl.text! = "My Account"
            
            if UserData().user_type == "0"{
                
                self.loginAsUser_lbl.text! = ""
                
                self.loginAsUser_lbl.text! = "Student"
                
            }else if UserData().user_type == "1"{
                
                self.loginAsUser_lbl.text! = ""
                
                self.loginAsUser_lbl.text! = "Staff Facility"
                
            }else if UserData().user_type == "2"{
                
                self.loginAsUser_lbl.text! = ""
                
                self.loginAsUser_lbl.text! = "Teacher"
                
                
            }
            
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // self.front_View.layoutIfNeeded()
        
    }
    
    func updateTableHeight(){
        var frame = self.aboutInformationDetail_TableView.frame
        frame.size.height = self.aboutInformationDetail_TableView.contentSize.height
        self.aboutInformationDetail_TableView.frame = frame
        self.aboutInformationDetail_TableView.reloadData()
        self.aboutInformationDetail_TableView.layoutIfNeeded()
        self.aboutInformationTableView_Height.constant = CGFloat(self.aboutInformationDetail_TableView.contentSize.height)
    }
    
    deinit {
        print(#file)
    }
    
    
    // MARK: - Button Action
    
    
    @IBAction func tapEdit_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        
        self.mySections.removeAll()
        self.aboutInformationArray.removeAll()
        self.aboutInformationImageArray.removeAll()
        self.aboutInformationDetailSectionNameArray.removeAll()
        self.aboutInformationDetailAnswerArray.removeAll()
        self.aboutInformationDetailImageArray.removeAll()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func tapBack_btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension ViewProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return filterArray.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //        if section == 0 {
        //
        //            return UIView()
        //
        //        }else {
        
        if self.filterArray[section].questionType == "simple" {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            
            let questionImage = UIImageView(frame: CGRect(x: 10, y: 0, width: 30, height: 30))
            
            let sectionname = UILabel(frame: CGRect(x:  50, y: 0, width: (tableView.frame.size.width - 30 ), height: 40))
            
            
            sectionname.numberOfLines = 0
            
            
            
            
            sectionname.text =  self.filterArray[section + 0].question
            
            
            questionImage.downLoadImage(ImageURL: categoryImageUrl + self.filterArray[section + 0].image!)
            
            //}
            
            sectionname.backgroundColor = UIColor.white
            
            sectionname.font = UIFont(name: "Arcon-Regular", size: 15)
            
            sectionname.textColor = UIColor.appSkyBlue
            
            view.addSubview(sectionname)
            
            view.addSubview(questionImage)
            
            self.view.addSubview(view)
            
            return view
            
        }else {
            
            return UIView()
        }
        
        //}
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        if section == 0 {
        //
        //            return UITableView.automaticDimension
        
        
        //}else {
        
        if self.filterArray[section].questionType == "simple" {
            
            
            return 40
            
        }else {
            
            return 0
        }
        //}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(filterArray[section].questionType, filterArray[section].quesAnswers?.first?.answer?.components(separatedBy: "\n").count, filterArray[section].question)
        
        if self.filterArray[section].questionType == "simple" {
            
            if (self.filterArray[section].quesAnswers?.first?.answer)?.contains("\n") ?? false {
                
                let fullAnswerArray = (self.filterArray[section].quesAnswers?.first?.answer)?.components(separatedBy: "\n")
                
                //  let mapped: [String?] = fullAnswerArray.map({$0 }) ?? <#default value#>
                
                let dataArray : [String] = fullAnswerArray!.filter( {$0 != ""}).map({ return $0})
                
                return dataArray.count
                
            }else {
                
                return filterArray[section].quesAnswers?.count ?? 0
                
            }
            
        }else {
            
            return filterArray[section].quesAnswers?.count ?? 0
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.aboutInformationDetail_TableView.dequeueReusableCell(withIdentifier: "ViewProfileTableViewCell") as! ViewProfileTableViewCell
        
        if filterArray[indexPath.section].questionType == "simple" {
            
            
            if (self.filterArray[indexPath.section].quesAnswers?.first?.answer)?.contains("\n") ?? false {
                
                let fullAnswerArray = (self.filterArray[indexPath.section].quesAnswers?.first?.answer)?.components(separatedBy: "\n")
                
                //                let mapped: [String?] = fullAnswerArray.map({$0 })
                //
                let dataArray : [String] = fullAnswerArray!.filter( {$0 != ""}).map({ return $0})
                
                //   let mmaapp : [String] = fullAnswerArray!.map({$0 != ""})
                
                cell.description_lbl.text =  dataArray[indexPath.row].replacingOccurrences(of: " ", with: "")
                
            }else {
                
                cell.description_lbl.text =  (self.filterArray[indexPath.section].quesAnswers?.first?.answer?.replacingOccurrences(of: " ", with: ""))
                
            }
            
            cell.description_ImageView.image = UIImage(named: "circleWithInnerCircle")
            
        }else{
            
            
            cell.description_lbl.text =  (self.filterArray[indexPath.section].quesAnswers?.first?.answer?.replacingOccurrences(of: "\n", with: " "))
            
            cell.description_ImageView.sd_setImage(with: URL(string:categoryImageUrl + self.filterArray[indexPath.section].image!), placeholderImage: UIImage(named: "noimage_icon"))
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    
    
}

// MARK: - Collection View Delegate

extension ViewProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView ==  selectCommericalSkills_CollectionView {
            
            return self.viewProfileData?.userDetail.userCourseCovered?.count ??  0
            
        }else if collectionView == hobbies_CollectionView {
            return self.viewProfileData?.userDetail.userHobbies?.count ?? 0
            
        }else {
            
            return self.viewProfileData?.userDetail.userHobbiesInterests?.count ?? 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView ==  selectCommericalSkills_CollectionView {
            
            let cell = self.selectCommericalSkills_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewProfileCollectionViewCell", for: indexPath) as! ViewProfileCollectionViewCell
            
            cell.descriptionValue_lbl.text = self.viewProfileData?.userDetail.userCourseCovered?[indexPath.row].answer
            
            //            [UIImage(named: "education_Icon"), UIImage(named: "expirence_Icon"), UIImage(named: "skill_Icon"), UIImage(named: "Achivement_Icon"), UIImage(named: "langauge_Icon")]
            
            if self.viewProfileData?.userDetail.userCourseCovered?[indexPath.row].courseID == 0 {
                
                cell.description_ImageView.image = UIImage(named: "education_Icon")
                
            }else if self.viewProfileData?.userDetail.userCourseCovered?[indexPath.row].courseID == 1 {
                
                cell.description_ImageView.image = UIImage(named: "expirence_Icon")
                
                
            }else if self.viewProfileData?.userDetail.userCourseCovered?[indexPath.row].courseID == 2 {
                
                cell.description_ImageView.image = UIImage(named: "skill_Icon")
                
                
            }else if self.viewProfileData?.userDetail.userCourseCovered?[indexPath.row].courseID == 3 {
                
                cell.description_ImageView.image = UIImage(named: "Achivement_Icon")
                
            }else if self.viewProfileData?.userDetail.userCourseCovered?[indexPath.row].courseID == 4 {
                
                cell.description_ImageView.image = UIImage(named: "langauge_Icon")
                
                
            }else  {
                
                cell.description_ImageView.image = UIImage(named: "bunchBook_icon")
                
                
            }
            
            //            cell.description_ImageView.sd_setImage(with: URL(string: categoryImageUrl + (self.viewProfileData?.userDetail.userCourseCovered?[indexPath.row].categoriesIconProfiles.categoriesIcon)!), placeholderImage: UIImage(named: ""))
            
            
            return cell
        }else if collectionView == hobbies_CollectionView {
            let cell = self.hobbies_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewProfileCollectionViewCell", for: indexPath) as! ViewProfileCollectionViewCell
            
            cell.descriptionValue_lbl.text = self.viewProfileData?.userDetail.userHobbies?[indexPath.row].hobbies?.name ?? ""
            
            cell.description_ImageView.sd_setImage(with: URL(string: categoryImageUrl + (self.viewProfileData?.userDetail.userHobbies?[indexPath.row].hobbies?.icon)!), placeholderImage: UIImage(named: ""))
            
            
            return cell
            
        }else {
            
            let cell = self.interest_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewProfileCollectionViewCell", for: indexPath) as! ViewProfileCollectionViewCell
            
            cell.descriptionValue_lbl.text = self.viewProfileData?.userDetail.userHobbiesInterests?[indexPath.row].hobbiesInterests?.name
            
            cell.description_ImageView.sd_setImage(with: URL(string: categoryImageUrl + (self.viewProfileData?.userDetail.userHobbiesInterests?[indexPath.row].hobbiesInterests?.icon)!), placeholderImage: UIImage(named: ""))
            
            
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100
            , height: 104 )
    }
    
    // self.selectCommericalSkills_CollectionView.frame.size.width
    
    
}

// MARK: - Profile Service Response

extension ViewProfileViewController {
    
    // MARK: - Profile Data
    
    func profileData() {
        
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId]  as [String: AnyObject]
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "view_profile_questions_answer", params: param as [String: AnyObject]) {[weak self ]  (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [String: AnyObject]else {
                        
                        return
                    }
                    
                    do{
                        
                        self.mySections.removeAll()
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.viewProfileData = try JSONDecoder().decode(ShowCompleteProfileData.self, from: jsonData)
                        
                        //let profileDataCount = self.viewProfileData?.userQuesAns.rows.count ?? 0
                        
                        let simpleQuestionFilterArray  = (self.viewProfileData?.userQuesAns.rows?.filter({$0.questionType == "simple" && $0.quesAnswers?.count != 0 &&  $0.quesAnswers?.first?.answer != ""}))!
                        
                        let profileQuestionFilterArray = (self.viewProfileData?.userQuesAns.rows?.filter({$0.questionType == "personal_info" && $0.quesAnswers?.count != 0  && $0.quesAnswers?.first?.answer != ""} ))!
                        
                        //self.filterArray = filterArray ?? 0
                        
                        self.filterArray =  profileQuestionFilterArray + simpleQuestionFilterArray
                        
                        let profileDataCount = self.viewProfileData?.userQuesAns.rows?.count ?? 0
                        
                        
                        let aboutInfoArray = (self.viewProfileData?.userQuesAns.rows?.filter({$0.questionType == "user_info"}))!
                        
                        for i in 0..<profileDataCount {
                            
                            if self.viewProfileData?.userQuesAns.rows?[i].questionType == "name" {
                                
                                if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer?.count != 0 {
                                    
                                    if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer != "" {
                                        
                                        self.nameValue_lbl.text! = self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer ?? ""
                                    }else {
                                        
                                        self.nameValue_lbl.text! = "N/A"
                                        
                                    }
                                    
                                }else {
                                    
                                    self.nameValue_lbl.text! = "N/A"
                                    
                                }
                                
                            }else if self.viewProfileData?.userQuesAns.rows?[i].questionType == "bio" {
                                
                                if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer?.count != 0 {
                                    
                                    if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer != "" {
                                        
                                        self.bioValue_lbl.text! = self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer ?? ""
                                    }else {
                                        
                                        self.bioValue_lbl.text! = "N/A"
                                        
                                    }
                                }else {
                                    
                                    self.bioValue_lbl.text! = "N/A"
                                    
                                }
                                
                                
                                
                            }else if self.viewProfileData?.userQuesAns.rows?[i].questionType == "studies" {
                                
                                //                                if   self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer?.count != 0 {
                                //
                                //                                    if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer != "" {
                                //
                                //                                        self.educationValue_lbl.text! = self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer ?? ""
                                //                                    }else {
                                //
                                //                                        self.educationValue_lbl.text! = "N/A"
                                //
                                //                                    }
                                //
                                //                                }
                                //                                else {
                                //
                                //                                    self.educationValue_lbl.text! = "N/A"
                                //                                }
                            }
                        }
                        
                        self.educationValue_lbl.text! = Singleton.sharedInstance.universityName ?? ""
                        
                        if self.viewProfileData?.userDetail.profileImage == nil {
                            
                            self.profile_ImageView.image = UIImage(named: "userProfile_ImageView")
                            
                        }else {
                            
                            self.profile_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.viewProfileData?.userDetail.profileImage)!), placeholderImage: UIImage(named: "userProfile_ImageView"))
                            
                        }
                        
                        
                        if self.viewProfileData?.userDetail.userCourseCovered?.count == 0{
                            self.selectCommericalSkills_CollectionView.isHidden = true
                            self.selectCommericalSkillsCollectionView_Height.constant = 0
                            
                        }else {
                            
                            self.selectCommericalSkills_CollectionView.isHidden = false
                            self.selectCommericalSkillsCollectionView_Height.constant = 130
                            //                            self.selectCommericalSkills_CollectionView.isHidden = true
                            //                            self.selectCommericalSkillsCollectionView_Height.constant = 0
                            
                            
                        }
                        if self.viewProfileData?.userDetail.userHobbies?.count == 0  {
                            
                            self.hoobiesCollectionView_Height.constant = 0
                            
                            self.secondLastQuestionName_lbl.isHidden = true
                        }else {
                            
                            self.hoobiesCollectionView_Height.constant = 100
                            
                            self.secondLastQuestionName_lbl.isHidden = false
                            
                            
                        }
                        
                        
                        if self.viewProfileData?.userDetail.userHobbiesInterests?.count == 0  {
                            
                            self.intersetsCollectionView_Height.constant = 0
                            
                            self.lastQuestionsName_lbl.isHidden = true
                            
                        }
                        else {
                            
                            self.intersetsCollectionView_Height.constant = 100
                            
                            self.lastQuestionsName_lbl.isHidden = false
                            
                            
                        }
                        
                        print(self.mySections)
                        
                        
                        
                        if self.viewProfileData?.userDetail.profileImage == nil {
                            
                            self.profile_ImageView.image = UIImage(named: "userProfile_ImageView")
                            
                        }else {
                            
                            self.profile_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.viewProfileData?.userDetail.profileImage)!), placeholderImage: UIImage(named: "userProfile_ImageView"))
                            
                        }
                        
                        
                        
                        
                        if self.viewProfileData?.userDetail.profileStatus != nil {
                            
                            //                            self.profileStatus_lbl.isHidden = false
                            //
                            //                            self.selectProfileStatus_View.isHidden = false
                            //
                            //
                            //                            if self.viewProfileData?.userDetail.profileStatus == "public" {
                            //
                            //                                self.public_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                            //
                            //                            }else if  self.viewProfileData?.userDetail.profileStatus == "private" {
                            //                                self.private_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                            //
                            //                            }else {
                            //
                            //                                self.onlyMe_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                            //                            }
                            
                            self.selectProfileStatus_View.isHidden = true
                            
                            self.profileStatusLabel_height.constant = 0
                            
                            self.profileStatusStack_Height.constant = 0
                            
                            self.profileStatus_lbl.isHidden = true
                        }else {
                            
                            self.profileStatusLabel_height.constant = 0
                            
                            self.profileStatusStack_Height.constant = 0
                            
                            self.selectProfileStatus_View.isHidden = true
                            
                            self.profileStatus_lbl.isHidden = true
                            
                        }
                        
                        //                        self.aboutInformationDetail_TableView.tableFooterView = self.aboutInformationFooter_View
                        
                        //                        self.aboutInformationDetail_TableView.tableHeaderView = self.header_View
                        
                        
                        
                        self.aboutInformationDetail_TableView.delegate = self
                        self.aboutInformationDetail_TableView.dataSource = self
                        
                        self.selectCommericalSkills_CollectionView.delegate = self
                        self.selectCommericalSkills_CollectionView.dataSource = self
                        
                        self.hobbies_CollectionView.delegate = self
                        self.hobbies_CollectionView.dataSource = self
                        
                        self.interest_CollectionView.delegate = self
                        self.interest_CollectionView.dataSource = self
                        
                        self.selectCommericalSkills_CollectionView.reloadData()
                        
                        self.hobbies_CollectionView.reloadData()
                        
                        self.interest_CollectionView.reloadData()
                        
                        self.aboutInformationDetail_TableView.reloadData()
                        
                        self.updateTableHeight()
                        
                    }catch {
                        
                        print(error.localizedDescription)
                        
                        
                    }
                    
                    
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
        }
        
    }
    
    // MARK: - Post User Profile Data
    
    func PostUserProfileData(){
        
        self.edit_btn.isHidden = true
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId, "post_user_id": self.post_id]  as [String: AnyObject]
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "show_user_detail", params: param as [String: AnyObject]) {[weak self]  (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [String: AnyObject]else {
                        
                        return
                    }
                    
                    do{
                        
                        self.mySections.removeAll()
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.viewProfileData = try JSONDecoder().decode(ShowCompleteProfileData.self, from: jsonData)
                        
                        //let profileDataCount = self.viewProfileData?.userQuesAns.rows.count ?? 0
                        
                        if  self.viewProfileData?.userDetail.profileStatus ?? "" == "public" {
                            
                            let simpleQuestionFilterArray  = (self.viewProfileData?.userQuesAns.rows?.filter({$0.questionType == "simple" && $0.quesAnswers?.count != 0 &&  $0.quesAnswers?.first?.answer != ""}))!
                            
                            let profileQuestionFilterArray = (self.viewProfileData?.userQuesAns.rows?.filter({$0.questionType == "personal_info" && $0.quesAnswers?.count != 0  && $0.quesAnswers?.first?.answer != ""} ))!
                            
                            //self.filterArray = filterArray ?? 0
                            
                            self.filterArray =  profileQuestionFilterArray + simpleQuestionFilterArray
                            
                            let profileDataCount = self.viewProfileData?.userQuesAns.rows?.count ?? 0
                            
                            
                            let aboutInfoArray = (self.viewProfileData?.userQuesAns.rows?.filter({$0.questionType == "user_info"}))!
                            
                            for i in 0..<profileDataCount {
                                
                                
                                
                                if self.viewProfileData?.userQuesAns.rows?[i].questionType == "name" {
                                    
                                    if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer?.count != 0 {
                                        
                                        if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer != "" {
                                            
                                            self.nameValue_lbl.text! = self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer ?? ""
                                        }else {
                                            
                                            self.nameValue_lbl.text! = "N/A"
                                            
                                        }
                                        
                                    }else {
                                        
                                        self.nameValue_lbl.text! = "N/A"
                                        
                                    }
                                    
                                }else if self.viewProfileData?.userQuesAns.rows?[i].questionType == "bio" {
                                    
                                    if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer?.count != 0 {
                                        
                                        if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer != "" {
                                            
                                            self.bioValue_lbl.text! = self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer ?? ""
                                        }else {
                                            
                                            self.bioValue_lbl.text! = "N/A"
                                            
                                        }
                                    }else {
                                        
                                        self.bioValue_lbl.text! = "N/A"
                                        
                                    }
                                    
                                    
                                    
                                }else if self.viewProfileData?.userQuesAns.rows?[i].questionType == "studies" {
                                    
                                    //                                if   self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer?.count != 0 {
                                    //
                                    //                                    if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer != "" {
                                    //
                                    //                                        self.educationValue_lbl.text! = self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer ?? ""
                                    //                                    }else {
                                    //
                                    //                                        self.educationValue_lbl.text! = "N/A"
                                    //
                                    //                                    }
                                    //
                                    //                                }
                                    //                                else {
                                    //
                                    //                                    self.educationValue_lbl.text! = "N/A"
                                    //                                }
                                }
                            }
                            
                            self.educationValue_lbl.text! = Singleton.sharedInstance.universityName ?? ""
                            
                            //                        if self.viewProfileData?.userDetail.profileImage == nil {
                            //
                            //                            self.profile_ImageView.image = UIImage(named: "userProfile_ImageView")
                            //
                            //                        }else {
                            //
                            //                            self.profile_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.viewProfileData?.userDetail.profileImage)!), placeholderImage: UIImage(named: "userProfile_ImageView"))
                            //
                            //                        }
                            
                            
                            if self.viewProfileData?.userDetail.userCourseCovered?.count == 0{
                                self.selectCommericalSkills_CollectionView.isHidden = true
                                self.selectCommericalSkillsCollectionView_Height.constant = 0
                                
                            }else {
                                
                                self.selectCommericalSkills_CollectionView.isHidden = false
                                self.selectCommericalSkillsCollectionView_Height.constant = 130
                                //                            self.selectCommericalSkills_CollectionView.isHidden = true
                                //                            self.selectCommericalSkillsCollectionView_Height.constant = 0
                                
                                
                            }
                            if self.viewProfileData?.userDetail.userHobbies?.count == 0  {
                                
                                self.hoobiesCollectionView_Height.constant = 0
                                
                                self.secondLastQuestionName_lbl.isHidden = true
                            }else {
                                
                                self.hoobiesCollectionView_Height.constant = 100
                                
                                self.secondLastQuestionName_lbl.isHidden = false
                                
                                
                            }
                            
                            
                            if self.viewProfileData?.userDetail.userHobbiesInterests?.count == 0  {
                                
                                self.intersetsCollectionView_Height.constant = 0
                                
                                self.lastQuestionsName_lbl.isHidden = true
                                
                            }
                            else {
                                
                                self.intersetsCollectionView_Height.constant = 100
                                
                                self.lastQuestionsName_lbl.isHidden = false
                                
                                
                            }
                            
                            
                            self.aboutInformationDetail_TableView.delegate = self
                            self.aboutInformationDetail_TableView.dataSource = self
                            
                            self.selectCommericalSkills_CollectionView.delegate = self
                            self.selectCommericalSkills_CollectionView.dataSource = self
                            
                            self.hobbies_CollectionView.delegate = self
                            self.hobbies_CollectionView.dataSource = self
                            
                            self.interest_CollectionView.delegate = self
                            self.interest_CollectionView.dataSource = self
                            
                            self.updateTableHeight()
                            
                            self.selectCommericalSkills_CollectionView.reloadData()
                            
                            self.hobbies_CollectionView.reloadData()
                            
                            self.interest_CollectionView.reloadData()
                            
                            self.aboutInformationDetail_TableView.reloadData()
                            
                            print(self.mySections)
                            
                            
                        }else if self.viewProfileData?.userDetail.profileStatus ?? "" == "private" || self.viewProfileData?.userDetail.profileStatus == "onlyme" {
                            
                            let profileDataCount = self.viewProfileData?.userQuesAns.rows?.count ?? 0
                            
                            for i in 0..<profileDataCount {
                                
                                
                                
                                if self.viewProfileData?.userQuesAns.rows?[i].questionType == "name" {
                                    
                                    if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer?.count != 0 {
                                        
                                        if self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer != "" {
                                            
                                            self.nameValue_lbl.text! = self.viewProfileData?.userQuesAns.rows?[i].quesAnswers?.first?.answer ?? ""
                                        }else {
                                            
                                            self.nameValue_lbl.text! = "N/A"
                                            
                                        }
                                        
                                    }else {
                                        
                                        self.nameValue_lbl.text! = "N/A"
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            self.selectCommericalSkills_CollectionView.isHidden = true
                            self.selectCommericalSkillsCollectionView_Height.constant = 0
                            
                            self.hoobiesCollectionView_Height.constant = 0
                            
                            self.hobbies_CollectionView.isHidden = true
                            
                            self.secondLastQuestionName_lbl.isHidden = true
                            
                            self.intersetsCollectionView_Height.constant = 0
                            
                            self.lastQuestionsName_lbl.isHidden = true
                            
                            self.lastQuestionsName_lbl.isHidden = true
                            
                            self.bioTitle_lbl.isHidden = true
                            self.bioValue_lbl.isHidden = true
                            self.educationValue_lbl.isHidden = true
                            
                        }
                        
                        if self.viewProfileData?.userDetail.profileImage == nil {
                            
                            self.profile_ImageView.image = UIImage(named: "userProfile_ImageView")
                            
                        }else {
                            
                            self.profile_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.viewProfileData?.userDetail.profileImage)!), placeholderImage: UIImage(named: "userProfile_ImageView"))
                            
                        }
                        
                        if self.viewProfileData?.userDetail.profileStatus != nil {
                            
                            //                            self.profileStatus_lbl.isHidden = false
                            //
                            //                            self.selectProfileStatus_View.isHidden = false
                            //
                            //
                            //                            if self.viewProfileData?.userDetail.profileStatus == "public" {
                            //
                            //                                self.public_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                            //
                            //                            }else if  self.viewProfileData?.userDetail.profileStatus == "private" {
                            //                                self.private_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                            //
                            //                            }else {
                            //
                            //                                self.onlyMe_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                            //                            }
                            
                            self.selectProfileStatus_View.isHidden = true
                            
                            self.profileStatusLabel_height.constant = 0
                            
                            self.profileStatusStack_Height.constant = 0
                            
                            self.profileStatus_lbl.isHidden = true
                        }else {
                            
                            self.profileStatusLabel_height.constant = 0
                            
                            self.profileStatusStack_Height.constant = 0
                            
                            self.selectProfileStatus_View.isHidden = true
                            
                            self.profileStatus_lbl.isHidden = true
                            
                        }
                        
                        //                        self.aboutInformationDetail_TableView.tableFooterView = self.aboutInformationFooter_View
                        
                        //                        self.aboutInformationDetail_TableView.tableHeaderView = self.header_View
                        
                        
                    }catch {
                        
                        print(error.localizedDescription)
                        
                        
                    }
                    
                    
                }else {
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
            }
        }
        
    }
    
}
