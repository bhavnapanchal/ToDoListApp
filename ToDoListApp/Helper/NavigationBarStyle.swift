//
//  NavigationBarStyle.swift
//  ToDoListApp
//
//  Created by Ami Panchal on 21/04/26.
//

import UIKit

struct NavigationBarStyle {
    
    static func defaultStyle() -> (appearance: UINavigationBarAppearance, tintColor: UIColor, large: Bool) {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "PrimaryColor")
        
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25) ?? UIFont.systemFont(ofSize: 25), .foregroundColor: UIColor.white]
        
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34), .foregroundColor: UIColor(named: "ListColor") ?? .white]
        
        return (appearance, .black, true)
    }
    
    static func popUpStyle() -> (appearance : UINavigationBarAppearance, tintColor: UIColor, large: Bool){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "ListColor")
        
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25) ?? UIFont.systemFont(ofSize: 25), .foregroundColor: UIColor(named: "PrimaryColor") ?? .black]
        
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica​Neue​-​Medium", size: 34) ?? UIFont.systemFont(ofSize: 34), .foregroundColor: UIColor(named: "PrimaryColor") ?? .black]
        
        return (appearance, .black, false)
    }
}


