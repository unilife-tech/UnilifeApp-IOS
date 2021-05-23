import UIKit
import TOCropViewController
import SDWebImage

class CompleteProfileViewController: UIViewController  {
    
    // MARK: - Outlet
    @IBOutlet var profile_ImageView: CircleImage!
    
    @IBOutlet var completeProfile_TableView: UITableView!
    
    @IBOutlet weak var profileImageView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var profileImageView_Width: NSLayoutConstraint!
    
    @IBOutlet weak var completeProfileTableView_Top: NSLayoutConstraint!
    
    @IBOutlet weak var submit_btn: SetButton!
    
    @IBOutlet weak var previous_btn: SetButton!
    
    @IBOutlet weak var skip_btn: UIButton!
    
    @IBOutlet weak var profileStatus_lbl: UILabel!
    
    @IBOutlet weak var onlyMe_btn: UIButton!
    
    @IBOutlet weak var private_btn: UIButton!
    
    @IBOutlet weak var profile_btn: UIButton!
    
    @IBOutlet weak var selectProfile_View: UIStackView!
    
    @IBOutlet weak var selectProfileView_height: NSLayoutConstraint!
    
    // MARK: - Variable
    
    var questionArray = [[String: AnyObject]]()
    
    var nextQuestionArray = [[String: AnyObject]]()
    
    let image_picker = UIImagePickerController()
    
    var cropStyle:TOCropViewCroppingStyle?
    
    var cropViewController = TOCropViewController()
    
    var completeProfile: CompleteProfile?
    
    var showAnswerData: ShowCompleteProfileData?
    
    var pageCount: Int = 0
    
    var arrayCount: Int = 0
    
    var selectedTextView:Int = -1
    
    var selectTextViewArray = [Int]()
    
    var sectionDict = [Int: String]()
    
    var hobbiesIdArray : NSArray = []
    
    var intersetIdArray : NSArray = []
    
    var categoriesArray : NSArray = []
    
    var userId = ""
    
    var currentOffset:Int = -1
    
    var previousArrayCount: Int = 0
    
    var conditionFlag = ""
    
    var buttonCondition = ""
    
    var selectProfile = ""
    
    var previousQuestionCondition = ""
    
    var checkOffsetValue: Int = 0
    
    var indexDictionaryStoredArray = [Int :[Int: String]]() // ANswers jd vi type kra ge eathe store ho ju ge
    
    var indexDictionaryQuestionStoredArray = [Int :[Int: String]]() // questions page according store ho ju ge
    
    var indexDictionaryIdStoredArray = [Int :[Int: String]]() // questions di id store ho ju gi
    
    var indexTypedArray = [Int :[Int: Bool]]() // questions di id store ho ju gi
    
    var indexArray : [Int] = [] //index kede kede te aasi type kita hai
    
    var isIncreMented = true
    
    var tempCategories = ""
    
    var indexDropDownValie = 0
    
    var categoriesNewId = ""
    
    var hoobiesId = ""
    
    var intersetId = ""
    
    var previusArrayStoredCount = 0
    
    //  MARK:- Default View
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.indexDictionaryIdStoredArray.removeAll()
        
        self.indexDictionaryStoredArray.removeAll()
        
        self.indexDictionaryQuestionStoredArray.removeAll()
        
        self.indexArray.removeAll()
        
        self.indexTypedArray.removeAll()
        
        self.pageCount = 0
        
        self.setProfileQuestion(offset: 0)
        
        self.completeProfile_TableView.register(UINib(nibName: "CompleteProfile", bundle: nil
        ), forCellReuseIdentifier: "CompleteProfileTableViewCell")
        
