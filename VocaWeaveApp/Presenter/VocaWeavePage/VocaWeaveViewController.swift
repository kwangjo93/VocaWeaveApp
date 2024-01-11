//
//  VocaWeaveViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/10/23.
//

import UIKit
import SnapKit
import Combine
import Lottie

class VocaWeaveViewController: UIViewController {
    // MARK: - Property
    let vocaWeaveViewModel: VocaWeaveViewModel
    let vocaWeaveView = VocaWeaveView()
    lazy var buttonArray = [vocaWeaveView.sourceTextButton1, vocaWeaveView.sourceTextButton2,
                       vocaWeaveView.sourceTextButton3, vocaWeaveView.sourceTextButton4,
                       vocaWeaveView.sourceTextButton5]
    var cancellables = Set<AnyCancellable>()
    lazy var refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(refreshButtonAction))
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureAnimation(vocaWeaveView.animationView)
        vocaWeaveViewModel.setRandomVocaData(buttons: buttonArray)
    }
    // MARK: - init
    init(vocaWeaveViewModel: VocaWeaveViewModel) {
        self.vocaWeaveViewModel = vocaWeaveViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helper
    private func setup() {
        configureNav()
        configure()
        setupLayout()
        modelDataBinding()
    }

    private func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "학습장"
            label.textColor = UIColor.label
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem

        let nightModeButton = nightModeBarButtonItem(
                                target: self,
                                action: #selector(nightModeButtonAction))
        navigationItem.rightBarButtonItems = [refreshButton, nightModeButton]
        navigationController?.configureBasicAppearance()
    }

    private func configure() {
        view.addSubview(vocaWeaveView)
        vocaWeaveView.weaveVocaTextField.delegate = self
        vocaWeaveView.responseDataText.isEditable = false
        buttonArray.forEach { vocaWeaveView.setButtonBorder(button: $0, color: UIColor.label.cgColor) }

        buttonArray.forEach { $0.addTarget(self,
                                           action: #selector(vocaButtonAction),
                                           for: .touchUpInside) }
    }

    private func setupLayout() {
        let defaultValue = 8
        vocaWeaveView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func modelDataBinding() {
        vocaWeaveViewModel.errorAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        vocaWeaveViewModel.selectedCountCountPublisher
            .sink { [weak self] count in
                self?.vocaWeaveView.selectedCountLabel.text = "/   \(count)"
            }
            .store(in: &cancellables)

        vocaWeaveViewModel.setupStatusCountPublisher
            .sink { [weak self] count in
                self?.vocaWeaveView.statusValueLabel.text = String(count)
                self?.vocaWeaveView.statusValueLabel.isHidden = false
                self?.vocaWeaveView.selectedCountLabel.isHidden = false
                self?.vocaWeaveView.lackOfDataLabel.isHidden = true
            }
            .store(in: &cancellables)

        vocaWeaveViewModel.setupStatusTextPublisher
            .sink { [weak self] text in
                self?.vocaWeaveView.statusValueLabel.isHidden = true
                self?.vocaWeaveView.selectedCountLabel.isHidden = true
                self?.vocaWeaveView.lackOfDataLabel.isHidden = false
                self?.vocaWeaveView.lackOfDataLabel.text = text
            }
            .store(in: &cancellables)
    }

    private func configureAnimation(_ view: LottieAnimationView) {
        let animation = LottieAnimation.named("disappear")
        view.animation = animation
        view.loopMode = .playOnce
        view.contentMode = .scaleAspectFit
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // MARK: - Action
    @objc private func refreshButtonAction() {
        vocaWeaveViewModel.refreshVocaData(buttons: buttonArray)
        vocaWeaveViewModel.isSelect = false
        vocaWeaveView.weaveVocaTextField.text = ""
    }

    @objc private func vocaButtonAction(_ sender: UIButton) {
        vocaWeaveViewModel.applyAnimation(textField: vocaWeaveView.weaveVocaTextField,
                                          text: sender.titleLabel?.text ?? "",
                                          view: vocaWeaveView.animationView)
        var changedText: String
        sender.isSelected.toggle()
        vocaWeaveViewModel.isSelect = sender.isSelected
        vocaWeaveViewModel.strikeButtonAction(sender: sender)
        changedText = vocaWeaveViewModel.putButtonText(with: vocaWeaveView.weaveVocaTextField.text ?? "",
                                                       to: sender.titleLabel?.text ?? "")
        vocaWeaveView.weaveVocaTextField.text = changedText
        vocaWeaveViewModel.applyAnimation(textField: vocaWeaveView.weaveVocaTextField,
                                          text: sender.titleLabel?.text ?? "",
                                          view: vocaWeaveView.animationView)
    }

    @objc private func nightModeButtonAction() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    if window.overrideUserInterfaceStyle == .dark {
                        window.overrideUserInterfaceStyle = .light
                        vocaWeaveView.responseDataText.layer.borderColor = UIColor.label.cgColor
                        buttonArray.forEach { vocaWeaveView.setButtonBorder(button: $0, color: UIColor.label.cgColor) }
                    } else {
                        window.overrideUserInterfaceStyle = .dark
                        vocaWeaveView.responseDataText.layer.borderColor = UIColor.white.cgColor
                        buttonArray.forEach { vocaWeaveView.setButtonBorder(button: $0, color: UIColor.white.cgColor) }
                    }
                }
            }
        }
    }
}

extension VocaWeaveViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let sourceText = vocaWeaveView.weaveVocaTextField.text else { return false }
        Task {
            do {
                guard let responseData = try await vocaWeaveViewModel.fetchDataAndHandleResult(
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

// 추후 ai 랑 연결할지 고민
