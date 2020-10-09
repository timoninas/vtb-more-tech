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
