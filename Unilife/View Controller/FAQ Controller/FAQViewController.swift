//
//  FAQViewController.swift
//  Unilife
//
//  Created by Apple on 03/09/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
    
    // MARK: - outlet
    
    @IBOutlet weak var faq_TableView: UITableView!
    
    // MARK: - Variable
    
    var selectedIndex:Int = -1
    
    var faqDataArray = [[String: AnyObject]]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.faq_TableView.delegate = self
        
        self.faq_TableView.dataSource = self
        
        faq()
        
    }
    
    deinit {
        print(#file)
        
        self.faqDataArray = [[:]]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.appSkyBlue
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.addNavigationBar(left: .Back, titleType: .Normal, title: "FAQ's ", titlePosition: .Middle, right: .None, rightButtonIconOrTitle: "", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {})
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
}

// MARK: - Table View delegate

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.faqDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.faq_TableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell") as! FAQTableViewCell
        
       
        
        cell.questionNumber_lbl.text! = "\(indexPath.row + 1)"
        
        cell.questionName_lbl.text! = String(describing: (self.faqDataArray[indexPath.row])["questions"]!)
        
        cell.answer_lbl.text! = String(describing: (self.faqDataArray[indexPath.row])["answer"]!)
        
        
        cell.down_btn.tag = indexPath.row
        cell.down_btn.addTarget(self, action: #selector(selectAnswer_btn(_:)), for: .touchUpInside)
        
        if self.selectedIndex == indexPath.row {
            
            if cell.answer_lbl.isHidden {
                cell.answer_lbl.isHidden = false
                
                cell.answerHeight_Constant.constant = 86.5
                cell.down_btn.setImage(UIImage(named: "dup(30x16)"), for: .normal)
                
            }else {
                
                cell.answer_lbl.isHidden = true
                
                cell.answerHeight_Constant.constant = 0
                cell.down_btn.setImage(UIImage(named: "d-30x16"), for: .normal)
            }
            
        }else {
            cell.answer_lbl.isHidden = true
            cell.answerHeight_Constant.constant = 0
            cell.down_btn.setImage(UIImage(named: "d-30x16"), for: .normal)
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return UITableView.automaticDimension
    //    }
    
    // MARK: - Button Action
    
    @objc func selectAnswer_btn(_ sender: UIButton) {
        
        self.selectedIndex = sender.tag
        
        self.faq_TableView.reloadData()
        
    }
    
}

extension FAQViewController {
    
    func faq() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "send_faq") {[weak self ] (receviedData) in
            
            print(receviedData)
            
            guard let self = self else {
                return
            }
            
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    self.faqDataArray = receviedData["data"] as? [[String: AnyObject]] ?? [[:]]
                    
                    self.faq_TableView.reloadData()
                    
                    
                }else {
                    
               self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No data found")
                    
                }
                
                
            }else {
           self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No data found")
                
            }
        }
    }
}
