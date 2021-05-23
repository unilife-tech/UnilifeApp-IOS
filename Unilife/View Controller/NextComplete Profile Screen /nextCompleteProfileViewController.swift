//
//  nextCompleteProfileViewController.swift
//  Unilife
//
//  Created by Apple on 02/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

struct QuestionData {
    
    var offet: Int
    
    var Ouestion: [Row]
}


class nextCompleteProfileViewController: UIViewController {
    
    // MARK: - outlet
    
    @IBOutlet weak var nextCompleteProfile_TableView: UITableView!
    
    // MARK: - Variable
    
    var questionArray = ["Question 6", "Question 7", "Question 8", "Question 9", "Question 10"]
    
    var nextQuestionArray = [[String: AnyObject]]()
    
    var selectedTextView:Int = -1
    
    var selectTextViewArray = [Int]()
    
    var completeProfile :CompleteProfile?
    
    var questionData = [QuestionData]()
    
    var pageCount: Int = 0
    
    var arrayCount: Int = 0
    
    var textViewArray = [String]()
    
    var sectionDict = [Int: String]()
    
    var hobbiesIdArray : NSArray = []
    
    var intersetIdArray : NSArray = []
    
    var categoriesArray : NSArray = []
    
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.nextCompleteProfile_TableView.register(UINib(nibName: "CompleteProfile", bundle: nil
        ), forCellReuseIdentifier: "CompleteProfileTableViewCell")
        
        self.setProfileQuestion(offset: 0)
        
        print(self.selectTextViewArray)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Button Action
    