        self.previous_btn.isHidden = true
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    // MARK: - Complete profile Question Service
    
    
    func setProfileQuestion(offset: Int) {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_profile_questions/\(offset)"){ (receviedData) in
            
            // print(receviedData)
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.skip_btn.isUserInteractionEnabled = true
                    
                    self.submit_btn.isUserInteractionEnabled = true
                    
                    guard let data = receviedData["data"] as? [String:AnyObject] else {
                        
                        return
                        
                    }
                    
                    do {
                        
                        let jasonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.completeProfile = try newJSONDecoder().decode(CompleteProfile.self, from: jasonData)
                        
                        self.checkOffsetValue = offset + 1
                        
                        if  self.conditionFlag == "Previous"{
                            
                            
                            self.previousArrayCount -= self.indexDictionaryQuestionStoredArray[self.pageCount + 1]?.count ?? 0
                            
                            print("Previous Array previous: \(self.previousArrayCount)")
                        }else {
                            self.previousArrayCount += self.completeProfile?.rows.count ?? 0
                            
                            self.previusArrayStoredCount = self.completeProfile?.rows.count ?? 0
                            print("Previous Array Next: \(self.previousArrayCount)")
                            
                        }
                        
                        
                        
                        // print(self.previousArrayCount)
                        
                        let arrayCount = self.completeProfile?.rows.count ?? 0
                        
                        var questionId = [Int : String]()
                        
                        var arrYQuestion = [Int : String]()
                        
                        //                         self.indexTypedArray.updateValue([Int : Bool](), forKey: self.pageCount)
                        
                        if self.indexDictionaryStoredArray.isEmpty {
                            
                            self.indexDictionaryStoredArray.updateValue([Int : String](), forKey: self.pageCount)
                            
                        } else {
                            
                            if let data = self.indexDictionaryStoredArray[self.pageCount]
                                
                            {
                                
                            } else {
                                
                                self.indexDictionaryStoredArray.updateValue([Int : String](), forKey: self.pageCount)
                                
                            }
                            
                        }
                        
                        if self.indexTypedArray[self.pageCount]?.isEmpty == nil {
                            
                            self.indexTypedArray.updateValue([Int : Bool](), forKey: self.pageCount)
                            
                        }
                        
                        for i in 0..<arrayCount {
                            
                            self.indexArray.append(0)
                            
                            self.selectTextViewArray.insert(0, at: i)
                            
                            arrYQuestion.updateValue((self.completeProfile?.rows[i].question)! , forKey: i)
                            
                            questionId.updateValue(String(describing: (self.completeProfile?.rows[i].id)!), forKey: i)
                            
                            //                             self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: i)
                            
                            
                            
                        }
                        print(self.indexArray)
                        
                        self.indexDictionaryQuestionStoredArray.updateValue(arrYQuestion, forKey: self.pageCount)
                        
                        self.indexDictionaryIdStoredArray.updateValue(questionId, forKey: self.pageCount)
                        
                        self.completeProfile_TableView.reloadData()
                        
                        if self.previousArrayCount == self.completeProfile?.count ?? 0 {
                            
                            self.skip_btn.isHidden = true
                            
                            self.buttonCondition = "Submit"
                            
                            self.selectProfileView_height.constant = 30
                            
                            self.selectProfile_View.isHidden = false
                            
                            self.profileStatus_lbl.isHidden = false
                            
                            self.submit_btn.setTitle("Submit", for: .normal)
                            
                        }else {
                            
                            self.skip_btn.isHidden = false
                            
                            self.selectProfileView_height.constant = 0
                            
                            self.selectProfile_View.isHidden = true
                            
                            self.profileStatus_lbl.isHidden = true
                            
                            self.buttonCondition = ""
                            
                            self.submit_btn.setTitle("Next", for: .normal)
                            
                            self.completeProfile_TableView.reloadData()
                            
                        }
                        
                        self.completeProfile_TableView.delegate = self
                        
                        self.completeProfile_TableView.dataSource = self
                        
                        self.completeProfile_TableView.reloadData()
                        
                        
                        
                    }catch {
                        
                        print(error.localizedDescription)
                        
                    }
                    
                    Indicator.shared.hideProgressView()
                    
                }else {
                    
                    Indicator.shared.hideProgressView()
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    self.skip_btn.isUserInteractionEnabled = false
                    
                    self.submit_btn.isUserInteractionEnabled = false
                    
                }
                
            }else {
                
                Indicator.shared.hideProgressView()
                
                self.skip_btn.isUserInteractionEnabled = false
                
                self.submit_btn.isUserInteractionEnabled = false
                
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
            }
            
        }
        
    }
    
    // MARK: - Show Answer Data
    
    func showAnswerData(offset: String) {
        
        let param = ["user_id": self.userId, "offset": offset] as [String: AnyObject]
        
        print(param)
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "view_profile_questions_answer_limit", params: param as [String:AnyObject]) { (receviedData) in
            
            print(receviedData)
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [String: AnyObject] else {
                        
                        return
                        
                    }
                    do {
                        //MARK:- Remove ARRAY
                        
                        let jasonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.showAnswerData = try newJSONDecoder().decode(ShowCompleteProfileData.self, from: jasonData)
                        
                        let dataCount = self.showAnswerData?.userQuesAns.rows?.count ?? 0
                        
                        
                        for i in 0..<dataCount {
                            
                            if self.showAnswerData?.userQuesAns.rows?[i].quesAnswers?.count ?? 0 == 0 {
                                
                                self.selectTextViewArray.insert(0, at: i)
                                
                            }else {
                                
                                self.selectTextViewArray.insert(1, at: i)
                                
                                // self.sectionDict[((self.showAnswerData?.userQuesAns[i].id ?? 0))] = self.showAnswerData?.userQuesAns[i].quesAnswers[0].answer ?? ""
                                
                            }
                            
                        }
                        
                        self.completeProfile_TableView.delegate = self
                        
                        self.completeProfile_TableView.dataSource = self
                        
                        self.completeProfile_TableView.reloadData()
                        
                        print(self.sectionDict)
                        
                        Indicator.shared.hideProgressView()
                        
                    }catch {
                        
                        print(error.localizedDescription)
                        
                        Indicator.shared.hideProgressView()
                        
                    }
                    
                }else {
                    
                    Indicator.shared.hideProgressView()
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
            }else {
                Indicator.shared.hideProgressView()
                self.showDefaultAlert(Message: receviedData["Error"] as! String)
                
                
            }
            
            
        }
        
    }
    
    // MARK: - Save Data
    
    func saveData() {
        
        Indicator.shared.showProgressView(self.view)
        
        var dataArray = [[String: AnyObject]]()
        
        var resultDict = [String: AnyObject]()
        var categoriesId = [String: AnyObject]()
        
        var categoryData = [[String: AnyObject]]()
        
        
        if conditionFlag == "Previous" {
            
            for i in 0..<self.indexArray.count {
                
                if self.indexArray[i] == 1 {
                    
                    resultDict["question_id"] = self.indexDictionaryIdStoredArray[self.pageCount]![i]! as AnyObject
                    
                    resultDict["answer"] = self.indexDictionaryStoredArray[self.pageCount]![i] as AnyObject
                    
                    dataArray.append(resultDict)
                    
                }
                
            }
            
        }else if self.conditionFlag == "Next" {
            
            for i in 0..<self.indexArray.count {
                
                if self.indexArray[i] == 1 {
                    
                    resultDict["question_id"] = self.indexDictionaryIdStoredArray[self.pageCount]![i]! as AnyObject
                    
                    resultDict["answer"] = self.indexDictionaryStoredArray[self.pageCount]![i] as AnyObject
                    
                    dataArray.append(resultDict)
                    
                }
                
            }
            
        }else {
            
            for i in 0..<self.indexArray.count {
                
                if self.indexArray[i] == 1 {
                    
                    resultDict["question_id"] = self.indexDictionaryIdStoredArray[self.pageCount]![i]! as AnyObject
                    
                    resultDict["answer"] = self.indexDictionaryStoredArray[self.pageCount]![i] as AnyObject
                    
                    dataArray.append(resultDict)
                    
                }
                
            }
            
        }
        
        for i in 0..<categoriesArray.count {
            
            categoriesId["Id"] = [i] as AnyObject
            
            categoryData.append(categoriesId)
            
            
        }
        
        
        
        let param = ["user_id": self.userId,"edit_answer": dataArray ,"profile_status": selectProfile,"hobbies_id": self.hoobiesId,"interest_id": self.intersetId,"categories_id": self.categoriesArray] as [String: AnyObject]
        
        print(param)
        
        if profile_ImageView.image == UIImage(named: "userProfile_ImageView") {
            Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "edit_profile", params: param as [String: AnyObject]) { (receviedData) in
                
                print(receviedData)
                
                print(self.indexDictionaryStoredArray)
                
                print(self.indexDictionaryQuestionStoredArray)
                
                print(self.indexDictionaryIdStoredArray)
                
                
                
                if Singleton.sharedInstance.connection.responseCode == 1 {
                    
                    if receviedData["response"] as? Bool == true {
                        
                        if String(describing: (receviedData["data"] as! [String: AnyObject])["profile_image"]!) == "" {
                            self.profile_ImageView.image = UIImage(named: "userProfile_ImageView")
                            
                        }else {
                            
                            self.profile_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: (receviedData["data"] as! [String: AnyObject])["profile_image"]!)), placeholderImage: UIImage(named: "userProfile_ImageView"))
                        }
                        
                        self.categoriesArray = receviedData["cat_ans"] as! [[String: AnyObject]] as NSArray
                        //                        self.indexArray.removeAll()
                        //
                        //                        self.conditionFlag = "Next"
                        //
                        //                        self.pageCount += 1
                        
                        //                        self.setProfileQuestion(offset: (((self.completeProfile?.rows.count)!) * self.pageCount))
                        //
                        //                        self.currentOffset = ((((self.completeProfile?.rows.count)!) * self.pageCount))
                        //
                        //                        self.checkOffsetValue = ((((self.completeProfile?.rows.count)!) * self.pageCount)) + 1
                        
                        print("currentOffsetSaveData\(self.currentOffset)")
                        
                        //MARK: - removing sections
                        
                        print("-->>>" ,self.sectionDict)
                        
                        self.sectionDict.removeAll()
                        
                        print("-->>>" ,self.sectionDict)
                        
                        //                        if self.pageCount > 0 {
                        //
                        //                            self.previous_btn.isHidden = false
                        //
                        //                        }else {
                        //
                        //                            self.previous_btn.isHidden = true
                        //
                        //                        }
                        
                        if self.buttonCondition == "Submit" {
                            
                            self.showAlertWithAction(Title: "Unilife", Message: "Profile Updated", ButtonTitle: "OK", outputBlock: {
                                
                                UserDefaults.standard.set("second", forKey: "signUpTime")
                                
                                //                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventAndPostViewController") as! EventAndPostViewController
                                
                                UserDefaults.standard.setValue((NSKeyedArchiver.archivedData(withRootObject: receviedData["data"]  as! [String: AnyObject])), forKey: "userData")
                                
                                Singleton.sharedInstance.universityName = String(describing: (receviedData["university"] as! [String: AnyObject])["name"]!)
                                
                                Singleton.sharedInstance.loginAsType = (((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["user_type"] as? String ?? "")
                                
                                self.addDevice()
                                
                                Switcher.afterLogin()
                                
                                
                            })
                            
                        }else {
                            
                            self.indexArray.removeAll()
                            
                            self.conditionFlag = "Next"
                            
                            self.pageCount += 1
                            
                            self.setProfileQuestion(offset: (((self.completeProfile?.rows.count)!) * self.pageCount))
                            
                            self.currentOffset = ((((self.completeProfile?.rows.count)!) * self.pageCount))
                            
                            self.checkOffsetValue = ((((self.completeProfile?.rows.count)!) * self.pageCount)) + 1
                            
                            
                            if self.pageCount > 0 {
                                
                                self.previous_btn.isHidden = false
                                
                            }else {
                                
                                self.previous_btn.isHidden = true
                                
                            }
                            
                            
                        }
                        
                        Indicator.shared.hideProgressView()
                        
                    }else {
                        
                        Indicator.shared.hideProgressView()
                        
                        self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                        
                    }
                    
                }else {
                    
                    Indicator.shared.hideProgressView()
                    
                    self.showDefaultAlert(Message: receviedData["Error"] as! String)
                    
                }
                
            }
            
        }else {
            
            let name = String(describing: Date().toMillis()!) + self.userId + "image.jpeg"
            
            Singleton.sharedInstance.connection.startConnectionWithSingleFile(FileData: self.profile_ImageView.image!.jpegData(compressionQuality: 0.8) as! Data, FileName: name, FileType: "image/jpg", FileParam: "profile_image", getUrlString: "edit_profile", params: param as [String: AnyObject]) { (receviedData,responseCode) in
                
                print(receviedData)
                
                
                if responseCode == 1 {
                    
                    // if receviedData["response"] as? Bool == true {
                    
                    if receviedData["response"] as? Bool == true {
                        
                        if String(describing: (receviedData["data"] as! [String: AnyObject])["profile_image"]!) == "" {
                            self.profile_ImageView.image = UIImage(named: "userProfile_ImageView")
                            
                        }else {
                            
                            self.profile_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: (receviedData["data"] as! [String: AnyObject])["profile_image"]!)), placeholderImage: UIImage(named: "userProfile_ImageView"))
                        }
                        
                        self.categoriesArray = receviedData["cat_ans"] as! [[String: AnyObject]] as NSArray
                        //                        self.indexArray.removeAll()
                        //
                        //                        self.conditionFlag = "Next"
                        //
                        //                        self.pageCount += 1
                        //
                        //                        self.setProfileQuestion(offset: (((self.completeProfile?.rows.count)!) * self.pageCount))
                        //
                        //                        self.currentOffset = ((((self.completeProfile?.rows.count)!) * self.pageCount))
                        //
                        //                        self.checkOffsetValue = ((((self.completeProfile?.rows.count)!) * self.pageCount)) + 1
                        
                        print("currentOffsetSaveData\(self.currentOffset)")
                        
                        //MARK: - removing sections
                        
                        print("-->>>" ,self.sectionDict)
                        
                        self.sectionDict.removeAll()
                        
                        print("-->>>" ,self.sectionDict)
                        
                        
                        
                        if self.buttonCondition == "Submit" {
                            
                            self.showAlertWithAction(Title: "Unilife", Message: "Profile Updated", ButtonTitle: "OK", outputBlock: {
                                
                                //                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                                //
                                //                                vc.condition = "Signup"
                                //
                                //                                //                                self.indexDictionaryIdStoredArray.removeAll()
                                //                                //
                                //                                //                                self.indexDictionaryStoredArray.removeAll()
                                //                                //
                                //                                //                                self.indexDictionaryQuestionStoredArray.removeAll()
                                //                                //
                                //                                //                                self.indexArray.removeAll()
                                //                                //
                                //                                //                                self.indexTypedArray.removeAll()
                                //
                                //                                self.navigationController?.pushViewController(vc, animated: true)
                                
                                UserDefaults.standard.set("second", forKey: "signUpTime")
                                
                                //                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventAndPostViewController") as! EventAndPostViewController
                                
                                UserDefaults.standard.setValue((NSKeyedArchiver.archivedData(withRootObject: receviedData["data"]  as! [String: AnyObject])), forKey: "userData")
                                
                                Singleton.sharedInstance.universityName = String(describing: (receviedData["university"] as! [String: AnyObject])["name"]!)
                                
                                Singleton.sharedInstance.loginAsType = (((receviedData as? [String: AnyObject])? ["data"] as? [String: AnyObject])? ["user_type"] as? String ?? "")
                                
                                self.addDevice()
                                
                                Switcher.afterLogin()
                                
                            })
                            
                        }else {
                            
                            self.indexArray.removeAll()
                            
                            self.conditionFlag = "Next"
                            
                            self.pageCount += 1
                            
                            self.setProfileQuestion(offset: (((self.completeProfile?.rows.count)!) * self.pageCount))
                            
                            self.currentOffset = ((((self.completeProfile?.rows.count)!) * self.pageCount))
                            
                            self.checkOffsetValue = ((((self.completeProfile?.rows.count)!) * self.pageCount)) + 1
                            
                            if self.pageCount > 0 {
                                
                                self.previous_btn.isHidden = false
                                
                            }else {
                                
                                self.previous_btn.isHidden = true
                                
                            }
                            
                        }
                        
                        Indicator.shared.hideProgressView()
                        
                    }else {
                        
                        Indicator.shared.hideProgressView()
                        
                        self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                        
                    }
                    
                    
                    
                }else {
                    
                    Indicator.shared.hideProgressView()
                    
                    self.showDefaultAlert(Message: receviedData["Error"] as! String)
                    
                }
                
            }
            
        }
        
    }
    
    // MARK: - Button Action
    
    @IBAction func tapProfileStatus_btn(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            if self.onlyMe_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.selectProfile = ""
                
                self.profile_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                
            }
                
            else if onlyMe_btn.currentImage == UIImage(named: "radioGray_Icon") {
                
                self.onlyMe_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
                self.selectProfile = "onlyme"
                
                self.profile_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
            
        }
        
        if sender.tag == 1 {
            
            if self.private_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.selectProfile = ""
                
                self.profile_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
                
            else if private_btn.currentImage == UIImage(named: "radioGray_Icon") {
                
                self.private_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
                self.selectProfile = "private"
                
                self.profile_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
            
        }
        
        if sender.tag == 2 {
            
            if self.profile_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.profile_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.selectProfile = ""
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
                
            else if self.profile_btn.currentImage == UIImage(named: "radioGray_Icon") {
                
                self.profile_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
                self.selectProfile = "public"
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
            
        }
        
        
    }
    
    
    @IBAction func tapSubmit_btn(_ sender: Any) {
        
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "nextCompleteProfileViewController") as! nextCompleteProfileViewController
        
        //
        
        //        vc.nextQuestionArray = self.nextQuestionArray
        
        //
        
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        //        self.completeProfileTableView_Top.constant = 0
        
        //
        
        //        self.profileImageView_Width.constant = 0
        
        //
        
        //        self.profileImageView_Height.constant = 0
        
        //
        
        //        self.profile_ImageView.isHidden = true
        
        //        if self.buttonCondition == "Submit" {
        
        //
        
        //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        //            self.navigationController?.pushViewController(vc, animated: true)
        
        //
        
        //        }else {
        
        
        // self.conditionFlag = ""
        self.view.endEditing(true)
        saveData()
        
        //}
        
    }
    
    @IBAction func tapEdit_btn(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Upload Profile Picture", style: UIAlertAction.Style.default)
            
            
        { action -> Void in
            
            self.showPicker()
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style:.default , handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func tapBack_btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        self.indexDictionaryIdStoredArray.removeAll()
        
        self.indexDictionaryQuestionStoredArray.removeAll()
        
        self.indexDictionaryStoredArray.removeAll()
        
        self.indexArray.removeAll()
        
    }
    
    @IBAction func tapPrevious_btn(_ sender: Any) {
        
        self.view.endEditing(true)
        
        self.conditionFlag = "Previous"
        
        print("-->>>" ,self.sectionDict)
        
        self.sectionDict.removeAll()
        
        self.pageCount -= 1
        
        if self.pageCount == 0 {
            
            
            self.currentOffset = self.currentOffset - 5
            
            self.checkOffsetValue = currentOffset + 1
            
            self.setProfileQuestion(offset: self.currentOffset)
            
            self.previous_btn.isHidden = true
            
            print("self.currentOffset Previous: -\(self.currentOffset)")
            
        }else {
            
            // self.setProfileQuestion(offset: self.currentOffset - 5)
            
            self.currentOffset = self.currentOffset - 5
            
            self.checkOffsetValue = currentOffset + 1
            
            self.setProfileQuestion(offset: self.currentOffset)
            
            self.previous_btn.isHidden = false
            
            print("self.currentOffset Previous: -\(self.currentOffset)")
            
        }
        
        
        
        // self.previousArrayCount -= self.completeProfile?.rows.count ?? 0
        
        print("Previous Array: \(self.previousArrayCount)")
        
        if self.previousArrayCount == self.completeProfile?.count ?? 0 {
            
            self.submit_btn.setTitle("Submit", for: .normal)
            
        }else {
            
            
            
            self.submit_btn.setTitle("Next", for: .normal)
            
        }
        
    }
    
    @IBAction func tapSkip_btn(_ sender: Any) {
        self.view.endEditing(true)
        saveData()
    }
    
}


