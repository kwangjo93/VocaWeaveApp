//
//  VocaWeaveVC.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/10/23.
//

import UIKit
import SnapKit
import Combine
import Lottie

final class VocaWeaveVC: UIViewController {
    // MARK: - Property
    private let vocaWeaveVM: VocaWeaveVM
    private let vocaWeaveView = VocaWeaveView()
    private lazy var buttonArray = [vocaWeaveView.sourceTextButton1, vocaWeaveView.sourceTextButton2,
                            vocaWeaveView.sourceTextButton3, vocaWeaveView.sourceTextButton4,
                            vocaWeaveView.sourceTextButton5]
    private var cancellables = Set<AnyCancellable>()
    private lazy var refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(refreshButtonAction))
    private lazy var nightModeButton = nightModeBarButtonItem(
                            target: self,
                            action: #selector(nightModeButtonAction))
    // MARK: - init
    init(vocaWeaveViewModel: VocaWeaveVM) {
        self.vocaWeaveVM = vocaWeaveViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        modelDataBinding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vocaWeaveVM.resetData = vocaWeaveVM.selectedValue
        refreshButtonAction()
        setNightButton(button: nightModeButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

private extension VocaWeaveVC {
    // MARK: - Helper
    func setup() {
        configureNav()
        configure()
        setupLayout()
        setButtonAction()
        configureAnimation(vocaWeaveView.animationView)
    }

    func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "학습장"
            label.textColor = UIColor.label
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        let categoryMenuButton = changeCategoryButton()
        navigationItem.leftBarButtonItem = titleItem
        navigationItem.rightBarButtonItems = [refreshButton, nightModeButton, categoryMenuButton]
        navigationController?.configureBasicAppearance()
    }

    func configure() {
        view.addSubview(vocaWeaveView)
        vocaWeaveView.weaveVocaTextField.delegate = self
        vocaWeaveView.responseDataText.isEditable = false
        buttonArray.forEach { vocaWeaveView.setButtonBorder(button: $0, color: UIColor.label.cgColor) }

        buttonArray.forEach { $0.addTarget(self,
                                           action: #selector(vocaButtonAction),
                                           for: .touchUpInside) }
    }

    func setupLayout() {
        let defaultValue = 8
        vocaWeaveView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func setButtonAction() {
        vocaWeaveView.copyButton.addTarget(self,
                                           action: #selector(copyButtonAction),
                                           for: .touchUpInside)
        vocaWeaveView.speakerButton.addTarget(self,
                                              action: #selector(speakerButtonAction),
                                              for: .touchUpInside)
    }

    func setNightButton(button: UIBarButtonItem) {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    if window.overrideUserInterfaceStyle == .dark {
                        button.image = UIImage(systemName: "moon.fill")
                        button.tintColor = .subTinkColor
                    } else {
                        button.image = UIImage(systemName: "moon")
                        button.tintColor = .black
                    }
                }
            }
        }
    }

    func changeCategoryButton() -> UIBarButtonItem {
        let myVoca = UIAction(title: "나의 단어장",
                              image: UIImage(systemName: "highlighter"),
                              handler: { _ in
            self.vocaWeaveVM.selectedVocaType = .myVoca
            self.vocaWeaveVM.selectVoca()
        })
        let dictionayVoca = UIAction(title: "사전 단어장",
                                     image: UIImage(systemName: "book.pages"),
                                     handler: { _ in
            self.vocaWeaveVM.selectedVocaType = .dicVoca
            self.vocaWeaveVM.selectVoca()
        })
        let myBookmarkVoca = UIAction(title: "나의 북마크 단어장",
                                    image: UIImage(systemName: "star.square.fill"),
                                    handler: { _ in
            self.vocaWeaveVM.selectedVocaType = .bookmarkVoca
            self.vocaWeaveVM.selectVoca()
        })
        let categoryMenu = UIMenu(title: "", children: [myVoca, dictionayVoca, myBookmarkVoca])
        return UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"),
                               primaryAction: nil, menu: categoryMenu)
    }

    func modelDataBinding() {
        vocaWeaveVM.errorAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        vocaWeaveVM.selectedCountCountPublisher
            .sink { [weak self] count in
                self?.vocaWeaveView.selectedCountLabel.text = "/   \(count)"
            }
            .store(in: &cancellables)

        vocaWeaveVM.setupStatusCountPublisher
            .sink { [weak self] count in
                self?.vocaWeaveView.statusValueLabel.text = String(count)
                self?.vocaWeaveView.statusValueLabel.isHidden = false
                self?.vocaWeaveView.selectedCountLabel.isHidden = false
                self?.vocaWeaveView.lackOfDataLabel.isHidden = true
            }
            .store(in: &cancellables)

        vocaWeaveVM.setupStatusTextPublisher
            .sink { [weak self] text in
                self?.vocaWeaveView.statusValueLabel.isHidden = true
                self?.vocaWeaveView.selectedCountLabel.isHidden = true
                self?.vocaWeaveView.lackOfDataLabel.isHidden = false
                self?.vocaWeaveView.lackOfDataLabel.text = text
            }
            .store(in: &cancellables)

        vocaWeaveVM.copyAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        vocaWeaveVM.changedVocaPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.vocaWeaveVM.changeVocaData(value: value)
                self?.vocaWeaveVM.changeDifferentTypeData(value: value, buttons: self!.buttonArray)
                self?.vocaWeaveVM.selectedValue = value
            }
            .store(in: &cancellables)
    }

    func configureAnimation(_ view: LottieAnimationView) {
        let animation = LottieAnimation.named("disappear")
        view.animation = animation
        view.loopMode = .playOnce
        view.contentMode = .scaleAspectFit
    }
    // MARK: - Action
    @objc func refreshButtonAction() {
        vocaWeaveVM.isSelect = false
        vocaWeaveView.weaveVocaTextField.text = ""
        vocaWeaveView.responseDataText.text = ""
        vocaWeaveVM.refreshVocaData(buttons: buttonArray)
    }

    @objc func vocaButtonAction(_ sender: UIButton) {
        vocaWeaveVM.applyAnimation(textField: vocaWeaveView.weaveVocaTextField,
                                          text: sender.titleLabel?.text ?? "",
                                          view: vocaWeaveView.animationView)
        var changedText: String
        sender.isSelected.toggle()
        vocaWeaveVM.isSelect = sender.isSelected
        vocaWeaveVM.strikeButtonTapped(sender: sender)
        changedText = vocaWeaveVM.putButtonText(with: vocaWeaveView.weaveVocaTextField.text ?? "",
                                                       to: sender.titleLabel?.text ?? "")
        vocaWeaveView.weaveVocaTextField.text = changedText
        vocaWeaveVM.applyAnimation(textField: vocaWeaveView.weaveVocaTextField,
                                          text: sender.titleLabel?.text ?? "",
                                          view: vocaWeaveView.animationView)
    }

    @objc func nightModeButtonAction() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    if window.overrideUserInterfaceStyle == .dark {
                        window.overrideUserInterfaceStyle = .light
                        nightModeButton.image = UIImage(systemName: "moon")
                        nightModeButton.tintColor = .black
                        vocaWeaveView.responseDataText.layer.borderColor = UIColor.label.cgColor
                        buttonArray.forEach { vocaWeaveView.setButtonBorder(button: $0, color: UIColor.label.cgColor) }
                    } else {
                        window.overrideUserInterfaceStyle = .dark
                        nightModeButton.image = UIImage(systemName: "moon.fill")
                        nightModeButton.tintColor = .subTinkColor
                        vocaWeaveView.responseDataText.layer.borderColor = UIColor.white.cgColor
                        buttonArray.forEach { vocaWeaveView.setButtonBorder(button: $0, color: UIColor.white.cgColor) }
                    }
                }
            }
        }
    }

    @objc func copyButtonAction() {
        vocaWeaveVM.copyText(text: vocaWeaveView.weaveVocaTextField.text)
    }

    @objc func speakerButtonAction() {
        vocaWeaveVM.speakerAction(text: vocaWeaveView.weaveVocaTextField.text,
                                         language: Language.sourceLanguage.avLanguageTitle)
    }
}

extension VocaWeaveVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let sourceText = vocaWeaveView.weaveVocaTextField.text else { return false }
        Task {
            do {
                guard let responseData = try await vocaWeaveVM.fetchDataAndHandleResult(
                                                                        sourceText: sourceText) else { return }
                vocaWeaveView.responseDataText.text = responseData
            } catch {
                print("Task Response error")
            }
        }
        textField.resignFirstResponder()
        return true
    }
}
