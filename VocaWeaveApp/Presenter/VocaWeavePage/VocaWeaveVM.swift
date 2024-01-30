//
//  VocaWeaveVM.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit
import Combine
import Lottie
import AVFoundation

final class VocaWeaveVM {
    // MARK: - Property
    private let vocaListManager: VocaListManager
    private let networking = NetworkingManager.shared

    let errorAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let setupStatusTextPublisher = PassthroughSubject<String, Never>()
    let setupStatusCountPublisher = PassthroughSubject<Int, Never>()
    let selectedCountCountPublisher = PassthroughSubject<Int, Never>()
    let copyAlertPublisher = PassthroughSubject<UIAlertController, Never>()

    private let speechSynthesizer = AVSpeechSynthesizer()
    private let realmQuery = "myVoca"
    var isSelect = false
    var selectedCount = 0
    var vocaList: [RealmVocaModel] {
        return vocaListManager.getVocaList(query: realmQuery)
    }
    lazy var vocaDataArray = vocaList.filter { isEnglishAlphabet($0.sourceText) }
    var resetData = false {
        didSet {
            vocaDataArray = vocaListManager.getVocaList(query: realmQuery)
                                                .filter { isEnglishAlphabet($0.sourceText) }
            isSelect = false
        }
    }
    // MARK: - init
    init(vocaListManager: VocaListManager) {
        self.vocaListManager = vocaListManager
    }
    // MARK: - Helper
    private func isEnglishAlphabet(_ str: String) -> Bool {
        let englishAlphabet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return str.rangeOfCharacter(from: englishAlphabet.inverted) == nil
    }

    func strikeButtonTapped(sender: UIButton) {
        let attributedString: NSAttributedString?
        if isSelect {
            attributedString = sender.titleLabel?.text?.strikethrough()
            sender.setAttributedTitle(attributedString, for: .normal)
            selectedCount -= 1
            selectedCountCountPublisher.send(selectedCount)
        } else {
            attributedString = NSAttributedString(string: sender.titleLabel?.text ?? "")
            sender.setAttributedTitle(attributedString, for: .normal)
            selectedCount += 1
            selectedCountCountPublisher.send(selectedCount)
        }
    }

     func resetStrikeButtons(sender: [UIButton]) {
        for button in sender {
            button.setAttributedTitle(nil, for: .normal)
            button.titleLabel?.attributedText = nil
        }
    }

    func putButtonText(with textFieldText: String,
                       to buttonText: String) -> String {
        let space = " "
        if isSelect {
            if !buttonText.isEmpty {
                return textFieldText + space + buttonText + space
            } else {
                return buttonText
            }
        } else {
            var originalText = textFieldText
            if textFieldText.contains(space + buttonText + space) {
                originalText = originalText.replacingOccurrences(of: space + buttonText + space, with: "")
            }
            return originalText
        }
    }

    private func findWordRange(in text: String, word: String) -> NSRange? {
        if let range = text.range(of: word) {
            let nsRange = NSRange(range, in: text)
            return nsRange
        }
        return nil
    }

    func applyAnimation(textField: UITextField, text: String, view: LottieAnimationView) {
        if let wordRange = findWordRange(in: textField.text!, word: text) {
            let textRect = textField.caretRect(for: textField.selectedTextRange!.start)
            let textFieldOrigin = textField.convert(textRect.origin, to: textField.superview)
            let yOffset = textFieldOrigin.y + textRect.height
            view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            view.center = CGPoint(x: CGFloat(wordRange.location) * 10, y: yOffset)
            view.play()
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

    func setRandomVocaData(buttons: [UIButton]) {
        if vocaDataArray.count > 4 {
            let selectedVoca = vocaDataArray.shuffled().prefix(5)
            selectedCount = 5
            selectedCountCountPublisher.send(5)
            for (index, button) in buttons.enumerated() {
                button.setTitle(selectedVoca[index].sourceText, for: .normal)
                vocaDataArray.removeAll { $0.sourceText == selectedVoca[index].sourceText}
            }
            setupStatusCountPublisher.send(vocaDataArray.count)
        } else {
            for index in 0..<5 {
                if index < vocaDataArray.count {
                    buttons[index].setTitle(vocaDataArray[index].sourceText, for: .normal)
                } else {
                    buttons[index].setTitle("", for: .normal)
                }
            }
            selectedCount = vocaDataArray.count
            selectedCountCountPublisher.send(vocaDataArray.count)
            setupStatusTextPublisher.send("단어의 개수가 5개 미만입니다.")
            vocaDataArray = vocaList.filter { isEnglishAlphabet($0.sourceText) }
        }
    }

    private func copyAlertAction() {
        let alert = UIAlertController(title: nil,
                                      message: "텍스트가 클립보드에 복사되었습니다.",
                                      preferredStyle: .alert)
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               alert.dismiss(animated: true, completion: nil)
           }
        copyAlertPublisher.send(alert)
    }
    // MARK: - Action
    func copyText(text: String?) {
        guard let textToCopy = text,
              !textToCopy.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let pasteboard = UIPasteboard.general
        pasteboard.string = textToCopy
        copyAlertAction()
    }

    func speakerAction(text: String?, language: String) {
        if let textData = text, textData.containsOnlyEnglish() {
            Language.sourceLanguage = .english
            let speechUtterance = AVSpeechUtterance(string: textData)
            speechUtterance.voice = AVSpeechSynthesisVoice(
                                                language: Language.sourceLanguage.avLanguageTitle)
            speechUtterance.rate = 0.5
            speechUtterance.volume = 1
            speechSynthesizer.speak(speechUtterance)
        }
    }

    func refreshVocaData(buttons: [UIButton]) {
        buttons.forEach { $0.isSelected = false }
        resetStrikeButtons(sender: buttons)
        setRandomVocaData(buttons: buttons)
    }

    func fetchDataAndHandleResult(sourceText: String) async throws -> String? {
        if Language.detectLanguage(text: sourceText) {
            do {
                let result = try await networking.fetchData(source: Language.sourceLanguage.languageCode,
                                                            target: Language.targetLanguage.languageCode,
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