    @IBAction func tapSubmit_btn(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    @IBAction func tapback_btn(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapSkip_btn(_ sender: Any) {
    }
    
    
    // MARK: - Categories Service
    
}

extension nextCompleteProfileViewController: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.questionData[0].Ouestion.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.nextCompleteProfile_TableView.dequeueReusableCell(withIdentifier: "CompleteProfileTableViewCell") as! CompleteProfileTableViewCell
        
        cell.question_lbl.text! = self.questionData[0].Ouestion[indexPath.row].question
        
        cell.answer_TextView.tag = indexPath.row
        
        if self.completeProfile?.rows[indexPath.row].questionType ?? "" == "categories" || self.completeProfile?.rows[indexPath.row].questionType ?? "" == "hobbies" || self.completeProfile?.rows[indexPath.row].questionType ?? "" == "interest"  {
            
            if  self.completeProfile?.rows[indexPath.row].questionType ?? "" == "categories" {
                
                cell.selectDropDown_btn.accessibilityIdentifier = "categories"
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil)
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, queue: nil) { (Notification) in
                    
                    let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                    
                    let data = dict["Name"] as! NSArray
                    
                    //                    if data.count == 0 {
                    //
                    //                        cell.select_View.backgroundColor = UIColor.white
                    //                        cell.selectCircle_ImageView.backgroundColor = UIColor.white
                    //
                    //                    }else {
                    //
                    //                        cell.select_View.backgroundColor = UIColor.appSkyBlue
                    //                        cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                    //
                    //
                    //                    }
                    
                    cell.answer_TextView.text = ""
                    self.categoriesArray = dict["Id"] as! NSArray
                    
                    var name = ""
                    
                    for i in 0..<data.count {
                        
                        name += "\(data[i]),"
                    }
                    
                    // cell.answer_TextView.text! = name
                    
                    self.textViewArray[indexPath.row] = name
                    
                    self.selectTextViewArray[indexPath.row] = 1
                    
                    self.nextCompleteProfile_TableView.reloadData()
                    
                }
                
                
            }else if  self.completeProfile?.rows[indexPath.row].questionType ?? "" == "hobbies" {
                cell.selectDropDown_btn.accessibilityIdentifier = "hobbies"
                
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "hobbies"), object: nil)
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "hobbies"), object: nil, queue: nil) { (Notification) in
                    
                    let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                    
                    let data = dict["Name"] as! NSArray
                    
                    self.hobbiesIdArray = dict["Id"] as! NSArray
                    
                    if data.count == 0 {
                        
                        cell.select_View.backgroundColor = UIColor.white
                        cell.selectCircle_ImageView.backgroundColor = UIColor.white
                        
                    }else {
                        
                        cell.select_View.backgroundColor = UIColor.appSkyBlue
                        cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                        
                        
                    }
                    
                    var name = ""
                    
                    for i in 0..<data.count {
                        
                        name += "\(data[i]),"
                    }
                    
                    self.textViewArray[indexPath.row] = name
                    
                    self.selectTextViewArray[indexPath.row] = 1
                    
                    self.nextCompleteProfile_TableView.reloadData()
                    
                }
                
            }else {
                cell.selectDropDown_btn.accessibilityIdentifier = "interest"
                NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "interest"), object: nil)
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "interest"), object: nil, queue: nil) { (Notification) in
                    
                    let dict = Notification.userInfo?["dataArray"] as! [String: AnyObject]
                    
                    let data = dict["Name"] as! NSArray
                    
                    if data.count == 0 {
                        
                        cell.select_View.backgroundColor = UIColor.white
                        cell.selectCircle_ImageView.backgroundColor = UIColor.white
                        
                    }else {
                        
                        cell.select_View.backgroundColor = UIColor.appSkyBlue
                        cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
                        
                        
                    }
                    
                    self.intersetIdArray = dict["Id"] as! NSArray
                    
                    var name = ""
                    
                    for i in 0..<data.count {
                        
                        name += "\(data[i]),"
                    }
                    
                    self.textViewArray[indexPath.row] = name
                    
                    self.selectTextViewArray[indexPath.row] = 1
                    
                    self.nextCompleteProfile_TableView.reloadData()
                    
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
            //cell.select_View.isHidden = false
        }
        
        cell.answer_TextView.delegate = self
        
        if self.textViewArray.count == 0 {
            
            cell.answer_TextView.text = ""
            
        }else {
            
            cell.answer_TextView.text! = self.textViewArray[indexPath.row]
            
        }
        
        if selectTextViewArray[indexPath.row] == 1 {
            
            cell.select_View.backgroundColor = UIColor.appSkyBlue
            cell.selectCircle_ImageView.backgroundColor = UIColor.appSkyBlue
        }else {
            
            cell.select_View.backgroundColor = UIColor.white
            cell.selectCircle_ImageView.backgroundColor = UIColor.white
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // MARK: textView Delegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        self.selectedTextView = textView.tag
        
        if self.selectTextViewArray[textView.tag] == 0 {
            
            self.selectTextViewArray[textView.tag] = 1
        }
            
        else
            if self.selectTextViewArray[textView.tag] == 1 {
                
                self.selectTextViewArray[textView.tag] = 0
        }
        
        self.nextCompleteProfile_TableView.reloadData()
        
        print(selectTextViewArray)
        
        
    }
    
    @objc func tapSelection_btn(_ sender: UIButton) {
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectionPopUpControllerViewController") as? SelectionPopUpControllerViewController else {return}
        
        
        popoverContent.controller = self
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popoverContent.preferredContentSize = CGSize(width: 300, height: 300)
        
        
        if sender.accessibilityIdentifier == "categories" {
            popoverContent.condition = "category"
            
        }else if sender.accessibilityIdentifier == "hobbies" {
            
            popoverContent.condition = "hobbies"
        }else {
            
            popoverContent.condition = ""
        }
        
        
        //        popoverContent.delegate = self
        //
        //        popoverContent.privacyFor = .story
        
        
        
        let popOver = popoverContent.popoverPresentationController
        
        popOver?.delegate = self
        
        popOver?.sourceView = sender as! UIView
        
        popOver?.sourceRect = (sender as AnyObject).bounds
        
        popOver?.permittedArrowDirections = [.up]
        
        
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
}

extension nextCompleteProfileViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

extension nextCompleteProfileViewController {
    
    func setProfileQuestion(offset: Int) {
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_profile_questions/\(offset)"){ (receviedData) in
            
            //print(receviedData)
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData["data"] as? [String:AnyObject] else {
                        
                        return
                    }
                    
                    do {
                        
                        let jasonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.completeProfile = try newJSONDecoder().decode(CompleteProfile.self, from: jasonData)
                        
                        //if let questionData = self.completeProfile?.rows {
                        
                        self.questionData.append(QuestionData(offet: offset , Ouestion: (self.completeProfile?.rows)!))
                        
                        let arrayCount = self.completeProfile?.rows.count ?? 0
                        
                        for i in 0..<arrayCount {
                            
                            self.selectTextViewArray.insert(0, at: i)
                            self.textViewArray.insert("", at: i)
                            
                            // self.textViewArray.insert("", at: i)
                            
                        }
                        
                        self.nextCompleteProfile_TableView.delegate = self
                        self.nextCompleteProfile_TableView.dataSource = self
                        
                        //}
                        
                        self.nextCompleteProfile_TableView.reloadData()
                        
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
