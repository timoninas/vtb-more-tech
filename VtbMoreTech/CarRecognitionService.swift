import UIKit

protocol CarRecognitionServiceDescription {
    func recoginizeCar(image: UIImage, completion: (([String: Double]?) -> Void)?)
}

final class CarRecognitionService: CarRecognitionServiceDescription {
    // MARK:- Properties
    static let shared = CarRecognitionService()
    private var _modelCars = [String : Double]()
    
    public var modelCars: [String : Double] {
        return _modelCars
    }
    
    private init() {}
    
    func recoginizeCar(image: UIImage, completion: (([String: Double]?) -> Void)?) {
        
        let headers = [
            "x-ibm-client-id": "1039399f119d8f9152f0a67dabe4fc6a",
            "content-type": "application/json",
            "accept": "application/json"
        ]
        
        let image = image
        guard let data = image.jpegData(compressionQuality: 0.2) else {
            completion?(nil)
            return
        }
        
        let newImg = UIImage(data: data)
        
        let parameters = ["content": data.base64EncodedString()] as [String : Any]
        
        var postData = Data()
        
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch let error {
            print(error.localizedDescription)
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://gw.hackathon.vtb.ru/vtb/hackathon/car-recognize")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
                completion?(nil)
                return
            } else {
                guard let data = data else { return }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, Any> {
                        guard let dictionary = json["probabilities"] as? [String: Double] else {
                            completion?(nil)
                            return
                        }
                        self._modelCars = dictionary
                        completion?(dictionary)
                    }
                } catch let error{
                    print(error.localizedDescription)
                    completion?(nil)
                    return
                }
            }
        })
        
        dataTask.resume()
    }
}
