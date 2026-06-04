//
//  UITextView+Extensions.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 23/04/26.
//

import UIKit

private var textViewPlaceholderKey : UInt8 = 0

extension UITextView{
    private var placeholderLabel: UILabel? {
        get{
            return objc_getAssociatedObject(self, &textViewPlaceholderKey) as? UILabel
        }
        set{
            return objc_setAssociatedObject(self, &textViewPlaceholderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setPlaceholder(_ text: String, color: UIColor = .lightGray){
        if placeholderLabel == nil{
            let label = UILabel()
            label.numberOfLines = 0
            label.text = text
            label.textColor = color
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
            ])
            
            placeholderLabel = label
            
            NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: self)
        }
        
        placeholderLabel?.text = text
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
    
    @objc private func textDidChange(){
        updatePlaceholder()
    }
    
    func updatePlaceholder() {
        placeholderLabel?.isHidden = !self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
