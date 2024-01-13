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
}
