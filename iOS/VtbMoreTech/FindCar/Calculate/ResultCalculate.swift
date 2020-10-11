import Foundation
//
//// MARK: - Welcome
//struct resultCalculate: Codable {
//    let program: program
//    let ranges: ranges
//    let result: result
//}
//
//// MARK: - Program
//struct program: Codable {
//    let cost: cost
//    let id, programName, programURL, requestURL: String
//
//    enum CodingKeys: String, CodingKey {
//        case cost, id, programName
//        case programURL = "programUrl"
//        case requestURL = "requestUrl"
//    }
//}
//
//// MARK: - Cost
//struct cost: Codable {
//    let filled: Bool
//    let max, min: Int?
//}
//
//// MARK: - Ranges
//struct ranges: Codable {
//    let cost, initialFee, residualPayment, term: cost
//}
//
//// MARK: - Result
//struct result: Codable {
//    let contractRate: Double
//    let kaskoCost: Int
//    let lastPayment: Double
//    let loanAmount, payment: Int
//    let subsidy: Double
//    let term: Int
//}

struct Ranges {
    var cost: MaxMinFilled?
    var initialFee: MaxMinFilled?
    var residualPayment: MaxMinFilled?
    var term: MaxMinFilled?
}

struct MaxMinFilled {
    var filled: Int? = 0
    var max: String? = ""
    var min: String? = ""
}

struct ResultCalculate {
    // Базовая процентная ставка
    var contractRate: String = "";
    
    // Стоимость каско
    var kaskoCost: Int = 0;
    
    // Остаточный платеж
    var lastPayment: String = "";
    
    // Сумма кредита
    var loanAmount: Int = 0;
    
    // Ежемесячный платеж
    var payment: Int = 0;
    
    var residualPayment: String = "";
    var subsidy: String = "";
    
    // Срок кредита
    var term: Int = 0;
}
