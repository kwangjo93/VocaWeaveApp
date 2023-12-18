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
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.shadowColor = nil

        self.navigationBar.tintColor = UIColor.label
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

extension String {
    func containsOnlyKorean() -> Bool {
        let koreanRegex = "^[ㄱ-ㅎㅏ-ㅣ가-힣]*$"
        return range(of: koreanRegex, options: .regularExpression) != nil
    }

    func containsOnlyEnglish() -> Bool {
        let englishRegex = "^[a-zA-Z]*$"
        return range(of: englishRegex, options: .regularExpression) != nil
    }

}
