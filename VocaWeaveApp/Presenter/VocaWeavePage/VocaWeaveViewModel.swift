//
//  VocaWeaveViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit

class VocaWeaveViewModel {
    // MARK: - Property
    private let vocaListManager: VocaListManager
    private let realmQuery = "myVoca"
    var isSelect = false
    // MARK: - init
    init(vocaListManager: VocaListManager) {
        self.vocaListManager = vocaListManager
    }

    // MARK: - Helper
    func strikeButtonAction(sender: UIButton) {
        let attributedString: NSAttributedString?
        if isSelect {
            attributedString = sender.titleLabel?.text?.strikethrough()
            sender.setAttributedTitle(attributedString, for: .normal)
        } else {
            attributedString = NSAttributedString(string: sender.titleLabel?.text ?? "")
            sender.setAttributedTitle(attributedString, for: .normal)
        }
    }

    func putButtonText(with textFieldText: String, to buttonText: String) -> String {
        if isSelect {
            return textFieldText + " \(buttonText) "
        } else {
            var originalText = textFieldText
            if textFieldText.contains(buttonText) {
                originalText = originalText.replacingOccurrences(of: buttonText, with: "")
            }
            return originalText
        }
    }
    // MARK: - Action
    func getVocaList() -> [RealmVocaModel] {
        return vocaListManager.getVocaList(query: realmQuery)
    }
}
