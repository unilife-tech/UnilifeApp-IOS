//
//  SelectionPopUpControllerViewController.swift
//  Unilife
//
//  Created by Apple on 09/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class SelectionPopUpControllerViewController: UIViewController {
    
    // MARK: - outlet
    
    
    @IBOutlet weak var selectionPop_TableView: UITableView!
    
    // MARK: - Variable
    
    var selectionDataArray = [[String: AnyObject]]()
    
    var condition = ""
    
    var controller = UIViewController()
    
    var selectCategoriesArray = [String]()
    
    var selectButtonTag: Int = -1
    
    var selectCategoriesNameArray = [String]()
    
    var seelctCategoriesIdArray = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectionPop_TableView.delegate = self
        
        self.selectionPop_TableView.dataSource = self
        
        if self.condition == "category" {
            
            self.categoryListing(url: "send_categories_icon_profile")
            
        }else if condition == "hobbies" {
            
            self.categoryListing(url: "send_hobbies")
        }else {
            
            self.categoryListing(url: "send_interests")
        }
        
    }
    
    deinit {
        
        print(#file)
    }
    
    
    // MARK: - Select Categories
    
    func categoryListing(url: String) {
        
        Indicator.shared.showProgressView(self.view)
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: url) {[weak self] (receviedData) in
            print(receviedData)
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.selectionDataArray = receviedData["data"] as! [[String: AnyObject]]
                    self?.selectionPop_TableView.reloadData()
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
                
            }
            
            
        }
    }
    
    
    
    
}

extension SelectionPopUpControllerViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if condition == "category" {
            
