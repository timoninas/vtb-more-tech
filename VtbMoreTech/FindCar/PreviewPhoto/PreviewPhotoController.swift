import UIKit

class PreviewPhotoController: UIViewController {
    
    var capturedImage: UIImage!
    var type: typeOfPhoto!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.appColor(.TabBarBackgroundColor)
        
        setupImage()
        
        request(image: capturedImage)
    }
    
    func setupImage() {
        guard let image = capturedImage else { return }
        imageView.image = image
        if type == typeOfPhoto.fromCamera {
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    func request(image: UIImage) {
        CarRecognitionService.shared.recoginizeCar(image: image) {[weak self] (dictionary) in
            if let self = self, let card = dictionary {
                print(dictionary)
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
