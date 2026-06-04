//
//  UIStackView+Extension.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 16/05/26.
//

import UIKit

extension UIStackView{
    
    func verticalStyle(){
        backgroundColor = UIColor(named: "ListColor")
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 5
    }
}
