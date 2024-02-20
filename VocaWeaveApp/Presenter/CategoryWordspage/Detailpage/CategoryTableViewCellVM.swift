//
//  CategoryTableViewCellVM.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 2/20/24.
//

import UIKit
import AVFoundation
import Combine

class CategoryTableViewCellVM {
    var vocaListData: RealmVocaModel?
    var vocaTanslatedData: RealmTranslateModel?

    var firstVocaData: [RealmVocaModel]?
    var secondVocaData: [RealmVocaModel]?
    var allVocaData: [RealmVocaModel]?

    var vocaListVM: VocaListVM?
    var vocaTanslatedVM: VocaTranslatedVM?

    private var cancellables = Set<AnyCancellable>()
    let vocaListTableViewUpdate = PassthroughSubject<[RealmVocaModel], Never>()
    let vocaTranslatedTableViewUpdate = PassthroughSubject<[RealmTranslateModel], Never>()

    var distinguishSavedData = true
    var isSelect = false
    var selectedSegmentIndex = 0
    private let speechSynthesizer = AVSpeechSynthesizer()

    init(vocaListData: RealmVocaModel?,
         vocaTanslatedData: RealmTranslateModel?,
         firstVocaData: [RealmVocaModel]?,
         secondVocaData: [RealmVocaModel]?,
         allVocaData: [RealmVocaModel]?,
         vocaListVM: VocaListVM?,
         vocaTanslatedVM: VocaTranslatedVM?,
         distinguishSavedData: Bool,
         isSelect: Bool,
         selectedSegmentIndex: Int) {
        self.vocaListData = vocaListData
        self.vocaTanslatedData = vocaTanslatedData
        self.firstVocaData = firstVocaData
        self.secondVocaData = secondVocaData
        self.allVocaData = allVocaData
        self.vocaListVM = vocaListVM
        self.vocaTanslatedVM = vocaTanslatedVM
        self.distinguishSavedData = distinguishSavedData
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
        guard let vocaListViewModel = vocaListVM else { return }
        guard let vocaListData = vocaListData else { return }
        vocaListViewModel.updateVoca(list: vocaListData,
                                      sourceText: vocaListData.sourceText,
                                      translatedText: vocaListData.translatedText,
                                      isSelected: isSelect)
        button.setImage(UIImage(systemName: isSelect == true ? "star.fill" : "star",
                                        withConfiguration: image),
                                        for: .normal)
    }

    func updateVocaTranslatedData(image: UIImage.SymbolConfiguration, button: UIButton) {
        guard let vocaTanslatedViewModel = vocaTanslatedVM else { return }
        guard let vocaTanslatedData = vocaTanslatedData else { return }
        vocaTanslatedViewModel.updateVoca(list: vocaTanslatedData,
                                           text: vocaTanslatedData.sourceText,
                                           isSelected: isSelect)
        let newVocaList: [RealmTranslateModel] = vocaTanslatedViewModel.vocaList
        self.vocaTranslatedTableViewUpdate.send(newVocaList.filter {$0.isSelected == true})
        button.setImage(UIImage(systemName: isSelect == true ? "star.fill" : "star",
                                        withConfiguration: image),
                                        for: .normal)
    }

    func updateBookmarkData(isSelect: Bool, button: UIButton) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        switch selectedSegmentIndex {
        case 0:
            updateVocaListData(image: imageConfig, button: button)
            if distinguishSavedData {
                guard let allVocaData = allVocaData else { return }
                let newVocaList: [RealmVocaModel] = allVocaData.filter {$0.isSelected == true}
                self.vocaListTableViewUpdate.send(newVocaList)
            } else {
                guard let firstVocaData = firstVocaData else { return }
                self.vocaListTableViewUpdate.send(firstVocaData)
            }
        case 1:
            if distinguishSavedData {
                updateVocaTranslatedData(image: imageConfig, button: button)
            } else {
                updateVocaListData(image: imageConfig, button: button)
                guard let secondVocaData = secondVocaData else { return }
                self.vocaListTableViewUpdate.send(secondVocaData)
            }
        default:
            break
        }
    }

    func setupCell(cell: CategoryTableViewCell,
                   sourceText: String,
                   translatedText: String) {
        cell.sourceLabel.text = sourceText
        cell.translatedLabel.text = translatedText
        cell.configureBookmark()
        cell.selectionStyle = .none
    }
}
