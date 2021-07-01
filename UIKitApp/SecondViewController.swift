//
//  SecondViewController.swift
//  UIKitApp
//
//  Created by Valerii D on 01.07.2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textView.text = ""
        
        textView.delegate = self
        
        textView.isHidden = true
        textView.alpha = 0
        
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.backgroundColor = view.backgroundColor
        
        textView.layer.cornerRadius = 10
        
        stepper.value = 17
        stepper.minimumValue = 10
        stepper.maximumValue = 25
        
        stepper.tintColor = .red
        stepper.backgroundColor = .yellow
        stepper.layer.cornerRadius = 5
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        activityIndicator.startAnimating()
        
        
        // отслеживает появление клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updatwTextView(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        // отслеживает скрытия клавиатуры
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updatwTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        UIView.animate(withDuration: 0, delay: 3, options: .curveEaseIn) {
            self.textView.alpha = 1
        } completion: { (finished) in
            self.activityIndicator.stopAnimating()
            self.textView.isHidden = false
        }

    }
    
    // скрытия клавиатуры потопу за пределами textView
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true) // - скрывает клавиатуру вызванную для любого объекта
        
        //textView.resignFirstResponder() // - скрывают клавиатуру вызванную для конкретного объекта
    }
    
    @objc func updatwTextView(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardFrame.height - bottomConstraint.constant,
                                                 right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    
    @IBAction func sizeFont(_ sender: UIStepper) {
        let font = textView.font?.fontName
        let fontSize = CGFloat(sender.value)
        
        textView.font = UIFont(name: font!, size: fontSize)
    }
    

}

extension SecondViewController: UITextViewDelegate {        // срабатывает при тапе на TextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .white
        textView.textColor = . gray
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {    // срабатывает по окончании работы с TextView
        textView.backgroundColor = view.backgroundColor
        textView.textColor = .black
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        countLabel.text = "\(textView.text.count)"
        return textView.text.count + (text.count - range.length) <= 60
    }
}
