//
//  ShowUniversityListViewController.swift
//  Unilife
//
//  Created by Promatics on 3/3/20.
//  Copyright © 2020 promatics. All rights reserved.
//

import UIKit

protocol selectUniversityName {
    
    func select(universityName: String, universityDomin: String, universityId:String)
}

class ShowUniversityListViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate  {
    
    // MARK: - Variable
    var universityListingArray = [[String: AnyObject]]()
    
    var allDataArray = [[String: AnyObject]]()
    
    var delegate :selectUniversityName?
    var selectIndex = -1
    
    // MARK: - Variable 
    
    @IBOutlet weak var showUniversityList_TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showUniversityList_TableView.register(UINib(nibName: "SelectUniversityCell", bundle: nil), forCellReuseIdentifier: "SelectUniversityTableViewCell")
        
        universityListing()
        
        self.showUniversityList_TableView.delegate = self
        self.showUniversityList_TableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "Search University / School", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            
        })
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        //       self.navigationController?.navigationBar.prefersLargeTitles = false
        //
        self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        //
        //        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.defaultSearchBar()
    }
    
    // MARK: - Serach Bar Function
    
    func defaultSearchBar() {
        
        if #available(iOS 11.0, *) {
            let sc = UISearchController(searchResultsController: nil)
            sc.delegate = self
            sc.searchResultsUpdater = self
            let scb = sc.searchBar
            scb.tintColor = UIColor.appDarKGray
            scb.barTintColor = UIColor.white
            scb.placeholder = "Search University / School"
            
            if let textfield = scb.value(forKey: "searchField") as? UITextField {
                textfield.textColor = UIColor.blue
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    backgroundview.backgroundColor = UIColor.white
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            
            if let navigationbar = self.navigationController?.navigationBar {
                navigationbar.barTintColor = UIColor.white
            }
            navigationItem.searchController = sc
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController?.searchBar.delegate = self
            self.definesPresentationContext = true
            
            sc.hidesNavigationBarDuringPresentation = false
            sc.dimsBackgroundDuringPresentation = false
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    // MARK: - University Listing
    
    func universityListing() {
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_university") {[weak self] (receviedData) in
            
            print(receviedData)
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self?.universityListingArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self?.allDataArray = receviedData["data"] as! [[String: AnyObject]]
                    
                    self?.showUniversityList_TableView.reloadData()
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: receviedData["Error"] as! String)
                
                
            }
            
        }
        
        
    }
}

extension ShowUniversityListViewController: UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UISearchResultsUpdating{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return universityListingArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.showUniversityList_TableView.dequeueReusableCell(withIdentifier: "SelectUniversityTableViewCell") as! SelectUniversityTableViewCell
        
        cell.selectUniversity_lbl.text! = String(describing: (self.universityListingArray[indexPath.row])["name"]!).capitalized
        
        if selectIndex == indexPath.row{
            
            cell.selectUniversity_btn.setImage(UIImage(named: "correctMark_icon"), for: .normal)
            cell.selectUniversityButton_Width.constant = 20
            cell.selectUniversity_btn.isHidden = false
        }else{
            cell.selectUniversityButton_Width.constant = 0
            cell.selectUniversity_btn.isHidden = true
            
        }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectIndex = indexPath.row
        
        self.showUniversityList_TableView.reloadData()
        
        delegate?.select(universityName: String(describing: (self.universityListingArray[indexPath.row])["name"]!).capitalized, universityDomin: String(describing: ((self.universityListingArray[indexPath.row])["university_domain"] as! [String: AnyObject])["domain"]!), universityId: String(describing: (self.universityListingArray[indexPath.row])["id"]!))
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        //      filterSearchData(for: searchController.searchBar.text ?? "")
        
        if  (searchController.searchBar.text ?? "") == "" {
            
            self.universityListingArray = self.allDataArray
            
        }else {
           
        // self.universityListingArray = self.allDataArray
            
            self.universityListingArray = self.universityListingArray.filter{(String(describing: $0["name"] as? String ?? "").lowercased()).contains((searchController.searchBar.text ?? "").lowercased())}
            
          //  self.universityListingArray = self.allDataArray
           
        }
        
        self.showUniversityList_TableView.reloadData()
        
    }
    
}
