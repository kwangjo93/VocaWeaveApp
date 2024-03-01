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
    private let apiVocaListManager: APIVocaListManager
    private let networking = NetworkingManager.shared
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let realmQuery = "myVoca"

    let errorAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let setupStatusTextPublisher = PassthroughSubject<String, Never>()
    let setupStatusCountPublisher = PassthroughSubject<Int, Never>()
    let selectedCountCountPublisher = PassthroughSubject<Int, Never>()
    let copyAlertPublisher = PassthroughSubject<UIAlertController, Never>()
    let changedVocaPublisher = PassthroughSubject<Int, Never>()

    var selectedVocaType: SelecVoca = .myVoca
    var isSelect = false
    var selectedCount = 0
    var selectedValue = 0
    lazy var vocaList = vocaListManager.getVocaList(query: realmQuery)
    lazy var vocaDataArray = vocaList.filter { isEnglishAlphabet($0.sourceText) }
    var resetData = 0 {
        didSet {
            changeVocaData(value: resetData)
            isSelect = false
        }
    }

    lazy var apiVocaList = apiVocaListManager.getVocaList()
    lazy var apiVocaDataArray = apiVocaList.filter { isEnglishAlphabet($0.sourceText) }
    // MARK: - init
    init(vocaListManager: VocaListManager, apiVocaListManager: APIVocaListManager) {
        self.vocaListManager = vocaListManager
        self.apiVocaListManager = apiVocaListManager
    }
    // MARK: - Helper
    func resetTextData(_ view: VocaWeaveView) {
        view.weaveVocaTextField.text = ""
        view.responseDataText.text = ""
    }

    func setStatusCount(count: Int, _ view: VocaWeaveView) {
        view.statusValueLabel.text = String(count)
        view.statusValueLabel.isHidden = false
        view.selectedCountLabel.isHidden = false
        view.lackOfDataLabel.isHidden = true
    }

    func setStatusText(text: String, _ view: VocaWeaveView) {
        view.statusValueLabel.isHidden = true
        view.selectedCountLabel.isHidden = true
        view.lackOfDataLabel.isHidden = false
        view.lackOfDataLabel.text = text
    }

    func resetCountData() {
        self.resetData = self.selectedValue
    }

    func changeDifferentTypeData(value: Int, buttons: [UIButton]) {
        changeVocaData(value: value)
        selectedValue = value
        switch value {
        case 0, 2:
            setRandomVocaData(buttons: buttons)
        case 1:
            setRandomAPIVocaData(buttons: buttons)
        default:
            break
        }
    }

    func selectVoca(buttons: [UIButton], view: VocaWeaveView) {
        switch selectedVocaType {
        case .myVoca, .dicVoca, .bookmarkVoca:
            self.isSelect = false
            buttons.forEach { $0.isSelected = false }
            resetStrikeButtons(sender: buttons)
            changedVocaPublisher.send(selectedVocaType.tagValue)
            resetTextData(view)
        }
    }
    // MARK: - Action
    func nightModeButtonAction(buttons: [UIButton], barButton: UIBarButtonItem, view: VocaWeaveView) {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    if window.overrideUserInterfaceStyle == .dark {
                        window.overrideUserInterfaceStyle = .light
                        barButton.image = UIImage(systemName: "moon")
                        barButton.tintColor = .black
                        view.responseDataText.layer.borderColor = UIColor.label.cgColor
                        buttons.forEach { view.setButtonBorder(button: $0, color: UIColor.label.cgColor) }
                    } else {
                        window.overrideUserInterfaceStyle = .dark
                        barButton.image = UIImage(systemName: "moon.fill")
                        barButton.tintColor = .subTinkColor
                        view.responseDataText.layer.borderColor = UIColor.white.cgColor
                        buttons.forEach { view.setButtonBorder(button: $0, color: UIColor.white.cgColor) }
                    }
                }
            }
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

    func refreshVocaData(buttons: [UIButton]) {
        self.isSelect = false
        buttons.forEach { $0.isSelected = false }
        resetStrikeButtons(sender: buttons)
        changeDifferentTypeData(value: selectedValue, buttons: buttons)
    }

    func fetchDataAndHandleResult(sourceText: String) async throws -> String? {
        if Language.detectLanguage(text: sourceText) {
            do {
                let result = try await networking.fetchData(source: Language.sourceLanguage.languageCode,
                                                            target: Language.targetLanguage.languageCode,
                                                            text: sourceText)
                return result
            } catch {
                print("에러 발생: \(error)")
                throw error
            }
        } else {
            errorResponseAlert()
            return nil
        }
    }

    func vocaButtonAction(isSelec: Bool,
                          textField: UITextField,
                          view: LottieAnimationView,
                          button: UIButton) {
        self.isSelect = isSelec
        applyAnimation(textField: textField,
                       text: button.titleLabel?.text ?? "",
                       view: view)
        strikeButtonTapped(sender: button)
        textField.text = putButtonText(with: textField.text ?? "",
                                       to: button.titleLabel?.text ?? "")
        applyAnimation(textField: textField,
                       text: button.titleLabel?.text ?? "",
                       view: view)
    }
}

