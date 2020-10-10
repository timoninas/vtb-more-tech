////
////  OffersCollectionViewController.swift
////  VtbMoreTech
////
////  Created by Mac-HOME on 10.10.2020.
////
//
////import UIKit
////import GravitySliderFlowLayout
//
////private let reuseIdentifier = "OffersCell"
////
////class OffersCollectionViewController: UICollectionViewController {
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
//////        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: 50, height: 50))
//////        collectionView.collectionViewLayout = gravitySliderLayout
////
////        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
////    }
////
////    override func numberOfSections(in collectionView: UICollectionView) -> Int {
////        // #warning Incomplete implementation, return the number of sections
////        return 1
////    }
////
////
////    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        // #warning Incomplete implementation, return the number of items
////        return 10
////    }
////
////    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
////
////        return cell
////    }
////}
//
//import UIKit
//import GravitySliderFlowLayout
//
////class ProductCollectionViewCell:  UICollectionViewCell {
////    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
////        super.init(style: style, reuseIdentifier: reuseIdentifier)
////
////        setupLayout()
////    }
////
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////
////    var productImage: UIImageView
////    var newLabel: UILabel
////}
//
//class OffersCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return itemsNumber
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
//        self.configureProductCell(cell, for: indexPath)
//        
//        cell.clipsToBounds = false
//                let gradientLayer = CAGradientLayer()
//                gradientLayer.frame = cell.bounds
//                gradientLayer.colors = [gradientFirstColor, gradientSecondColor]
//                gradientLayer.cornerRadius = 21
//                gradientLayer.masksToBounds = true
//                cell.layer.insertSublayer(gradientLayer, at: 0)
//                
//                cell.layer.shadowColor = cellsShadowColor
//                cell.layer.shadowOpacity = 0.2
//                cell.layer.shadowRadius = 20
//                cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
//
//                cell.productImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * collectionViewCellWidthCoefficient, height: self.view.frame.height * collectionViewCellHeightCoefficient)
//                cell.productImage.contentMode = .scaleAspectFit
//        //        cell.productImage.layer.layoutIfNeeded()
//        //        cell.productImage.layer.cornerRadius = 21
//        //        cell.productImage.layer.masksToBounds = true
//        //        cell.productImage.clipsToBounds = true
//                cell.productImage.image = images[indexPath.row % images.count]
//                
//                cell.newLabel.layer.cornerRadius = 8
//                cell.newLabel.clipsToBounds = true
//                cell.newLabel.layer.borderColor = UIColor.white.cgColor
//                cell.newLabel.layer.borderWidth = 1.0
//                cell.newLabel.text = "AAA"
//        
//        return cell
//    }
//    
//    
//    @IBOutlet weak var priceButton: UIButton!
//    @IBOutlet weak var pageControl: UIPageControl!
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var productSubtitleLabel: UILabel!
//    @IBOutlet weak var productTitleLabel: UILabel!
//    
//    var images = [#imageLiteral(resourceName: "beats_image"), #imageLiteral(resourceName: "beats_headphone"), #imageLiteral(resourceName: "beats_headphones_white"), #imageLiteral(resourceName: "beats_headphones_white")]
//    let titles = ["Beats Solo", "Beats X - White", "Beats Studio", "ASF"]
//    let subtitles = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "For most people, buying a new computer\ndoes not have to be as stressful as\n        buying a new car.", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "ASF"]
//    let prices = ["$30.00", "$19.00", "$60.00", "10"]
//    
//    let collectionViewCellHeightCoefficient: CGFloat = 0.85
//    let collectionViewCellWidthCoefficient: CGFloat = 0.75
//    let priceButtonCornerRadius: CGFloat = 10
//    let gradientFirstColor = UIColor(named: "ff8181")?.cgColor
//    let gradientSecondColor = UIColor(named: "a81382")?.cgColor
//    let cellsShadowColor = UIColor(named: "2a002a")?.cgColor
//    let productCellIdentifier = "ProductCollectionViewCell"
//    
//    private var itemsNumber = 1000
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
//        
//        var url = URL(string: "https://tradeins.space/uploads/photo/176471/volvo-xc60_1.jpg")
//        var data = try? Data(contentsOf: url!)
//        var image = UIImage(data: data!)
//        images[0] = image!
//        
//        url = URL(string: "https://tradeins.space/uploads/photo/150675/sx4-new_1.jpg")
//        data = try? Data(contentsOf: url!)
//        image = UIImage(data: data!)
//        images[1] = image!
//        
//        configureCollectionView()
//        configurePriceButton()
//    }
//    
//    private func configureCollectionView() {
//        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: collectionView.frame.size.height * collectionViewCellWidthCoefficient, height: collectionView.frame.size.height * collectionViewCellHeightCoefficient))
//        collectionView.collectionViewLayout = gravitySliderLayout
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        pageControl.numberOfPages = 4
//    }
//    
//    private func configurePriceButton() {
//        priceButton.layer.cornerRadius = priceButtonCornerRadius
//    }
//    
//    private func configureProductCell(_ cell: ProductCollectionViewCell, for indexPath: IndexPath) {
//        cell.clipsToBounds = false
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = cell.bounds
//        gradientLayer.colors = [gradientFirstColor, gradientSecondColor]
//        gradientLayer.cornerRadius = 21
//        gradientLayer.masksToBounds = true
//        cell.layer.insertSublayer(gradientLayer, at: 0)
//        
//        cell.layer.shadowColor = cellsShadowColor
//        cell.layer.shadowOpacity = 0.2
//        cell.layer.shadowRadius = 20
//        cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
//
//        cell.productImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * collectionViewCellWidthCoefficient, height: self.view.frame.height * collectionViewCellHeightCoefficient)
//        cell.productImage.contentMode = .scaleAspectFit
////        cell.productImage.layer.layoutIfNeeded()
////        cell.productImage.layer.cornerRadius = 21
////        cell.productImage.layer.masksToBounds = true
////        cell.productImage.clipsToBounds = true
//        cell.productImage.image = images[indexPath.row % images.count]
//        
//        cell.newLabel.layer.cornerRadius = 8
//        cell.newLabel.clipsToBounds = true
//        cell.newLabel.layer.borderColor = UIColor.white.cgColor
//        cell.newLabel.layer.borderWidth = 1.0
//        cell.newLabel.text = "AAA"
//    }
//    
//    private func animateChangingTitle(for indexPath: IndexPath) {
//        UIView.transition(with: productTitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.productTitleLabel.text = self.titles[indexPath.row % self.titles.count]
//        }, completion: nil)
//        UIView.transition(with: productSubtitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.productSubtitleLabel.text = self.subtitles[indexPath.row % self.subtitles.count]
//        }, completion: nil)
//        UIView.transition(with: priceButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.priceButton.setTitle(self.prices[indexPath.row % self.prices.count], for: .normal)
//        }, completion: nil)
//    }
//    
//    @IBAction func didPressPriceButton(_ sender: Any) {
//        
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
//        let locationSecond = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x + 20, y: collectionView.center.y + scrollView.contentOffset.y)
//        let locationThird = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x - 20, y: collectionView.center.y + scrollView.contentOffset.y)
//        
//        if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst),
//            let indexPathSecond = collectionView.indexPathForItem(at: locationSecond),
//            let indexPathThird = collectionView.indexPathForItem(at: locationThird),
//            indexPathFirst.row == indexPathSecond.row &&
//            indexPathSecond.row == indexPathThird.row &&
//            indexPathFirst.row != pageControl.currentPage {
//            
//            pageControl.currentPage = indexPathFirst.row % images.count
//            self.animateChangingTitle(for: indexPathFirst)
//        }
//    }
//    
//}
//
////extension ViewController: UICollectionViewDataSource {
////    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return itemsNumber
////    }
////
////    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCollectionViewCell
////        self.configureProductCell(cell, for: indexPath)
////        return cell
////    }
////
////
////}
//
////extension ViewController: UICollectionViewDelegate {
////    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
////        let locationSecond = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x + 20, y: collectionView.center.y + scrollView.contentOffset.y)
////        let locationThird = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x - 20, y: collectionView.center.y + scrollView.contentOffset.y)
////        
////        if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst),
////            let indexPathSecond = collectionView.indexPathForItem(at: locationSecond),
////            let indexPathThird = collectionView.indexPathForItem(at: locationThird),
////            indexPathFirst.row == indexPathSecond.row &&
////            indexPathSecond.row == indexPathThird.row &&
////            indexPathFirst.row != pageControl.currentPage {
////            
////            pageControl.currentPage = indexPathFirst.row % images.count
////            self.animateChangingTitle(for: indexPathFirst)
////        }
////    }
////}
//
