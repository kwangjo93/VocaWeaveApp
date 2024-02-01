//
//  OnboardingVC.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 1/16/24.
//

import UIKit
import SnapKit

final class OnboardingVC: UIPageViewController {
    // MARK: - Property
    private var currentImageIndex: Int = 0

    private var images: [UIImage] = [
        UIImage(named: "step1")!,
        UIImage(named: "step2")!,
        UIImage(named: "step3")!,
        UIImage(named: "step4")!,
        UIImage(named: "step5")!
    ]

    private let backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        return backgroundView
    }()

    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        return button
    }()
    // MARK: - LifrCycle
    override func viewDidLoad() {
        setup()
    }
    // MARK: - Helper
    private func setup() {
        configure()
        setupLayout()
        buttonAction()
        setImageView()
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

    private func setImageView() {
        mainImageView.image = images[currentImageIndex]
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
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

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
         if gesture.direction == .left {
             showNextImage(withAnimation: true)
         } else if gesture.direction == .right {
             showPreviousImage(withAnimation: true)
         }
     }

    private  func showNextImage(withAnimation animate: Bool) {
        let newImageIndex = (currentImageIndex + 1) % images.count
        updateImageView(with: images[newImageIndex], animated: animate)
        currentImageIndex = newImageIndex
    }

    private func showPreviousImage(withAnimation animate: Bool) {
        let newImageIndex = (currentImageIndex - 1 + images.count) % images.count
        updateImageView(with: images[newImageIndex], animated: animate)
        currentImageIndex = newImageIndex
    }

    private func updateImageView(with newImage: UIImage, animated: Bool) {
        if animated {
            UIView.transition(with: mainImageView,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: {
                self.mainImageView.image = newImage
            }, completion: nil)
        } else {
            mainImageView.image = newImage
        }
    }
}