// MARK: - Alert
private extension VocaWeaveVM {
    func copyAlertAction() {
        let alert = UIAlertController(title: nil,
                                      message: "텍스트가 클립보드에 복사되었습니다.",
                                      preferredStyle: .alert)
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
               alert.dismiss(animated: true, completion: nil)
           }
        copyAlertPublisher.send(alert)
    }

    func errorResponseAlert() {
        let alert = UIAlertController(title: "오류!!",
                                      message: "영어 또는 한글의 언어를 입력해 주세요!",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(cancel)
        errorAlertPublisher.send(alert)
    }
}
// MARK: - Set func
private extension VocaWeaveVM {
    func setMyVocaData() {
        vocaList = vocaListManager.getVocaList(query: realmQuery)
        vocaDataArray = vocaList.filter { isEnglishAlphabet($0.sourceText) }
    }

    func setDicVocaData() {
        apiVocaList = apiVocaListManager.getVocaList()
        apiVocaDataArray = apiVocaList.filter { isEnglishAlphabet($0.sourceText) }
    }

    func setBookmarkVocaData() {
        vocaList = vocaListManager.getAllVocaData().filter { $0.isSelected == true }
        vocaDataArray = vocaList.filter { isEnglishAlphabet($0.sourceText) }
    }

    func findWordRange(in text: String, word: String) -> NSRange? {
        if let range = text.range(of: word) {
            let nsRange = NSRange(range, in: text)
            return nsRange
        }
        return nil
    }

    func isEnglishAlphabet(_ str: String) -> Bool {
        let trimmedStr = str.trimmingCharacters(in: .whitespacesAndNewlines)
        let words = trimmedStr.components(separatedBy: .whitespaces)
        let englishAlphabet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        for word in words where word.rangeOfCharacter(from: englishAlphabet.inverted) != nil {
            return false
        }
        return true
    }
}
// MARK: - About Buttons
private extension VocaWeaveVM {
    func assignVocaListToButtons(_ buttons: [UIButton],
                                 with selectedVoca: Array<RealmVocaModel>.SubSequence,
                                 count: Int) {
        selectedCount = count
        selectedCountCountPublisher.send(count)
        for (index, button) in buttons.enumerated() {
            button.setTitle(selectedVoca[index].sourceText, for: .normal)
            vocaDataArray.removeAll { $0.sourceText == selectedVoca[index].sourceText}
        }
        setupStatusCountPublisher.send(vocaDataArray.count)
    }

    func handleLessThanFiveWordsWithVocaList(buttons: [UIButton]) {
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

    func assignAPIVocaListToButtons(_ buttons: [UIButton],
                                    with selectedVoca: Array<APIRealmVocaModel>.SubSequence,
                                    count: Int) {
        selectedCount = count
        selectedCountCountPublisher.send(count)
        for (index, button) in buttons.enumerated() {
            button.setTitle(selectedVoca[index].sourceText, for: .normal)
            apiVocaDataArray.removeAll { $0.sourceText == selectedVoca[index].sourceText}
        }
        setupStatusCountPublisher.send(apiVocaDataArray.count)
    }

    func handleLessThanFiveWordsWithAPIVocaList(buttons: [UIButton]) {
        for index in 0..<5 {
            if index < apiVocaDataArray.count {
                buttons[index].setTitle(apiVocaDataArray[index].sourceText, for: .normal)
            } else {
                buttons[index].setTitle("", for: .normal)
            }
        }
        selectedCount = apiVocaDataArray.count
        selectedCountCountPublisher.send(apiVocaDataArray.count)
        setupStatusTextPublisher.send("단어의 개수가 5개 미만입니다.")
        apiVocaDataArray = apiVocaList.filter { isEnglishAlphabet($0.sourceText) }
    }

    func setRandomVocaData(buttons: [UIButton]) {
        let defaultCount = 5
        if vocaDataArray.count > 4 {
            let selectedVoca = vocaDataArray.shuffled().prefix(defaultCount)
            assignVocaListToButtons(buttons, with: selectedVoca, count: defaultCount)
        } else {
            handleLessThanFiveWordsWithVocaList(buttons: buttons)
        }
    }

    func setRandomAPIVocaData(buttons: [UIButton]) {
        let defaultCount = 5
        if apiVocaDataArray.count > 4 {
            let selectedVoca = apiVocaDataArray.shuffled().prefix(defaultCount)
            assignAPIVocaListToButtons(buttons, with: selectedVoca, count: defaultCount)
        } else {
            handleLessThanFiveWordsWithAPIVocaList(buttons: buttons)
        }
    }

    func changeVocaData(value: Int) {
        switch value {
        case 0:
            setMyVocaData()
        case 1:
            setDicVocaData()
        case 2:
            setBookmarkVocaData()
        default:
            break
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

    func applyAnimation(textField: UITextField, text: String, view: LottieAnimationView) {
        if let wordRange = findWordRange(in: textField.text!, word: text) {
            let textRect = textField.caretRect(for: textField.selectedTextRange!.start)
            let textFieldOrigin = textField.convert(textRect.origin, to: textField.superview)
            let yOffset = textFieldOrigin.y + textRect.height
            view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            view.center = CGPoint(x: CGFloat(wordRange.location) * 8, y: yOffset)
            view.play()
        }
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
}
