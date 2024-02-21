//
//  VocaCellVM.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 2/19/24.
//

import AVFoundation
import UIKit

final class VocaCellVM {
    var vocaListData: RealmVocaModel?
    var vocaTanslatedData: RealmTranslateModel?

    var vocaListVM: VocaListVM?
    var vocaTanslatedVM: VocaTranslatedVM?

    private let speechSynthesizer = AVSpeechSynthesizer()
    var isSelect = false
    var selectedSegmentIndex = 0

    init(vocaListData: RealmVocaModel?,
         vocaTanslatedData: RealmTranslateModel?,
         vocaListVM: VocaListVM?,
         vocaTanslatedVM: VocaTranslatedVM?,
         isSelect: Bool,
         selectedSegmentIndex: Int) {
        self.vocaListData = vocaListData
        self.vocaTanslatedData = vocaTanslatedData
        self.vocaListVM = vocaListVM
        self.vocaTanslatedVM = vocaTanslatedVM
        self.isSelect = isSelect
        self.selectedSegmentIndex = selectedSegmentIndex
    }

    func speakerButtonAction(sourceText: String?) {
        if let text = sourceText, text.containsOnlyEnglish() {
            Language.sourceLanguage = .english
            let speechUtterance = AVSpeechUtterance(string: text)
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

    func updateVocaListData(image: UIImage.SymbolConfiguration, button: UIButton) {
        guard let vocaListVM = vocaListVM else { return }
        guard let vocaListData = vocaListData else { return }
        vocaListVM.updateVoca(list: vocaListData,
                              sourceText: vocaListData.sourceText,
                              translatedText: vocaListData.translatedText,
                              isSelected: isSelect)
        button.setImage(UIImage(systemName: isSelect == true ? "star.fill" : "star",
                                withConfiguration: image),
                        for: .normal)
    }

    func updateVocaTranslatedData(image: UIImage.SymbolConfiguration, button: UIButton) {
        guard let vocaTanslatedVM = vocaTanslatedVM else { return }
        guard let vocaTanslatedData = vocaTanslatedData else { return }
        vocaTanslatedVM.updateVoca(list: vocaTanslatedData,
                                   text: vocaTanslatedData.sourceText,
                                   isSelected: isSelect)
        button.setImage(UIImage(systemName: isSelect == true ? "star.fill" : "star",
                                withConfiguration: image),
                        for: .normal)
    }

    func updateBookmarkData(isSelect: Bool, button: UIButton) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        switch selectedSegmentIndex {
        case 0:
            updateVocaListData(image: imageConfig, button: button)
        case 1:
            updateVocaTranslatedData(image: imageConfig, button: button)
        default:
            break
        }
    }

    func setupCell(cell: VocaTableViewCell,
                   sourceText: String,
                   translatedText: String) {
        cell.sourceLabel.text = sourceText
        cell.translatedLabel.text = translatedText
        cell.configureBookmark()
        cell.selectionStyle = .none
    }
}
