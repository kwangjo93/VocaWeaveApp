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
import Lottie

final class VocaTableViewCell: UITableViewCell {
    // MARK: - Property
    static let identifier = "VocaTableViewCell"
    var vocaListData: RealmVocaModel?
    var vocaTanslatedData: RealmTranslateModel?

    var firstVocaData: [RealmVocaModel]?
    var secondVocaData: [RealmVocaModel]?
    var allVocaData: [RealmVocaModel]?

    var vocaListViewModel: VocaListVM?
    var vocaTanslatedViewModel: VocaTranslatedVM?

    let vocaListTableViewUpdate = PassthroughSubject<[RealmVocaModel], Never>()
    let vocaTranslatedTableViewUpdate = PassthroughSubject<[RealmTranslateModel], Never>()

    var distinguishSavedData = true
    var isSelect = false
    var selectedSegmentIndex = 0

    private let speechSynthesizer = AVSpeechSynthesizer()
    var animationView = LottieAnimationView()

    let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Sejong hospital Light", size: 18)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()

    let translatedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Sejong hospital Light", size: 18)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()

    let speakerButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "speaker.wave.2", withConfiguration: imageConfig),
                        for: .normal)
        button.tintColor = UIColor.subTinkColor
        return button
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = UIColor.subTinkColor
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
        [sourceLabel,
         translatedLabel,
         speakerButton,
         bookmarkButton].forEach { contentView.addSubview($0) }
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
            $0.top.equalTo(sourceLabel.snp.top)
            $0.bottom.equalTo(sourceLabel.snp.bottom)
            $0.width.equalTo(120)
        }

        speakerButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(defaultValue)
        }

        bookmarkButton.snp.makeConstraints {
            $0.leading.equalTo(speakerButton.snp.trailing).offset(defaultValue)
            $0.top.bottom.equalToSuperview().inset(defaultValue)
            $0.trailing.equalToSuperview().inset(defaultValue * 2)
        }
    }

    private func setupAnimationView() {
        bookmarkButton.addSubview(animationView)
        let animation = LottieAnimation.named("starfill")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.isHidden = true
        animationView.frame = CGRect(x: -37, y: -37, width: 100, height: 100)
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

    @objc func vocaBookmarkButtonAction() {
        setupAnimationView()
        isSelect.toggle()
        if isSelect {
            updateBookmarkData(isSelect: true)
            animationView.isHidden = false
            animationView.play { [weak self] _ in
                self?.animationView.isHidden = true
            }
        } else {
            updateBookmarkData(isSelect: false)
        }
    }

    private func updateVocaListData(image: UIImage.SymbolConfiguration) {
        guard let vocaListViewModel = vocaListViewModel else { return }
        guard let vocaListData = vocaListData else { return }
        vocaListViewModel.updateVoca(list: vocaListData,
                                      sourceText: vocaListData.sourceText,
                                      translatedText: vocaListData.translatedText,
                                      isSelected: isSelect)
        bookmarkButton.setImage(UIImage(systemName: isSelect == true ? "star.fill" : "star",
                                        withConfiguration: image),
                                        for: .normal)
    }

    private func updateVocaTranslatedData(image: UIImage.SymbolConfiguration) {
        guard let vocaTanslatedViewModel = vocaTanslatedViewModel else { return }
        guard let vocaTanslatedData = vocaTanslatedData else { return }
        vocaTanslatedViewModel.updateVoca(list: vocaTanslatedData,
                                           text: vocaTanslatedData.sourceText,
                                           isSelected: isSelect)
        let newVocaList: [RealmTranslateModel] = vocaTanslatedViewModel.vocaList
        self.vocaTranslatedTableViewUpdate.send(newVocaList.filter {$0.isSelected == true})
        bookmarkButton.setImage(UIImage(systemName: isSelect == true ? "star.fill" : "star",
                                        withConfiguration: image),
                                        for: .normal)
    }

    private func updateBookmarkData(isSelect: Bool) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        switch selectedSegmentIndex {
        case 0:
            updateVocaListData(image: imageConfig)
            if distinguishSavedData {
                guard let allVocaData = allVocaData else { return }
                let newVocaList: [RealmVocaModel] = allVocaData
                                                        .filter {$0.isSelected == true}
                self.vocaListTableViewUpdate.send(newVocaList)
            } else {
                guard let firstVocaData = firstVocaData else { return }
                self.vocaListTableViewUpdate.send(firstVocaData)
            }
        case 1:
            if distinguishSavedData {
                updateVocaTranslatedData(image: imageConfig)
            } else {
                updateVocaListData(image: imageConfig)
                guard let secondVocaData = secondVocaData else { return }
                self.vocaListTableViewUpdate.send(secondVocaData)
            }
        default:
            break
        }
    }
}
// MARK: - CategoryView
extension VocaTableViewCell {
    func bindVocaListData() {
        guard let vocaListData = vocaListData else { return }
        self.sourceLabel.text = vocaListData.sourceText
        self.translatedLabel.text = vocaListData.translatedText
        self.isSelect = vocaListData.isSelected
    }

    func bindVocaTranslatedData() {
        guard let vocaTanslatedData = vocaTanslatedData else { return }
        self.sourceLabel.text = vocaTanslatedData.sourceText
        self.translatedLabel.text = vocaTanslatedData.translatedText
        self.isSelect = vocaTanslatedData.isSelected
    }
}
