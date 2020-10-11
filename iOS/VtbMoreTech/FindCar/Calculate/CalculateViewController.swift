//
//  CalculateViewController.swift
//  VtbMoreTech
//
//  Created by Антон Тимонин on 11.10.2020.
//

import UIKit

class CalculateViewController: UIViewController {
    
    var result: ResultCalculate!
    var car: CarModel!
    
    @IBOutlet weak var contractRateLabel: UILabel!
    @IBOutlet weak var loadAmountLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var kaskoCostLabel: UILabel!
    
    @IBOutlet weak var formCreditButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupButtons()
        setupLabels()
        // Do any additional setup after loading the view.
    }
    
    func setupButtons() {
        formCreditButton.vtbStyleButton()
    }
    
    func setupLabels() {
        guard let result = self.result else { return }
        contractRateLabel.text = "Базовая процентная ставка \(result.contractRate)%"
        loadAmountLabel.text = "Сумма кредита: \(result.loanAmount) РУБ."
        paymentLabel.text = "Ежемесячный платеж: \(result.payment) РУБ."
        termLabel.text = "Срок кредита: \(result.term) лет"
        kaskoCostLabel.text = "Стоимость каско: \(result.kaskoCost) РУБ."
    }

    @IBAction func formCreditTapped(_ sender: Any) {
        let formVC = ModuleBuilder.createInputFormModule(result: result, car: car)
        navigationController?.pushViewController(formVC, animated: true)
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
