//
//  CalculateService.swift
//  VtbMoreTech
//
//  Created by Антон Тимонин on 11.10.2020.
//

import UIKit

protocol CalculateServiceDescription {
    func calculate(cost: Int, initialFee: Int, completion: ((ResultCalculate?) -> Void)?)
}

final class CalculateService: CalculateServiceDescription {
    // MARK:- Properties
    static let shared = CalculateService()
    
    private init() {}
    
    func calculate(cost: Int, initialFee: Int, completion: ((ResultCalculate?) -> Void)?) {
        let headers = [
            "x-ibm-client-id": "1039399f119d8f9152f0a67dabe4fc6a",
            "content-type": "application/json",
            "accept": "application/json"
        ]
        
        let calculateParametrs = CalculateParametrs(cost: cost, initialFee: initialFee)
        let parameters = calculateParametrs.getParametrs() as [String : Any]
        
        var postData = Data()
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch let error {
            print(error.localizedDescription)
            completion?(nil)
            return
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
                completion?(nil)
                return
            } else {
                do {
                    guard let data = data else {
                        completion?(nil)
                        return
                    }
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                        print(json)
//                        print("\n\n")
//                        decodeRanges(line: json["ranges"]! as! [String: Any])
//                        print("\n\n")
//                        print(json["result"]! as! [String: Any])
                        let res = decodeResult(line: json["result"]! as! [String: Any])
                        completion?(res)
//                        print(json["program"]! as! [String: Any])
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completion?(nil)
                    return
                }
            }
        })
        
        dataTask.resume()
    }
    
    func decodeResult(line: [String: Any]) -> ResultCalculate {
        var result = ResultCalculate()
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
}


