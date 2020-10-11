import Foundation

struct CalculateParametrs: Codable {
    let clientTypes: [String]
    let cost, initialFee, kaskoValue: Int
    let language: String
    let residualPayment: Double
    let settingsName: String
    let specialConditions: [String]
    let term: Int
}
