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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = ""
        
        textView.delegate = self
        
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.backgroundColor = view.backgroundColor
        
        textView.layer.cornerRadius = 10
        
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
