//
//  VocaWeaveViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/10/23.
//

import UIKit
import SnapKit

class VocaWeaveViewController: UIViewController {
    // MARK: - Property
    let vocaWeaveViewModel: VocaWeaveViewModel
    let vocaWeaveView = VocaWeaveView()
    lazy var buttonArray = [vocaWeaveView.sourceTextButton1, vocaWeaveView.sourceTextButton2,
                       vocaWeaveView.sourceTextButton3, vocaWeaveView.sourceTextButton4,
                       vocaWeaveView.sourceTextButton5]
    lazy var refreshButton = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(refreshButtonAction))
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setVocaData()
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

    private func setVocaData() {
        let vocaData = vocaWeaveViewModel.getVocaList()
        let randomVocaCount = 5
        if vocaData.count < 5 {
            vocaWeaveView.statusValueLabel.text = "저장 된 단어가 5개 미만입니다."
        } else {
            vocaWeaveView.statusValueLabel.text = "\(vocaData.count - 5) / \(randomVocaCount)"
            configureVocaButton()
        }
    }

    private func configureVocaButton() {
        let vocaList = vocaWeaveViewModel.getVocaList().shuffled().prefix(5)
        let vocaButtons = [
            vocaWeaveView.sourceTextButton1,
            vocaWeaveView.sourceTextButton2,
            vocaWeaveView.sourceTextButton3,
            vocaWeaveView.sourceTextButton4,
            vocaWeaveView.sourceTextButton5
        ]
        for (index, button) in vocaButtons.enumerated() {
            if index < vocaList.count {
                button.setTitle(vocaList[index].sourceText, for: .normal)
            } else {
                button.setTitle("", for: .normal)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // MARK: - Action
    @objc private func refreshButtonAction() {

    }

    @objc private func vocaButtonAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        vocaWeaveViewModel.isSelect = sender.isSelected
        var changedText: String
        vocaWeaveViewModel.strikeButtonAction(sender: sender)
        changedText = vocaWeaveViewModel.putButtonText(with: vocaWeaveView.weaveVocaTextField.text ?? "",
                                                       to: sender.titleLabel?.text ?? "")
        vocaWeaveView.weaveVocaTextField.text = changedText
    }

    @objc private func nightModeButtonAction() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    if window.overrideUserInterfaceStyle == .dark {
                        window.overrideUserInterfaceStyle = .light
                        vocaWeaveView.responseDataLabel.layer.borderColor = UIColor.label.cgColor
                        buttonArray.forEach { vocaWeaveView.setButtonBorder(button: $0, color: UIColor.label.cgColor) }
                    } else {
                        window.overrideUserInterfaceStyle = .dark
                        vocaWeaveView.responseDataLabel.layer.borderColor = UIColor.white.cgColor
                        buttonArray.forEach { vocaWeaveView.setButtonBorder(button: $0, color: UIColor.white.cgColor) }
                    }
                }
            }
        }
    }
}
