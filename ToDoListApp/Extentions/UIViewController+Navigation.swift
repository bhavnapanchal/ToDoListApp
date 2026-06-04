//
//  UIViewController+Navigation.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 21/04/26.
//

import UIKit

extension UIViewController{

    func applyNavigationStyle(appearance: UINavigationBarAppearance,
                              tintColor: UIColor,
                              prefersLargeTitles: Bool) {
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.tintColor = tintColor
        
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
    }
}
