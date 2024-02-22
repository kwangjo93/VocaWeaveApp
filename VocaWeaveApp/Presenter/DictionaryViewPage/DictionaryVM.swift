//
//  DictionaryVM.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit
import Combine
import AVFoundation
import Lottie

final class DictionaryVM {
    // MARK: - Property
    private let vocaTranslatedVM: VocaTranslatedVM
    private let networking = NetworkingManager.shared
    private let speechSynthesizer = AVSpeechSynthesizer()
    let errorAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let copyAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let duplicationAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    var isSelect = false
    var vocaTranslatedData: RealmTranslateModel?
    var apiVocaList: [RealmTranslateModel] {
        return vocaTranslatedVM.vocaList
    }
    // MARK: - init
    init(vocaTranslatedVM: VocaTranslatedVM, vocaTranslatedData: RealmTranslateModel?) {
        self.vocaTranslatedVM = vocaTranslatedVM
        self.vocaTranslatedData = vocaTranslatedData
    }
    // MARK: - Method
    func bindTextData(_ data: RealmTranslateModel, _ view: DictionaryView) {
        view.sourceTextField.text = data.sourceText
        view.translationText.text = data.translatedText
    }

    func resetText( _ view: DictionaryView) {
        view.sourceTextField.text = ""
        view.translationText.text = ""
    }

    func setBookmarkStatus(isSelec: Bool, view: DictionaryView, text: String) {
        self.isSelect = isSelec
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        if isSelec {
            view.bookmarkButton.setImage(UIImage(systemName: "star.fill",
                                    withConfiguration: imageConfig),
                                    for: .normal)
            playAnimation(view: view, isSelect: isSelec, text: text)
        } else {
            view.bookmarkButton.setImage(UIImage(systemName: "star",
                                    withConfiguration: imageConfig),
                                    for: .normal)
        }
    }

    @MainActor
    func updateTranslationView(with vocaData: RealmTranslateModel?,
                               view: DictionaryView) {
        guard let vocaData = vocaData else { return }
        view.translationText.text = vocaData.translatedText
        self.isSelect = vocaData.isSelected
        self.setBookmarkStatus(isSelec: isSelect, view: view, text: vocaData.sourceText)
    }

    func fetchDataAndHandleResult(sourceText: String) async throws -> RealmTranslateModel? {
        if Language.detectLanguage(text: sourceText) {
            do {
                let responseData = try await networking.fetchData(source: Language.sourceLanguage.languageCode,
                                                                  target: Language.targetLanguage.languageCode,
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
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                speechSynthesizer.speak(speechUtterance)
            } catch {
                print("Error setting up AVAudioSession: \(error)")
            }
        }
    }

    @MainActor
    func bookmarkButtonAction(text: String, view: DictionaryView, sourceText: String) {
        guard let vocaData = vocaTranslatedData else { return }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        if checkForExistingData(with: text) == nil {
            saveDictionaryData(vocaData)
            vocaTranslatedVM.updateVoca(list: vocaData,
                                        text: vocaData.translatedText,
                                        isSelected: true)
        } else {
            changeBookmark(vocaData: vocaData)
        }
        setBookmarkStatus(isSelec: self.isSelect, view: view, text: sourceText)
    }

    func saveDictionaryData(_ voca: RealmTranslateModel) {
        if !vocaTranslatedVM.isVocaAlreadyExists(voca) {
            vocaTranslatedVM.addVoca(voca)
        } else {
            let alert = UIAlertController(title: "중복",
                                          message: "같은 단어가 이미 있습니다",
                                          preferredStyle: .alert)
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                   alert.dismiss(animated: true, completion: nil)
               }
            duplicationAlertPublisher.send(alert)
        }
    }

    func nightButtonAction(button: UIBarButtonItem, _ textView: UITextView) {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    if window.overrideUserInterfaceStyle == .dark {
                        window.overrideUserInterfaceStyle = .light
                        button.image = UIImage(systemName: "moon")
                        button.tintColor = .black
                        textView.layer.borderColor = UIColor.label.cgColor
                    } else {
                        window.overrideUserInterfaceStyle = .dark
                        button.image = UIImage(systemName: "moon.fill")
                        button.tintColor = .subTinkColor
                        textView.layer.borderColor = UIColor.white.cgColor
                    }
                }
            }
        }
    }
}

private extension DictionaryVM {
    func errorResponseAlert() {
        let alert = UIAlertController(title: "오류!!",
                                      message: "영어 또는 한글의 언어를 입력해 주세요!",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(cancel)
        errorAlertPublisher.send(alert)
    }

   func copyAlertAction() {
        let alert = UIAlertController(title: nil, message: "텍스트가 클립보드에 복사되었습니다.", preferredStyle: .alert)
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               alert.dismiss(animated: true, completion: nil)
           }
        copyAlertPublisher.send(alert)
    }

    func changeBookmark(vocaData: RealmTranslateModel) {
        if self.isSelect {
            vocaTranslatedVM.updateVoca(list: vocaData,
                                        text: vocaData.translatedText,
                                        isSelected: true)
        } else {
            vocaTranslatedVM.updateVoca(list: vocaData,
                                        text: vocaData.translatedText,
                                        isSelected: false)
        }
    }

    @MainActor
    func checkForExistingData(with text: String) -> RealmTranslateModel? {
        let translatedData = vocaTranslatedVM.vocaList
        if let duplicatedData = translatedData.first(where: { $0.sourceText == text }) {
            return duplicatedData
        }
        return nil
    }

    @MainActor
    func checkDuplicationData(vocaData: RealmTranslateModel, text: String) -> RealmTranslateModel {
        if vocaData.sourceText == text {
            if let duplicatedData = checkForExistingData(with: text) {
                return duplicatedData
            }
        }
        return vocaData
    }
}
// MARK: - Animation
private extension DictionaryVM {
    func playAnimation(view: DictionaryView, isSelect: Bool, text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        setupAnimationView(button: view.bookmarkButton,
                           animationView: view.animationView)
        view.animationView.isHidden = false
        view.animationView.play { _ in
            view.animationView.isHidden = true
        }
    }

    func setupAnimationView(button: UIButton, animationView view: LottieAnimationView) {
        button.addSubview(view)
        let animation = LottieAnimation.named("starfill")
        view.animation = animation
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.isHidden = true
        view.frame = CGRect(x: -37, y: -37, width: 100, height: 100)
    }
}
