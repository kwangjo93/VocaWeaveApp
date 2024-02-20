//
//  VocaTableViewCell.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit
import SnapKit
import AVFoundation
import Lottie

final class VocaTableViewCell: UITableViewCell {
    // MARK: - Property
    static let identifier = "VocaTableViewCell"
    private var animationView = LottieAnimationView()
    var viewModel: VocaCellVM?
    let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Sejong hospital Light", size: 18)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()

    let translatedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Sejong hospital Light", size: 18)
        label.textColor = UIColor.label
        label.numberOfLines = 0
        return label
    }()

    private let speakerButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "speaker.wave.2", withConfiguration: imageConfig),
                        for: .normal)
        button.tintColor = UIColor.subTinkColor
        return button
    }()

    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = UIColor.subTinkColor
        return button
    }()
    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setupLayout()
        speakerButtonTapped()
        vocaBookmarkButtonTapped()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Method
    func configureBookmark() {
        guard let viewModel = viewModel else { return }
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        if viewModel.isSelect == true {
            bookmarkButton.setImage(UIImage(systemName: "star.fill",
                                            withConfiguration: imageConfig),
                                            for: .normal)
        } else {
            bookmarkButton.setImage(UIImage(systemName: "star",
                                            withConfiguration: imageConfig),
                                            for: .normal)
        }
    }
}

private extension VocaTableViewCell {
    // MARK: - Helper
    func configure() {
        [sourceLabel,
         translatedLabel,
         speakerButton,
         bookmarkButton].forEach { contentView.addSubview($0) }
    }

    func setupLayout() {
        let defaultValue = 8

        sourceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(defaultValue * 2)
            $0.top.bottom.equalToSuperview().inset(defaultValue)
            $0.width.equalTo(120)
        }

        translatedLabel.snp.makeConstraints {
            $0.leading.equalTo(sourceLabel.snp.trailing).offset(defaultValue * 2)
            $0.top.equalTo(sourceLabel.snp.top)
            $0.bottom.equalTo(sourceLabel.snp.bottom)
            $0.width.equalTo(120)
        }

        speakerButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(defaultValue)
        }

        bookmarkButton.snp.makeConstraints {
            $0.leading.equalTo(speakerButton.snp.trailing).offset(defaultValue)
            $0.top.bottom.equalToSuperview().inset(defaultValue)
            $0.trailing.equalToSuperview().inset(defaultValue * 2)
        }
    }

    func setupAnimationView() {
        bookmarkButton.addSubview(animationView)
        let animation = LottieAnimation.named("starfill")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.isHidden = true
        animationView.frame = CGRect(x: -37, y: -37, width: 100, height: 100)
    }

    func speakerButtonTapped() {
        speakerButton.addTarget(self, action: #selector(speakerButtonAction), for: .touchUpInside)
    }

    func vocaBookmarkButtonTapped() {
        bookmarkButton.addTarget(self, action: #selector(vocaBookmarkButtonAction), for: .touchUpInside)
    }
    // MARK: - Action
    @objc  func speakerButtonAction() {
        guard let viewModel = viewModel else { return }
        viewModel.speakerButtonAction(sourceText: sourceLabel.text)
    }

    @objc func vocaBookmarkButtonAction() {
        guard let viewModel = viewModel else { return }
        setupAnimationView()
        viewModel.isSelect.toggle()
        if viewModel.isSelect {
            viewModel.updateBookmarkData(isSelect: true, button: bookmarkButton)
            animationView.isHidden = false
            animationView.play { [weak self] _ in
                self?.animationView.isHidden = true
            }
        } else {
            viewModel.updateBookmarkData(isSelect: false, button: bookmarkButton)
        }
    }
}
