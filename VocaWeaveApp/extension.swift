//
//  extension.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit

extension UIColor {
    static var mainTintColor = UIColor.systemOrange
}

extension UINavigationController {
    func configureBasicAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.shadowColor = nil

        self.navigationBar.tintColor = .black
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension UIViewController {
    func nightModeBarButtonItem(target: Any?, action: Selector) -> UIBarButtonItem {
            return UIBarButtonItem(image: UIImage(systemName: "moon"),
                                   style: .plain,
                                   target: target,
                                   action: action)
        }
}
