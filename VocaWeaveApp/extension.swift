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
        let koreanRegex = "^[ㄱ-ㅎㅏ-ㅣ가-힣₩~,.?!\\-_/\\s]*$"
        return range(of: koreanRegex, options: .regularExpression) != nil
    }

    func containsOnlyEnglish() -> Bool {
        let englishRegex = "^[a-zA-Z₩~,.?!\\-_/\\s]*$"
        return range(of: englishRegex, options: .regularExpression) != nil
    }

    func getFirstLetter() -> String {
        let hangulMap: [UInt32: String] = [
            0x1100: "ㄱ", 0x1101: "ㄲ", 0x1102: "ㄴ", 0x1103: "ㄷ", 0x1104: "ㄸ",
            0x1105: "ㄹ", 0x1106: "ㅁ", 0x1107: "ㅂ", 0x1108: "ㅃ", 0x1109: "ㅅ",
            0x110A: "ㅆ", 0x110B: "ㅇ", 0x110C: "ㅈ", 0x110D: "ㅉ", 0x110E: "ㅊ",
            0x110F: "ㅋ", 0x1110: "ㅌ", 0x1111: "ㅍ", 0x1112: "ㅎ"
        ]

        var result = ""
        let unicodeScalar = self.unicodeScalars

        // 한글일 경우
        if let firstScalar = unicodeScalar.first, 0xAC00 <= firstScalar.value && firstScalar.value <= 0xD7A3 {
            let index = Int((firstScalar.value - 0xAC00) / 28 / 21)
            if let unicode = hangulMap[UInt32(0x1100 + index)] {
                result = unicode
            }
        }
        // 영어일 경우
        else if let firstLetter = self.first, firstLetter.isLetter {
            result = String(firstLetter).uppercased()
        }

        return result
    }

    func strikethrough() -> NSAttributedString {
           let attributeString = NSMutableAttributedString(string: self)
           attributeString.addAttribute(.strikethroughStyle,
                                        value: 2,
                                        range: NSRange(location: 0, length: attributeString.length))
           return attributeString
       }
}
