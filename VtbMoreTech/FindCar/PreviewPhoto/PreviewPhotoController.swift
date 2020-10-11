import UIKit

struct CarInfo {
    var brand = String()
    var model = String()
    var beautyBrand = String()
    var beautyModel = String()
}

let cars: [String: CarInfo] = [
    "BMW 3": CarInfo(brand: "bmw", model: "3_series", beautyBrand: "BMW", beautyModel: "3 серия"),
    "BMW 5": CarInfo(brand: "bmw", model: "5_series", beautyBrand: "BMW", beautyModel: "5 серия"),
    "Cadillac ESCALADE": CarInfo(brand: "cadillac", model: "escalade", beautyBrand: "Cadillac", beautyModel: "ESCALADE"),
    "Chevrolet Tahoe": CarInfo(brand: "chevrolet", model: "tahoe", beautyBrand: "Chevrolet", beautyModel: "Tahoe"),
    "Hyundai Genesis": CarInfo(brand: "hyundai", model: "solaris-2017", beautyBrand: "Hyundai", beautyModel: "Solaris"),
    "Jaguar F-PACE": CarInfo(brand: "jaguar", model: "f-pace", beautyBrand: "Jaguar", beautyModel: "F-PACE"),
    "KIA K5": CarInfo(brand: "kia", model: "k5", beautyBrand: "KIA", beautyModel: "K5"),
    "KIA Optima": CarInfo(brand: "kia", model: "new_optima", beautyBrand: "KIA", beautyModel: "Optima"),
    "KIA Sportage": CarInfo(brand: "kia", model: "sportage", beautyBrand: "KIA", beautyModel: "Sportage"),
    "Land Rover RANGE ROVER VELAR": CarInfo(brand: "land-rover", model: "rangerovervelar", beautyBrand: "Land Rover", beautyModel: "VELAR"),
    "Mazda 3": CarInfo(brand: "mazda", model: "mazda6", beautyBrand: "Mazda", beautyModel: "3 серия"),
    "Mazda 6": CarInfo(brand: "mazda", model: "mazda6", beautyBrand: "Mazda", beautyModel: "6 серия"),
    "Mercedes A": CarInfo(brand: "", model: "", beautyBrand: "", beautyModel: ""),
    "Toyota Camry": CarInfo(brand: "", model: "", beautyBrand: "", beautyModel: ""),
]

class PreviewPhotoController: UIViewController {
    
    var capturedImage: UIImage!
    var type: typeOfPhoto!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var showPriceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.appColor(.TabBarBackgroundColor)
        
        setupButtons()
        setupImage()
    }
    
    func setupImage() {
        guard let image = capturedImage else { return }
        imageView.image = image
        if type == typeOfPhoto.fromCamera {
            imageView.contentMode = .scaleAspectFill
            request(image: capturedImage.rotate(radians: .ulpOfOne))
        } else {
            imageView.contentMode = .scaleAspectFit
            request(image: capturedImage)
        }
    }
    
    func request(image: UIImage) {
        CarRecognitionService.shared.recoginizeCar(image: image) {[weak self] (dictionary) in
            if let self = self, let card = dictionary {
                DispatchQueue.main.async {
                    self.navigationItem.title = card.max { (val1, val2) -> Bool in
                        if (val1.value < val2.value) {
                            return true
                        }
                        return false
                    }?.key;
                }
            }
        }
    }
    
    @IBAction func showPriceTapped(_ sender: UIButton) {
        startActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            ModuleBuilder.createOfferModule(carBrand: "", carModel: "", beautyCarBrand: "", beautyCarModel: "")
            guard let naming = self.navigationItem.title else { return }
            let carInfo = cars[naming]
            let vc = ModuleBuilder.createOfferModule(carBrand: carInfo?.brand ?? "", carModel: carInfo?.model ?? "", beautyCarBrand: carInfo?.beautyBrand ?? "", beautyCarModel: carInfo?.beautyModel ?? "")
            self.stopActivityIndicator()
//            self.present(vc, animated: true, completion: nil)
            
            self.navigationController?.pushViewController(vc, animated: true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupButtons() {
        showPriceButton.vtbStyleButton()
    }
    
    // MARK: - Activity indicator
    
    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        ai.style = .large
        ai.center = self.view.center
        ai.backgroundColor = .white
        ai.hidesWhenStopped = true
        return ai
    }()
    
    fileprivate lazy var loadingView: UIView = {
        let lv = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        lv.center = self.view.center
        lv.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        lv.layer.cornerRadius = 10
        lv.clipsToBounds = true
        return lv
    }()
    
    fileprivate func startActivityIndicator() {
        view.addSubview(activityIndicator)
        view.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    
    fileprivate func stopActivityIndicator() {
        loadingView.isHidden = true
        activityIndicator.stopAnimating()
    }
}
