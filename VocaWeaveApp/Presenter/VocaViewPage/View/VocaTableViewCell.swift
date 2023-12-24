//
//  VocaTableViewCell.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit
import SnapKit
import AVFoundation
import Combine

class VocaTableViewCell: UITableViewCell {
    // MARK: - Property
    static let identifier = "VocaTableViewCell"
    let speaker = AVSpeechSynthesizer()
    var vocaListData: RealmVocaModel?
    var vocaTanslatedData: RealmTranslateModel?

    var firstVocaData: [RealmVocaModel]?
    var secondVocaData: [RealmVocaModel]?
    var allVocaData: [RealmVocaModel]?

    var vocaListViewModel: VocaListViewModel?
    var vocaTanslatedViewModel: VocaTranslatedViewModel?

    let vocaListTableViewUpdate = PassthroughSubject<[RealmVocaModel], Never>()
    let vocaTranslatedTableViewUpdate = PassthroughSubject<[RealmTranslateModel], Never>()
    var distinguishSavedData = true
    var isSelect = false
    var selectedSegmentIndex = 0

    let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()

    let translatedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()

    let speakerButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        let button = UIButton(type: .custom)
        button.frame.size.height = 40
        button.setImage(UIImage(systemName: "speaker.wave.2", withConfiguration: imageConfig),
                        for: .normal)
        return button
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setupLayout()
        speakerButtonTapped()
        vocaBookmarkButtonTapped()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper
    private func configure() {
        [sourceLabel, translatedLabel, speakerButton, bookmarkButton].forEach { contentView.addSubview($0) }
    }

    private func setupLayout() {
        let defaultValue = 8

        sourceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(defaultValue * 2)
            $0.top.bottom.equalToSuperview().inset(defaultValue)
            $0.width.equalTo(120)
        }

        translatedLabel.snp.makeConstraints {
            $0.leading.equalTo(sourceLabel.snp.trailing).offset(defaultValue * 2)
            $0.top.bottom.equalToSuperview().inset(defaultValue)
            $0.width.equalTo(120)
        }

        speakerButton.snp.makeConstraints {
            $0.leading.equalTo(translatedLabel.snp.trailing).offset(defaultValue)
            $0.top.bottom.equalToSuperview().inset(defaultValue)
        }

        bookmarkButton.snp.makeConstraints {
            $0.leading.equalTo(speakerButton.snp.trailing).offset(defaultValue)
            $0.top.bottom.equalToSuperview().inset(defaultValue)
            $0.trailing.equalToSuperview().inset(defaultValue * 2)
        }
    }

    // MARK: - Helper
    private func speakerButtonTapped() {
        speakerButton.addTarget(self, action: #selector(speakerButtonAction), for: .touchUpInside)
    }

    private func vocaBookmarkButtonTapped() {
        bookmarkButton.addTarget(self, action: #selector(vocaBookmarkButtonAction), for: .touchUpInside)
    }

    func configureBookmark() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        if isSelect == true {
            bookmarkButton.setImage(UIImage(systemName: "star.fill",
                                            withConfiguration: imageConfig),
                                            for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "star",
                                            withConfiguration: imageConfig),
                                            for: .normal)
        }
    }

    // MARK: - Action
    @objc func speakerButtonAction() {
        if let text = sourceLabel.text, text.containsOnlyEnglish() {
            let speechUtterance = AVSpeechUtterance(string: text)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") // 설정한 언어로 음성 선택
            let speechSynthesizer = AVSpeechSynthesizer()
            speechSynthesizer.speak(speechUtterance)
        }
    }

    @objc func vocaBookmarkButtonAction() {
        isSelect.toggle()
        if isSelect {
            bookmarkUpdateData(isSelect: true)
        } else {
            bookmarkUpdateData(isSelect: false)
        }
    }

    private func bookmarkUpdateData(isSelect: Bool) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        switch selectedSegmentIndex {
        case 0:
            guard let vocaListViewModel = vocaListViewModel else { return }
            guard let vocaListData = vocaListData else { return }
            vocaListViewModel.updateVoca(list: vocaListData,
                                          sourceText: vocaListData.sourceText,
                                          translatedText: vocaListData.translatedText,
                                          isSelected: isSelect)
            bookmarkButton.setImage(UIImage(systemName: isSelect == true ? "star.fill" : "star",
                                            withConfiguration: imageConfig),
                                            for: .normal)
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
                guard let vocaTanslatedViewModel = vocaTanslatedViewModel else { return }
                guard let vocaTanslatedData = vocaTanslatedData else { return }
                vocaTanslatedViewModel.updateVoca(list: vocaTanslatedData,
                                                   text: vocaTanslatedData.sourceText,
                                                   isSelected: isSelect)
                let newVocaList: [RealmTranslateModel] = vocaTanslatedViewModel.getVocaList()
                self.vocaTranslatedTableViewUpdate.send(newVocaList.filter {$0.isSelected == true})
                bookmarkButton.setImage(UIImage(systemName: isSelect == true ? "star.fill" : "star",
                                                withConfiguration: imageConfig),
                                                for: .normal)
            } else {
                guard let vocaListViewModel = vocaListViewModel else { return }
                guard let vocaListData = vocaListData else { return }
                guard let secondVocaData = secondVocaData else { return }
                vocaListViewModel.updateVoca(list: vocaListData,
                                              sourceText: vocaListData.sourceText,
                                              translatedText: vocaListData.translatedText,
                                              isSelected: isSelect)
                self.vocaListTableViewUpdate.send(secondVocaData)
                bookmarkButton.setImage(UIImage(systemName: isSelect == true ? "star.fill" : "star",
                                                withConfiguration: imageConfig),
                                                for: .normal)
            }
        default:
            break
        }
    }
}
