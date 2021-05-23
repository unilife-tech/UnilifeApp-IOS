//
//  UnilifeBrandViewController.swift
//  Unilife
//
//  Created by promatics on 23/08/19.
//  Copyright © 2019 promatics. All rights reserved.
//

import UIKit
import iCarousel



class UnilifeBrandViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    // MARK: - Outlet
    
    @IBOutlet weak var collectionSlider: UICollectionView!
    @IBOutlet weak var topSlider_ImageView: iCarousel!
    
    @IBOutlet weak var topSliderIndicator_pageController: UIPageControl!
    
    @IBOutlet weak var trendingOffer_View: UIView!
    
    @IBOutlet weak var newlyAddedOffer_View: UIView!
    
    @IBOutlet weak var newlyAddedOfferTitle_lbl: UILabel!
    
    @IBOutlet weak var newAddedOfferViewAll_btn: SetButton!
    
    @IBOutlet weak var newAddedOfferWithImageleftSide_TableView: UITableView!
    
    @IBOutlet weak var newlyAddedOffresWithImageRightSide_TableView: UITableView!
    
    @IBOutlet weak var brandOffer_View: UIView!
    
    @IBOutlet weak var brandOfferTitle_lbl: UILabel!
    
    @IBOutlet weak var brandOfferViewAll_btn: SetButton!
    
    @IBOutlet weak var brandOffer_CollectionView: UICollectionView!
    
    @IBOutlet weak var latestBlogs_View: UIView!
    
    @IBOutlet weak var category_View: UIView!
    
    @IBOutlet weak var categoryViewAll_btn: SetButton!
    
    @IBOutlet weak var categoryList_TableView: UITableView!
    
    @IBOutlet weak var trendingOffer_CollectionView: UICollectionView!
    
    @IBOutlet weak var latestBlog_CollectionView: UICollectionView!
    
    @IBOutlet weak var categoryListingTableView_height: NSLayoutConstraint!
    
    @IBOutlet weak var trendingOfferName_lbl: UILabel!
    
    @IBOutlet weak var newlyAddedOffer_lbl: UILabel!
    
    @IBOutlet weak var newAddedLeftSideImageTableView_height: NSLayoutConstraint!
    
    @IBOutlet weak var newAddedRightSideImageTableView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var brandOffer_Slider: iCarousel!
    
    @IBOutlet weak var blogName_lbl: UILabel!
    
    @IBOutlet weak var categoryName_lbl: UILabel!
    
    @IBOutlet weak var brandSlider_height: NSLayoutConstraint!

    @IBOutlet weak var trending_View: UIView!
    
    @IBOutlet weak var trendingView_height: NSLayoutConstraint!
    
    @IBOutlet weak var trendingCollectionView_height: NSLayoutConstraint!
    
    @IBOutlet weak var newlyAddedOfferView_height: NSLayoutConstraint!
    
    @IBOutlet weak var newLyAddedOfferWithLeftSide_height: NSLayoutConstraint!
    
    @IBOutlet weak var brandOfferHeight_View: NSLayoutConstraint!
    
    @IBOutlet weak var brandOfferCollectionView_Height: NSLayoutConstraint!
    
    @IBOutlet weak var latestBlogsView_height: NSLayoutConstraint!
    
    @IBOutlet weak var categoryView_Height: NSLayoutConstraint!
    
    // MARK: - Variable
    
    var brandImageArray = [UIImage(named: "brand-3"), UIImage(named: "brand-4"), UIImage(named: "brand-5"), UIImage(named: "brand-6")] //UIImage(named: "brand-7")]
    
    var brandDiscount = ["10% OFF", "20% OFF","30% OFF","10% OFF","20% OFF"]
    
    var blogImageArray = [UIImage(named: "blog-1"), UIImage(named: "blog-2"), UIImage(named: "blog-3"), UIImage(named: "blog-4"),UIImage(named: "blog-5")]
    
    
    var blogNameArray = ["6 Tech gadget every college students must have", "How game of thrones should have ended", "Heathy living habbits for UniStudents", "How to prepare for next summer vacation", "9Cities you visit before you graduate from college"]
    
    var sliderArray = [UIImage(named: "big-1"), UIImage(named: "big-1"), UIImage(named: "big-1")]
    
    var brandOffersData: UnilifeBrandModel?
    
    var newlyAddedOffers: [BrandOffer]?
    
    var trendingOffers:  [BrandOffer]?
    
    var brandRealtedOffers: [BrandOffer]?
    
    var blogDataArray : [CategoriesBlog1]?
    
    var categoryBrandData : [Offer1]?
    
    var rowNum = 4
    
    var timer = Timer()
    
    var pushController: Bool = false
    
    // MARK: - Variable
    
    // MARK: - Default View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationItem.searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.defaultSearchBar()
        
        brandData()
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.addNavigationBar(left: .Profile, titleType: .Normal, title: "Unilife Brands", titlePosition: .Middle, right: .Icon, rightButtonIconOrTitle: "notification_Icon", bgColor: .White, barTintColor: UIColor.black, navigationBarStyle: .default, rightFunction: {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListingViewController") as! NotificationListingViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
//       self.navigationController?.navigationBar.prefersLargeTitles = false
//
          self.navigationItem.searchController = UISearchController(searchResultsController: nil)
//
//        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.defaultSearchBar()
        
        brandData()
    }
    
    func autoScroll(){
        //print("auto")
        self.brandOffer_CollectionView.setContentOffset(CGPoint(x: 0, y: self.brandOffer_CollectionView.contentSize.height - self.brandOffer_CollectionView.bounds.size.height), animated: true)
        self.brandOffer_CollectionView.scrollToItem(at: IndexPath(row: self.rowNum + 1, section: 0), at: .left, animated: true)
        self.rowNum += 4
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    
    
    func updateTableHeight(){
        var frame = self.newAddedOfferWithImageleftSide_TableView.frame
        frame.size.height = self.newAddedOfferWithImageleftSide_TableView.contentSize.height
        self.newAddedOfferWithImageleftSide_TableView.frame = frame
        self.newAddedOfferWithImageleftSide_TableView.reloadData()
        self.newAddedOfferWithImageleftSide_TableView.layoutIfNeeded()
        self.newAddedLeftSideImageTableView_height.constant = CGFloat(self.newAddedOfferWithImageleftSide_TableView.contentSize.height)
    }
    
    deinit {
        print(#file)
    }
    
    // MARK: - All Delegate And DataSource
    func allDelegateAndDataSource() {
        
        // MARK: - iCoursel Delegate
        
       // self.topSlider_ImageView.type = .rotary
        
      //  self.topSlider_ImageView.delegate = self
        
      //  self.topSlider_ImageView.dataSource = self
        
     //   self.topSlider_ImageView.bounces = false
        
        
     //   self.topSlider_ImageView.clipsToBounds = true
        
    //    self.topSlider_ImageView.layer.masksToBounds = true
        
    //    self.topSliderIndicator_pageController.currentPage = 0
        
        if (self.categoryBrandData?.count ?? 0) > 3 {
          
            self.categoryListingTableView_height.constant = CGFloat(100 * 3)
            
        }else {
        self.categoryListingTableView_height.constant = CGFloat(100 * (self.categoryBrandData?.count ?? 0) )
        
        }
        
        self.topSliderIndicator_pageController.numberOfPages = self.brandOffersData?.slider?.count ?? 0
        
        self.trendingOffer_CollectionView.delegate = self
        
        self.trendingOffer_CollectionView.dataSource = self
        
        self.newlyAddedOffresWithImageRightSide_TableView.delegate = self
        self.newlyAddedOffresWithImageRightSide_TableView.dataSource = self
        
        //        self.newAddedOfferWithImageleftSide_TableView.delegate = self
        //        self.newAddedOfferWithImageleftSide_TableView.dataSource = self
        
        self.brandOffer_CollectionView.delegate = self
        self.brandOffer_CollectionView.dataSource = self
        self.latestBlog_CollectionView.delegate = self
        self.latestBlog_CollectionView.dataSource = self
        
        self.categoryList_TableView.delegate = self
        self.categoryList_TableView.dataSource = self
        
        //        self.newlyAddedOffresWithImageRightSide_TableView.register(UINib(nibName: "NewAddedOffersTableView", bundle: nil), forCellReuseIdentifier: "NewlyAddedOffersTableViewCell")
        //
        //        self.newAddedOfferWithImageleftSide_TableView.register(UINib(nibName: "newlyAddedOffersWithLeftImage", bundle: nil), forCellReuseIdentifier: "NewlyAddedOfferWithLeftSideImageTableViewCell")
        
        self.trendingOffer_CollectionView.register(UINib(nibName: "TrendingOfferCollectionView", bundle: nil), forCellWithReuseIdentifier: "TrendingCollectionViewCell")
        
        //        self.brandOffer_CollectionView.register(UINib(nibName: "BrandOffersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandsOffersCollectionViewCell")
        
        self.latestBlog_CollectionView.register(UINib(nibName: "LatestBlogCollectionView", bundle: nil), forCellWithReuseIdentifier: "LatestBlogsCollectionViewCell")
        
        
        self.categoryList_TableView.register(UINib(nibName: "categoriesTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableViewCellTableViewCell")
        
    }
    
    // MARK: - Serach Bar Function
    
    func defaultSearchBar() {
        
        if #available(iOS 11.0, *) {
            let sc = UISearchController(searchResultsController: nil)
            sc.delegate = self
            //sc.searchResultsUpdater = self
            sc.searchBar.delegate = self
            
            let scb = sc.searchBar
            scb.tintColor = UIColor.appDarKGray
            scb.barTintColor = UIColor.white
            scb.placeholder = "Search Coupons & More "
            
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
            //sc.searchBar.showsScopeBar = true
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        if self.pushController == true {
            
            self.pushController = false
            
            
        }else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
            
            vc.condition = "search"
            vc.search = searchBar.text ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
            
             searchBar.setShowsCancelButton(false, animated: true)
            
            
        }
        
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.pushController = true
    }
    
    // MARK: - Button Action
    
    
    @IBAction func newAddedOfferViewAll_btn(_ sender: UIButton) {
        
        // vc.condition = "offers"
        if sender.tag == 0 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
            
            vc.brandArray = self.trendingOffers
            
            vc.navigationTitle = self.brandOffersData?.offer?[sender.tag].name ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if sender.tag == 1 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
            
            vc.brandArray = self.newlyAddedOffers
            
            vc.navigationTitle = self.brandOffersData?.offer?[sender.tag].name ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else if sender.tag == 2 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
            
            vc.navigationTitle = self.brandOffersData?.offer?[sender.tag].name ?? ""
            
            vc.brandArray = self.brandRealtedOffers
            
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if sender.tag == 3 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBlogViewController") as! ViewAllBlogViewController
            
            vc.navigationTitle = self.brandOffersData?.blogs?.first?.categoriesName ?? ""
            
        //  vc.brandBlogData = self.brandOffersData?.blogs
            
            vc.isUserFromCategory = true
            
            vc.categoryId = self.brandOffersData?.blogs?.first?.id ?? 0
            
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsAccordingToCategoryViewController") as! ViewAllBrandsAccordingToCategoryViewController
            
            vc.allOfferData = self.brandOffersData?.offer
            
            self.navigationController?.pushViewController(vc, animated: true)
            
//            self.categoryListingTableView_height.constant = CGFloat( (self.categoryBrandData?.count ?? 0) * 100)
//            
//            self.categoryList_TableView.reloadData()
//            //          let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
//            //            
//            //            vc.navigationTitle = self.brandOffersData?.offer?[sender.tag].name ?? ""
//            //            
//            //            
//            //            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        
        
    }
    
    
    
    @IBAction func tapCategories_btn(_ sender: Any) {
        
        guard let popoverContent = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewAllProductViewController") as? ViewAllProductViewController else {return}
        
        
        popoverContent.condition = "Brand"
        
        popoverContent.brandCategoriesDetail = self.brandOffersData?.offer
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        
        var popoverHeight: Int = 0
        
        let count = self.brandOffersData?.offer?.count ?? 0
        
        if count > 10 {
            
        popoverHeight = 11 * 50
            
        }else {
        
        popoverHeight = (count + 1) * 50
            
        }
        
        popoverContent.preferredContentSize = CGSize(width: 200, height: popoverHeight)
        
        //        popoverContent.delegate = self
        //
        //        popoverContent.privacyFor = .story
        
        popoverContent.controller = self
        
        let popOver = popoverContent.popoverPresentationController
        
        popOver?.delegate = self
        
        popOver?.sourceView = sender as! UIView
        
        popOver?.sourceRect = (sender as AnyObject).bounds
        
        popOver?.permittedArrowDirections = [.up]
        
        self.present(popoverContent, animated: true, completion: nil)
        
    }
    
}

// MARK: - Table View Delegate

extension UnilifeBrandViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.newlyAddedOffresWithImageRightSide_TableView {
            
            if self.newlyAddedOffers?.count ?? 0 > 3 {
                
                return 3
            }else {
            
            return self.newlyAddedOffers?.count ?? 0
                
            }
            
        }else if tableView == self.newAddedOfferWithImageleftSide_TableView {
            
            return 0
            
        }else {
            
            return self.categoryBrandData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.newlyAddedOffresWithImageRightSide_TableView {
            if indexPath.row % 2 == 0 {
                
                let cell = self.newAddedOfferWithImageleftSide_TableView.dequeueReusableCell(withIdentifier: "NewlyAddedOffersTableViewCell") as! NewlyAddedOffersTableViewCell
                
                cell.productName_lbl.text! = self.newlyAddedOffers?[indexPath.row].brandNameData?.brandName ?? ""
                
                cell.producImage_View.sd_setImage(with: URL(string: offerImageUrl + (self.newlyAddedOffers?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage"))
                
                cell.productDiscount_lbl.text! = String (self.newlyAddedOffers?[indexPath.row].discountPercent ?? 0 ) + " % OFF \(self.newlyAddedOffers?[indexPath.row].brandNameData?.brandName ?? "")"
                
                return cell
                
            }else {
                
                
                let cell = self.newAddedOfferWithImageleftSide_TableView.dequeueReusableCell(withIdentifier: "NewlyAddedOfferWithLeftSideImageTableViewCell") as! NewlyAddedOfferWithLeftSideImageTableViewCell
                
                cell.productName_lbl.text! = self.newlyAddedOffers?[indexPath.row].brandNameData?.brandName ?? ""
                
                cell.productImage_View.sd_setImage(with: URL(string: offerImageUrl + (self.newlyAddedOffers?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage"))
                
                cell.productDiscount_lbl.text! = String (self.newlyAddedOffers?[indexPath.row].discountPercent ?? 0 ) + " % OFF \(self.newlyAddedOffers?[indexPath.row].brandNameData?.brandName ?? "")"
                
                return cell
                
            }
            
            
        }else if tableView == self.newAddedOfferWithImageleftSide_TableView {
            
            
            let cell = self.newAddedOfferWithImageleftSide_TableView.dequeueReusableCell(withIdentifier: "NewlyAddedOffersTableViewCell") as! NewlyAddedOffersTableViewCell
            
            return cell
            
        }else {
            
            let cell = self.categoryList_TableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCellTableViewCell") as! CategoriesTableViewCellTableViewCell
            cell.categoryImage_ImgView.sd_setImage(with: URL(string: brandImageUrl + (self.categoryBrandData?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage"))
            
            cell.categoryName_lbl.text! = self.categoryBrandData?[indexPath.row].name ?? ""
            
            return cell
            
            
        }
    }
    
    // MARK: - TableView Did select
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.newlyAddedOffresWithImageRightSide_TableView {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
            
            vc.offer_id = self.newlyAddedOffers?[indexPath.row].id ?? 0
            
            self.navigationController?.pushViewController(vc
                , animated: true)
            
            
        }else if tableView == self.newAddedOfferWithImageleftSide_TableView {
            
            
        }else {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewAllBrandsViewController") as! ViewAllBrandsViewController
            
            vc.condition = "offers"
            
            vc.navigationTitle = self.categoryBrandData?[indexPath.row].name ?? ""
            
            vc.categories_id = String(self.categoryBrandData?[indexPath.row].categoriesBrand?.first?.categoriesID ?? 0)
            
            self.navigationController?.pushViewController(vc
                , animated: true)
            
        }
        
    }
    
}

// MARK: - Collection View Delegate

extension UnilifeBrandViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == brandOffer_CollectionView {
            
            return 1
            
        }else if collectionView == latestBlog_CollectionView {
            
            return 1
        }
            
        else {
            
            return 1
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == brandOffer_CollectionView {
            
            if self.brandRealtedOffers?.count == 1 {
                return (self.brandRealtedOffers?.count ?? 0)
                
            }else if self.brandRealtedOffers?.count == 2 {
                
                return (self.brandRealtedOffers?.count ?? 0) / 2
                
            }else if self.brandRealtedOffers?.count == 3 {
                
                return (self.brandRealtedOffers?.count ?? 0) / 2
                
            }else {
                
                return (self.brandRealtedOffers?.count ?? 0) / 4
                
            }
            
            //  return 2
            
            
        }else if collectionView == latestBlog_CollectionView {
            
            if (self.blogDataArray?.count ?? 0) > 6 {
                
            return 6
                
                
            }else {
            
            return self.blogDataArray?.count ?? 0
                
            }
            
            
        }else if (collectionView == collectionSlider)
        {
            return self.brandOffersData?.slider?.count ?? 0
        }
        else {
            
            if (self.trendingOffers?.count ?? 0) >  6 {
                
            return 6 
                
            
            }else {
            
            return self.trendingOffers?.count ?? 0
                
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == brandOffer_CollectionView {
            
            let cell = self.brandOffer_CollectionView.dequeueReusableCell(withReuseIdentifier: "NumberBrandOfferCollectionViewCell", for: indexPath) as! NumberBrandOfferCollectionViewCell
            //            cell.brandOffersRealatedCollection_View.register(UINib(nibName: "BrandOffersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BrandsOffersCollectionViewCell")
            
            cell.brandOfferData = self.brandRealtedOffers
            
            cell.brandOffersRealatedCollection_View.reloadData()
            
            cell.brandOffersRealatedCollection_View.delegate = cell
            
            cell.brandOffersRealatedCollection_View.dataSource = cell
            
            cell.index = indexPath.row
            
            cell.brandOfferData? = []
            
            if (self.brandRealtedOffers?.count ?? 0) < 5 {
                
                cell.brandOfferData = self.brandRealtedOffers
                
            }else {
                
                 var start_counter = indexPath.row + 4
                
                if indexPath.row == 0 {
                    
                    start_counter = 0
                    
                }else {
                    
                    start_counter = indexPath.row * 4
                }
                
               
                
                var end_counter = start_counter + 4
                
                if end_counter > (self.brandRealtedOffers?.count ?? 0) {
                    
                    end_counter = (self.brandRealtedOffers?.count ?? 0)
                }
                
                for i in start_counter..<end_counter {
                    
                    if brandRealtedOffers?[i] != nil {
                        
                        cell.brandOfferData?.append(((self.brandRealtedOffers?[i])!))

                    }
                    
                }
            }
            
            cell.brandOffersRealatedCollection_View.reloadData()
            
            return cell
            
        }else if collectionView == latestBlog_CollectionView {
            
            let cell = self.latestBlog_CollectionView.dequeueReusableCell(withReuseIdentifier: "LatestBlogsCollectionViewCell", for: indexPath) as! LatestBlogsCollectionViewCell
            
            cell.latestBlog_ImageView.sd_setImage(with: URL(string: blogImageUrl + (self.blogDataArray?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage"))
            
            cell.blogName_lbl.text = self.blogDataArray?[indexPath.row].title ?? ""
            
            return cell
            
        }
        else if (collectionView == collectionSlider)
        {
            //                let cell = self.trendingOffer_CollectionView.dequeueReusableCell(withReuseIdentifier: "BrandImageSliderCollectionCell", for: indexPath) as! BrandImageSliderCollectionCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandImageSliderCollectionCell", for: indexPath as IndexPath) as! BrandImageSliderCollectionCell
            
            cell.img.sd_setImage(with: URL(string: offerImageUrl + (self.brandOffersData?.slider?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage"))
            return cell
        }
        else if (collectionView == trendingOffer_CollectionView)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandFoodCell", for: indexPath as IndexPath) as! BrandFoodCell
                                     
//                           cell.img.sd_setImage(with: URL(string: offerImageUrl + (self.brandOffersData?.slider?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage"))
            cell.img.sd_setImage(with: URL(string: offerImageUrl + (self.trendingOffers?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage"))
            cell.viwInner.layer.cornerRadius = 5
            cell.viwInner.layer.borderColor = UIColor.lightGray.cgColor
            cell.viwInner.layer.borderWidth = 0.5
                return cell
        }
        else {
            let cell = self.trendingOffer_CollectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as! TrendingCollectionViewCell
            
            cell.product_ImageView.sd_setImage(with: URL(string: offerImageUrl + (self.trendingOffers?[indexPath.row].image ?? "")), placeholderImage: UIImage(named: "noimage"))
            
            cell.productDiscount_lbl.text = ""
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == brandOffer_CollectionView {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
            
            vc.offer_id = self.brandRealtedOffers?[indexPath.row].id ?? 0
             self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == trendingOffer_CollectionView  {
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
            
            vc.offer_id = self.trendingOffers?[indexPath.row].id ?? 0
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        } else if collectionView == latestBlog_CollectionView {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailViewController") as! BlogDetailViewController
            
            vc.condition = ""
            
            vc.viewBlogFromBrand = self.blogDataArray?[indexPath.row]
            
            vc.navigationTitle = self.brandOffersData?.blogs?.first?.categoriesName ?? ""
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == brandOffer_CollectionView {
            
            //             return CGSize(width: self.DirectoryCollectioView.frame.width/2 - 10, height: 130)
            
            //  self.brandOffer_CollectionView.scrollddir
            
            return CGSize(width: brandOffer_CollectionView.frame.width - 10, height:  (brandOffer_CollectionView.frame.width - 10))
            
            
        }else if collectionView == latestBlog_CollectionView {
            
            return CGSize(width: 144, height: 150)
            
        }else if (collectionView == collectionSlider)
        {
            return CGSize(width: (collectionView.frame.width), height: collectionView.frame.height)
        }
            
            
        else {
            return CGSize(width: (self.trendingOffer_CollectionView.frame.height - 20), height: self.trendingOffer_CollectionView.frame.height)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == brandOffer_CollectionView {
            return 4
            
        }else if collectionView == latestBlog_CollectionView {
            
            return 10
        }else if (collectionView == collectionSlider)
        {
            return 0
        }
            
        else {
            return 10
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == brandOffer_CollectionView {
            return 4
        }else if collectionView == latestBlog_CollectionView {
            
            return 10
            
        }else if (collectionView == collectionSlider)
        {
            return 0
        }
            
        else {
            return 10
            
        }
    }
    
}

//------------------------------------------------------
// MARK: UIScrollViewDelegate   ------------------------------------------------------
//------------------------------------------------------

extension UnilifeBrandViewController:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView.tag == 1000)
        {
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let ip = self.collectionSlider.indexPathForItem(at: center) {
                self.topSliderIndicator_pageController.currentPage = ip.row
                //self.currentPage = ip.row
            }
        }
        
    }
}

/*
// MARK: - ICarousel Delegate And DataSoucre

extension UnilifeBrandViewController: iCarouselDelegate, iCarouselDataSource {
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        return self.brandOffersData?.slider?.count ?? 0
        
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let sliderView = Bundle.main.loadNibNamed("TopSliderImage", owner: self, options: nil)?.first as! TopSlider
        
        sliderView.frame = self.topSlider_ImageView.frame
        
        sliderView.sliderImage.contentMode = .scaleAspectFit
        
        sliderView.sliderImage.clipsToBounds = true
       // sliderView.backgroundColor = UIColor.red
        sliderView.sliderImage.sd_setImage(with: URL(string: offerImageUrl + (self.brandOffersData?.slider?[index].image ?? "")), placeholderImage: UIImage(named: "noimage"))
        
        return sliderView
        
        
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        
       // self.topSliderIndicator_pageController.currentPage = carousel.currentItemIndex
        
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch option {
        case .spacing:
            return 1.1
        default:
            return value
        }
        
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedeemCouponViewController") as! RedeemCouponViewController
        
        vc.offer_id = self.brandOffersData?.slider?[index].id ?? 0
        
        self.navigationController?.pushViewController(vc
            , animated: true)
        
    }
    
}
*/

extension UnilifeBrandViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}

// MARK: - Service Response

extension UnilifeBrandViewController {
    
    // MARK: - Get Brand Data
    
    func brandData() {
        
        Indicator.shared.showProgressView(self.view)
        
        Singleton.sharedInstance.connection.startConnectionWithGetType(getUrlString: "show_offers/\(UserData().userId)") {[weak self] (receviedData) in
            
            print(receviedData)
            guard let self = self else {
                return
            }
            
            
            if Singleton.sharedInstance.connection.responseCode == 1 {
                
                if receviedData["response"] as? Bool == true {
                    
                    guard let data = receviedData as? [String: AnyObject]else {
                        
                        return
                    }
                    
                    do {
                        
                        let jsonData = try?JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                        
                        self.brandOffersData = try JSONDecoder().decode(UnilifeBrandModel.self, from: jsonData!)
                        
                        
                        //let count = self.brandOffersData?.offer?.count ?? 0
                        
                        if (self.brandOffersData?.slider?.count ?? 0) == 0 {
                            //    self.topSlider_ImageView.isHidden = true
                            self.brandSlider_height.constant = 0
                            
                            self.topSliderIndicator_pageController.isHidden = true
                            
                        }else {
                            
                            //   self.topSlider_ImageView.isHidden = false
                            self.brandSlider_height.constant = 150
                            self.topSliderIndicator_pageController.isHidden = false
                            
                        }
                        
                        if self.brandOffersData?.offer?.count ?? 0 > 0 {
                            
                            
                            self.trending_View.isHidden = false
                            
                            self.trendingView_height.constant  = 50
                            
                            self.trendingCollectionView_height.constant = 150
                            
                            self.trendingOffer_CollectionView.isHidden = false
                            
                            let trendingOfferData = self.brandOffersData?.offer?[0].categoriesBrand
                            
                            let newData = trendingOfferData?.filter({$0.brandOffer?.filter({$0 != nil}) != nil })
                            
                            var brandOffear = [[BrandOffer]]()
                            
                            for i in 0..<(newData?.count ?? 0) {
                                
                                brandOffear.append((newData?[i].brandOffer!)! as [BrandOffer])
                                
                            }
                            
                            //   let kllaKllaIndexOfBrandOffer = brandOffear.flatMap({$0})
                            
                            self.trendingOffers =  brandOffear.flatMap({$0})
                            
                            self.trendingOfferName_lbl.text! = self.brandOffersData?.offer?[0].name ?? ""
                            
                            if self.trendingOffers?.count == 0 {
                                
                                self.trending_View.isHidden = true
                                
                                self.trendingView_height.constant  = 0
                                
                                self.trendingCollectionView_height.constant = 0
                                
                                self.trendingOffer_CollectionView.isHidden = true
                                
                            }else {
                                
                                
                            }
                            
                            // mxnxbhsxhcvgcvgvcgcvvcvc
                            
                        }else {
                            self.trending_View.isHidden = true
                            
                            self.trendingView_height.constant  = 0
                            
                            self.trendingCollectionView_height.constant = 0
                            
                            self.trendingOffer_CollectionView.isHidden = true
                            
                        }
                        
                        if (self.brandOffersData?.offer?.count ?? 0) > 1 {
                            
                            self.newlyAddedOffer_View.isHidden = false
                            
                            self.newlyAddedOfferView_height.constant = 50
                            
                            let newlyAddedOfferData = self.brandOffersData?.offer?[1].categoriesBrand
                            
                            let newAddedFilterData = newlyAddedOfferData?.filter({$0.brandOffer?.filter({$0 != nil}) != nil })
                            
                            
                            
                            var filterNewAddedBrandData = [[BrandOffer]]()
                            
                            for i in 0..<(newAddedFilterData?.count ?? 0) {
                                
                                filterNewAddedBrandData.append((newAddedFilterData?[i].brandOffer!)! as [BrandOffer])
                                
                            }
                            
                            //   let kllaKllaIndexOfBrandOffer = brandOffear.flatMap({$0})
                            
                            self.newlyAddedOffers =  filterNewAddedBrandData.flatMap({$0})
                            
                            self.newlyAddedOffer_lbl.text! = self.brandOffersData?.offer?[1].name ?? ""
                            self.newAddedLeftSideImageTableView_height.constant = 0
                            self.newlyAddedOffresWithImageRightSide_TableView.reloadData()
                            
                            if (self.newlyAddedOffers?.count ?? 0) == 0 {
                                
                                self.newlyAddedOffer_View.isHidden = true
                                
                                self.newlyAddedOfferView_height.constant = 0
                                
                                self.newAddedRightSideImageTableView_Height.constant = 0
                                
                                self.newAddedOfferWithImageleftSide_TableView.isHidden = true
                                
                            }else {
                                
                                if (self.newlyAddedOffers?.count ?? 0) > 3 {
                                    self.newAddedRightSideImageTableView_Height.constant = CGFloat(3 * 120)
                                    
                                }else{
                                    
                                    self.newAddedRightSideImageTableView_Height.constant = CGFloat((self.newlyAddedOffers?.count ?? 0) * 120)
                                    
                                }
                                
                            }
                            
                        }else {
                            
                            self.newlyAddedOffer_View.isHidden = true
                            
                            self.newlyAddedOfferView_height.constant = 0
                            
                            self.newAddedLeftSideImageTableView_height.constant = 0
                            
                            self.newAddedOfferWithImageleftSide_TableView.isHidden = true
                            
                            self.newAddedRightSideImageTableView_Height.constant = 0
                        }
                        
                        if self.brandOffersData?.offer?.count ?? 0 >  2 {
                            
                            
                            
                            let brandOfferArray = self.brandOffersData?.offer?[2].categoriesBrand
                            
                            let filterBrandOffer = brandOfferArray?.filter({$0.brandOffer?.filter({$0 != nil}) != nil })
                            
                            
                            
                            var filterNewBrandOfferData = [[BrandOffer]]()
                            
                            for i in 0..<(filterBrandOffer?.count ?? 0) {
                                
                                filterNewBrandOfferData.append((filterBrandOffer?[i].brandOffer!)! as [BrandOffer])
                                
                            }
                            
                            //   let kllaKllaIndexOfBrandOffer = brandOffear.flatMap({$0})
                            
                            self.brandRealtedOffers =  filterNewBrandOfferData.flatMap({$0})
                            
                            self.brandOffer_CollectionView.reloadData()
                            
                            self.brandOfferTitle_lbl.text! = self.brandOffersData?.offer?[2].name ?? ""
                            
                            if (self.brandRealtedOffers?.count ?? 0) == 0 {
                                
                                self.brandOfferHeight_View.constant = 0
                                
                                self.brandOfferCollectionView_Height.constant = 0
                                self.brandOffer_View.isHidden = true
                                
                                self.brandOffer_CollectionView.isHidden = true
                                
                            }else if (self.brandRealtedOffers?.count ?? 0) == 1 {
                                
                                self.brandOfferCollectionView_Height.constant = 200
                                
                            }else {
                                
                            }
                            
                            
                            
                        }else {
                            
                            self.brandOfferHeight_View.constant = 0
                            
                            self.brandOfferCollectionView_Height.constant = 0
                            self.brandOffer_View.isHidden = true
                            
                            self.brandOffer_CollectionView.isHidden = true
                        }
                        
                        if self.brandOffersData?.offer?.count ?? 0 > 3 {
                            
                            self.categoryBrandData = Array((self.brandOffersData?.offer?[3..<(self.brandOffersData?.offer?.count ?? 0)])!)
                            
                            
                            
                            //                        let count = self.brandOffersData?.offer?.count ?? 0
                            //
                            //                            var categoryData : [CategoriesBrand1]?
                            //
                            //                            for i in 3..<count {
                            //
                            //                            categoryData = self.brandOffersData?.offer?[i].categoriesBrand
                            //
                            //                            }
                            //
                            //                        print(categoryData)
                            //
                            //
                            //
                            //                            let categaoryFilterData = categoryData?.filter({$0.brandOffer?.filter({$0 != nil}) != nil })
                            //
                            //
                            //
                            //                            var filterCategoryData = [[BrandOffer]]()
                            //
                            //                            for i in 0..<(categaoryFilterData?.count ?? 0) {
                            //
                            //                                filterCategoryData.append((categaoryFilterData?[i].brandOffer!)! as [BrandOffer])
                            //
                            //                            }
                            //
                            //                            //   let kllaKllaIndexOfBrandOffer = brandOffear.flatMap({$0})
                            //
                            //                            self.categoryBrandData =  filterCategoryData.flatMap({$0})
                            //
                            ////                            self.brandOfferTitle_lbl.text! = self.brandOffersData?.offer?[2].name ?? ""
                            
                        }else {
                            
                            self.category_View.isHidden = true
                            
                            self.categoryView_Height.constant = 0
                            
                            self.categoryListingTableView_height.constant = 0
                            
                            self.categoryList_TableView.isHidden = true
                        }
                        
                        //let blogCount = self.brandOffersData?.blogs?.count ?? 0
                        
                        self.blogName_lbl.text! = self.brandOffersData?.blogs?.first?.categoriesName ?? ""
                        
                        
                        self.blogDataArray = self.brandOffersData?.blogs?.first?.categoriesBlog
                        
                        //sleep(2)
                        
                        if (self.brandOffersData?.blogs?.count ?? 0) > 0 {
                            
                            if (self.blogDataArray?.count ?? 0) > 0 {
                                
                                self.latestBlogs_View.isHidden = false
                                
                                self.latestBlogsView_height.constant = 198
                                
                                
                            }else {
                                
                                self.latestBlogs_View.isHidden = true
                                
                                self.latestBlogsView_height.constant = 0
                                
                            }
                            
                        }else {
                            
                            
                            self.latestBlogs_View.isHidden = true
                            
                            self.latestBlogsView_height.constant = 0
                            
                        }
                        
                        self.latestBlog_CollectionView.reloadData()
                        
                        self.trendingOffer_CollectionView.reloadData()
                        
                        self.brandOffer_CollectionView.reloadData()
                        
                        self.allDelegateAndDataSource()
                        
                        self.latestBlogs_View.layoutIfNeeded()
                        
                        Indicator.shared.hideProgressView()
                        
                        self.collectionSlider.reloadData()
                    }catch {
                        
                        print(error.localizedDescription)
                        Indicator.shared.hideProgressView()
                    }
                    
                }else {
                    
                    
                    self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["message"] as? String ?? "No Data Found ")
                    
                    Indicator.shared.hideProgressView()
                    
                }
                
            }else {
                
                
                
                self.showDefaultAlert(Message: (receviedData as? [String: AnyObject])? ["Error"] as? String ?? "No Data Found ")
                
                Indicator.shared.hideProgressView()
                
            }
            
        }
        
    }
    
    
}


