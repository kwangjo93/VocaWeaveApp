//
//  VocaWeaveViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit
import Combine

class VocaWeaveViewModel {
    // MARK: - Property
    private let vocaListManager: VocaListManager
    private let networking = NetworkingManager.shared
    let errorAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let statusTextPublisher = PassthroughSubject<Int, Never>()
    private let realmQuery = "myVoca"
    var isSelect = false
    var sourceLanguage: Language = .korean
    var targetLanguage: Language = .english
    lazy var vocaDataCount = getVocaList().count
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

    private func resetStrikeButtons(sender: [UIButton]) {
        for button in sender {
            if let title = button.titleLabel?.text {
                let attributedString = NSAttributedString(string: title)
                button.setAttributedTitle(attributedString, for: .normal)
            }
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

    private func errorResponseAlert() {
        let alert = UIAlertController(title: "오류!!",
                                      message: "영어 또는 한글의 언어를 입력해 주세요!",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(cancel)
        errorAlertPublisher.send(alert)
    }

    private func detectLanguage(text: String) -> Bool {
        if text.containsOnlyKorean() {
            sourceLanguage = .korean
            targetLanguage = .english
            return true
        } else if text.containsOnlyEnglish() {
            sourceLanguage = .english
            targetLanguage = .korean
           return true
        }
        return false
    }

    private func configureVocaButton(buttons: [UIButton]) {
        let vocaList = getVocaList().shuffled().prefix(5)
        for (index, button) in buttons.enumerated() {
            if index < vocaList.count {
                button.setTitle(vocaList[index].sourceText, for: .normal)
            } else {
                button.setTitle("", for: .normal)
            }
        }
    }
    // MARK: - Action
    func getVocaList() -> [RealmVocaModel] {
        return vocaListManager.getVocaList(query: realmQuery)
    }

    func refreshVocaData(buttons: [UIButton]) {
        if self.vocaDataCount > 5 {
            vocaDataCount -= 5
            configureVocaButton(buttons: buttons)
        } else {
            vocaDataCount = getVocaList().count
        }
        resetStrikeButtons(sender: buttons)
        buttons.forEach { $0.isSelected = false }
        statusTextPublisher.send(vocaDataCount)
    }

    func fetchDataAndHandleResult(sourceText: String) async throws -> String? {
        if detectLanguage(text: sourceText) {
            do {
                let result = try await networking.fetchData(source: sourceLanguage.languageCode,
                                                            target: targetLanguage.languageCode,
                                                            text: sourceText)
                return result.translatedText
            } catch {
                print("에러 발생: \(error)")
                throw error
            }
        } else {
            errorResponseAlert()
            return nil
        }
    }
}
