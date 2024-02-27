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
    var apiVocaData: APIRealmVocaModel?

    var vocaListVM: VocaListVM?
    var apiVocaListVM: APIVocaListVM?

    private let speechSynthesizer = AVSpeechSynthesizer()
    var isSelect = false
    var selectedSegmentIndex = 0

    init(vocaListData: RealmVocaModel?,
         apiVocaData: APIRealmVocaModel?,
         vocaListVM: VocaListVM?,
         apiVocaListVM: APIVocaListVM?,
         isSelect: Bool,
         selectedSegmentIndex: Int) {
        self.vocaListData = vocaListData
        self.apiVocaData = apiVocaData
        self.vocaListVM = vocaListVM
        self.apiVocaListVM = apiVocaListVM
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

    func updateAPIVocaData(image: UIImage.SymbolConfiguration, button: UIButton) {
        guard let apiVocaListVM = apiVocaListVM else { return }
        guard let vocaTanslatedData = apiVocaData else { return }
        apiVocaListVM.updateVoca(list: vocaTanslatedData,
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
            updateAPIVocaData(image: imageConfig, button: button)
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
