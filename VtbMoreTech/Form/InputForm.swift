//
//  InputForm.swift
//  VtbMoreTech
//
//  Created by Mac-HOME on 11.10.2020.
//

import Foundation
import XLForm

class InputsFormViewController : XLFormViewController {

    fileprivate struct Tags {
        static let Name = "name"
        static let Email = "email"
        static let Twitter = "twitter"
        static let Number = "number"
        static let Integer = "integer"
        static let Decimal = "decimal"
        static let Password = "password"
        static let Phone = "phone"
        static let Url = "url"
        static let ZipCode = "zipCode"
        static let TextView = "textView"
        static let Notes = "notes"
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
        
        form = XLFormDescriptor(title: "Text Fields")
        form.assignFirstResponderOnShow = true
        
        section = XLFormSectionDescriptor.formSection(withTitle: "TextField Types")
        section.footerTitle = "This is a long text that will appear on section footer"
        form.addFormSection(section)
        
        
        // Name
        row = XLFormRowDescriptor(tag: Tags.Name, rowType: XLFormRowDescriptorTypeText, title: "Name")
        row.isRequired = true
        section.addFormRow(row)
        
        // Email
        row = XLFormRowDescriptor(tag: Tags.Email, rowType: XLFormRowDescriptorTypeEmail, title: "Email")
        // validate the email
        row.addValidator(XLFormValidator.email())
        section.addFormRow(row)
        
        // Twitter
        row = XLFormRowDescriptor(tag: Tags.Name, rowType: XLFormRowDescriptorTypeTwitter, title: "Twitter")
        row.disabled = NSNumber(value: true as Bool)
        row.value = "@no_editable"
        section.addFormRow(row)
        
        // Zip Code
        row = XLFormRowDescriptor(tag: Tags.ZipCode, rowType: XLFormRowDescriptorTypeZipCode, title: "Zip Code")
        section.addFormRow(row)

        // Number
        row = XLFormRowDescriptor(tag: Tags.Number, rowType: XLFormRowDescriptorTypeNumber, title: "Number")
        section.addFormRow(row)
        
        // Integer
        row = XLFormRowDescriptor(tag: Tags.Integer, rowType: XLFormRowDescriptorTypeInteger, title: "Integer")
        section.addFormRow(row)
        
        // Decimal
        row = XLFormRowDescriptor(tag: Tags.Decimal, rowType: XLFormRowDescriptorTypeDecimal, title: "Decimal")
        section.addFormRow(row)
        
        // Password
        row = XLFormRowDescriptor(tag: Tags.Password, rowType: XLFormRowDescriptorTypePassword, title: "Password")
        section.addFormRow(row)
        
        // Phone
        row = XLFormRowDescriptor(tag: Tags.Phone, rowType: XLFormRowDescriptorTypePhone, title: "Phone")
        section.addFormRow(row)
        
        // Url
        row = XLFormRowDescriptor(tag: Tags.Url, rowType: XLFormRowDescriptorTypeURL, title: "Url")
        section.addFormRow(row)
        
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        
        // TextView
        row = XLFormRowDescriptor(tag: Tags.TextView, rowType: XLFormRowDescriptorTypeTextView)
        row.cellConfigAtConfigure["textView.placeholder"] = "TEXT VIEW EXAMPLE"
        section.addFormRow(row)
        

        section = XLFormSectionDescriptor.formSection(withTitle: "TextView With Label Example")
        form.addFormSection(section)
        
        row = XLFormRowDescriptor(tag: Tags.Number, rowType: XLFormRowDescriptorTypeTextView, title: "Notes")
        section.addFormRow(row)
        
        self.form = form
        
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(InputsFormViewController.savePressed(_:)))
    }
    
    @objc func savePressed(_ button: UIBarButtonItem)
    {
        let validationErrors : Array<NSError> = self.formValidationErrors() as! Array<NSError>
        if (validationErrors.count > 0){
            self.showFormValidationError(validationErrors.first)
            return
        }
        self.tableView.endEditing(true)
        
        let alert = UIAlertController(title: "Valid Form", message: "No errors found!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

}
