//
//  ReportPostOrUserViewController.swift
//  Unilife
//
//  Created by Apple on 18/12/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class ReportPostOrUserViewController: UIViewController {
    
    // MARK: - Outlet
    
    
    @IBOutlet weak var reportTable_View: UITableView!
    var delegate:deletePressPostProtocol?
    // MARK: - Variable
    
    var reportArray = ["Report User", "Report Post"]
    
    var controller = UIViewController()
    
    var postId = ""
    var getIndex:Int = 0
    var postUserId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reportTable_View.delegate = self
        self.reportTable_View.dataSource = self
        if(postUserId == UserData().userId)
        {
         reportArray.append("Delete")
        }
        
    }
    
}

// MARK: - Table View Delegate

extension ReportPostOrUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = self.reportTable_View.dequeueReusableCell(withIdentifier: "ReportPostTableViewCell") as! ReportPostTableViewCell
        
        cell.report_lbl.text! = reportArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportListingReasonViewController") as! ReportListingReasonViewController
                
                vc.condition = "postUser"
                
                vc.postUserId = self.postUserId
                
                self.controller.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportListingReasonViewController") as! ReportListingReasonViewController
                vc.condition = "postUser"
                vc.postUserId = self.postUserId
                self.controller.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
            
            self.dismiss(animated: true, completion: nil)
            
        }else if indexPath.row == 1 {
            
            
            if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportListingReasonViewController") as! ReportListingReasonViewController
                
                
                vc.postId = self.postId
                vc.condition = ""
                
                self.controller.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportListingReasonViewController") as! ReportListingReasonViewController
                
                
                vc.postId = self.postId
                
                vc.condition = ""
                
                self.controller.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
        else if (indexPath.row == 2) //... delete
        {
            if(delegate != nil)
            {
                delegate?.didTapDelete(getID: self.postId, getIndex: getIndex)
            }
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
    
}




