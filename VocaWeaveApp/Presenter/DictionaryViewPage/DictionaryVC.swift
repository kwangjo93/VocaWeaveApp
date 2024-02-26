//
//  DictionaryVC.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit
import Combine
import AVFoundation

final class DictionaryVC: UIViewController {
    // MARK: - Property
    let dictionaryView = DictionaryView()
    let dictionaryVM: DictionaryVM
    var cancellables = Set<AnyCancellable>()

    lazy var backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backBarButtonAction))

    lazy var addRightBarButton = UIBarButtonItem(title: "추 가",
                                     style: .plain,
                                     target: self,
                                     action: #selector(addRightBarButtonAction))

    lazy var nightModeButton = nightModeBarButtonItem(target: self,
                                                      action: #selector(nightModeBuutonAction))
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        modelDataBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNightButton(button: nightModeButton)
    }
    // MARK: - init
    init(dictionaryVM: DictionaryVM) {
        self.dictionaryVM = dictionaryVM
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
private extension DictionaryVC {
    // MARK: - Helper
    func setup() {
        view.addSubview(dictionaryView)
        configureNav()
        configureVocaData()
        setupLayout()
        setButtonAction()
        dictionaryView.sourceTextField.delegate = self
    }

    func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "사 전"
            label.textColor = UIColor.label
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItems = [titleItem]
        navigationItem.rightBarButtonItems = [nightModeButton]
        navigationController?.configureBasicAppearance()
    }

    func setupLayout() {
        let defaultValue = 8
        dictionaryView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(defaultValue * 2)
        }
    }

    func configureVocaData() {
        guard let vocaTranslatedData = dictionaryVM.vocaTranslatedData else { return }
        switch dictionaryVM.dictionaryEnum {
        case .edit, .response:
            tabBarController?.tabBar.isHidden = true
            dictionaryVM.bindTextData(vocaTranslatedData, dictionaryView)
            hideAndPresnetAddButton()
            dictionaryVM.setBookmarkStatus(isSelec: vocaTranslatedData.isSelected,
                                           view: dictionaryView,
                                           text: vocaTranslatedData.sourceText)
        case .new:
            break
        }
    }

    func hideAndPresnetAddButton() {
        switch dictionaryVM.dictionaryEnum {
        case .response:
            navigationItem.leftBarButtonItems?.insert(backBarButton, at: 0)
            navigationItem.rightBarButtonItems?.insert(addRightBarButton, at: 0)
        case .edit:
            navigationItem.leftBarButtonItems?.insert(backBarButton, at: 0)
            if let index = navigationItem.rightBarButtonItems?.firstIndex(of: addRightBarButton) {
                navigationItem.rightBarButtonItems?.remove(at: index)
            }
        case .new:
            break
        }
    }

    func handleVocaTranslation(sourceText: String) {
        if (dictionaryVM.apiVocaList.first(where: { $0.sourceText == sourceText })) != nil {
            if let index = navigationItem.rightBarButtonItems?.firstIndex(of: addRightBarButton) {
                navigationItem.rightBarButtonItems?.remove(at: index)
            }
        } else {
            navigationItem.rightBarButtonItems?.insert(addRightBarButton, at: 0)
        }
    }

    func modelDataBinding() {
        dictionaryVM.errorAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        dictionaryVM.copyAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        dictionaryVM.duplicationAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }

    func setButtonAction() {
        dictionaryView.sourceTextSpeakerButton.addTarget(self,
                                                         action: #selector(sourceTextSpeakerButtonAction),
                                                         for: .touchUpInside)
        dictionaryView.sourceTextCopyButton.addTarget(self,
                                                      action: #selector(sourceTextCopyButtonAction),
                                                      for: .touchUpInside)
        dictionaryView.cancelButton.addTarget(self,
                                              action: #selector(cancelButtonAction),
                                              for: .touchUpInside)
        dictionaryView.translatedTextSpeakerButton.addTarget(self,
                                                             action: #selector(translatedSpeakerButtonAction),
                                                             for: .touchUpInside)
        dictionaryView.translatedTextCopyButton.addTarget(self,
                                                          action: #selector(translatedCopyButtonAction),
                                                          for: .touchUpInside)
        dictionaryView.bookmarkButton.addTarget(self,
                                                action: #selector(bookmarkButtonAction),
                                                for: .touchUpInside)
    }
    @objc func addRightBarButtonAction() {
        dictionaryVM.saveDictionaryData()
        switch dictionaryVM.dictionaryEnum {
        case .response, .edit:
            self.dismiss(animated: true)
        case .new:
            break
        }
    }

    @objc func nightModeBuutonAction() {
        dictionaryVM.nightButtonAction(button: nightModeButton, dictionaryView.translationText)
    }

    @objc func sourceTextSpeakerButtonAction() {
        dictionaryVM.speakerAction(text: dictionaryView.sourceTextField.text,
                                          language: Language.sourceLanguage.avLanguageTitle)
    }

    @objc func sourceTextCopyButtonAction() {
        dictionaryVM.copyText(text: dictionaryView.sourceTextField.text)
        view.endEditing(true)
    }

    @objc func translatedSpeakerButtonAction() {
        dictionaryVM.speakerAction(text: dictionaryView.translationText.text,
                                          language: Language.sourceLanguage.avLanguageTitle)
    }

    @objc func translatedCopyButtonAction() {
        dictionaryVM.copyText(text: dictionaryView.translationText.text)
        view.endEditing(true)
    }

    @objc func cancelButtonAction() {
        dictionaryVM.resetText(dictionaryView)
        dictionaryVM.setBookmarkStatus(isSelec: false,
                                       view: dictionaryView,
                                       text: "")
        view.endEditing(true)
    }

    @objc func bookmarkButtonAction() {
        guard let sourceText = dictionaryView.sourceTextField.text else { return }
        dictionaryVM.isSelect.toggle()
        dictionaryVM.bookmarkButtonAction(text: sourceText,
                                          view: dictionaryView,
                                          sourceText: sourceText)
    }

    @objc func backBarButtonAction() {
        self.dismiss(animated: true)
    }
}

extension DictionaryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let sourceText = dictionaryView.sourceTextField.text else { return false }
            Task {
                do {
                    dictionaryVM.vocaTranslatedData = try await dictionaryVM
                                                            .fetchDataAndHandleResult(sourceText: sourceText)
                    dictionaryVM.updateTranslationView(with: dictionaryVM.vocaTranslatedData,
                                                       view: dictionaryView)
                    handleVocaTranslation(sourceText: sourceText)
                } catch {
                    print("Task Response error")
                }
            }
        textField.resignFirstResponder()
        return true
    }
}
