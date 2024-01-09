//
//  DictionaryViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit
import Combine
import AVFoundation

class DictionaryViewController: UIViewController {
    // MARK: - Property
    let dictionaryView = DictionaryView()
    let dictionaryViewModel: DictionaryViewModel?
    private let vocaTranslatedViewModel: VocaTranslatedViewModel?
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
         vocaTranslatedViewModel: VocaTranslatedViewModel?,
         dictionaryViewModel: DictionaryViewModel?) {
        self.vocaTranslatedData = vocaTranslatedData
        self.dictionaryEnum = dictionaryEnum
        self.vocaTranslatedViewModel = vocaTranslatedViewModel
        self.dictionaryViewModel = dictionaryViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helper
    private func setup() {
        view.addSubview(dictionaryView)
        configureNav()
        configure()
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

    private func configure() {
        guard let vocaTranslatedData = vocaTranslatedData else { return }
        if dictionaryEnum == .response {
            dictionaryView.sourceTextField.text = vocaTranslatedData.sourceText
            dictionaryView.translationTextLabel.text = vocaTranslatedData.translatedText
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
        guard let dictionaryViewModel = dictionaryViewModel else { return }
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
        vocaTranslatedViewModel?.saveDictionaryData(vocaTranslatedData)
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
        guard let dictionaryViewModel = dictionaryViewModel else { return }
        dictionaryViewModel.speakerAction(text: dictionaryView.sourceTextField.text,
                                          language: dictionaryViewModel.sourceLanguage.avLanguageTitle)
    }

    @objc private func sourceTextCopyButtonAction() {
        dictionaryViewModel?.copyText(text: dictionaryView.sourceTextField.text)
        view.endEditing(true)
    }

    @objc private func translatedSpeakerButtonAction() {
        guard let dictionaryViewModel = dictionaryViewModel else { return }
        dictionaryViewModel.speakerAction(text: dictionaryView.translationTextLabel.text,
                                          language: dictionaryViewModel.targetLanguage.avLanguageTitle)
    }

    @objc private func translatedCopyButtonAction() {
        dictionaryViewModel?.copyText(text: dictionaryView.translationTextLabel.text)
        view.endEditing(true)
    }

    @objc private func cancelButtonAction() {
        dictionaryView.sourceTextField.text = ""
        view.endEditing(true)
    }
    @objc private func bookmarkButtonAction() {
        dictionaryViewModel?.addDictionaryData(sourceText: dictionaryView.sourceTextField.text,
                                               translatedText: dictionaryView.translationTextLabel.text)
    }
    @objc private func backBarButtonAction() {
        self.dismiss(animated: true)
    }
}
extension DictionaryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let sourceText = dictionaryView.sourceTextField.text else { return false }
        guard let dictionaryViewModel = dictionaryViewModel else { return false }
        Task {
            do {
                guard let responseData = try await dictionaryViewModel.fetchDataAndHandleResult(
                                                                        sourceText: sourceText) else { return }
                dictionaryView.translationTextLabel.text = responseData
            } catch {
                print("Task Response error")
            }
        }
        textField.resignFirstResponder()
        return true
    }
}
// 검색을 하고 해당 검색한 데이터를 넘어온 데이터와 비교를 한 후에 추가하기를 했을 경우 중복인지 확인하는 과정 필요
// 북마크 이미지 변경하기, 애니메이션 적용하기.
// 네이버 백과사전api 적용
