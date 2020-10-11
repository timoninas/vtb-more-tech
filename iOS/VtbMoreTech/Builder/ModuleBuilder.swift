import UIKit

protocol ProtocolBuilder {
    static func createCameraModule() -> UIViewController
    static func createProfileModule() -> UIViewController
    static func createCameraModule(image: UIImage, type: typeOfPhoto) -> UIViewController
    static func createOfferModule(carBrand: String, carModel: String, beautyCarBrand: String, beautyCarModel: String) -> UIViewController
    static func createCalculateModule(result: ResultCalculate, car: CarModel) -> UIViewController
    static func createInputFormModule(result: ResultCalculate, car: CarModel) -> UIViewController
    static func createSettingCalculateModule(car: CarModel) -> UIViewController
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
    
    static func createOfferModule(carBrand: String, carModel: String, beautyCarBrand: String, beautyCarModel: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let offersVC = storyboard.instantiateViewController(withIdentifier: "Offers") as! OffersViewController
        offersVC.carBrand = carBrand
        offersVC.carModel = carModel
        offersVC.beautyCarBrand = beautyCarBrand
        offersVC.beautyCarModel = beautyCarModel
        return offersVC
    }
    
    static func createCalculateModule(result: ResultCalculate, car: CarModel) -> UIViewController {
        let view = CalculateViewController()
        view.result = result
        view.car = car
        return view
    }
    
    static func createInputFormModule(result: ResultCalculate, car: CarModel) -> UIViewController {
        let view = InputsFormViewController()
        view.result = result
        view.car = car
        return view
    }
    
    static func createSettingCalculateModule(car: CarModel) -> UIViewController {
        let view = SettingCalculateViewController()
        view.car = car
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
