//
//  EditProfileViewController.swift
//  Unilife
//
//  Created by Apple on 02/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import TOCropViewController

class EditProfileViewController: UIViewController {
    
    // MARK: outlet
    
    @IBOutlet weak var editProfile_TableView: UITableView!
    
    
    @IBOutlet weak var hobbies_CollectionView: UICollectionView!
    
    @IBOutlet weak var selectInterests_CollectionView: UICollectionView!
    
    @IBOutlet weak var profile_ImageView: CircleImage!
    
    @IBOutlet weak var onlyMe_btn: UIButton!
    
    @IBOutlet weak var private_btn: UIButton!
    
    @IBOutlet weak var public_btn: UIButton!
    
    @IBOutlet weak var previous_btn: SetButton!
    
    @IBOutlet weak var next_btn: UIButton!
    
    @IBOutlet weak var profileTitle_lbl: UILabel!
    
    @IBOutlet weak var profileStack_View: UIStackView!
    
    @IBOutlet weak var profileStack_Height: NSLayoutConstraint!
    
    // MARK: - Variable
    
    
    var selectHobbiesNameArray = ["Music", "Swimming", "Bowling", "Photography", "Cycling"]
    
    var selectHobbiesImageArray = [UIImage(named: "music_Icon"), UIImage(named: "swin_Icon"), UIImage(named: "bowl_Icon"), UIImage(named: "camera_Icon"), UIImage(named: "cycle_Icon")]
    
    var selectInterestsImageArray = [UIImage(named: "monitor_Icon"), UIImage(named: "headPhone_icon"), UIImage(named: "interest_Icon"), UIImage(named: "swin_Icon")]
    
    var editProfileData: ShowCompleteProfileData?
    
    var selectTextViewArray = [Int]()
    
    var indexArray : [Int] = []
    
    let image_picker = UIImagePickerController()
    
    var cropStyle:TOCropViewCroppingStyle?
    
    var cropViewController = TOCropViewController()
    
    var pageCount: Int = 0
    
    var arrayCount: Int = 0
    
    var selectedTextView:Int = -1
    
    var textViewArray = [String]()
    
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
    
    var indexDictionaryStoredArray = [Int :[Int: String]]()
    
    var indexDictionaryQuestionStoredArray = [Int :[Int: String]]()
    
    var indexDictionaryIdStoredArray = [Int :[Int: String]]()
    
    var checkOffsetValue: Int = 0
    
    var tempCategories = ""
    
    var indexDropDownValie = 0
    
    var indexTypedArray = [Int :[Int: Bool]]()
    
    var categoriesNewId = ""
    
    var hoobiesId = ""
    
    var intersetId = ""
    
    var previusArrayStoredCount = 0
    
    var timer = Timer()
    
    
    // MARK: - Default View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProfileData(offset: "0")
        
        
        self.previous_btn.isHidden = true
        
        
        self.editProfile_TableView.register(UINib(nibName: "CompleteProfile", bundle: nil
        ), forCellReuseIdentifier: "CompleteProfileTableViewCell")
        
        
        
        hobbies_CollectionView.register(UINib(nibName: "ViewProfileCollectionView", bundle: nil), forCellWithReuseIdentifier: "ViewProfileCollectionViewCell")
        