// MARK: - Table View Delegate

extension CompleteProfileViewController: UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if self.conditionFlag == "Previous" {
            
            return self.completeProfile?.rows.count ??  0
            
        }else {
            
            return self.completeProfile?.rows.count ??  0
            
            
        }
        
    }
    
    
    func setNextData(indexPath : Int , selectView : UIView , imageView : UIImageView , textView : UITextView , label :UILabel , dropDownBtn : UIButton)
        
    {
        
        label.text = self.indexDictionaryQuestionStoredArray[self.pageCount]![indexPath]
        
        textView.delegate = self
        
        textView.tag = indexPath
        
        if self.indexTypedArray[self.pageCount]![indexPath] == true
            
        {
            
            imageView.backgroundColor = UIColor.appSkyBlue
            
            selectView.backgroundColor = UIColor.appSkyBlue
            
        } else {
            
            imageView.backgroundColor = UIColor.appLightGreyColor
            
            selectView.backgroundColor = UIColor.appLightGreyColor
            
        }
        
        //        self.editProfileData?.userQuesAns.rows?[indexPath.row].questionType ?? "" == ""
        if self.completeProfile?.rows[indexPath].questionType == "categories" {
            
            dropDownBtn.isHidden = false
            
            dropDownBtn.isUserInteractionEnabled = true
            
            dropDownBtn.setImage(UIImage(named: "plus_btn"), for: .normal)
            
            textView.isUserInteractionEnabled = false
            
            dropDownBtn.accessibilityIdentifier = "categories"
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil)
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, queue: nil) { (Notification) in
                
                Indicator.shared.showProgressView(self.view)
                
                let count = self.completeProfile?.rows.count ??  0
                
                //JUGADU KAMM ;^>
                
                if String(describing: UserDefaults.standard.value(forKey: "signUpTime")!) == "second" {
                    
                    self.pageCount = 0
                    
                    let newCount = self.indexDictionaryQuestionStoredArray[0]?.count ?? 0
                    
                    UserDefaults.standard.set("third", forKey: "signUpTime")
                    
                    for _ in 0..<newCount {
                        
                        self.indexArray.append(0)
                        
                    }
                    
                }else {
                    
                    if self.indexArray.isEmpty {
                        
                        for _ in 0..<(self.indexDictionaryQuestionStoredArray[0]?.count ?? 0) {
                            
                            self.indexArray.append(0)
                        }
                        
                        //self.indexArray[indexPath] = 1
                    }else {
                        
                        for _ in 0..<(self.indexDictionaryQuestionStoredArray[0]?.count ?? 0) {
                            
                            self.indexArray.append(0)
                        }
                        
                    }
                    
                }
                
                let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                
                let data = dict["Name"] as! NSArray
                
                let dataId = dict["Id"] as! NSArray
                
                if data.count == 0 {
                    
                    self.indexArray[indexPath] = 0
                    
                    self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appLightGreyColor
                    
                    imageView.backgroundColor = UIColor.appLightGreyColor
                    
                }else {
                    
                    self.indexArray[indexPath] = 1
                    
                    self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appSkyBlue
                    
                    imageView.backgroundColor = UIColor.appSkyBlue
                    
                }
                
                textView.text = ""
                
                //self.categoriesArray = dict["Id"] as! NSArray
                
                self.categoriesArray = dict["result"] as! NSArray
                
                //self.categoriesArray.adding(dict["Id"] as! NSArray)
                
                
                
                var name = ""
                
                var cateId = ""
                
                for i in 0..<dataId.count {
                    
                    cateId += "\(dataId[i]),"
                    
                    
                }
                
                for i in 0..<data.count {
                    
                    if "\(data[i])" == "" {
                        
                    }else {
                        
                        name += "\(data[i]),"
                        
                    }
                    
                }
                
                
                self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath)
                
                //  self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                
                textView.text = name
                
                self.categoriesNewId = cateId
                
                self.tempCategories = name
                
                self.indexDropDownValie = textView.tag
                
                //                self.completeProfile_TableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
                
                self.completeProfile_TableView.reloadData()
                
                Indicator.shared.hideProgressView()
                
            }
            
        } else if label.text == "Hobbies" {
            
            dropDownBtn.setImage(UIImage(named: "downArrow_Icon"), for: .normal)
            
            dropDownBtn.isHidden = false
            
            dropDownBtn.isUserInteractionEnabled = true
            
            textView.isUserInteractionEnabled = false
            
            dropDownBtn.accessibilityIdentifier = "hobbies"
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "hobbies"), object: nil)
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "hobbies"), object: nil, queue: nil) { (Notification) in
                
                
                let count = self.completeProfile?.rows.count ??  0
                
                if String(describing: UserDefaults.standard.value(forKey: "signUpTime")!) == "second" {
                    
                    self.pageCount = 2
                    
                    
                    let newCount = self.indexDictionaryQuestionStoredArray[self.pageCount]?.count ?? 0
                    
                    UserDefaults.standard.set("third", forKey: "signUpTime")
                    
                    for _ in 0..<newCount {
                        self.indexArray.append(0)
                        
                    }
                    
                }else {
                    
                    if self.indexArray.isEmpty {
                        
                        
                        for _ in 0..<count {
                            
                            self.indexArray.append(0)
                        }
                        
                        //self.indexArray[indexPath] = 1
                    }else {
                        
                        //self.indexArray[indexPath] = 1
                        
                    }
                    
                }
                
                let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                
                let data = dict["Name"] as! NSArray
                
                let hobbiesData = dict["Id"] as! NSArray
                
                self.hobbiesIdArray = dict["Id"] as! NSArray
                
                if data.count == 0 {
                    
                    self.indexArray[indexPath] = 0
                    
                    self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appLightGreyColor
                    
                    imageView.backgroundColor = UIColor.appLightGreyColor
                    
                    
                    
                }else {
                    
                    self.indexArray[indexPath] = 1
                    self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                    
                    
                    selectView.backgroundColor = UIColor.appSkyBlue
                    
                    imageView.backgroundColor = UIColor.appSkyBlue
                    
                }
                
                
                var name = ""
                var hobbiId = ""
                
                //                if self.indexArray.isEmpty {
                //
                //
                //                    for _ in 0..<5 {
                //
                //                        self.indexArray.append(0)
                //                    }
                //
                //                    self.indexArray[indexPath] = 1
                //                }else {
                //
                //                    self.indexArray[indexPath] = 1
                //
                //                }
                for i in 0..<hobbiesData.count {
                    
                    hobbiId += "\(hobbiesData[i]),"
                }
                
                
                for i in 0..<data.count {
                    
                    name += "\(data[i]),"
                    
                }
                
                
                
                self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath)
                
                
                
                // self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                
                
                
                textView.text = name
                
                self.hoobiesId = hobbiId
                
                //                self.completeProfile_TableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
                
                self.completeProfile_TableView.reloadData()
                
            }
            
        }else if label.text == "Interest" {
            
            dropDownBtn.setImage(UIImage(named: "downArrow_Icon"), for: .normal)
            
            dropDownBtn.isHidden = false
            
            dropDownBtn.isUserInteractionEnabled = true
            
            textView.isUserInteractionEnabled = false
            
            dropDownBtn.accessibilityIdentifier = "interest"
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "interest"), object: nil)
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "interest"), object: nil, queue: nil) { (Notification) in
                
                
                let count = self.completeProfile?.rows.count ??  0
                
                if String(describing: UserDefaults.standard.value(forKey: "signUpTime")!) == "second" {
                    
                    self.pageCount = 2
                    
                    
                    let newCount = self.indexDictionaryQuestionStoredArray[self.pageCount]?.count ?? 0
                    
                    UserDefaults.standard.set("third", forKey: "signUpTime")
                    
                    for _ in 0..<newCount {
                        self.indexArray.append(0)
                        
                    }
                    
                }else {
                    
                    if self.indexArray.isEmpty {
                        
                        
                        for _ in 0..<count {
                            
                            self.indexArray.append(0)
                        }
                        
                        //self.indexArray[indexPath] = 1
                    }else {
                        
                        //self.indexArray[indexPath] = 1
                        
                    }
                    
                }
                
                let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                
                let data = dict["Name"] as! NSArray
                
                let intersetData = dict["Id"] as! NSArray
                
                if data.count == 0 {
                    
                    self.indexArray[indexPath] = 0
                    
                    self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appLightGreyColor
                    
                    imageView.backgroundColor = UIColor.appLightGreyColor
                    
                    
                    
                }else {
                    
                    self.indexArray[indexPath] = 1
                    
                    
                    self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appSkyBlue
                    
                    imageView.backgroundColor = UIColor.appSkyBlue
                    
                }
                
                self.intersetIdArray = dict["Id"] as! NSArray
                
                
                var name = ""
                var intresId = ""
                
                //  if self.indexArray.isEmpty {
                
                
                //                    for _ in 0..<5 {
                //
                //                        self.indexArray.append(0)
                //                    }
                //
                //                    self.indexArray[indexPath] = 1
                //                }else {
                //
                //                    self.indexArray[indexPath] = 1
                //
                //                }
                
                for i in 0..<data.count {
                    
                    name += "\(data[i]),"
                    
                }
                
                for i in 0..<intersetData.count {
                    
                    intresId += "\(intersetData[i]),"
                }
                
                textView.text = name
                
                self.intersetId = intresId
                
                self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath)
                
                // self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                
                //                self.completeProfile_TableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
                
                
                self.completeProfile_TableView.reloadData()
            }
            
        }
            
        else {
            
            dropDownBtn.isHidden = true
            
            dropDownBtn.isUserInteractionEnabled = false
            
            textView.isUserInteractionEnabled = true
            
        }
        
        dropDownBtn.addTarget(self, action: #selector(tapSelection_btn(_:)), for: .touchUpInside)
        
        if !(self.indexDictionaryStoredArray[self.pageCount]?.isEmpty)! {
            
            if self.indexDictionaryStoredArray[self.pageCount]![indexPath] != ""  {
                
                textView.text = self.indexDictionaryStoredArray[self.pageCount]![indexPath]
                
                
            } else {
                
                
                textView.text = ""
                
            }
            
        } else {
            
            textView.text = ""
            
            
            
        }
        
        
        
    }
    
    
    
    func setPreviousData(indexPath : Int , selectView : UIView , imageView : UIImageView , textView : UITextView , label :UILabel , dropDownBtn : UIButton)
        
    {
        
        label.text = self.indexDictionaryQuestionStoredArray[self.pageCount]![indexPath]
        
        textView.delegate = self
        
        textView.tag = indexPath
        
        if self.indexTypedArray[self.pageCount]![indexPath] == true {
            
            imageView.backgroundColor = UIColor.appSkyBlue
            
            selectView.backgroundColor = UIColor.appSkyBlue
            
        } else {
            
            imageView.backgroundColor = UIColor.appLightGreyColor
            
            selectView.backgroundColor = UIColor.appLightGreyColor
            
        }
        
        if self.completeProfile?.rows[indexPath].questionType == "categories" {
            
            dropDownBtn.setImage(UIImage(named: "plus_btn"), for: .normal)
            
            dropDownBtn.isHidden = false
            
            dropDownBtn.isUserInteractionEnabled = true
            
            textView.isUserInteractionEnabled = false
            
            dropDownBtn.accessibilityIdentifier = "categories"
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil)
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, queue: nil) { (Notification) in
                
                let count = self.completeProfile?.rows.count ??  0
                
                if self.indexArray.isEmpty {
                    
                    
                    for _ in 0..<count {
                        
                        self.indexArray.append(0)
                    }
                    
                    //self.indexArray[indexPath] = 1
                }else {
                    
                    //self.indexArray[indexPath] = 1
                    
                }
                
                let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                
                let data = dict["Name"] as! NSArray
                let categData = dict["Id"] as! NSArray
                
                if data.count == 0 {
                    self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appLightGreyColor
                    
                    imageView.backgroundColor = UIColor.appLightGreyColor
                    
                }else {
                    self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appSkyBlue
                    
                    imageView.backgroundColor = UIColor.appSkyBlue
                    
                }
                
                
                
                
                
                textView.text = ""
                
                self.indexArray[indexPath] = 1
                
                self.categoriesArray = dict["result"] as! NSArray
                
                
                
                var name = ""
                
                var categoryId = ""
                
                for i in 0..<categData.count {
                    
                    categoryId += "\(categData[i]),"
                }
                
                
                
                for i in 0..<data.count {
                    
                    if "\(data[i])" == "" {
                        
                    }else {
                        
                        name += "\(data[i]),"
                        
                    }
                }
                
                
                
                self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath)
                
                
                
                // self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                
                
                
                textView.text = name
                self.categoriesNewId = categoryId
                
                self.tempCategories = name
                
                self.indexDropDownValie = textView.tag
                
                
                //                self.completeProfile_TableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
                
                self.completeProfile_TableView.reloadData()
                
                
                
            }
            
            
        } else if label.text == "Hobbies" {
            
            dropDownBtn.setImage(UIImage(named: "downArrow_Icon"), for: .normal)
            
            
            dropDownBtn.isHidden = false
            
            
            
            dropDownBtn.isUserInteractionEnabled = true
            
            
            
            textView.isUserInteractionEnabled = false
            
            
            
            dropDownBtn.accessibilityIdentifier = "hobbies"
            
            
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "hobbies"), object: nil)
            
            
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "hobbies"), object: nil, queue: nil) { (Notification) in
                
                
                let count = self.completeProfile?.rows.count ??  0
                
                if self.indexArray.isEmpty {
                    
                    
                    for _ in 0..<count {
                        
                        self.indexArray.append(0)
                    }
                    
                    //self.indexArray[indexPath] = 1
                }else {
                    
                    //self.indexArray[indexPath] = 1
                    
                }
                
                
                let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                
                
                
                let data = dict["Name"] as! NSArray
                let hobbiesData = dict["Id"] as! NSArray
                
                
                
                self.hobbiesIdArray = dict["Id"] as! NSArray
                
                self.indexArray[indexPath] = 1
                
                if data.count == 0 {
                    self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appLightGreyColor
                    
                    imageView.backgroundColor = UIColor.appLightGreyColor
                    
                }else {
                    
                    self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appSkyBlue
                    
                    imageView.backgroundColor = UIColor.appSkyBlue
                    
                }
                
                
                
                var name = ""
                
                var hoobiesPreviousId = ""
                
                for i in 0..<hobbiesData.count{
                    
                    hoobiesPreviousId += "\(hobbiesData[i]),"
                    
                    
                }
                
                
                
                for i in 0..<data.count {
                    
                    
                    
                    name += "\(data[i]),"
                    
                    
                    
                }
                
                
                
                textView.text = name
                
                self.hoobiesId = hoobiesPreviousId
                
                
                
                self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath)
                
                
                
                // self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                
                
                
                
                //
                //                self.completeProfile_TableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
                
                self.completeProfile_TableView.reloadData()
                
                
            }
            
        }else if label.text == "Interest" {
            
            dropDownBtn.setImage(UIImage(named: "downArrow_Icon"), for: .normal)
            
            dropDownBtn.isHidden = false
            
            dropDownBtn.isUserInteractionEnabled = true
            
            textView.isUserInteractionEnabled = false
            
            
            
            dropDownBtn.accessibilityIdentifier = "interest"
            
            
            
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "interest"), object: nil)
            
            
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "interest"), object: nil, queue: nil) { (Notification) in
                
                
                let count = self.completeProfile?.rows.count ??  0
                
                if self.indexArray.isEmpty {
                    
                    
                    for _ in 0..<count {
                        
                        self.indexArray.append(0)
                    }
                    
                    //self.indexArray[indexPath] = 1
                }else {
                    
                    //self.indexArray[indexPath] = 1
                    
                }
                
                
                
                let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                
                
                
                let data = dict["Name"] as! NSArray
                
                let intersetPreviousData = dict["Id"] as! NSArray
                
                
                self.indexArray[indexPath] = 1
                
                
                if data.count == 0 {
                    
                    self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appLightGreyColor
                    
                    imageView.backgroundColor = UIColor.appLightGreyColor
                    
                }else {
                    
                    self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                    
                    selectView.backgroundColor = UIColor.appSkyBlue
                    
                    imageView.backgroundColor = UIColor.appSkyBlue
                    
                }
                
                self.intersetIdArray = dict["Id"] as! NSArray
                
                var name = ""
                var intersetPreviousId = ""
                
                
                for i in 0..<data.count {
                    
                    name += "\(data[i]),"
                    
                }
                
                for i in 0..<intersetPreviousData.count{
                    
                    intersetPreviousId += "\(intersetPreviousData[i]),"
                }
                
                
                
                textView.text = name
                
                self.intersetId = intersetPreviousId
                
                self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath)
                
                
                
                self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath)
                
                
                
                //                self.completeProfile_TableView.reloadRows(at: [IndexPath(row: indexPath, section: 0)], with: .automatic)
                
                self.completeProfile_TableView.reloadData()
                
                
                
            }
            
            
            
        }
            
            
            
        else {
            
            
            
            dropDownBtn.isHidden = true
            
            
            
            dropDownBtn.isUserInteractionEnabled = false
            
            
            
            textView.isUserInteractionEnabled = true
            
            
            
        }
        
        
        
        dropDownBtn.addTarget(self, action: #selector(tapSelection_btn(_:)), for: .touchUpInside)
        
        
        
        
        
        if self.indexDictionaryStoredArray[self.pageCount]![indexPath] != "" {
            
            
            
            textView.text = self.indexDictionaryStoredArray[self.pageCount]![indexPath]
            
            
            
            
            
        } else {
            
            textView.text = ""
            
            
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = self.completeProfile_TableView.dequeueReusableCell(withIdentifier: "CompleteProfileTableViewCell") as! CompleteProfileTableViewCell
        
        
        
        //MARK :- Previous
        
        
        
        if self.conditionFlag == "Previous" {
            
            
            
            self.setPreviousData(indexPath: indexPath.row, selectView: cell.select_View, imageView: cell.selectCircle_ImageView!, textView: cell.answer_TextView, label: cell.question_lbl , dropDownBtn : cell.selectDropDown_btn)
            
            
            
            
            
            
            
        }else {
            
            
            
            //MARK :- Next
            
            
            
            self.setNextData(indexPath: indexPath.row, selectView: cell.select_View, imageView: cell.selectCircle_ImageView!, textView: cell.answer_TextView, label: cell.question_lbl, dropDownBtn: cell.selectDropDown_btn)
            
            
            
        }
        
        
        
        return cell
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        
        return UITableView.automaticDimension
        
        
        
    }
    
    
    
    
    
    // MARK: - Button Action
    
    
    
    @objc func tapSelection_btn(_ sender: UIButton) {
        
        if sender.accessibilityIdentifier == "categories" {
            
            //            popoverContent.condition = "category"
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourseCoveredPopViewController") as! CourseCoveredPopViewController
            
            if self.conditionFlag == "Previous" {
                
                vc.condition = "Previous"
                
                vc.courseCoveredPreviousData = self.categoriesArray as! [[String : AnyObject]]
                
                
            }else {
                
                vc.condition = ""
                
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if sender.accessibilityIdentifier == "hobbies" {
            
            guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionPopUpControllerViewController") as? SelectionPopUpControllerViewController else {return}
            
            popoverContent.controller = self
            
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            
            
            popoverContent.preferredContentSize = CGSize(width: 350, height: 200)
            
            popoverContent.condition = "hobbies"
            
            let popOver = popoverContent.popoverPresentationController
            
            popOver?.delegate = self
            
            popOver?.sourceView = sender as! UIView
            
            
            popOver?.sourceRect = (sender as AnyObject).bounds
            
            
            popOver?.permittedArrowDirections = [.up]
            
            self.present(popoverContent, animated: true, completion: nil)
            
        }else {
            
            guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionPopUpControllerViewController") as? SelectionPopUpControllerViewController else {return}
            
            popoverContent.controller = self
            
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            
            
            popoverContent.preferredContentSize = CGSize(width: 300, height: 200)
            
            popoverContent.condition = ""
            
            let popOver = popoverContent.popoverPresentationController
            
            popOver?.delegate = self
            
            popOver?.sourceView = sender as! UIView
            
            
            popOver?.sourceRect = (sender as AnyObject).bounds
            
            
            popOver?.permittedArrowDirections = [.up]
            
            self.present(popoverContent, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    // MARK: textView Delegate
    
    
    
    
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
        
        if self.conditionFlag == "Previous"
            
        {
            
            if textView.text!.isEmpty {
                
                self.selectTextViewArray[textView.tag] = 0
                
            }else {
                
                self.indexArray[textView.tag] = 1
                
                self.selectTextViewArray[textView.tag] = 1
                
            }
            
            for i in 0..<self.indexArray.count {
                
                if textView.tag == i {
                    
                    if textView.text != ""
                    {
                        self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: textView.tag)
                        
                    } else {
                        self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: textView.tag)
                        
                    }
                    
                }
                
            }
            
            self.sectionDict[textView.tag] = textView.text!
            self.indexDictionaryStoredArray[self.pageCount]?.updateValue(textView.text, forKey: textView.tag)
            
        } else if self.conditionFlag == "Next" {
            
            if textView.text!.isEmpty {
                
                self.selectTextViewArray[textView.tag] = 0
                
            }else {
                
                self.indexArray[textView.tag] = 1
                
                self.selectTextViewArray[textView.tag] = 1
                
            }
            
            for i in 0..<self.indexArray.count {
                
                if textView.tag == i {
                    
                    if textView.text != ""{
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: textView.tag)
                        
                    } else {
                        self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: textView.tag)
                        
                    }
                    
                    
                    
                }
                
            }
            
            
            
            self.sectionDict[textView.tag] = textView.text!
            
            
            
            
            
            self.indexDictionaryStoredArray[self.pageCount]?.updateValue(textView.text, forKey: textView.tag)
            
            
            
        } else {
            
            
            
            if textView.text!.isEmpty {
                
                
                
                self.selectTextViewArray[textView.tag] = 0
                
                
                
            }else {
                
                
                
                self.indexArray[textView.tag] = 1
                
                
                
                
                
                self.selectTextViewArray[textView.tag] = 1
                
                
                
            }
            
            
            
            for i in 0..<self.indexArray.count {
                
                
                
                if textView.tag == i {
                    
                    
                    
                    if textView.text != ""
                        
                    {
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: textView.tag)
                        
                    } else {
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: textView.tag)
                        
                    }
                    
                    
                    
                }
                
            }
            
            
            
            self.sectionDict[textView.tag] = textView.text!
            
            
            
            self.indexDictionaryStoredArray.updateValue(self.sectionDict, forKey: self.pageCount)
            
            
            
            self.indexDictionaryStoredArray[self.pageCount]?.updateValue(textView.text, forKey: textView.tag)
            
            
            
        }
        
        
        
        if textView.text != "" {
            
            
            
            self.completeProfile_TableView.reloadRows(at: [IndexPath(row: textView.tag, section: 0)], with: .automatic)
            
            
            
        }
        
        self.completeProfile_TableView.reloadData()
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
}

