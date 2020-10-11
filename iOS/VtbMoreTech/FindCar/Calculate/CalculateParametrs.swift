import Foundation

struct CalculateParametrs: Codable {
    let clientTypes: [String]
    let cost, initialFee, kaskoValue: Int
    let language: String
    let residualPayment: Double
    let settingsName: String
    let specialConditions: [String]
    let term: Int
    
    init(cost: Int, initialFee: Int, kaskoValue: Int, residualPayment: Double, term: Int) {
        clientTypes = [ "ac43d7e4-cd8c-4f6f-b18a-5ccbc1356f75"]
        self.cost = cost
        self.initialFee = initialFee
        self.kaskoValue = kaskoValue
        language = "ru-RU"
        self.residualPayment = residualPayment
        settingsName = "Haval"
        specialConditions = [
            "57ba0183-5988-4137-86a6-3d30a4ed8dc9",
            "b907b476-5a26-4b25-b9c0-8091e9d5c65f",
            "cbfc4ef3-af70-4182-8cf6-e73f361d1e68"
        ]
        self.term = term
    }
    
    func getParametrs() -> [String : Any] {
        let parameters = [
            "clientTypes": self.clientTypes,
            "cost": self.cost,
            "initialFee": self.initialFee,
            "kaskoValue": self.kaskoValue,
            "language": self.language,
            "residualPayment": self.residualPayment,
            "settingsName": self.settingsName,
            "specialConditions": self.specialConditions,
            "term": self.term
        ] as [String : Any]
        
        return parameters
    }
}

