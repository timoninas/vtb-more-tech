import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent //.default for black style
    }
    
    @IBOutlet weak var takePhotoButton: UIButton!
    
    @IBOutlet weak var choosePhotoFromLibraryButton: UIButton!
    
    
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Marketplace.shared.upload()
        
        takePhotoButton.vtbStyleButton()
        takePhotoButton.backgroundColor = .lightGray
        choosePhotoFromLibraryButton.vtbStyleButton()
        setupLayout()
        prepareCamera()
        request()
    }
    
    func request() {
        let headers = [
            "x-ibm-client-id": "1039399f119d8f9152f0a67dabe4fc6a",
            "content-type": "application/json",
            "accept": "application/json"
        ]
        let parameters = [
            "clientTypes": ["ac43d7e4-cd8c-4f6f-b18a-5ccbc1356f75"],
            "cost": 850000,
            "initialFee": 200000,
            "kaskoValue": 26272442,
            "language": "ru-RU",
            "residualPayment": 87.95449806,
            "settingsName": "Haval",
            "specialConditions": ["57ba0183-5988-4137-86a6-3d30a4ed8dc9", "b907b476-5a26-4b25-b9c0-8091e9d5c65f", "cbfc4ef3-af70-4182-8cf6-e73f361d1e68"],
            "term": 5
        ] as [String : Any]
        
        var postData = Data()
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch let error {
            print(error.localizedDescription)
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://gw.hackathon.vtb.ru/vtb/hackathon/calculate")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                do {
                    guard let data = data else { return }
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print(json)
                        print("\n\n")
//                        decodeRanges(line: json["ranges"]! as! [String: Any])
//                        print("\n\n")
//                        print(json["result"]! as! [String: Any])
//                        decodeResult(line: json["result"]! as! [String: Any])
//                        print("\n\n")
//                        print(json["program"]! as! [String: Any])
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        })
        
        dataTask.resume()
    }
    
    func decodeResult(line: [String: Any]) -> Result {
        var result = Result()
        result.contractRate = "\(line["contractRate"] ?? "")" as! String
        result.kaskoCost = line["kaskoCost"] as! Int
        result.lastPayment = "\(line["lastPayment"] ?? "")" as! String
        result.loanAmount = line["loanAmount"] as! Int
        result.payment = line["payment"] as! Int
        result.residualPayment = "\(line["residualPayment"] ?? "")" as! String
        result.subsidy = "\(line["subsidy"] ?? "")" as! String
        result.term = line["term"] as! Int
        return result
    }
    
    func decodeRanges(line: [String: Any]) -> Ranges {
        print(line)
        guard let initialFee = line["initialFee"] as? [String: Any] else { return Ranges() }
        var inititalFeeStruct = MaxMinFilled()
        inititalFeeStruct.filled = initialFee["filled"] as! Int
        inititalFeeStruct.max = "\(initialFee["max"]!)" as! String
        inititalFeeStruct.min = "\(initialFee["min"]!)" as! String
        guard let cost = line["initialFee"] as? [String: Any] else { return Ranges() }
        var costStruct = MaxMinFilled()
        costStruct.filled = cost["filled"] as! Int
        costStruct.max = "\(cost["max"]!)" as! String
        costStruct.min = "\(cost["min"]!)" as! String
        guard let residualPayment = line["initialFee"] as? [String: Any] else { return Ranges() }
        var residualPaymentStruct = MaxMinFilled()
        residualPaymentStruct.filled = residualPayment["filled"] as! Int
        residualPaymentStruct.max = "\(residualPayment["max"]!)" as! String
        residualPaymentStruct.min = "\(residualPayment["min"]!)" as! String
        guard let term = line["initialFee"] as? [String: Any] else { return Ranges() }
        var termStruct = MaxMinFilled()
        termStruct.filled = term["filled"] as! Int
        termStruct.max = "\(term["max"]!)" as! String
        termStruct.min = "\(term["min"]!)" as! String
        
        let range = Ranges(cost: costStruct, initialFee: inititalFeeStruct, residualPayment: residualPaymentStruct, term: termStruct)
        return range
    }
    
    func prepareCamera() {
        session.sessionPreset = AVCaptureSession.Preset.photo
        camera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            guard let camera = camera else { return }
            let cameraCaptureInput = try AVCaptureDeviceInput(device: camera)
            cameraCaptureOutput = AVCapturePhotoOutput()
            
            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutput!)
            session.commitConfiguration()
        } catch let error {
            print(error.localizedDescription)
        }
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = view.bounds
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        
        session.startRunning()
    }
    
    func takePicture() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        cameraCaptureOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    
    @IBAction func takePhotoTapped(_ sender: UIButton) {
        takePicture()
    }
    
    @IBAction func choosePhotoFromLibraryButton(_ sender: UIButton) {
        self.chooseImagePicker(source: .photoLibrary)
    }
    
    
    func setupLayout() {
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setPhotoButton()
    }
    
    func setPhotoButton() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 1.0
        pulse.toValue = 1.03
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 0.8
        self.takePhotoButton.layer.add(pulse, forKey: nil)
    }
    
    func setupNavBar() {
        let size = 250
        self.takePhotoButton.frame = CGRect(x: Int(self.view.bounds.width) / 2 - size / 2, y: Int(self.view.bounds.height) / 2 - size / 2, width: size, height: size)
        self.takePhotoButton.layer.cornerRadius = 0.5 * takePhotoButton.bounds.size.width
        self.takePhotoButton.contentMode = .center
        self.takePhotoButton.imageView?.contentMode = .scaleAspectFit
        self.takePhotoButton.imageView?.tintColor = .white
        setPhotoButton()
        
        navigationItem.title = "VTB TECH";
//        view.backgroundColor = UIColor.appColor(.White)
        self.view.backgroundColor = UIColor.appColor(.TabBarBackgroundColor)
        navigationController?.navigationBar.barTintColor = UIColor.appColor(.TabBarBackgroundColor)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.appColor(.White)]
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

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let unwrappedError = error {
            print(unwrappedError.localizedDescription)
        } else {
            
            if let sampleBuffer = photoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) {
                
                if let finalImage = UIImage(data: dataImage) {
                    guard let img1 = UIImage(data: dataImage)?.jpegData(compressionQuality: 0.5) else { return }
                    guard let img = UIImage(data: img1) else { return }
                    navigationController?.pushViewController(ModuleBuilder.createCameraModule(image: img, type: .fromCamera), animated: true)
                }
            }
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            imagePicker.delegate = self
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = (info[.editedImage] as! UIImage)
        navigationController?.pushViewController(ModuleBuilder.createCameraModule(image: image, type: .fromLibrary), animated: true)
        dismiss(animated: true, completion: nil)
    }
}
