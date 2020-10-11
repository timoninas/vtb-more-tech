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
        takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        takePhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        takePhotoButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        takePhotoButton.heightAnchor.constraint(equalToConstant: 250).isActive = true
        self.takePhotoButton.frame = CGRect(x: 0, y: 0, width: size, height: size)
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
