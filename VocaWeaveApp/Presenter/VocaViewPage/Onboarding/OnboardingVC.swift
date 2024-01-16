//
//  OnboardingVC.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 1/16/24.
//

import UIKit
import SnapKit

class OnboardingVC: UIViewController {
    // MARK: - Property
    let onBoardingVM = OnboardingVM()
    let pageControl = UIPageControl()

    let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        return backgroundView
    }()

    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()

    let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        return button
    }()
    // MARK: - init
    // MARK: - LifrCycle
    override func viewDidLoad() {
        setup()
    }
    // MARK: - Helper
    private func setup() {
        configure()
        setupLayout()
        buttonAction()
    }

    private func configure() {
        [mainImageView, closeButton].forEach { backgroundView.addSubview($0) }
        view.addSubview(backgroundView)
    }

    private func setupLayout() {
        let defaultValue = 8
        let screenHeight = UIScreen.main.bounds.height
        let buttonStackViewHeight = min(screenHeight / 2 * 0.1, 30.0)
        let mainImageHeight = screenHeight / 2 - buttonStackViewHeight

        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(defaultValue * 4)
            $0.height.equalTo(screenHeight / 2)
        }
        mainImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(defaultValue)
            $0.bottom.equalTo(closeButton.snp.top)
            $0.height.equalTo(mainImageHeight)
        }
        closeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(defaultValue)
            $0.height.equalTo(buttonStackViewHeight)
        }
    }

    private func buttonAction() {
        closeButton.addTarget(self,
                              action: #selector(closeButtonAction),
                              for: .touchUpInside)
    }
    // MARK: - Action
    @objc private func closeButtonAction() {
        self.dismiss(animated: true)
    }
}
