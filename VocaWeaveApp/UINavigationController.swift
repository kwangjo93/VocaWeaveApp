//
//  UINavigationController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 1/12/24.
//

import UIKit

extension UINavigationController {
    func configureBasicAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = nil

        self.navigationBar.tintColor = UIColor.label
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
}
