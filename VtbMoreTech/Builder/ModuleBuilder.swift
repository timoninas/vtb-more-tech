import UIKit

protocol ProtocolBuilder {
    static func createCameraModule() -> UIViewController
    static func createProfileModule() -> UIViewController
}

class ModuleBuilder: ProtocolBuilder {
    static func createCameraModule() -> UIViewController {
        let view = CameraViewController()
        
        return view
    }
    
    static func createCameraModule(image: UIImage) -> UIViewController {
        let view = PreviewPhotoController()
        view.capturedImage = image
        return view
    }
    
    static func createProfileModule() -> UIViewController {
        let view = ProfileViewController()
        
        return view
    }
}

    //    static func createCameraModule() -> UIViewController {
    //        let networkService = NetworkService()
    //        let view = FirstView()
    //        let presenter = FirstPresenter(view: view, networkService: networkService)
    //        view.presenter = presenter
    //
    //        return view
    //    }
