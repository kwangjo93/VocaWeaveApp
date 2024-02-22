//
//  UIViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 1/12/24.
//

import UIKit

extension UIViewController {
    func nightModeBarButtonItem(target: Any?, action: Selector) -> UIBarButtonItem {
            return UIBarButtonItem(image: UIImage(systemName: "moon"),
                                   style: .plain,
                                   target: target,
                                   action: action)
        }

    func setNightButton(button: UIBarButtonItem) {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            button.image = UIImage(systemName: "moon.fill")
            button.tintColor = UIColor(red: 0.91, green: 0.77, blue: 0.42, alpha: 1.00)
        } else {
            button.tintColor = .label
            button.image = UIImage(systemName: "moon")
        }
    }
}
