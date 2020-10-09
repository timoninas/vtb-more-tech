import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        prepareCamera()
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
    
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        takePicture()
    }
    
    @IBAction func choosePhotoFromLibraryButton(_ sender: UIButton) {
//        let cameraIcon = #imageLiteral(resourceName: "camera")
//        let libraryIcon = #imageLiteral(resourceName: "image")
        
        let alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Camera", style: .default) { _ in
            //TODO Camera action
            self.chooseImagePicker(source: .camera)
        }
        
//        action1.setValue(cameraIcon, forKey: "image")
        action1.setValue(CATextLayerAlignmentMode.left, forKey: "TitleTextAlignment")
        
        let action2 = UIAlertAction(title: "Library", style: .default) { _ in
            //TODO Library action
            self.chooseImagePicker(source: .photoLibrary)
        }
//        action2.setValue(libraryIcon, forKey: "image")
        action2.setValue(CATextLayerAlignmentMode.left, forKey: "TitleTextAlignment")
        
        let action3 = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func setupLayout() {
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationItem.title = "Поиск машины";
        view.backgroundColor = UIColor.appColor(.White)
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
                    navigationController?.pushViewController(ModuleBuilder.createCameraModule(image: img), animated: true)
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
        navigationController?.pushViewController(ModuleBuilder.createCameraModule(image: image), animated: true)
        dismiss(animated: true, completion: nil)
    }
}
