//
//  InputForm.swift
//  VtbMoreTech
//
//  Created by Mac-HOME on 11.10.2020.
//

import Foundation
import XLForm

// TODO: Parse data from calculator and send it here
class InputsFormViewController : XLFormViewController {
    
    var result: ResultCalculate!
    var car: CarModel!
    
    fileprivate struct Tags {
        static let FirstName = "first_name"
        static let FamilyName = "family_name"
        static let MiddleName = "middle_name"
        static let Email = "email"
        static let Phone = "phone"
        static let BirthDate = "birth_date_time"
        static let BirthPlace = "birth_place"
        static let Gender = "gender"
        static let Country = "nationality_country_code"
        static let Comment = "comment"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initializeForm()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeForm()
    }
    
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        form = XLFormDescriptor(title: "Заявка на кредит")
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSection(withTitle: "Введите ваши данные")
        section.footerTitle = "Данные будут переданы напрямую в банк VTB"
        form.addFormSection(section)
        
        // Person
        row = XLFormRowDescriptor(tag: Tags.FamilyName, rowType: XLFormRowDescriptorTypeText, title: "Фамилия")
        row.isRequired = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.FirstName, rowType: XLFormRowDescriptorTypeText, title: "Имя")
        row.isRequired = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.MiddleName, rowType: XLFormRowDescriptorTypeText, title: "Отчество")
        row.isRequired = false
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.BirthDate, rowType: XLFormRowDescriptorTypeDateInline, title:"Дата рождения")
        row.value = Date()
        row.cellConfigAtConfigure["locale"] =  Locale(identifier: "FR_fr")
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.BirthPlace, rowType: XLFormRowDescriptorTypeText, title: "Место рождения")
        row.isRequired = true
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Gender, rowType: XLFormRowDescriptorTypeSelectorSegmentedControl, title: "Пол")
        row.selectorOptions = ["Муж", "Жен"]
        row.value = "Муж"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Country, rowType: XLFormRowDescriptorTypeText, title: "Код страны")
        row.isRequired = true
        row.value = "RU"
        section.addFormRow(row)
        
        // Email
        row = XLFormRowDescriptor(tag: Tags.Email, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        row.isRequired = true
        row.addValidator(XLFormValidator.email())
        section.addFormRow(row)
        
        // Phone
        row = XLFormRowDescriptor(tag: Tags.Phone, rowType: XLFormRowDescriptorTypePhone, title: "Телефон")
        row.isRequired = true
        row.value = "+7"
        section.addFormRow(row)
        
        // Comment
        row = XLFormRowDescriptor(tag: Tags.Comment, rowType: XLFormRowDescriptorTypeTextView, title: "Комментарий")
        section.addFormRow(row)
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        self.form = form
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(InputsFormViewController.savePressed(_:)))
        
        setupInfo()
    }
    
    func setupInfo() {
        print("")
    }
    
    @objc func savePressed(_ button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first)
            return
        }
        self.tableView.endEditing(true)
        
        if let formData = form.formValues() as? [String: Any] {
            if var customer = parameters["customer_party"] as? [String: Any] {
                
                // Person
                if let familyName = formData["family_name"] as? String {
                    person["family_name"] = familyName
                }
                if let firstName = formData["first_name"] as? String {
                    person["first_name"] = firstName
                }
                if let middleName = formData["middle_name"] as? String {
                    person["middle_name"] = middleName
                }
                if let сountry = formData["nationality_country_code"] as? String {
                    person["nationality_country_code"] = сountry
                }
                if let gender = formData["gender"] as? String {
                    if gender == "Mуж" {
                        person["gender"] = "male"
                    } else {
                        person["gender"] = "female"
                    }
                }
                if let date = formData["birth_date_time"] as? String {
                    person["birth_date_time"] = date
                }
                
                // Customer
                customer["person"] = person
                if let email = formData["email"] as? String {
                    customer["email"] = email
                }
                if let phone = formData["phone"] as? String {
                    customer["phone"] = phone
                }
                
                // Parameters
                if let comment = formData["comment"] as? String {
                    parameters["comment"] = comment
                }
                parameters["customer_party"] = customer
            }
        }
        
        sendRequset()
    }
    
    // TODO: Remove hard code data when calculator will be done
    var person: [String: String] = [
        "birth_date_time": "1981-11-01",
        "birth_place": "г. Воронеж",
        "family_name": "Иванов",
        "first_name": "Иван",
        "gender": "unknown",
        "middle_name": "Иванович",
        "nationality_country_code": "RU"
    ]
    var parameters = [
        "comment": "Комментарий",
        "customer_party": [
            "email": "apetrovich@example.com",
            "income_amount": 140000,
            "person": [],
            "phone": "+99999999999"
        ],
        "datetime": "2020-10-10T08:15:47Z",
        "interest_rate": 15.7,
        "requested_amount": 300000,
        "requested_term": 36,
        "trade_mark": "Nissan",
        "vehicle_cost": 600000
    ] as [String : Any]
    
    func sendRequset() {
        let headers = [
            "x-ibm-client-id": "5d2d01335a94cffe195b8906b50fee6b",
            "content-type": "application/json",
            "accept": "application/json"
        ]
        
        self.parameters["requested_amount"] = result.loanAmount
        self.parameters["requested_term"] = result.term * 12
        self.parameters["trade_mark"] = car.brand
        self.parameters["vehicle_cost"] = car.price
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else { return }
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://gw.hackathon.vtb.ru/vtb/hackathon/carloan")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
            
            guard let self = self else { return }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Form: No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let responseJSON = responseJSON {
                print(responseJSON)
                let resp = responseJSON["application"]
                if let resp = resp as? [String: Any] {
                    if let report = resp["decision_report"] {
                        if let report = report as? [String: Any] {
                            print(report)
                            guard let date_end = report["decision_end_date"] else { return }
                            guard let montly_payment = report["monthly_payment"] else { return }
                            DispatchQueue.main.async {
                                self.showAlert(date_end: date_end as! String, montly_payment: Int(montly_payment as! Double))
                            }
                        }
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    
    func showAlert(date_end: String, montly_payment: Int) {
        let alert = UIAlertController(title: "Заявка принята", message: "Решение кредита с ежемесячным платежом \(montly_payment) РУБ. будет рассмотрено до \(date_end) числа.\nОжидайте, когда с вами свяжутся", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
