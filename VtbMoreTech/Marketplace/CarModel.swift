//
//  CarModel.swift
//  VtbMoreTech
//
//  Created by Mac-HOME on 10.10.2020.
//

import UIKit

struct CarModel {
    var brand: String
    var model: String
    var images = [UIImage]()
    
    init(brand: String, model: String) {
        self.brand = brand.lowercased()
        self.model = model.lowercased()
    }
}