// MARK: - Image Picker Delegate



extension CompleteProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        cropStyle = TOCropViewCroppingStyle.default
        
        cropViewController.customAspectRatio = CGSize(width: self.profile_ImageView.frame.size.width, height: self.profile_ImageView.frame.size.height)
        
        
        cropViewController = TOCropViewController(croppingStyle: cropStyle!, image: selectedImage)
        
        cropViewController.toolbar.clampButtonHidden = true
        
        
        cropViewController.toolbar.rotateClockwiseButtonHidden = true
        
        cropViewController.cropView.setAspectRatio(CGSize(width: self.profile_ImageView.frame.size.width, height: self.profile_ImageView.frame.size.height), animated: true)
        
        
        cropViewController.cropView.aspectRatioLockEnabled = true
        
        cropViewController.toolbar.rotateButton.isHidden = true
        
        
        
        cropViewController.toolbar.resetButton.isHidden = true
        
        
        
        cropViewController.delegate = self
        
        
        
        dismiss(animated: true, completion: nil)
        
        
        
        self.navigationController?.present(cropViewController, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        
        
        
        self.profile_ImageView.contentMode = .scaleToFill
        
        
        
        self.profile_ImageView.image = image
        
        
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    
    func showPicker(){
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
                
                
                
                self.camera()
                
                
                
            }))
            
            
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: {(alert:UIAlertAction) -> Void in
                
                
                
                self.photolibrary()
                
                
                
            }))
            
            
            
        }else{
            
            
            
            actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: {(alert:UIAlertAction) -> Void in
                
                
                
                self.photolibrary()
                
                
                
            }))
            
            
            
        }
        
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            
            
            let popUp = UIPopoverController(contentViewController: actionSheet)
            
            
            
            popUp.present(from: CGRect(x: 15, y: self.view.frame.height - 150, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            
            
            
        }else{
            
            
            
            self.present(actionSheet, animated: true, completion: nil)
            
            
            
        }
        
        
        
    }
    
    
    
    func camera(){
        
        self.image_picker.sourceType = .camera
        
        
        
        self.image_picker.delegate = self
        
        
        
        present(image_picker, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func photolibrary(){
        
        
        
        self.image_picker.sourceType = .photoLibrary
        
        
        
        self.image_picker.delegate = self
        
        present(image_picker, animated: true, completion: nil)
        
    }
    
}



extension CompleteProfileViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
        
    }
    
}

extension Date {
    
    func toMillis() -> Int64! {
        
        return Int64(self.timeIntervalSince1970 * 1000)
        
    }
    
}

extension CompleteProfileViewController{
    
    // MARK: - Add Device
    
    func addDevice(){
        Indicator.shared.showProgressView(self.view)
        
        let param = ["user_id": UserData().userId,"device_token": UserDefaults.standard.value(forKey: "fcmToken"),"device_id": UserDefaults.standard.value(forKey: "deviceId") ,"type": "ios"] as [String: AnyObject]
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "User_device", params: param as [String: AnyObject]){ (receviedData) in
            
            print(receviedData)
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    
                }else {
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                }
                
            }else {
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
    }
}
