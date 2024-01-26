//
//  UIColor.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit

extension UIColor {
    static var subTinkColor = UIColor(red: 0.91, green: 0.77, blue: 0.42, alpha: 1.00)
    static var mainTintColor = UIColor(red: 0.96, green: 0.64, blue: 0.38, alpha: 1.00)
    static var errorColor = UIColor(red: 0.76, green: 0.07, blue: 0.12, alpha: 1.00)
    static var gradientColor: [CGColor] = [
        UIColor(red: 1.00, green: 0.23, blue: 0.23, alpha: 1.00).cgColor,
        UIColor(red: 1.00, green: 0.45, blue: 0.27, alpha: 1.00).cgColor,
        UIColor(red: 1.00, green: 0.72, blue: 0.52, alpha: 1.00).cgColor,
        UIColor(red: 1.00, green: 0.88, blue: 0.58, alpha: 1.00).cgColor
    ]
}