        selectInterests_CollectionView.register(UINib(nibName: "ViewProfileCollectionView", bundle: nil), forCellWithReuseIdentifier: "ViewProfileCollectionViewCell")
        
    }
    
    deinit {
        print(#file)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Edit Account", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        
        
        //        self.indexDictionaryIdStoredArray.removeAll()
        //
        //        self.indexDictionaryStoredArray.removeAll()
        //
        //        self.indexDictionaryQuestionStoredArray.removeAll()
        //
        //        self.indexArray.removeAll()
        //
        //        self.indexTypedArray.removeAll()
        
        //            self.navigationController?.popViewController(animated: true
        //            )
        
    }
    
    // MARK: - Button Action
    
    
    
    @IBAction func tapProfileStatus_btn(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            if self.onlyMe_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.selectProfile = ""
                
                self.public_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                
            }
                
            else if onlyMe_btn.currentImage == UIImage(named: "radioGray_Icon") {
                
                self.onlyMe_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
                self.selectProfile = "onlyme"
                
                self.public_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
            
        }
        
        if sender.tag == 1 {
            
            if self.private_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.selectProfile = ""
                
                self.public_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
                
            else if private_btn.currentImage == UIImage(named: "radioGray_Icon") {
                
                self.private_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
                self.selectProfile = "private"
                
                self.public_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
            
        }
        
        if sender.tag == 2 {
            
            if self.public_btn.currentImage == UIImage(named: "radioBlue_Icon") {
                
                self.public_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.selectProfile = ""
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
                
            else if self.public_btn.currentImage == UIImage(named: "radioGray_Icon") {
                
                self.public_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                
                self.selectProfile = "public"
                
                self.private_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
                self.onlyMe_btn.setImage(UIImage(named: "radioGray_Icon"), for: .normal)
                
            }
            
        }
        
        
    }
    
    
    @objc func tapSelection_btn(_ sender: UIButton) {
        
        if sender.accessibilityIdentifier == "categories" {
            
            //            popoverContent.condition = "category"
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CourseCoveredPopViewController") as! CourseCoveredPopViewController
            
            vc.condition = "EditProfile"
            
            vc.courseCoveredData = self.editProfileData?.userDetail.userCourseCovered
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if sender.accessibilityIdentifier == "hobbies" {
            
            guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionPopUpControllerViewController") as? SelectionPopUpControllerViewController else {return}
            
            popoverContent.controller = self
            
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            
            
            popoverContent.preferredContentSize = CGSize(width: 300, height: 200)
            
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
    
    
    @IBAction func tapPrevious_btn(_ sender: Any) {
        
        self.view.endEditing(true)
        
        self.indexArray.removeAll()
        
        self.conditionFlag = "Previous"
        
        self.pageCount -= 1
        
        if self.pageCount == 0 {
            
            
            self.currentOffset = self.currentOffset - 5
            
            self.checkOffsetValue = currentOffset + 1
            
            // self.showAnswerData(offset: String(currentOffset))
            self.setProfileData(offset: String(self.currentOffset))
            
            self.previous_btn.isHidden = true
            
            print("self.currentOffset: -\(self.currentOffset)")
            
        }else {
            
            // self.setProfileQuestion(offset: self.currentOffset - 5)
            
            self.currentOffset = self.currentOffset - 5
            
            self.checkOffsetValue = currentOffset + 1
            
            self.setProfileData(offset: String(self.currentOffset))
            
            // self.showAnswerData(offset: String(currentOffset))
            
            self.previous_btn.isHidden = false
            
            print("self.currentOffset: -\(self.currentOffset)")
            
        }
        
        //         self.previousArrayCount -= self.editProfileData?.userQuesAns.rows?.count ?? 0
        //
        //        print("Previous Array: \(self.previousArrayCount)")
        
        
    }
    
    
    @IBAction func tapNext_btn(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if self.next_btn.currentTitle == "Submit" {
            
            self.buttonCondition = "Submit"
            
            self.conditionFlag = ""
            
            saveData()
            
        }else {
            
            self.conditionFlag = ""
            
            self.saveData()
            
        }
        
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
    
    
    
}

// MARK: - Table View Delegate
extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.editProfileData?.userQuesAns.rows?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.editProfile_TableView.dequeueReusableCell(withIdentifier: "CompleteProfileTableViewCell") as! CompleteProfileTableViewCell
        
        
        if conditionFlag == "Previous" {
            
            cell.answer_TextView.delegate = self
            
            cell.answer_TextView.tag = indexPath.row
            
            if self.indexDictionaryStoredArray[self.pageCount]?[indexPath.row] != "" {
                
                
                cell.answer_TextView.text = self.indexDictionaryStoredArray[self.pageCount]?[indexPath.row]
                
            } else {
                
                cell.answer_TextView.text! = ""
                
            }
            
            
            if self.indexTypedArray[self.pageCount]![indexPath.row] == true {
                
                cell.select_View.backgroundColor = UIColor.appSkyBlue
                
                cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                
            }else {
                
                cell.select_View.backgroundColor = UIColor.appLightGreyColor
                
                cell.selectCircle_ImageView.backgroundColor = UIColor.appLightGreyColor
                
            }
            
            
            
            if !self.indexDictionaryQuestionStoredArray.isEmpty {
                
                if let data  = self.indexDictionaryQuestionStoredArray[self.pageCount] {
                    
                    cell.question_lbl.text = data[indexPath.row]
                } else {
                    cell.question_lbl.text! = ""
                }
                
            } else {
                
                cell.question_lbl.text! = ""
                
            }
           
            if self.editProfileData?.userQuesAns.rows?[indexPath.row].questionType ?? "" == "categories"
                
            {
                cell.selectDropDown_btn.setImage(UIImage(named: "plus_btn"), for: .normal)
                
                cell.selectDropDown_btn.isHidden = false
                
                cell.answer_TextView.isUserInteractionEnabled = false
                
                cell.selectDropDown_btn.accessibilityIdentifier = "categories"
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil)
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, queue: nil) { (Notification) in
                    
                    cell.selectDropDown_btn.setImage(UIImage(named: "plus_btn"), for: .normal)
                    
                    cell.selectDropDown_btn.isHidden = false
                    
                    cell.answer_TextView.isUserInteractionEnabled = false
                    
                    let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                    
                    let data = dict["Name"] as! NSArray
                    
                    let categData = dict["Id"] as! NSArray
                    
                    if data.count == 0 {
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath.row)
                        
                        self.selectTextViewArray[indexPath.row] = 0
                        
                        cell.select_View.backgroundColor = UIColor.appLightGreyColor
                        
                        cell.selectCircle_ImageView.backgroundColor = UIColor.appLightGreyColor
                        
                    }else {
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                        
                        self.selectTextViewArray[indexPath.row] = 1
                        
                        cell.select_View.backgroundColor = UIColor.appSkyBlue
                        
                        cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                        
                    }
                    
                    cell.answer_TextView.text = ""
                    
                    self.categoriesArray = dict["result"] as! NSArray
                    
                    var name = ""
                    var categoryId = ""
                    
                    
                    for i in 0..<categData.count {
                        
                        categoryId += "\(categData[i]),"
                    }
                    
                    
                    
                    for i in 0..<data.count {
                        
                        
                        
                        name += "\(data[i]),"
                        
                        
                        
                    }
                    self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath.row)
                    
                    
                    self.indexArray[indexPath.row] = 1
                    
                    cell.answer_TextView.text! = name
                    
                    self.categoriesNewId = categoryId
                    
                    
                    
                    self.tempCategories = name
                    
                    
                    
                    self.indexDropDownValie = indexPath.row
                    
                    self.editProfile_TableView.reloadData()
                    
                }
                
            } else if cell.question_lbl.text == "Hobbies"
                
            {
                cell.selectDropDown_btn.setImage(UIImage(named: "downArrow_Icon"), for: .normal)
                cell.selectDropDown_btn.isHidden = false
                
                cell.answer_TextView.isUserInteractionEnabled = false
                
                cell.selectDropDown_btn.accessibilityIdentifier = "hobbies"
                
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil)
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, queue: nil) { (Notification) in
                    
                    cell.selectDropDown_btn.isHidden = false
                    
                    cell.answer_TextView .isUserInteractionEnabled = false
                    
                    let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                    
                    let data = dict["Name"] as! NSArray
                    
                    
                    if data.count == 0 {
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath.row)
                        
                        self.selectTextViewArray[indexPath.row] = 0
                        
                        cell.select_View.backgroundColor = UIColor.appLightGreyColor
                        
                        cell.selectCircle_ImageView.backgroundColor = UIColor.appLightGreyColor
                        
                    }else {
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                        
                        self.selectTextViewArray[indexPath.row] = 1
                        cell.select_View.backgroundColor = UIColor.appSkyBlue
                        
                        cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                        
                    }
                    
                    let hobbiesData = dict["Id"] as! NSArray
                    
                    
                    cell.answer_TextView.text = ""
                    
                    self.hobbiesIdArray = dict["Id"] as! NSArray
                    
                    var name = ""
                    
                    var hoobiesPreviousId = ""
                    
                    for i in 0..<hobbiesData.count{
                        
                        hoobiesPreviousId += "\(hobbiesData[i]),"
                        
                        
                    }
                    
                    
                    
                    for i in 0..<data.count {
                        
                        
                        
                        name += "\(data[i]),"
                        
                        
                        
                    }
                    
                    self.indexArray[indexPath.row] = 1
                    self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath.row)
                    
                    
                    
                    //self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                    
                    
                    
                    cell.answer_TextView.text! = name
                    
                    self.hoobiesId = hoobiesPreviousId
                    
                    self.tempCategories = name
                    
                    
                    self.indexDropDownValie = indexPath.row
                    
                    self.editProfile_TableView.reloadData()
                    
                }
                
            } else if cell.question_lbl.text == "Interest"{
                
                cell.selectDropDown_btn.setImage(UIImage(named: "downArrow_Icon"), for: .normal)
                
                cell.selectDropDown_btn.isHidden = false
                
                cell.answer_TextView.isUserInteractionEnabled = false
                
                cell.selectDropDown_btn.accessibilityIdentifier = "Interest"
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil)
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, queue: nil) { (Notification) in
                    
                    cell.selectDropDown_btn.isHidden = false
                    
                    cell.answer_TextView.isUserInteractionEnabled = false
                    
                    let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                    
                    let intersetPreviousData = dict["Id"] as! NSArray
                    
                    let data = dict["Name"] as! NSArray
                    
                    
                    if data.count == 0 {
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath.row)
                        
                        self.selectTextViewArray[indexPath.row] = 0
                        
                        cell.select_View.backgroundColor = UIColor.appLightGreyColor
                        
                        cell.selectCircle_ImageView.backgroundColor = UIColor.appLightGreyColor
                        
                    }else {
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                        
                        self.selectTextViewArray[indexPath.row] = 1
                        cell.select_View.backgroundColor = UIColor.appSkyBlue
                        
                        cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                        
                    }
                    
                    cell.answer_TextView.text = ""
                    
                    self.intersetIdArray = dict["Id"] as! NSArray
                    
                    var name = ""
                    
                    var intersetPreviousId = ""
                    
                    for i in 0..<data.count {
                        
                        name += "\(data[i]),"
                        
                    }
                    
                    for i in 0..<intersetPreviousData.count{
                        
                        intersetPreviousId += "\(intersetPreviousData[i]),"
                    }
                    
                    self.indexArray[indexPath.row] = 1
                    self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath.row)
                    
                    
                    
                    //self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                    
                    
                    cell.answer_TextView.text! = name
                    
                    self.intersetId = intersetPreviousId
                    
                    
                    self.tempCategories = name
                    
                    
                    
                    self.indexDropDownValie = indexPath.row
                    
                    self.editProfile_TableView.reloadData()
                    
                }
                
            } else {
                
                cell.selectDropDown_btn.isHidden = true
                
                cell.answer_TextView.isUserInteractionEnabled = true
                
            }
            
            cell.selectDropDown_btn.addTarget(self, action: #selector(tapSelection_btn(_:)), for: .touchUpInside)
            
            
        }else {
            
            cell.answer_TextView.delegate = self
            
            cell.answer_TextView.tag = indexPath.row
            
            if (!((indexDictionaryStoredArray[pageCount]?.isEmpty ?? true))) {
                
                if let data = self.indexDictionaryStoredArray[self.pageCount]
                {
                    cell.answer_TextView.text = data[indexPath.row]
                    
                    //                    imageView.backgroundColor = UIColor.appSkyBlue
                    //                    selectView.backgroundColor = UIColor.appSkyBlue
                    
                } else {
                    
                    cell.answer_TextView.text = ""
                    
                    
                }
                
                //            imageView.backgroundColor = UIColor.appSkyBlue
                //            selectView.backgroundColor = UIColor.appSkyBlue
                
            }else {
                
                //                    imageView.backgroundColor = UIColor.appDarKGray
                //                    selectView.backgroundColor = UIColor.appDarKGray
                
                
            }
            
            if self.editProfileData?.userQuesAns.rows?[indexPath.row].questionType ?? "" == "categories" || self.editProfileData?.userQuesAns.rows?[indexPath.row].questionType ?? "" == "hobbies" || self.editProfileData?.userQuesAns.rows?[indexPath.row].questionType ?? "" == "interest"  {
                
                if  self.editProfileData?.userQuesAns.rows?[indexPath.row].questionType ?? "" == "categories" {
                     cell.selectDropDown_btn.setImage(UIImage(named: "plus_btn"), for: .normal)
                    
                    cell.selectDropDown_btn.accessibilityIdentifier = "categories"
                    
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil)
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, queue: nil) { (Notification) in
                        
                        
                       // sleep(2)                            // your code here
                       
                        Indicator.shared.showProgressView(self.view)
                        
                        let count = self.editProfileData?.userQuesAns.rows?.count ?? 0
                        
                        if String(describing: UserDefaults.standard.value(forKey: "signUpTime")!) == "second" {
                            
                            self.pageCount = 0
                            
                            let newCount = self.indexDictionaryQuestionStoredArray[self.pageCount]?.count ?? 0
                            
                            UserDefaults.standard.set("third", forKey: "signUpTime")
                            
                            if self.indexArray.count != 0 {
                                
                                self.indexArray.removeAll()
                                
                                for _ in 0..<newCount {
                                    self.indexArray.append(0)
                                    
                                }
                                
                            } else {
                                
                                for _ in 0..<newCount {
                                    self.indexArray.append(0)
                                    
                                }
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
                        
//                        if self.indexArray.isEmpty {
//
//                            for  _ in 0..<count {
//
//                                self.indexArray.append(0)
//                            }
//
//
//                        }else {
//
//
//                        }
                        
                        let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                        
                        let data = dict["Name"] as! NSArray
                        
                        
                        if data.count == 0 {
                            
                            self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath.row)
                            
                            self.selectTextViewArray[indexPath.row] = 0
                            
                            cell.select_View.backgroundColor = UIColor.appLightGreyColor
                            
                            cell.selectCircle_ImageView.backgroundColor = UIColor.appLightGreyColor
                            
                        }else {
                            
                            self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                            
                            self.selectTextViewArray[indexPath.row] = 1
                            cell.select_View.backgroundColor = UIColor.appSkyBlue
                            
                            cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                            
                        }
                        
                        //   let dataId = dict["Id"] as! NSArray
                        
                        cell.answer_TextView.text! = ""
                        
                        //self.categoriesArray = dict["Id"] as! NSArray
                        
                        var name = ""
                        
                        var cateId = ""
                        
                        for i in 0..<data.count {
                            
                            if "\(data[i])" == "" {
                                
                            }else {
                                
                                name += "\(data[i]),"
                                
                            }
                            
                        }
                        //
                        //                        for i in 0..<dataId.count {
                        //
                        //                            cateId += "\(dataId[i]),"
                        //
                        //
                        //                        }
                        
                        
                        
                        self.indexArray[indexPath.row] = 1
                        
                        cell.answer_TextView.text = name
                        
                        self.tempCategories = name
                        
                        self.categoriesNewId = cateId
                        
                        self.indexDropDownValie = indexPath.row
                        self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath.row)
                        
                        
                        
                        //self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                        //
                        //
                        //                        self.tempCategories = name
                        //
                        //
                        //
                        
                        self.categoriesArray = dict["result"] as! NSArray
                        self.indexDropDownValie = indexPath.row
                        
                        self.editProfile_TableView.reloadData()
                        
                         Indicator.shared.hideProgressView()
                            
                       // }
                        
                    }
                    
                }else if  self.editProfileData?.userQuesAns.rows?[indexPath.row].questionType ?? "" == "hobbies" {
                    
                    cell.selectDropDown_btn.setImage(UIImage(named: "downArrow_Icon"), for: .normal)
                    
                    cell.selectDropDown_btn.accessibilityIdentifier = "hobbies"
                    
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "hobbies"), object: nil)
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "hobbies"), object: nil, queue: nil) { (Notification) in
                        
                        
                        let count = self.editProfileData?.userQuesAns.rows?.count ?? 0
                        
                        if self.indexArray.isEmpty {
                            
                            for  _ in 0..<count {
                                
                                self.indexArray.append(0)
                            }
                            
                            
                        }else {
                            
                            
                        }
                        
                        let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                        
                        let data = dict["Name"] as! NSArray
                        
                        let hobbiesData = dict["Id"] as! NSArray
                        
                        self.hobbiesIdArray = dict["Id"] as! NSArray
                        
                        if data.count == 0 {
                            
                            self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath.row)
                            
                            self.selectTextViewArray[indexPath.row] = 0
                            cell.select_View.backgroundColor = UIColor.appLightGreyColor
                            
                            cell.selectCircle_ImageView.backgroundColor = UIColor.appLightGreyColor
                            
                        }else {
                            
                            self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                            
                            self.selectTextViewArray[indexPath.row] = 1
                            cell.select_View.backgroundColor = UIColor.appSkyBlue
                            
                            cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                            
                        }
                        
                        var name = ""
                        
                        var hobbiId = ""
                        
                        
                        for i in 0..<hobbiesData.count {
                            
                            hobbiId += "\(hobbiesData[i]),"
                        }
                        
                        for i in 0..<data.count {
                            
                            name += "\(data[i]),"
                            
                        }
                        
                        cell.answer_TextView.text = name
                        
                        self.hoobiesId = hobbiId
                        
                        self.tempCategories = name
                        
                        self.indexArray[indexPath.row] = 1
                        self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath.row)
                        
                        
                        self.tempCategories = name
                        
                        self.indexDropDownValie = indexPath.row
                        
                        self.editProfile_TableView.reloadData()
                    }
                    
                }else {
                    
                    cell.selectDropDown_btn.accessibilityIdentifier = "interest"
                    
                    cell.selectDropDown_btn.setImage(UIImage(named: "downArrow_Icon"), for: .normal)
                    
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "interest"), object: nil)
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "interest"), object: nil, queue: nil) { (Notification) in
                        
                        
                        let count = self.editProfileData?.userQuesAns.rows?.count ?? 0
                        
                        if self.indexArray.isEmpty {
                            
                            for  _ in 0..<count {
                                
                                self.indexArray.append(0)
                            }
                            
                            
                        }else {
                            
                            
                        }
                        
                        let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                        
                        let data = dict["Name"] as! NSArray
                        
                        let intersetData = dict["Id"] as! NSArray
                        
                        
                        if data.count == 0 {
                            
                            self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: indexPath.row)
                            
                            self.selectTextViewArray[indexPath.row] = 0
                            cell.select_View.backgroundColor = UIColor.appLightGreyColor
                            
                            cell.selectCircle_ImageView.backgroundColor = UIColor.appLightGreyColor
                            
                        }else {
                            
                            self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                            
                            self.selectTextViewArray[indexPath.row] = 1
                            cell.select_View.backgroundColor = UIColor.appSkyBlue
                            
                            cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                            
                        }
                        
                        self.intersetIdArray = dict["Id"] as! NSArray
                        
                        var name = ""
                        
                        
                        var intresId = ""
                        
                        
                        for i in 0..<data.count {
                            
                            name += "\(data[i]),"
                            
                        }
                        
                        for i in 0..<intersetData.count {
                            
                            intresId += "\(intersetData[i]),"
                        }
                        self.intersetId = intresId
                        
                        cell.answer_TextView.text = name
                        
                        //self.tempCategories = name
                        self.indexDictionaryStoredArray[self.pageCount]?.updateValue(name, forKey: indexPath.row)
                        
                        
                        
                        self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: indexPath.row)
                        
                        self.indexArray[indexPath.row] = 1
                        
                        
                        self.tempCategories = name
                        
                        self.indexDropDownValie = indexPath.row
                        
                        self.editProfile_TableView.reloadData()
                    }
                    
                }
                
                cell.answer_TextView.placeholder = "Select"
                
                cell.answer_TextView.isUserInteractionEnabled = false
                
                cell.selectDropDown_btn.isHidden = false
                
                //cell.selectDropDown_btn.tag = indexPath.row
                
                cell.selectDropDown_btn.addTarget(self, action: #selector(tapSelection_btn(_:)), for: .touchUpInside)
                
                //cell.select_View.isHidden = true
                
            }else {
                
                cell.selectDropDown_btn.isHidden = true
                
                cell.answer_TextView.isUserInteractionEnabled = true
                
                cell.answer_TextView.placeholder = "type answer ...."
                
                //cell.select_View.isHidden = false
                
            }
            
            if selectTextViewArray[indexPath.row] == 1 {
                
                cell.select_View.backgroundColor = UIColor.appSkyBlue
                
                cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                
            }else {
                
                cell.select_View.backgroundColor = UIColor.appLightGreyColor
                
                cell.selectCircle_ImageView.backgroundColor = UIColor.appLightGreyColor
                
            }
            
            
            if !self.indexDictionaryQuestionStoredArray.isEmpty {
                
                if let data  = self.indexDictionaryQuestionStoredArray[self.pageCount] {
                    
                    cell.question_lbl.text = data[indexPath.row]
                    // textView.text = ""
                } else {
                    
                    cell.question_lbl.text = ""
                    //textView.text = ""
                }
                
            } else {
                
                // textView.text = ""
                cell.question_lbl.text = " "
                
            }
            
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
    // MARK: textView Delegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.conditionFlag == "Previous"
        {
            
            if textView.text!.isEmpty {
                
                self.selectTextViewArray[textView.tag] = 0
                
                //self.indexArray.append(textView.tag)
                
            }else {
                
                self.indexArray[textView.tag] = 1
                
                self.selectTextViewArray[textView.tag] = 1
                self.textViewArray.insert(textView.text!, at: textView.tag)
                
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
            
        }else {
            
            if textView.text!.isEmpty {
                
                // self.indexArray.append(textView.tag)
                
                self.selectTextViewArray[textView.tag] = 0
                
            }else {
                
                self.indexArray[textView.tag] = 1
                
                self.selectTextViewArray[textView.tag] = 1
                self.textViewArray.insert(textView.text!, at: textView.tag)
                
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
            
            //        self.indexDictionaryStoredArray.updateValue(self.sectionDict, forKey: self.pageCount)
            
            self.indexDictionaryStoredArray[self.pageCount]?.updateValue(textView.text, forKey: textView.tag)
            
        }
        
        self.editProfile_TableView.reloadData()
        
        print(selectTextViewArray)
        
        print(textViewArray)
        
        print(self.indexDictionaryQuestionStoredArray)
        print(self.indexDictionaryStoredArray)
        print(self.indexDictionaryIdStoredArray)
        
        
    }
    
    
    
    
}


