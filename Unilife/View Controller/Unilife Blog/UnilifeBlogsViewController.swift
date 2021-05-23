//
//  UnilifeBlogsViewController.swift
//  Unilife
//
//  Created by promatics on 23/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import iCarousel
import SDWebImage

class UnilifeBlogsViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    // MARK: - Outlet
    
    @IBOutlet weak var topSlider_ImageView: iCarousel!
    
    @IBOutlet weak var topSliderIndicator_pageController: UIPageControl!
    
    @IBOutlet weak var blogsCategories_TableView: UITableView!
    
    @IBOutlet weak var ourTeamSlider_View: iCarousel!
    
    @IBOutlet weak var blogSlider_height: NSLayoutConstraint!
    
    @IBOutlet weak var topSliderIndicator_height: NSLayoutConstraint!
    
    
    // MARK: - Variable
    
    var blogsData : Blogs?
    
    private var limitForBlog: Int = 3
    
    private var showAllCategoriesOpen : Bool = false
    
    var pushController: Bool = false
    
    // MARK: - Default View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        //        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        //defaultSearchBar()
        
        self.topSlider_ImageView.type = .rotary
        
        self.topSlider_ImageView.delegate = self
        
        self.topSlider_ImageView.dataSource = self
        
        self.topSlider_ImageView.bounces = false
        
        self.topSlider_ImageView.clipsToBounds = true
        
        self.topSlider_ImageView.layer.masksToBounds = true
        
        self.ourTeamSlider_View.type = .rotary
        
        self.ourTeamSlider_View.delegate = self
        
        self.ourTeamSlider_View.dataSource = self
        
        self.ourTeamSlider_View.bounces = false
        
        self.ourTeamSlider_View.clipsToBounds = true
        
        self.ourTeamSlider_View.layer.masksToBounds = true
        
        self.blogsCategories_TableView.delegate = self
        
        self.blogsCategories_TableView.dataSource = self
        
        self.blogsCategories_TableView.register(UINib(nibName: "LatestBlogsTableViewCell", bundle: nil), forCellReuseIdentifier: "LatestBlogTableViewCell")
        
        self.defaultSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //   self.navigationItem.largeTitleDisplayMode = .automatic
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        self.addNavigationBar(left: .Profile, titleType: .Normal, title: "Unilife Blogs", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "notification_Icon", bgColor: .Clear, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListingViewController") as! NotificationListingViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        //
        //        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.defaultSearchBar()
        
        
        self.showBlogs(serviceUrl: "show_blog/\(UserData().userId)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    deinit {
        
    print("Structure Called")
    }
    
    // MARK: - Serach Bar Function
    
    func defaultSearchBar() {
        
        if #available(iOS 11.0, *) {
            let sc = UISearchController(searchResultsController: nil)
            sc.delegate = self
            sc.searchResultsUpdater = self
            sc.searchBar.delegate = self
            
            let scb = sc.searchBar
            scb.tintColor = UIColor.appDarKGray
            scb.barTintColor = UIColor.white
            scb.placeholder = "Search Blogs "
            
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
            
            sc.searchBar.showsCancelButton = false
            navigationItem.searchController = sc
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController?.searchBar.delegate = self
            self.definesPresentationContext = true
            
            sc.hidesNavigationBarDuringPresentation = false
            sc.dimsBackgroundDuringPresentation = false
            
            
            
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if self.pushController == true {
            
            self.pushController = false
            
            
        }else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
            
            vc.condition = "SearchBlog"
            vc.seacrhBlogName = searchBar.text ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.pushController = true
        
        
    }
    
    
    // MARK: - Button Action
    
    @IBAction func tapCategories_btn(_ sender: Any) {
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllProductViewController") as? ViewAllProductViewController else {return}
        
        popoverContent.condition = ""
        
        popoverContent.blogCategoriesDetail = self.blogsData?.blogs
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let count = self.blogsData?.blogs?.count ?? 0
        
        var popoverHeight:Int = 0
        
        
        if count > 10 {
            
            popoverHeight = 11 * 50
            
        }else {
            
            popoverHeight = (count + 1) * 50
            
        }
        
        //let popoverHeight = (count - 1) * 50
        
        popoverContent.preferredContentSize = CGSize(width: 200, height: popoverHeight)
        
        let popOver = popoverContent.popoverPresentationController
        
        popoverContent.controller = self
        
        popOver?.delegate = self
        
        popOver?.sourceView = sender as! UIView
        
        popOver?.sourceRect = (sender as AnyObject).bounds
        
        popOver?.permittedArrowDirections = [.up]
        
        self.present(popoverContent, animated: true, completion: nil)
        
    }
    
}