            return self.selectionDataArray.count
            
        }else if self.condition == "hobbies" {
            
            return self.selectionDataArray.count
        }else {
            
            return self.selectionDataArray.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.selectionPop_TableView.dequeueReusableCell(withIdentifier: "SelectionPopUpTableViewCell") as! SelectionPopUpTableViewCell
        
        if condition == "category" {
            
            cell.selectionPopName_lbl.text! = String(describing: (self.selectionDataArray[indexPath.row])["categories_name"]!)
            
            cell.selectName_btn.tag = indexPath.row
            
            cell.selectName_btn.addTarget(self, action: #selector(tapSelectCheckBox_btn(_:)), for: .touchUpInside)
            
            if selectButtonTag == indexPath.row {
                
                if cell.selectName_btn.currentImage == UIImage(named: "check-symbol") {
                    
                    cell.selectName_btn.setImage(UIImage(named: "checkBox"), for: .normal)
                }else if cell.selectName_btn.currentImage == UIImage(named: "checkBox") {
                    
                    cell.selectName_btn.setImage(UIImage(named: "check-symbol"), for: .normal)
                }
            }
            
        }else if self.condition == "hobbies" {
            cell.selectionPopName_lbl.text! = String(describing: (self.selectionDataArray[indexPath.row])["name"]!)
            
            cell.selectName_btn.tag = indexPath.row
            
            cell.selectName_btn.addTarget(self, action: #selector(tapSelectCheckBox_btn(_:)), for: .touchUpInside)
            
            if selectButtonTag == indexPath.row {
                
                if cell.selectName_btn.currentImage == UIImage(named: "check-symbol") {
                    
                    cell.selectName_btn.setImage(UIImage(named: "checkBox"), for: .normal)
                }else if cell.selectName_btn.currentImage == UIImage(named: "checkBox") {
                    
                    cell.selectName_btn.setImage(UIImage(named: "check-symbol"), for: .normal)
                }
            }
            
        }else {
            
            cell.selectionPopName_lbl.text! = String(describing: (self.selectionDataArray[indexPath.row])["name"]!)
            
            cell.selectName_btn.tag = indexPath.row
            
            cell.selectName_btn.addTarget(self, action: #selector(tapSelectCheckBox_btn(_:)), for: .touchUpInside)
            
            if selectButtonTag == indexPath.row {
                
                if cell.selectName_btn.currentImage == UIImage(named: "check-symbol") {
                    
                    cell.selectName_btn.setImage(UIImage(named: "checkBox"), for: .normal)
                }else if cell.selectName_btn.currentImage == UIImage(named: "checkBox") {
                    
                    cell.selectName_btn.setImage(UIImage(named: "check-symbol"), for: .normal)
                }
            }
            
        }
        
        
        
        return  cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if condition == "category" {
            
            self.selectButtonTag = indexPath.row
            
            if self.selectCategoriesArray.contains(String(describing: (self.selectionDataArray[indexPath.row])["id"]!)) {
                
                self.selectCategoriesNameArray.remove(at: self.selectCategoriesNameArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["categories_name"]!))!)
                
                
                self.selectCategoriesArray.remove(at: self.selectCategoriesArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["id"]!))!)
                
            }else {
                
                self.selectCategoriesNameArray.append(String(describing: (self.selectionDataArray[indexPath.row])["categories_name"]!))
                
                self.selectCategoriesArray.append(String(describing: (self.selectionDataArray[indexPath.row])["id"]!))
            }
            
            let data = ["Id":  self.selectCategoriesArray, "Name":  self.selectCategoriesNameArray ] as [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, userInfo: ["dataArray": data])
            
            print(self.selectCategoriesArray)
            
            self.selectionPop_TableView.reloadData()
            //self.dismiss(animated: true, completion: nil)
            
            
            
        }else if self.condition == "hobbies" {
            
            self.selectButtonTag = indexPath.row
            
            if self.selectCategoriesArray.contains(String(describing: (self.selectionDataArray[indexPath.row])["id"]!)) {
                
                self.selectCategoriesNameArray.remove(at: self.selectCategoriesNameArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["name"]!))!)
                
                
                self.selectCategoriesArray.remove(at: self.selectCategoriesArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["id"]!))!)
                
            }else {
                
                self.selectCategoriesNameArray.append(String(describing: (self.selectionDataArray[indexPath.row])["name"]!))
                
                self.selectCategoriesArray.append(String(describing: (self.selectionDataArray[indexPath.row])["id"]!))
            }
            
            let data = ["Id":   self.selectCategoriesArray, "Name":  self.selectCategoriesNameArray ] as [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hobbies"), object: nil, userInfo: ["dataArray": data])
            
            print(self.selectCategoriesArray)
            
            self.selectionPop_TableView.reloadData()
            
            //self.dismiss(animated: true, completion: nil)
            
            
        }else {
            
            self.selectButtonTag = indexPath.row
            
            if self.selectCategoriesArray.contains(String(describing: (self.selectionDataArray[indexPath.row])["id"]!)) {
                
                self.selectCategoriesNameArray.remove(at: self.selectCategoriesNameArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["name"]!))!)
                
                self.selectCategoriesArray.remove(at: self.selectCategoriesArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["id"]!))!)
                
            }else {
                
                self.selectCategoriesNameArray.append(String(describing: (self.selectionDataArray[indexPath.row])["name"]!))
                
                self.selectCategoriesArray.append(String(describing: (self.selectionDataArray[indexPath.row])["id"]!))
                
            }
            
            let data = ["Id":   self.selectCategoriesArray, "Name": self.selectCategoriesNameArray ] as [String : Any]
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "interest"), object: nil, userInfo: ["dataArray": data])
            
            print(self.selectCategoriesArray)
            //self.dismiss(animated: true, completion: nil)
            
            self.selectionPop_TableView.reloadData()
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    // MARK: - Button Action
    
    @objc func tapSelectCheckBox_btn(_ sender: UIButton) {
        
        //        if condition == "category" {
        //
        //            self.selectButtonTag = indexPath.row
        //
        //            if self.selectCategoriesArray.contains(String(describing: (self.selectionDataArray[indexPath.row])["id"]!)) {
        //
        //                self.selectCategoriesNameArray.remove(at: self.selectCategoriesNameArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["categories_name"]!))!)
        //
        //
        //                self.selectCategoriesArray.remove(at: self.selectCategoriesArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["id"]!))!)
        //
        //            }else {
        //
        //                self.selectCategoriesNameArray.append(String(describing: (self.selectionDataArray[indexPath.row])["categories_name"]!))
        //
        //                self.selectCategoriesArray.append(String(describing: (self.selectionDataArray[indexPath.row])["id"]!))
        //            }
        //
        //            let data = ["Id":  self.selectCategoriesArray, "Name":  self.selectCategoriesNameArray ] as [String : Any]
        //
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectionPopUp"), object: nil, userInfo: ["dataArray": data])
        //
        //            print(self.selectCategoriesArray)
        //
        //            self.selectionPop_TableView.reloadData()
        //            //self.dismiss(animated: true, completion: nil)
        //
        //
        //
        //        }else if self.condition == "hobbies" {
        //
        //            self.selectButtonTag = indexPath.row
        //
        //            if self.selectCategoriesArray.contains(String(describing: (self.selectionDataArray[indexPath.row])["id"]!)) {
        //
        //                self.selectCategoriesNameArray.remove(at: self.selectCategoriesNameArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["name"]!))!)
        //
        //
        //                self.selectCategoriesArray.remove(at: self.selectCategoriesArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["id"]!))!)
        //
        //            }else {
        //
        //                self.selectCategoriesNameArray.append(String(describing: (self.selectionDataArray[indexPath.row])["name"]!))
        //
        //                self.selectCategoriesArray.append(String(describing: (self.selectionDataArray[indexPath.row])["id"]!))
        //            }
        //
        //            let data = ["Id":   self.selectCategoriesArray, "Name":  self.selectCategoriesNameArray ] as [String : Any]
        //
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hobbies"), object: nil, userInfo: ["dataArray": data])
        //
        //            print(self.selectCategoriesArray)
        //
        //            self.selectionPop_TableView.reloadData()
        //
        //            //self.dismiss(animated: true, completion: nil)
        //
        //
        //        }else {
        //
        //            self.selectButtonTag = indexPath.row
        //
        //            if self.selectCategoriesArray.contains(String(describing: (self.selectionDataArray[indexPath.row])["id"]!)) {
        //
        //                self.selectCategoriesNameArray.remove(at: self.selectCategoriesNameArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["name"]!))!)
        //
        //                self.selectCategoriesArray.remove(at: self.selectCategoriesArray.index(of:String(describing: (self.selectionDataArray[indexPath.row])["id"]!))!)
        //
        //            }else {
        //
        //                self.selectCategoriesNameArray.append(String(describing: (self.selectionDataArray[indexPath.row])["name"]!))
        //
        //                self.selectCategoriesArray.append(String(describing: (self.selectionDataArray[indexPath.row])["id"]!))
        //
        //            }
        //
        //            let data = ["Id":   self.selectCategoriesArray, "Name": self.selectCategoriesNameArray ] as [String : Any]
        //
        //            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "interest"), object: nil, userInfo: ["dataArray": data])
        //
        //            print(self.selectCategoriesArray)
        //            //self.dismiss(animated: true, completion: nil)
        //
        //            self.selectionPop_TableView.reloadData()
        //
        //
        //        }
        
        
        
        
    }
}
