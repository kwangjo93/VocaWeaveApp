//
//  DictionaryViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit

class DictionaryViewController: UIViewController {
    // MARK: - Property
    let dictionaryView = DictionaryView()
    let dictionaryViewModel = DictionaryViewModel()
    var vocaTranslatedData: RealmTranslateModel?
    var dictionaryEnum: DictionaryEnum = .new

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
    }

    // MARK: - init
    init(vocaTranslatedData: RealmTranslateModel?,
         dictionaryEnum: DictionaryEnum) {
        self.vocaTranslatedData = vocaTranslatedData
        self.dictionaryEnum = dictionaryEnum
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
        navigationItem.leftBarButtonItem = titleItem

        let nightModeButton = nightModeBarButtonItem(
                                target: self,
                                action: #selector(nightModeBuutonAction))
        navigationItem.rightBarButtonItem = nightModeButton
        navigationController?.configureBasicAppearance()
    }

    private func configure() {
        guard let vocaTranslatedData = vocaTranslatedData else { return }
        if dictionaryEnum == .response {
            dictionaryView.sourceTextField.text = vocaTranslatedData.sourceText
            dictionaryView.translationTextLabel.text = vocaTranslatedData.translatedText
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

    // MARK: - Action
    @objc private func addRightBarButtonAction() {
        dictionaryView
        dictionaryView
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

    @objc private func backBarButtonAction() {

    }
}
