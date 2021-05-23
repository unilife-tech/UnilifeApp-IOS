//
//  CourseCoveredPopViewController.swift
//  Unilife
//
//  Created by Apple on 21/10/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class CourseCoveredPopViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate {
    
    
    
    // MARK: - Table View
    
    @IBOutlet weak var selectCourseCollection_View: UICollectionView!
    
    // MARK: - Variable
    
    var indexTagArray = [Int]()
    
    var textEnteredArray = [String]()
    
    var condition = ""
    
    var courseCoveredData: [UserCourseCovered]?
    
    var courseCoveredPreviousData = [[String: AnyObject]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectCourseCollection_View.delegate = self
        
        self.selectCourseCollection_View.dataSource = self
        
        if self.condition == "EditProfile" {
            
            for _ in 0..<6 {
                
            self.textEnteredArray.append("")
                
            self.indexTagArray.append(-1)
            }

        let count = self.courseCoveredData?.count ?? 0

            for i in 0..<count {

            self.textEnteredArray[self.courseCoveredData?[i].courseID ?? 0] = self.courseCoveredData?[i].answer ?? ""
                
            self.indexTagArray[self.courseCoveredData?[i].courseID ?? 0] = self.courseCoveredData?[i].courseID ?? 0
           
            }

        }else if self.condition == "Previous" {
            
            for _ in 0..<6 {
                
                self.textEnteredArray.append("")
                
                self.indexTagArray.append(-1)
            }
          
            for i in 0..<self.courseCoveredPreviousData.count {
                
                self.textEnteredArray[Int(String(describing: (self.courseCoveredPreviousData[i])["course_id"]!)) ?? 0] = String(describing: (self.courseCoveredPreviousData[i])["answer"]!)
                
                self.indexTagArray[Int(String(describing: (self.courseCoveredPreviousData[i])["course_id"]!)) ?? 0] = Int(String(describing: (self.courseCoveredPreviousData[i])["course_id"]!)) ?? 0
                
            }
           
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Courses Covered", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.selectCourseCollection_View.dequeueReusableCell(withReuseIdentifier: "CourseSelectionPopUpCollectionViewCell", for: indexPath) as! CourseSelectionPopUpCollectionViewCell
        
        //cell.selectCourse_TextField.textAlignment = .
    
        
        cell.selectCourse_TextField.delegate = self
        
        cell.selectCourse_TextField.tag = indexPath.row
        
        if self.condition == "EditProfile" {
            
          // if indexPath.row < self.courseCoveredData?.count ?? 0 {
            
        cell.selectCourse_TextField.text! = textEnteredArray[indexPath.row]
            
        }else if self.condition == "Previous" {
            
          cell.selectCourse_TextField.text! = textEnteredArray[indexPath.row]
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.selectCourseCollection_View.bounds.width / 2 - 10, height: 50)
    }
    
    // MARK: - Button Action
    
    
    @IBAction func tapSubmit_btn(_ sender: Any) {
        
        self.view.endEditing(true)
        
        var courseDict = [String: AnyObject]()
        
        var resultArray = [[String: AnyObject]]()
        
        for i in 0..<self.textEnteredArray.count {
            
            if textEnteredArray[i] == "" {
                
            }else {
            
            
            courseDict["course_id"] = self.indexTagArray[i] as AnyObject
            
            courseDict["answer"] = self.textEnteredArray[i] as AnyObject
            
            resultArray.append(courseDict)
            }
            
        }
        
        
        let data = ["Id":  self.indexTagArray, "Name":  self.textEnteredArray, "result": resultArray ] as [String : Any]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, userInfo: ["dataArray": data])
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - TextView Delegate
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if self.condition == "EditProfile" {
            
            if indexTagArray.contains(textView.tag) {
                
                if textView.text!.isEmpty {
                    
                    self.textEnteredArray.remove(at: indexTagArray.index(of: textView.tag) ?? 0)
                    
                }else {
                    
                    self.textEnteredArray[indexTagArray.index(of: textView.tag) ?? 0] = textView.text!
                    
                }
                
            }else {
                
                if textView.text!.isEmpty {
                    
                }else {
                    
                    indexTagArray.append(textView.tag)
                    
                    self.textEnteredArray.append(textView.text)
                    
                }
            }
            
        }else if self.condition == "Previous" {
            
        
            if indexTagArray.contains(textView.tag) {
                
                if textView.text!.isEmpty {
                    
                    self.textEnteredArray.remove(at: indexTagArray.index(of: textView.tag) ?? 0)
                    
                }else {
                    
                    self.textEnteredArray[indexTagArray.index(of: textView.tag) ?? 0] = textView.text!
                    
                }
                
            }else {
                
                if textView.text!.isEmpty {
                    
                }else {
                    
                    indexTagArray.append(textView.tag)
                    
                    self.textEnteredArray.append(textView.text)
                    
                }
            }
            
            
        }
       
        else {
        
        if indexTagArray.contains(textView.tag) {
            
            if textView.text!.isEmpty {
                
                self.textEnteredArray.remove(at: indexTagArray.index(of: textView.tag) ?? 0)
                
            }else {
                
                self.textEnteredArray[indexTagArray.index(of: textView.tag) ?? 0] = textView.text!
                
            }
            
        }else {
            
            if textView.text!.isEmpty {
                
            }else {
                
                indexTagArray.append(textView.tag)
                
                self.textEnteredArray.append(textView.text)
                
            }
        }
        }
        
        print(indexTagArray)
        
        print(textEnteredArray)
        
        
    }
    
}
