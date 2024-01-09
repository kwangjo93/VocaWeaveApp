//
//  DictionaryViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit
import Combine
import AVFoundation

class DictionaryViewModel {
    // MARK: - Property
    private let vocaTranslatedViewModel: VocaTranslatedViewModel
    private let networking = NetworkingManager.shared
    var sourceLanguage: Language = .korean
    var targetLanguage: Language = .english
    let errorAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let copyAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    // MARK: - init
    init(vocaTranslatedViewModel: VocaTranslatedViewModel) {
        self.vocaTranslatedViewModel = vocaTranslatedViewModel
    }
    // MARK: - Helper
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

    private func copyAlertAction() {
        let alert = UIAlertController(title: nil, message: "텍스트가 클립보드에 복사되었습니다.", preferredStyle: .alert)
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               alert.dismiss(animated: true, completion: nil)
           }
        copyAlertPublisher.send(alert)
    }
    // MARK: - Action
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

    func copyText(text: String?) {
        guard let textToCopy = text else { return }
        let pasteboard = UIPasteboard.general
        pasteboard.string = textToCopy
        copyAlertAction()
    }

    func speakerAction(text: String?, language: String) {
        if let text = text {
            let speechUtterance = AVSpeechUtterance(string: text)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: language)
            let speechSynthesizer = AVSpeechSynthesizer()
            speechSynthesizer.speak(speechUtterance)
        }
    }

    func addDictionaryData(sourceText: String?, translatedText: String?) {
        guard let sourceText = sourceText else { return }
        guard let translatedText = translatedText else { return }
        let vocaData = RealmTranslateModel(sourceText: sourceText,
                                       translatedText: translatedText,
                                       isSelected: true)
        vocaTranslatedViewModel.saveDictionaryData(vocaData)
    }
}
