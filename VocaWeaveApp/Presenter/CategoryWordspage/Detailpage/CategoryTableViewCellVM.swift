//
//  CategoryTableViewCellVM.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 2/20/24.
//

import UIKit
import AVFoundation
import Combine

final class CategoryTableViewCellVM {
    var vocaListData: RealmVocaModel?
    var apiVocaData: APIRealmVocaModel?

    var firstVocaData: [RealmVocaModel]?
    var secondVocaData: [RealmVocaModel]?
    var allVocaData: [RealmVocaModel]?

    var vocaListVM: VocaListVM?
    var apiVocaListVM: APIVocaListVM?

    private var cancellables = Set<AnyCancellable>()
    let vocaListTableViewUpdate = PassthroughSubject<[RealmVocaModel], Never>()
    let apiVocaTableViewUpdate = PassthroughSubject<[APIRealmVocaModel], Never>()

    var distinguishSavedData = true
    var isSelect = false
    var selectedSegmentIndex = 0
    private let speechSynthesizer = AVSpeechSynthesizer()

    init(vocaListData: RealmVocaModel?,
         apiVocaData: APIRealmVocaModel?,
         firstVocaData: [RealmVocaModel]?,
         secondVocaData: [RealmVocaModel]?,
         allVocaData: [RealmVocaModel]?,
         vocaListVM: VocaListVM?,
         apiVocaListVM: APIVocaListVM?,
         distinguishSavedData: Bool,
         isSelect: Bool,
         selectedSegmentIndex: Int) {
        self.vocaListData = vocaListData
        self.apiVocaData = apiVocaData
        self.firstVocaData = firstVocaData
        self.secondVocaData = secondVocaData
        self.allVocaData = allVocaData
        self.vocaListVM = vocaListVM
        self.apiVocaListVM = apiVocaListVM
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
        guard let apiVocaData = apiVocaData else { return }
        apiVocaListVM.updateVoca(list: apiVocaData,
                                 text: apiVocaData.sourceText,
                                 isSelected: isSelect)
        let newVocaList: [APIRealmVocaModel] = apiVocaListVM.vocaList
        self.apiVocaTableViewUpdate.send(newVocaList.filter {$0.isSelected == true})
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
                updateAPIVocaData(image: imageConfig, button: button)
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
