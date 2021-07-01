//
//  ViewController.swift
//  UIKitApp
//
//  Created by Valerii D on 15.04.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var segmenttedControl: UISegmentedControl!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var slider: UISlider!
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var hideAllElements: UISwitch!
    @IBOutlet var switchLabel: UILabel!
    
    var uiElements = ["UISegmentedControl",
                      "UILabel",
                      "UISlider",
                      "UITextField",
                      "UIButton",
                      "UIDatePicker"]
    
    var selectedElement: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup main label
        mainLabel.font = mainLabel.font.withSize(35)
        mainLabel.textAlignment = .center
        mainLabel.numberOfLines = 2
        
        // Setup segment control
        segmenttedControl.insertSegment(withTitle: "Third", at: 2, animated: false)
        
        // Setup slider
        slider.value = 1
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.minimumTrackTintColor = .yellow
        slider.maximumTrackTintColor = .red
        slider.thumbTintColor = .blue
        
        mainLabel.text = String(slider.value)
        
        //Setup Date Picker
        datePicker.locale = Locale(identifier: "ru_RU")
        
        //Setup switch
        hideAllElements.onTintColor = .red
        switchLabel.text = "Скрыть все элементы"
        
        choiseUIElement()
        createToolbar()
    }
    
    func hideAllElementsFunc() {
        segmenttedControl.isHidden = true
        mainLabel.isHidden = true
        slider.isHidden = true
        doneButton.isHidden = true
        datePicker.isHidden = true
    }
    
    func choiseUIElement() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        
        textField.inputView = elementPicker
        
        //Castomization
        elementPicker.backgroundColor = .yellow
    }
    
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolbar
        
        //Castomization
        toolbar.tintColor = .blue
        toolbar.barTintColor = .yellow
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func changeSegment() {
        switch segmenttedControl.selectedSegmentIndex {
        case 0:
            mainLabel.text = "The first segment is selected"
            mainLabel.textColor = .red
        case 1:
            mainLabel.text = "The second segment is selected"
            mainLabel.textColor = .blue
        case 2:
            mainLabel.text = "The third segment is selected"
            mainLabel.textColor = .yellow
        default:
            break
        }
    }
    
    @IBAction func sliderAction() {
        let backgroundcolor = view.backgroundColor
        view.backgroundColor = backgroundcolor?.withAlphaComponent(CGFloat(slider.value))
        mainLabel.text = String(slider.value)
    }
    
    @IBAction func doneButtonPressed() {
        guard let inputText = textField.text, !inputText.isEmpty else { return }
        
        if let _ = Double(inputText) {
            showAlert(title: "Wrong format", message: "Please enter your name")
            print("Wrong format")
        } else {
            mainLabel.text = inputText
            textField.text = nil
        }
    }
    @IBAction func changeDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "ru_RU")
         
        let dateValue = dateFormatter.string(from: datePicker.date)
        mainLabel.text = dateValue
    }
    
    @IBAction func switchAction() {
        segmenttedControl.isHidden.toggle()
        mainLabel.isHidden.toggle()
        slider.isHidden.toggle()
        textField.isHidden.toggle()
        doneButton.isHidden.toggle()
        datePicker.isHidden.toggle()
        
        switchLabel.text = hideAllElements.isOn ? "Скрыть все элементы" : "Отобразить все элементы"
    }
}

extension ViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.textField.text = ""
        }
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return uiElements.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return uiElements[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedElement = uiElements[row]
        textField.text = selectedElement
        
        switch row {
        case 0:
            hideAllElementsFunc()
            segmenttedControl.isHidden = false
        case 1:
            hideAllElementsFunc()
            mainLabel.isHidden = false
        case 2:
            hideAllElementsFunc()
            slider.isHidden = false
        case 3:
            hideAllElementsFunc()
        case 4:
            hideAllElementsFunc()
            doneButton.isHidden = false
        case 5:
            hideAllElementsFunc()
            datePicker.isHidden = false
        default:
            hideAllElementsFunc()
        }
    }
}