// MARK: - Table View Delegate

extension UnilifeBlogsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ((self.blogsData?.blogs?.count ?? 0) > self.limitForBlog){
            
            return (self.limitForBlog + (self.blogsData?.offer?.count ?? 0)) + 1
            
        }else{
            
            return ((self.blogsData?.blogs?.count ?? 0) + (self.blogsData?.offer?.count ?? 0))
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((self.blogsData?.blogs?.count ?? 0) > self.limitForBlog) {
            
            if(indexPath.row <  (self.limitForBlog)) {
                
                let cell = self.blogsCategories_TableView.dequeueReusableCell(withIdentifier: "LatestBlogTableViewCell") as! LatestBlogTableViewCell
                
                cell.latestBlogsValue_lbl.text = self.blogsData?.blogs?[indexPath.row].categoriesName ?? ""
                
                cell.condition = "blogs"
                
                cell.blogsData = self.blogsData?.blogs?[indexPath.row]
                
                cell.blogs_CollectionView.reloadData()
                
                cell.blogViewAll_btn.tag = indexPath.row
                
                cell.blogViewAll_btn.addTarget(self, action: #selector(viewAll_btn(_:)), for: .touchUpInside)
                
                cell.show_View.isHidden = false
                
                return cell
                
            } else if (indexPath.row > (self.limitForBlog) - 1) && (indexPath.row < ((self.limitForBlog) + (self.blogsData?.offer?.count ?? 0)))  {
                
                let cell = self.blogsCategories_TableView.dequeueReusableCell(withIdentifier: "LatestBlogTableViewCell") as! LatestBlogTableViewCell
                
                let index = indexPath.row - (self.limitForBlog)
                
                cell.latestBlogsValue_lbl.text =  self.blogsData?.offer?[index].name ?? ""
                
                cell.offerData = self.blogsData?.offer?[index].categoriesBrand?.flatMap({$0.brandOffer!})
                
                cell.condition = "offers"
                
                cell.blogs_CollectionView.reloadData()
                
                cell.blogViewAll_btn.tag = indexPath.row
                
                cell.blogViewAll_btn.addTarget(self, action: #selector(viewAll_btn(_:)), for: .touchUpInside)
                
                cell.show_View.isHidden = false
                
                return cell
                
            }else{
                
                let cell = self.blogsCategories_TableView.dequeueReusableCell(withIdentifier: "BlogsCategoriesTableViewCell") as! BlogsCategoriesTableViewCell
                
                cell.BlogCategoryData = Array((self.blogsData?.blogs?[self.limitForBlog..<(self.blogsData?.blogs?.count ?? 0)])!)
                
                cell.showAllCategoriesOpen = self.showAllCategoriesOpen
                
                if(self.showAllCategoriesOpen){
                    cell.categoriesView_btn.setTitle("View Less", for: .normal)
                }else{
                    cell.categoriesView_btn.setTitle("View All", for: .normal)
                }
                
                cell.categoriesView_btn.tag = indexPath.row
                
                cell.categoriesView_btn.addTarget(self, action: #selector(self.tapviewAllcategoriesCellButton(_ :)), for: .touchUpInside)
                
                return cell
                
            }
            
            
        }else {
            
            if(indexPath.row <  (self.blogsData?.blogs?.count ?? 0)) {
                
                let cell = self.blogsCategories_TableView.dequeueReusableCell(withIdentifier: "LatestBlogTableViewCell") as! LatestBlogTableViewCell
                
                cell.latestBlogsValue_lbl.text = self.blogsData?.blogs?[indexPath.row].categoriesName ?? ""
                
                cell.condition = "blogs"
                
                cell.blogsData = self.blogsData?.blogs?[indexPath.row]
                
                cell.blogs_CollectionView.reloadData()
                
                cell.blogViewAll_btn.tag = indexPath.row
                
                cell.blogViewAll_btn.addTarget(self, action: #selector(viewAll_btn(_:)), for: .touchUpInside)
                
                cell.show_View.isHidden = false
                
                return cell
                
            } else if (indexPath.row > (self.blogsData?.blogs?.count ?? 0) - 1) && (indexPath.row < ((self.blogsData?.blogs?.count ?? 0) + (self.blogsData?.offer?.count ?? 0)))  {
                
                let cell = self.blogsCategories_TableView.dequeueReusableCell(withIdentifier: "LatestBlogTableViewCell") as! LatestBlogTableViewCell
                
                let index = indexPath.row - ((self.blogsData?.blogs?.count ?? 0))
                
                cell.latestBlogsValue_lbl.text =  self.blogsData?.offer?[index].name ?? ""
                
                //                cell.offerData = self.blogsData?.offer?[index].categoriesBrand?.forEach({$0.brandOffer})
                
                cell.offerData = self.blogsData?.offer?[index].categoriesBrand?.flatMap({$0.brandOffer!})
                
                cell.condition = "offers"
                
                cell.blogs_CollectionView.reloadData()
                
                cell.blogViewAll_btn.tag = indexPath.row
                
                cell.blogViewAll_btn.addTarget(self, action: #selector(viewAll_btn(_:)), for: .touchUpInside)
                
                cell.show_View.isHidden = false
                
                return cell
                
            }else{
                
                let cell = self.blogsCategories_TableView.dequeueReusableCell(withIdentifier: "BlogsCategoriesTableViewCell") as! BlogsCategoriesTableViewCell
                
                cell.BlogCategoryData = Array((self.blogsData?.blogs?[self.limitForBlog..<(self.blogsData?.blogs?.count ?? 0)])!)
                
                cell.categoriesView_btn.tag = indexPath.row
                
                cell.showAllCategoriesOpen = self.showAllCategoriesOpen
                
                if(self.showAllCategoriesOpen){
                    cell.categoriesView_btn.setTitle("View All", for: .normal)
                }else{
                    cell.categoriesView_btn.setTitle("View Less", for: .normal)
                }
                
                cell.categoriesView_btn.addTarget(self, action: #selector(self.tapviewAllcategoriesCellButton(_ :)), for: .touchUpInside)
                
                cell.blogsCategoriesCell_TableView.reloadData()
                
                return cell
                
            }
            
            
        }
        
    }
    
    // MARK: - Button Action
    
    @objc func tapviewAllcategoriesCellButton(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
        
        vc.condition = "viewAllCategory"
        
        vc.viewallblogs = self.blogsData?.blogs
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        //        self.showAllCategoriesOpen = !showAllCategoriesOpen
        //
        //        self.blogsCategories_TableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
        
    }
    
    @objc func viewAll_btn (_ sender: UIButton) {
        
        if ((self.blogsData?.blogs?.count ?? 0) > self.limitForBlog) {
            
            if(sender.tag <  (self.limitForBlog)) {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
                
                vc.categoryId = self.blogsData?.blogs?[sender.tag].id ?? -11
                
                vc.isUserFromCategory = true
                
                vc.navigationTitle = self.blogsData?.blogs?[sender.tag].categoriesName ?? ""
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if (sender.tag > (self.limitForBlog) - 1) && (sender.tag < ((self.limitForBlog) + (self.blogsData?.offer?.count ?? 0)))  {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
                
                vc.condition = "ComingFromBlogPage"
                
                let index = sender.tag - (self.limitForBlog)
                
                vc.navigationTitle =  self.blogsData?.offer?[index].name ?? ""
                //
                vc.brandArrayFromBlog = self.blogsData?.offer?[index].categoriesBrand?.flatMap({$0.brandOffer!})
                
                self.navigationController?.pushViewController(vc, animated: true)
                
                
                
            }else{
                
            }
            
            
        }
            
        else if (sender.tag > (self.blogsData?.blogs?.count ?? 0) - 1) && (sender.tag < ((self.blogsData?.blogs?.count ?? 0) + (self.blogsData?.offer?.count ?? 0)))  {
            
        }else{
            
            if(sender.tag <  (self.blogsData?.blogs?.count ?? 0)) {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
                
                vc.categoryId = self.blogsData?.blogs?[sender.tag].id ?? -11
                
                vc.isUserFromCategory = true
                
                vc.navigationTitle = self.blogsData?.blogs?[sender.tag].categoriesName ?? ""
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if (sender.tag > (self.blogsData?.blogs?.count ?? 0) - 1) && (sender.tag < ((self.blogsData?.blogs?.count ?? 0) + (self.blogsData?.offer?.count ?? 0)))  {
                
                
                
                // let index = sender.tag - ((self.blogsData?.blogs?.count ?? 0))
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
                
                vc.condition = "ComingFromBlogPage"
                
                let index = sender.tag - ((self.blogsData?.blogs?.count ?? 0))
                
                vc.navigationTitle =  self.blogsData?.offer?[index].name ?? ""
                //
                vc.brandArrayFromBlog = self.blogsData?.offer?[index].categoriesBrand?.flatMap({$0.brandOffer!})
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                
                
                
            }
            
            
        }
        
    }
    
    func setData(){
        
        self.topSliderIndicator_pageController.numberOfPages = self.blogsData?.slider?.count ?? 0
        
    }
    
}

// MARK: - ICarousel Delegate And DataSoucre

extension UnilifeBlogsViewController: iCarouselDelegate, iCarouselDataSource {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        if carousel == topSlider_ImageView {
            
            return self.blogsData?.slider?.count ?? 0
            
        }else {
            
            return self.blogsData?.team?.count ?? 0
        }
        
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        if carousel == topSlider_ImageView {
            
            let sliderView = Bundle.main.loadNibNamed("TopSliderImage", owner: self, options: nil)?.first as! TopSlider
            
            sliderView.frame = self.topSlider_ImageView.frame
            sliderView.sliderImage.contentMode = .scaleAspectFit
            sliderView.sliderImage.clipsToBounds = true
            
            sliderView.sliderImage.sd_setImage(with: URL(string: blogImageUrl + (self.blogsData?.slider?[index].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            return sliderView
            
        }else {
            
            let sliderView = Bundle.main.loadNibNamed("teamSlider", owner: self, options: nil)?.first as! teamSlider
            
            sliderView.frame = CGRect(x: 0, y: 0, width: (self.ourTeamSlider_View.frame.height - 20), height: (self.ourTeamSlider_View.frame.height ))
            
            sliderView.teamSlider_ImageView.sd_setImage(with: URL(string: profileImageUrl + (self.blogsData?.team?[index].image ?? "")), placeholderImage: UIImage(named: "noimage_icon"))
            
            sliderView.teamSliderName_lbl.text = (self.blogsData?.team?[index].name ?? "").capitalized
            
            return sliderView
            
        }
        
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        
        self.topSliderIndicator_pageController.currentPage = carousel.currentItemIndex
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if carousel == topSlider_ImageView {
            
            switch option {
            case .spacing:
                return 1.1
            default:
                return value
            }
            
        }else {
            switch option {
            case .spacing:
                return 4
            default:
                return value
            }
            
        }
        
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if carousel == topSlider_ImageView {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
            vc.condition = "blogs"
            vc.blogsData =  self.blogsData?.slider?[index]
            
            //            vc.navigationTitle = self.blogsData?.slider?[index].title ?? ""
            //           vc.condition = "blogData"
            //           vc.viewBlogData = self.blogsData?.slider?[index]
            //
            //            vc.categoryId = self.blogsData?.slider?[index].categoriesID ?? -11
            self.navigationController?.pushViewController(vc
                , animated: true)
        }
    }
    
}

extension UnilifeBlogsViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

//MARK:- Web Services

extension UnilifeBlogsViewController {
    
    func showBlogs(serviceUrl: String) {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: serviceUrl){ [weak self](receviedData) in
            
            Indicator.shared.hideProgressView()
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                print(receviedData)
                if receviedData["response"] as? Bool == true {
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: receviedData, options: .prettyPrinted)
                        
                        let unilifeBlogsData = try JSONDecoder().decode(Blogs.self , from: jsonData)
                      //  print(unilifeBlogsData)
                        self?.blogsData = unilifeBlogsData
                        
                        if (self?.blogsData?.slider?.count ?? 0) == 0 {
                            
                        self?.blogSlider_height.constant = 0
                            
                        self?.topSliderIndicator_height.constant = 0
                            
                        self?.topSlider_ImageView.isHidden = true
                            
                        self?.topSliderIndicator_pageController.isHidden = true
                        }else {
                            
                            
                        }
                        
                        self?.topSlider_ImageView.reloadData()
                        
                        self?.ourTeamSlider_View.reloadData()
                        
                        self?.blogsCategories_TableView.reloadData()
                        
                        self?.setData()
                        
                    } catch {
                        
                        self?.showDefaultAlert(Message: error.localizedDescription)
                        
                    }
                    
                    
                }else {
                    
                    self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["message"] as? String ?? "No blogs found")
                    
                }
                
            }else {
                
                self?.showDefaultAlert(Message: (receviedData as? [String: AnyObject])?["Error"] as? String ?? "No blogs found")
                
            }
            
        }
    }
    
    
    
}


