import UIKit

protocol ProtocolBuilder {
    static func createCameraModule() -> UIViewController
    static func createProfileModule() -> UIViewController
}

enum typeOfPhoto {
    case fromCamera
    case fromLibrary
}

class ModuleBuilder: ProtocolBuilder {
    static func createCameraModule() -> UIViewController {
        let view = CameraViewController()
        
        return view
    }
    
    static func createCameraModule(image: UIImage, type: typeOfPhoto) -> UIViewController {
        let view = PreviewPhotoController()
        view.capturedImage = image
        view.type = type
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
