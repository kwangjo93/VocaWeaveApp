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
    let vocaWeaveView = VocaWeaveView()
    lazy var buttonArray = [vocaWeaveView.sourceTextButton1, vocaWeaveView.sourceTextButton2,
                       vocaWeaveView.sourceTextButton3, vocaWeaveView.sourceTextButton4,
                       vocaWeaveView.sourceTextButton5]
    lazy var refreshButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(refreshButtonAction))
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configure()
        setupLayout()
    }

    // MARK: - Helper
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
    }

    private func setupLayout() {
        let defaultValue = 8
        vocaWeaveView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    // MARK: - Action
    @objc private func refreshButtonAction() {

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
