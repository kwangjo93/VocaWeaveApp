//
//  DictionaryViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit
import Combine
import AVFoundation
import Lottie

class DictionaryViewModel {
    // MARK: - Property
    private let vocaTranslatedViewModel: VocaTranslatedViewModel
    private let networking = NetworkingManager.shared
    var sourceLanguage: Language = .korean
    var targetLanguage: Language = .english
    let errorAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let copyAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    var isSelect = false
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

    private func setupAnimationView(button: UIButton, animationView view: LottieAnimationView) {
        button.addSubview(view)
        let animation = LottieAnimation.named("starfill")
        view.animation = animation
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.isHidden = true
        view.frame = CGRect(x: -37, y: -37, width: 100, height: 100)
    }

    func playAnimation(view: DictionaryView, isSelect: Bool, text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        if isSelect {
            setupAnimationView(button: view.bookmarkButton,
                            animationView: view.animationView)
            view.animationView.isHidden = false
            view.animationView.play { _ in
                view.animationView.isHidden = true
            }
        }
    }

    func setBookmarkStatus(bookmarkButton: UIButton) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        if self.isSelect {
            bookmarkButton.setImage(UIImage(systemName: "star.fill",
                                    withConfiguration: imageConfig),
                                    for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "star",
                                    withConfiguration: imageConfig),
                                    for: .normal)
        }
    }
    @MainActor
    private func checkForExistingData(with text: String) -> RealmTranslateModel? {
        let translatedData = vocaTranslatedViewModel.getVocaList()
        if let duplicatedData = translatedData.first(where: { $0.sourceText == text }) {
            return duplicatedData
        }
        return nil
    }

    @MainActor
    private func checkDuplicationData(vocaData: RealmTranslateModel, text: String) -> RealmTranslateModel {
        if vocaData.sourceText == text {
            if let duplicatedData = checkForExistingData(with: text) {
                return duplicatedData
            }
        }
        return vocaData
    }

    @MainActor
    func updateTranslationView(with vocaData: RealmTranslateModel?,
                               dictionaryViewModel: DictionaryViewModel?,
                               view: DictionaryView) {
        guard let vocaData = vocaData else { return }
        view.translationTextLabel.text = vocaData.translatedText
        self.isSelect = vocaData.isSelected
        self.setBookmarkStatus(bookmarkButton: view.bookmarkButton)
    }
    // MARK: - Action
    func fetchDataAndHandleResult(sourceText: String) async throws -> RealmTranslateModel? {
        if detectLanguage(text: sourceText) {
            do {
                let responseData = try await networking.fetchData(source: sourceLanguage.languageCode,
                                                            target: targetLanguage.languageCode,
                                                            text: sourceText)
                let result = RealmTranslateModel(apiModel: responseData, sourceText: sourceText)
                let vocaData = await checkDuplicationData(vocaData: result, text: sourceText)
                return vocaData
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

    private func changeBookmark(vocaData: RealmTranslateModel) {
        if self.isSelect {
            vocaTranslatedViewModel.updateVoca(list: vocaData,
                                               text: vocaData.translatedText,
                                               isSelected: true)
        } else {
            vocaTranslatedViewModel.updateVoca(list: vocaData,
                                               text: vocaData.translatedText,
                                               isSelected: false)
        }
    }

    @MainActor
    func bookmarkButtonAction(vocaData: RealmTranslateModel?, text: String, bookmarkButton: UIButton) {
        guard let vocaData = vocaData else { return }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        if checkForExistingData(with: text) == nil {
            vocaTranslatedViewModel.saveDictionaryData(vocaData, vocaTranslatedViewModel: nil)
            vocaTranslatedViewModel.updateVoca(list: vocaData,
                                               text: vocaData.translatedText,
                                               isSelected: true)
        } else {
            changeBookmark(vocaData: vocaData)
        }
        setBookmarkStatus(bookmarkButton: bookmarkButton)
    }
}
