import UIKit

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
        ModuleBuilder.createOfferModule(carBrand: "", carModel: "")
        guard let naming = navigationItem.title else { return }
        let separatedCarName = naming.split(separator: " ")
        var brand = "\(separatedCarName.first!)"
        var model = ""
        for i in 1..<separatedCarName.count {
            if separatedCarName[i] == "Rover" {
                brand += " \(separatedCarName[i])"
            } else {
                model += "\(separatedCarName[i]) "
            }
        }
        
        present(ModuleBuilder.createOfferModule(carBrand: brand, carModel: model), animated: true, completion: nil)
    }
    
    func setupButtons() {
        showPriceButton.vtbStyleButton()
    }
}