// MARK: - Collection View Delegate
extension EditProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == hobbies_CollectionView {
            
            return selectHobbiesNameArray.count
            
        }else {
            
            return self.selectInterestsImageArray.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hobbies_CollectionView {
            
            let cell = self.hobbies_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewProfileCollectionViewCell", for: indexPath) as! ViewProfileCollectionViewCell
            
            cell.descriptionValue_lbl.text = self.selectHobbiesNameArray[indexPath.row]
            cell.description_ImageView.image = self.selectHobbiesImageArray[indexPath.row]
            
            return cell
            
        }else {
            
            let cell = self.selectInterests_CollectionView.dequeueReusableCell(withReuseIdentifier: "ViewProfileCollectionViewCell", for: indexPath) as! ViewProfileCollectionViewCell
            
            cell.description_ImageView.image = self.selectInterestsImageArray[indexPath.row]
            
            cell.descriptionValue_lbl.text = ""
            
            
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100
            , height: 104 )
        
    }
    
}


// MARK: - Service Response

extension EditProfileViewController {
    
    // MARK: - Set Data
    
    func setProfileData(offset: String) {
        // UserData().userId
        let param = ["user_id": UserData().userId ,"offset": offset] as [String: AnyObject]
        
        Indicator.shared.showProgressView(self.view)
        
        print(param)
        Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "view_profile_questions_answer_limit", params: param as [String: AnyObject]) {[weak self] (receviedData) in
            
            //print(receviedData)
            guard let self = self else {
                return
            }
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [String: AnyObject]else {
                        
                        return
                    }
                    
                    do{
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        
                        self.editProfileData = try newJSONDecoder().decode(ShowCompleteProfileData.self, from: jsonData)
                        
                        
                        if  self.conditionFlag == "Previous"{
                            
                            
                            self.previousArrayCount -= self.indexDictionaryQuestionStoredArray[self.pageCount + 1]?.count ?? 0
                            
                            print("Previous Array previous: \(self.previousArrayCount)")
                        }else {
                            self.previousArrayCount += self.editProfileData?.userQuesAns.rows?.count ?? 0
                            
                            self.previusArrayStoredCount = self.editProfileData?.userQuesAns.rows?.count ?? 0
                            print("Previous Array Next: \(self.previousArrayCount)")
                            
                        }
                        
                        if self.indexTypedArray[self.pageCount]?.isEmpty == nil {
                            
                            self.indexTypedArray.updateValue([Int : Bool](), forKey: self.pageCount)
                            
                        }
                        
                        let dataCount = self.editProfileData?.userQuesAns.rows?.count ?? 0
                        
                        self.selectTextViewArray.removeAll()
                        
                        
                        var questionId = [Int : String]()
                        
                        var arrYQuestion = [Int : String]()
                        
                        var answerData = [Int: String]()
                        
                        for i in 0..<dataCount {
                            
                            arrYQuestion.updateValue(self.editProfileData?.userQuesAns.rows?[i].question ?? "" , forKey: i)
                            
                            questionId.updateValue(String(self.editProfileData?.userQuesAns.rows?[i].id ?? 0), forKey: i)
                            
                            if (self.editProfileData?.userQuesAns.rows?[i].quesAnswers?.isEmpty)! {
                                
                                answerData.updateValue("", forKey: i)
                                self.selectTextViewArray.insert(0, at: i)
                                self.textViewArray.insert("", at: i)
                                self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: i)
                                
                            }else {
                                
                                if self.editProfileData?.userQuesAns.rows?[i].quesAnswers?[0].answer != "" {
                                    answerData.updateValue(self.editProfileData?.userQuesAns.rows?[i].quesAnswers?[0].answer ?? "", forKey: i)
                                    
                                    self.selectTextViewArray.insert(1, at: i)
                                    self.textViewArray.insert(self.editProfileData?.userQuesAns.rows?[i].quesAnswers?[0].answer ?? "", at: i)
                                    
                                    self.indexTypedArray[self.pageCount]?.updateValue(true, forKey: i)
                                }else {
                                    answerData.updateValue(self.editProfileData?.userQuesAns.rows?[i].quesAnswers?[0].answer ?? "", forKey: i)
                                    
                                    self.selectTextViewArray.insert(0, at: i)
                                    self.textViewArray.insert(self.editProfileData?.userQuesAns.rows?[i].quesAnswers?[0].answer ?? "", at: i)
                                    
                                    self.indexTypedArray[self.pageCount]?.updateValue(false, forKey: i)
                                    
                                }
                                
                            }
                            
                            
                            
                            self.indexArray.append(0)
                            
                        }
                        
                        self.indexDictionaryQuestionStoredArray.updateValue(arrYQuestion, forKey: self.pageCount)
                        
                        self.indexDictionaryIdStoredArray.updateValue(questionId, forKey: self.pageCount)
                        
                        if self.conditionFlag != "Previous" {
                            
                            self.indexDictionaryStoredArray.updateValue(answerData, forKey: self.pageCount)
                        }
                        
                        
                        if self.indexDictionaryStoredArray.isEmpty {
                            
                            self.indexDictionaryStoredArray.updateValue([Int : String](), forKey: self.pageCount)
                            
                        } else {
                            if let data = self.indexDictionaryStoredArray[self.pageCount]
                            {
                                
                            } else {
                                self.indexDictionaryStoredArray.updateValue([Int : String](), forKey: self.pageCount)
                                
                            }
                        }
                        
                        
                        if self.editProfileData?.userDetail.userCourseCovered?.count != 0 {
                            
                            let userProfileCount = self.editProfileData?.userDetail.userCourseCovered?.count ?? 0
                            
                            // var categoryId = ""
                            
                            var courseDict = [String: AnyObject]()
                            
                            var resultArray = [[String: AnyObject]]()
                            
                            for i in 0..<userProfileCount {
                                
                                courseDict["course_id"] = self.editProfileData?.userDetail.userCourseCovered?[i].courseID as AnyObject
                                
                                
                                courseDict["answer"] = self.editProfileData?.userDetail.userCourseCovered?[i].answer as AnyObject
                                
                                resultArray.append(courseDict)
                            }
                            
                            self.categoriesArray = resultArray as NSArray
                            
                        }
                        
                        
                        if self.editProfileData?.userDetail.userHobbies?.count != 0 {
                            
                            let userProfileCount = self.editProfileData?.userDetail.userHobbies?.count ?? 0
                            
                            var hoobiesId1 = ""
                            
                            for i in 0..<userProfileCount {
                                
                                hoobiesId1 += "\(self.editProfileData?.userDetail.userHobbies?[i].hobbies?.id ?? 0),"
                            }
                            
                            self.hoobiesId = hoobiesId1
                            
                            
                        }
                        
                        
                        if self.editProfileData?.userDetail.userHobbiesInterests?.count != 0 {
                            
                            let userProfileCount = self.editProfileData?.userDetail.userHobbiesInterests?.count ?? 0
                            
                            var interstId = ""
                            
                            for i in 0..<userProfileCount {
                                
                                interstId += "\(self.editProfileData?.userDetail.userHobbiesInterests?[i].hobbiesInterests?.id ?? 0),"
                            }
                            
                            self.intersetId = interstId
                            
                            
                        }
                        
                        if self.editProfileData?.userDetail.profileImage == nil {
                            
                            self.profile_ImageView.image = UIImage(named: "userProfile_ImageView")
                            
                        }else {
                            
                            self.profile_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.editProfileData?.userDetail.profileImage)!), placeholderImage: UIImage(named: "userProfile_ImageView"))
                            
                        }
                        
                        
                        if self.previousArrayCount == self.editProfileData?.userQuesAns.count ?? 0 {
                            
                            //                            self.profileTitle_lbl.isHidden = false
                            //                            self.profileStack_View.isHidden = false
                            //                            self.profileStack_Height.constant = 30
                            
                            self.next_btn.setTitle("Submit", for: .normal)
                            
                            if self.editProfileData?.userDetail.profileStatus != nil {
                                
                                self.profileTitle_lbl.isHidden = false
                                
                                self.profileStack_View.isHidden = false
                                self.profileStack_Height.constant = 30
                                
                                
                                if self.editProfileData?.userDetail.profileStatus == "public" {
                                    
                                    self.public_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                                    
                                }else if  self.editProfileData?.userDetail.profileStatus == "private" {
                                    self.private_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                                    
                                }else {
                                    
                                    self.onlyMe_btn.setImage(UIImage(named: "radioBlue_Icon"), for: .normal)
                                }
                            }else {
                                
                                self.profileStack_View.isHidden = true
                                self.profileStack_Height.constant = 0
                                self.profileTitle_lbl.isHidden = true
                                
                            }
                            
                            
                        }else {
                            
                            self.profileTitle_lbl.isHidden = true
                            self.profileStack_View.isHidden = true
                            self.profileStack_Height.constant = 0
                            
                            self.next_btn.setTitle("Next", for: .normal)
                        }
                        
                        
                        print(self.textViewArray)
                        print(self.selectTextViewArray)
                        print(self.sectionDict)
                        print(self.indexDictionaryQuestionStoredArray)
                        print(self.indexDictionaryStoredArray)
                        print(self.indexDictionaryIdStoredArray)
                        print(self.indexTypedArray)
                        
                        
                        self.editProfile_TableView.delegate = self
                        
                        self.editProfile_TableView.dataSource = self
                        
                        self.hobbies_CollectionView.delegate = self
                        
                        self.hobbies_CollectionView.dataSource = self
                        
                        self.selectInterests_CollectionView.delegate = self
                        
                        self.selectInterests_CollectionView.dataSource = self
                        
                        self.editProfile_TableView.reloadData()
                        
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
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
            
        }
        
        
    }
    
    
    // MARK: - Save Data
    
    func saveData() {
        
        Indicator.shared.showProgressView(self.view)
        
        var dataArray = [[String: AnyObject]]()
        
        var resultDict = [String: AnyObject]()
        
        if conditionFlag == "Previous" {
            
            for i in 0..<self.indexArray.count {
                
                // if self.indexArray[i] == 1 {
                
                resultDict["question_id"] = self.indexDictionaryIdStoredArray[self.pageCount]![i]! as AnyObject
                
                resultDict["answer"] = self.indexDictionaryStoredArray[self.pageCount]![i] as AnyObject
                
                dataArray.append(resultDict)
                
                //}
                
            }
            
        }else if self.conditionFlag == "Next" {
            
            
            
            for i in 0..<self.indexArray.count {
                
                // if self.indexArray[i] == 1 {
                
                resultDict["question_id"] = self.indexDictionaryIdStoredArray[self.pageCount]![i]! as AnyObject
                
                resultDict["answer"] = self.indexDictionaryStoredArray[self.pageCount]![i] as AnyObject
                
                dataArray.append(resultDict)
                
                //}
                
            }
            
        }else {
            
            for i in 0..<self.indexArray.count {
                
                // if self.indexArray[i] == 1 {
                
                resultDict["question_id"] = self.indexDictionaryIdStoredArray[self.pageCount]![i]! as AnyObject
                
                resultDict["answer"] = self.indexDictionaryStoredArray[self.pageCount]![i] as AnyObject
                
                dataArray.append(resultDict)
                
                //}
                
            }
            
        }
        
        let param = ["user_id": UserData().userId,"edit_answer": dataArray ,"profile_status": selectProfile,"hobbies_id": self.hoobiesId,"interest_id": self.intersetId,"categories_id": self.categoriesArray] as [String: AnyObject]
        
        print(param)
        
        if profile_ImageView.image == UIImage(named: "userProfile_ImageView") {
            Singleton.sharedInstance.connection.startConnectionWithPostType(getUrlString: "edit_profile", params: param as [String: AnyObject]) {[weak self] (receviedData) in
                
                print(receviedData)
                
                guard let self = self else {
                    return
                }
                
                
                Indicator.shared.hideProgressView()
                
                if Singleton.sharedInstance.connection.responseCode == 1 {
                    
                    if receviedData["response"] as? Bool == true {
                        
                        if String(describing: (receviedData["data"] as! [String: AnyObject])["profile_image"]!) == "" {
                            self.profile_ImageView.image = UIImage(named: "userProfile_ImageView")
                            
                        }else {
                            
                            self.profile_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: (receviedData["data"] as! [String: AnyObject])["profile_image"]!)), placeholderImage: UIImage(named: "userProfile_ImageView"))
                        }
                        
                        UserDefaults.standard.setValue((NSKeyedArchiver.archivedData(withRootObject: receviedData["data"]  as! [String: AnyObject])), forKey: "userData")
                        
                        self.indexArray.removeAll()
                        
                        self.pageCount += 1
                        
                        self.setProfileData(offset: String((self.editProfileData?.userQuesAns.rows?.count ?? 0) * self.pageCount))
                        
                        self.currentOffset = (self.editProfileData?.userQuesAns.rows?.count ?? 0) * self.pageCount
                        
                        print(self.currentOffset)
                        
                        //                        self.checkOffsetValue = ((((self.editProfileData?.rows?.count)!) * self.pageCount)) + 1
                        //
                        print("currentOffsetSaveData\(self.currentOffset)")
                        
                        
                        
                        self.sectionDict.removeAll()
                        
                        if self.pageCount > 0 {
                            
                            self.previous_btn.isHidden = false
                            
                        }else {
                            
                            self.previous_btn.isHidden = true
                            
                        }
                        
                        if self.buttonCondition == "Submit" {
                            
                            
                            
                            self.indexDictionaryIdStoredArray.removeAll()
                            
                            self.indexDictionaryStoredArray.removeAll()
                            
                            self.indexDictionaryQuestionStoredArray.removeAll()
                            
                            self.indexArray.removeAll()
                            
                            self.indexTypedArray.removeAll()
                            
                            self.navigationController?.popViewController(animated: true
                            )
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name("viewProfile"), object: nil, userInfo: nil)
                        
                    }else {
                        
                        self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                        
                    }
                    
                }else {
                    
                    self.showDefaultAlert(Message: receviedData["Error"] as! String)
                    
                }
                
            }
            
        }else {
            
            let name = String(describing: Date().toMillis()!) + UserData().userId + "image.jpeg"
            
            Singleton.sharedInstance.connection.startConnectionWithSingleFile(FileData: self.profile_ImageView.image!.jpegData(compressionQuality: 0.8) as! Data, FileName: name, FileType: "image/jpg", FileParam: "profile_image", getUrlString: "edit_profile", params: param as [String: AnyObject]) { (receviedData,responseCode) in
                
                print(receviedData)
                Indicator.shared.hideProgressView()
                if responseCode == 1 {
                    
                    if receviedData["response"] as? Bool == true {
                        
                        
                        if String(describing: (receviedData["data"] as! [String: AnyObject])["profile_image"]!) == "" {
                            self.profile_ImageView.image = UIImage(named: "userProfile_ImageView")
                            
                        }else {
                            
                            self.profile_ImageView.sd_setImage(with: URL(string: profileImageUrl + String(describing: (receviedData["data"] as! [String: AnyObject])["profile_image"]!)), placeholderImage: UIImage(named: "userProfile_ImageView"))
                        }
                        
                        UserDefaults.standard.setValue((NSKeyedArchiver.archivedData(withRootObject: receviedData["data"]  as! [String: AnyObject])), forKey: "userData")
                        
                        self.indexArray.removeAll()
                        
                        self.pageCount += 1
                        
                        self.setProfileData(offset: String((self.editProfileData?.userQuesAns.rows?.count ?? 0) * self.pageCount))
                        
                        self.currentOffset = (self.editProfileData?.userQuesAns.rows?.count ?? 0) * self.pageCount
                        
                        print(self.currentOffset)
                        
                        //                        self.checkOffsetValue = ((((self.editProfileData?.rows?.count)!) * self.pageCount)) + 1
                        //
                        print("currentOffsetSaveData\(self.currentOffset)")
                        
                        
                        
                        self.sectionDict.removeAll()
                        
                        if self.pageCount > 0 {
                            
                            self.previous_btn.isHidden = false
                            
                        }else {
                            
                            self.previous_btn.isHidden = true
                            
                        }
                        
                        if self.buttonCondition == "Submit" {
                            
                            self.indexDictionaryIdStoredArray.removeAll()
                            
                            self.indexDictionaryStoredArray.removeAll()
                            
                            self.indexDictionaryQuestionStoredArray.removeAll()
                            
                            self.indexArray.removeAll()
                            
                            self.indexTypedArray.removeAll()
                            
                            self.navigationController?.popViewController(animated: true
                            )
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name("viewProfile"), object: nil, userInfo: nil)
                        
                        
                    }else {
                        
                        self.showDefaultAlert(Message: receviedData["Error"] as! String)
                        
                    }
                    
                }else {
                    
                    self.showDefaultAlert(Message: receviedData["Error"] as! String)
                    
                }
                
            }
            
        }
        
    }
}

extension EditProfileViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
        
    }
}

// MARK: - Image Picker Delegate

extension EditProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    
    
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
        
        cropViewController.cropView.setAspectRatio(CGSize(width: self.profile_ImageView.frame.size.width, height: self.profile_ImageView.frame.size.height  ), animated: true)
        
        
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

