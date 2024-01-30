//
//  DictionaryView.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit
import SnapKit
import Lottie

final class DictionaryView: UIView {
    // MARK: - Property
    let defaultValue = 8

    var animationView = LottieAnimationView()

    let sourceTextSpeakerButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "speaker.wave.2",
                                withConfiguration: imageConfig),
                                for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    let sourceTextCopyButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "doc.on.doc",
                                withConfiguration: imageConfig),
                                for: .normal)
        button.imageView?.contentMode = .scaleToFill
        return button
    }()

    lazy var sourceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()

    let cancelButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "multiply",
                                withConfiguration: imageConfig),
                                for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.tintColor = UIColor.label
        return button
    }()

    let sourceTextField: UITextField = {
        let textFeild = UITextField()
        textFeild.textColor = UIColor.label
        textFeild.borderStyle = .roundedRect
        textFeild.autocapitalizationType = .none
        textFeild.autocorrectionType = .no
        textFeild.spellCheckingType = .no
        textFeild.clearsOnBeginEditing = false
        textFeild.placeholder = "입력해 주세요."
        return textFeild
    }()

    let translatedTextSpeakerButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "speaker.wave.2",
                                withConfiguration: imageConfig),
                                for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    let translatedTextCopyButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "doc.on.doc",
                                withConfiguration: imageConfig),
                                for: .normal)
        button.imageView?.contentMode = .scaleToFill
        return button
    }()

    let bookmarkButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star",
                                withConfiguration: imageConfig),
                                for: .normal)
        button.tintColor = UIColor.subTinkColor
        return button
    }()

    lazy var explainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()

    let translationLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label
        label.text = "번역"
        return label
    }()

    let translationText: UITextView = {
        let textView = UITextView()
        textView.font = .boldSystemFont(ofSize: 18)
        textView.textColor = UIColor.label
        textView.isScrollEnabled = true
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.label.cgColor
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 15
        return textView
    }()
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configure()
        setupLayout()
        setupStackViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper
    private func configure() {
        [sourceTextSpeakerButton, sourceTextCopyButton].forEach {sourceStackView.addArrangedSubview($0)}

        [translatedTextSpeakerButton, translatedTextCopyButton].forEach {explainStackView.addArrangedSubview($0)}

        [sourceStackView, cancelButton, sourceTextField, bookmarkButton,
         explainStackView, translationText, translationLabel].forEach {self.addSubview($0)}
    }

    private func setupLayout() {
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(defaultValue * 4)
            $0.trailing.equalToSuperview()
        }
        sourceTextField.snp.makeConstraints {
            $0.top.equalTo(sourceStackView.snp.bottom).offset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultValue * 6)
        }

        bookmarkButton.snp.makeConstraints {
            $0.top.equalTo(explainStackView.snp.top)
            $0.trailing.equalToSuperview()
        }

        translationLabel.snp.makeConstraints {
            $0.top.equalTo(explainStackView.snp.bottom).offset(defaultValue)
            $0.leading.trailing.equalToSuperview().inset(defaultValue)
            $0.height.equalTo(defaultValue * 4)
        }

        translationText.snp.makeConstraints {
            $0.top.equalTo(translationLabel.snp.bottom).offset(defaultValue)
            $0.leading.trailing.equalToSuperview().inset(defaultValue)
            $0.bottom.equalToSuperview().inset(defaultValue * 2)
        }
    }

    private func setupStackViewLayout() {
        sourceStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(defaultValue * 4)
            $0.leading.equalToSuperview()
            $0.height.equalTo(defaultValue * 4)
        }

        explainStackView.snp.makeConstraints {
            $0.top.equalTo(sourceTextField.snp.bottom).offset(defaultValue * 6)
            $0.leading.equalToSuperview()
            $0.height.equalTo(defaultValue * 4)
        }
    }
}
