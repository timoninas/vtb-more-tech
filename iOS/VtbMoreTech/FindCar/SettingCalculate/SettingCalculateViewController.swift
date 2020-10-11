//
//  SettingCalculateViewController.swift
//  VtbMoreTech
//
//  Created by Антон Тимонин on 11.10.2020.
//

import UIKit

class SettingCalculateViewController: UIViewController {
    
    var car: CarModel!
    
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var initialFeeLabel: UILabel!
    @IBOutlet weak var initialFeeSlider: UISlider!
    
    @IBOutlet weak var kaskoValueLabel: UILabel!
    @IBOutlet weak var kaskoValueSlider: UISlider!
    
    @IBOutlet weak var residualPaymentLabel: UILabel!
    @IBOutlet weak var residualPaymentSlider: UISlider!
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var termSlider: UISlider!
    
    @IBOutlet weak var countCreditButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupSliders()
        setupLabels()
    }
    
    func setupButtons() {
        countCreditButton.vtbStyleButton()
    }

    func setupLabels() {
        if let car = self.car, let price = car.price {
            costLabel.text = "Цена автомобиля: \(String(describing: price)) РУБ."
        }
        initialFeeLabel.text = "Первоначальный взнос: \(initialFeeSlider.value) РУБ."
        kaskoValueLabel.text = "Сумма каско: \(kaskoValueSlider.value) РУБ."
        residualPaymentLabel.text = "Остаточный платеж: \(residualPaymentSlider.value) РУБ."
        termLabel.text = "Срок кредита: \(Int(termSlider.value)) лет"
    }
    
    func setupSliders() {
        initialFeeSlider.value = Float(500000.0)
        kaskoValueSlider.value = Float(20000.0)
        residualPaymentSlider.value = Float(90.0)
        termSlider.value = Float(3)
    }
    
    @IBAction func initialFeeSlidierind(_ sender: UISlider) {
        initialFeeLabel.text = "Первоначальный взнос: \(sender.value) РУБ."
    }
    
    
    @IBAction func kaskoValueSliderind(_ sender: UISlider) {
        kaskoValueLabel.text = "Сумма каско: \(sender.value) РУБ."
    }
    
    @IBAction func residualPaymentSliderind(_ sender: UISlider) {
        residualPaymentLabel.text = "Остаточный платеж: \(sender.value) РУБ."
    }
    
    @IBAction func termSlideind(_ sender: UISlider) {
        termLabel.text = "Срок кредита: \(Int(sender.value)) лет"
    }
    
    @IBAction func countCreditButtonTapped(_ sender: UIButton) {
        guard let cost = Int(car.price) else { return }
        let initialFee = Int(initialFeeSlider.value)
        let kaskoValue = Int(kaskoValueSlider.value)
        let residualPayment = Double(residualPaymentSlider.value)
        let term = Int(termSlider.value)
        
        let result = CalculateParametrs(cost: cost, initialFee: initialFee, kaskoValue: kaskoValue, residualPayment: residualPayment, term: term)
        
        guard let priceStr = car.price else { return }
        guard let price = Int(priceStr) else { return }
        CalculateService.shared.calculate(calculate: result) { [weak self] (result) in
            guard let self = self else { return }
            guard let result = result else { return }
            guard let car = self.car else { return }
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(ModuleBuilder.createCalculateModule(result: result, car: car), animated: true)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
