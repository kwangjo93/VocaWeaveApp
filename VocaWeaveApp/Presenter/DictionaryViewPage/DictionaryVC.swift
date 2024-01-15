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
    let dictionaryVM: DictionaryVM?
    private let vocaTranslatedVM: VocaTranslatedVM?
    private var vocaTranslatedData: RealmTranslateModel?
    var dictionaryEnum: DictionaryEnum = .new
    var cancellables = Set<AnyCancellable>()

    lazy var backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backBarButtonAction))

    lazy var addRightBarButton = UIBarButtonItem(title: "추 가",
                                     style: .plain,
                                     target: self,
                                     action: #selector(addRightBarButtonAction))
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        modelDataBinding()
    }

    // MARK: - init
    init(vocaTranslatedData: RealmTranslateModel?,
         dictionaryEnum: DictionaryEnum,
         vocaTranslatedVM: VocaTranslatedVM?,
         dictionaryVM: DictionaryVM?) {
        self.vocaTranslatedData = vocaTranslatedData
        self.dictionaryEnum = dictionaryEnum
        self.vocaTranslatedVM = vocaTranslatedVM
        self.dictionaryVM = dictionaryVM
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helper
    private func setup() {
        view.addSubview(dictionaryView)
        configureNav()
        configureResponseData()
        setupLayout()
        setButtonAction()
        dictionaryView.sourceTextField.delegate = self
    }

    private func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "사 전"
            label.textColor = UIColor.label
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItems = [titleItem]

        let nightModeButton = nightModeBarButtonItem(
                                target: self,
                                action: #selector(nightModeBuutonAction))
        navigationItem.rightBarButtonItems = [nightModeButton]
        navigationController?.configureBasicAppearance()
    }

    private func configureResponseData() {
        guard let vocaTranslatedData = vocaTranslatedData else { return }
        if dictionaryEnum == .response {
            dictionaryView.sourceTextField.text = vocaTranslatedData.sourceText
            dictionaryView.translationText.text = vocaTranslatedData.translatedText
            navigationItem.leftBarButtonItems?.insert(backBarButton, at: 0)
            navigationItem.rightBarButtonItems?.insert(addRightBarButton, at: 0)
        }
    }

    private func setupLayout() {
        let defaultValue = 8
        dictionaryView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(defaultValue * 2)
        }
    }

    private func modelDataBinding() {
        guard let dictionaryViewModel = dictionaryVM else { return }
        dictionaryViewModel.errorAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        dictionaryViewModel.copyAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }

    private func setButtonAction() {
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // MARK: - Action
    @objc private func addRightBarButtonAction() {
        guard let vocaTranslatedData = vocaTranslatedData else { return }
        vocaTranslatedVM?.saveDictionaryData(vocaTranslatedData,
                                            vocaTranslatedViewModel: vocaTranslatedVM)
        self.dismiss(animated: true)
    }

    @objc private func nightModeBuutonAction() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    if window.overrideUserInterfaceStyle == .dark {
                        window.overrideUserInterfaceStyle = .light
                        dictionaryView.explainView.layer.borderColor = UIColor.label.cgColor
                    } else {
                        window.overrideUserInterfaceStyle = .dark
                        dictionaryView.explainView.layer.borderColor = UIColor.white.cgColor
                    }
                }
            }
        }
    }

    @objc private func sourceTextSpeakerButtonAction() {
        guard let dictionaryViewModel = dictionaryVM else { return }
        dictionaryViewModel.speakerAction(text: dictionaryView.sourceTextField.text,
                                          language: Language.sourceLanguage.avLanguageTitle)
    }

    @objc private func sourceTextCopyButtonAction() {
        dictionaryVM?.copyText(text: dictionaryView.sourceTextField.text)
        view.endEditing(true)
    }

    @objc private func translatedSpeakerButtonAction() {
        guard let dictionaryViewModel = dictionaryVM else { return }
        dictionaryViewModel.speakerAction(text: dictionaryView.translationText.text,
                                          language: Language.targetLanguage.avLanguageTitle)
    }

    @objc private func translatedCopyButtonAction() {
        dictionaryVM?.copyText(text: dictionaryView.translationText.text)
        view.endEditing(true)
    }

    @objc private func cancelButtonAction() {
        dictionaryView.sourceTextField.text = ""
        dictionaryView.translationText.text = ""
        dictionaryVM?.isSelect = false
        dictionaryVM?.setBookmarkStatus(bookmarkButton: dictionaryView.bookmarkButton)
        view.endEditing(true)
    }

    @objc private func bookmarkButtonAction() {
        guard let sourceText = dictionaryView.sourceTextField.text else { return }
        dictionaryVM?.isSelect.toggle()
        dictionaryVM?.bookmarkButtonAction(vocaData: vocaTranslatedData,
                                                  text: sourceText,
                                                  bookmarkButton: dictionaryView.bookmarkButton)
        dictionaryVM?.playAnimation(view: dictionaryView,
                                           isSelect: dictionaryVM!.isSelect,
                                           text: sourceText)
    }
    @objc private func backBarButtonAction() {
        self.dismiss(animated: true)
    }
}
extension DictionaryVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let sourceText = dictionaryView.sourceTextField.text else { return false }
        guard let dictionaryVM = dictionaryVM else { return false }
        Task {
            do {
                self.vocaTranslatedData = try await dictionaryVM
                                                        .fetchDataAndHandleResult(sourceText: sourceText)
                dictionaryVM.updateTranslationView(with: vocaTranslatedData,
                                                   view: dictionaryView)
                dictionaryVM.playAnimation(view: dictionaryView,
                                           isSelect: vocaTranslatedData?.isSelected ?? false,
                                           text: sourceText)
            } catch {
                print("Task Response error")
            }
        }
        textField.resignFirstResponder()
        return true
    }
}