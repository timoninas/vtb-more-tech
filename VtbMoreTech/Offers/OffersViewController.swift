//
//  OffersViewController.swift
//  VtbMoreTech
//
//  Created by Mac-HOME on 09.10.2020.
//

import UIKit
import GravitySliderFlowLayout

// MARK: Обычно мы так не пишем :)

class OffersViewController: UIViewController {
    
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productSubtitleLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    
    var images = [UIImage]()
    let titles = [String]()
    let subtitles = [String]()
    let prices = [String]()
    
    let collectionViewCellHeightCoefficient: CGFloat = 0.95
    let collectionViewCellWidthCoefficient: CGFloat = 0.75
    let priceButtonCornerRadius: CGFloat = 10
    let gradientFirstColor = UIColor(named: "ff8181")?.cgColor
    let gradientSecondColor = UIColor(named: "a81382")?.cgColor
    let cellsShadowColor = UIColor(named: "2a002a")?.cgColor
    let productCellIdentifier = "ProductCollectionViewCell"
    
    var carBrand: String! = "Cadillac"
    var carModel: String! = "ESCALADE"
    var car: CarModel!
    
    private var itemsNumber = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let car = Marketplace.shared.getCarData(carBrand: carBrand.lowercased(), carModel: carModel.lowercased()) {
            self.car = car
            self.images = car.images
        } else {
            // Emmpty state
        }
        
        configureCollectionView()
        configurePriceButton()
    }
    
    private func configureCollectionView() {
        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: collectionView.frame.size.height * collectionViewCellWidthCoefficient, height: collectionView.frame.size.height * collectionViewCellHeightCoefficient))
//        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: 400, height: 300))
        collectionView.collectionViewLayout = gravitySliderLayout
        collectionView.dataSource = self
        collectionView.delegate = self
        pageControl.numberOfPages = 4
    }
    
    private func configurePriceButton() {
        priceButton.layer.cornerRadius = priceButtonCornerRadius
    }
    
    private func configureProductCell(_ cell: ProductCollectionViewCell, for indexPath: IndexPath) {
        cell.clipsToBounds = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.bounds
        gradientLayer.colors = [gradientFirstColor, gradientSecondColor]
        gradientLayer.cornerRadius = 21
        gradientLayer.masksToBounds = true
        cell.layer.insertSublayer(gradientLayer, at: 0)
        
        cell.layer.shadowColor = cellsShadowColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 20
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
        
        if images.count != 0 {
            cell.productImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * collectionViewCellWidthCoefficient, height: self.view.frame.height * collectionViewCellHeightCoefficient)
                    cell.productImage.contentMode = .scaleAspectFit
            //        cell.productImage.layer.layoutIfNeeded()
            //        cell.productImage.layer.cornerRadius = 21
            //        cell.productImage.layer.masksToBounds = true
            //        cell.productImage.clipsToBounds = true
                    cell.productImage.image = images[indexPath.row % images.count]
        }
        
        cell.newLabel.layer.cornerRadius = 8
        cell.newLabel.clipsToBounds = true
        cell.newLabel.layer.borderColor = UIColor.white.cgColor
        cell.newLabel.layer.borderWidth = 1.0
        cell.newLabel.text = "AAA"
    }
    
    private func animateChangingTitle(for indexPath: IndexPath) {
//        UIView.transition(with: productTitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.productTitleLabel.text = self.titles[indexPath.row % self.titles.count]
//        }, completion: nil)
//        UIView.transition(with: productSubtitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.productSubtitleLabel.text = self.subtitles[indexPath.row % self.subtitles.count]
//        }, completion: nil)
//        UIView.transition(with: priceButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
//            self.priceButton.setTitle(self.prices[indexPath.row % self.prices.count], for: .normal)
//        }, completion: nil)
    }
    
    @IBAction func didPressPriceButton(_ sender: Any) {
        
    }
    
}

extension OffersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCollectionViewCell
        self.configureProductCell(cell, for: indexPath)
        return cell
    }
}

extension OffersViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
        let locationSecond = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x + 20, y: collectionView.center.y + scrollView.contentOffset.y)
        let locationThird = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x - 20, y: collectionView.center.y + scrollView.contentOffset.y)
        
        if images.count != 0 {
            if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst),
                let indexPathSecond = collectionView.indexPathForItem(at: locationSecond),
                let indexPathThird = collectionView.indexPathForItem(at: locationThird),
                indexPathFirst.row == indexPathSecond.row &&
                indexPathSecond.row == indexPathThird.row &&
                indexPathFirst.row != pageControl.currentPage {
                
                pageControl.currentPage = indexPathFirst.row % images.count
                self.animateChangingTitle(for: indexPathFirst)
            }
        }
    }
}
