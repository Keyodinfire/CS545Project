//
//  AddViewController.swift
//  WorkMoreApp
//
//  Created by user201634 on 7/23/21.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePickerStart: UIDatePicker!
    @IBOutlet var datePickerEnd: UIDatePicker!
    @IBOutlet var breakPicker: UIDatePicker!
    @IBOutlet var breakEndPicker: UIDatePicker!
    
    public var completion: ((String, String, Date, Date, Date, Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        bodyField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveReminder))

    }
    
    @objc func saveReminder() {
        if let titleText = titleField.text, !titleText.isEmpty,
           let bodyText = bodyField.text, !bodyText.isEmpty {
            
            let reminderDateStart = datePickerStart.date
            let reminderDateEnd = datePickerEnd.date
            let reminderBreak = breakPicker.date
            let reminderBreakEnd = breakEndPicker.date
            
            completion?(titleText, bodyText, reminderDateStart, reminderDateEnd, reminderBreak, reminderBreakEnd)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
