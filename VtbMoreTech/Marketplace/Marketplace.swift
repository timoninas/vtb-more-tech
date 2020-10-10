//
//  Marketplace.swift
//  VtbMoreTech
//
//  Created by Mac-HOME on 10.10.2020.
//

import UIKit

struct Marketplace {
    static var shared = Marketplace()
    
    var cars = [[String: Any]]()
    var car = [String: Any]()

    mutating func upload() {
        let headers = [
          "x-ibm-client-id": "5d2d01335a94cffe195b8906b50fee6b",
          "accept": "application/json"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://gw.hackathon.vtb.ru/vtb/hackathon/marketplace")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in

            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Marketplace: No data")
                return
            }

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String: Any]]]
            if let responseJSON = responseJSON {
                let resp = responseJSON["list"]
                if let resp = resp {
                    Marketplace.shared.cars = resp
                    print(resp)
                }
            }
        })
        dataTask.resume()
    }
    
    func getCarData(carBrand: String, carModel: String) -> CarModel! {
        var carData = CarModel(brand: carBrand, model: carModel)
        
        // Search brand
        var brandData: [String: Any]!
        for car in cars {
            if car["alias"] as? String == carBrand {
                brandData = car
            }
        }
        guard brandData != nil else { return nil }
        
//        print(brandData)
        
        // Search model
        var modelData: [String: Any]!
        let models = brandData["models"] as! [[String: Any]]
        for model in models {
            if model["alias"] as? String == carModel {
                modelData = model
            }
        }
        guard modelData != nil else { return nil }
        
//        print(modelData)
        
        // IT IS TERRABLE BUT HAVE NO TIME
        // LIKE LISP :)
        if let imagesData = modelData["renderPhotos"] as! [String: Any]? {
            for (_, imageData) in imagesData {
                if let imageData = imageData as? [String: Any] { // back
                    for (_, typeImageData) in imageData {
                        if let typeImageData = typeImageData as? [String: Any] {
                            if let imagePath = typeImageData["path"] as? String {
                                let url = URL(string: imagePath)
                                if let data = try? Data(contentsOf: url!) {
                                    if let image = UIImage(data: data) {
                                        carData.images.append(image)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
//        print(modelData["minPrice"])
        
        if let price = modelData["minPrice"] as? Int {
            carData.price = String(price)
        }
        
        return carData
    }
}
