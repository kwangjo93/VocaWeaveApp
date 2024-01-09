//
//  DictionaryView.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit
import SnapKit

class DictionaryView: UIView {
    // MARK: - Property
    let defaultValue = 8
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

    let explainView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.label.cgColor
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    let translationLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label
        label.text = "번역"
        return label
    }()

    let translationTextLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label
        return label
    }()

    let explanationLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label
        label.text = "설 명"
        return label
    }()

    let explanationTextLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label
        return label
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

        [sourceStackView, cancelButton, sourceTextField,
         bookmarkButton, explainStackView, explainView,
         translationTextLabel, translationLabel, explanationTextLabel,
         explanationLabel].forEach {self.addSubview($0)}
    }

    private func setupLayout() {
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(defaultValue * 2)
            $0.trailing.equalToSuperview()
        }
        sourceTextField.snp.makeConstraints {
            $0.top.equalTo(sourceStackView.snp.bottom).offset(defaultValue)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultValue * 5)
        }

        bookmarkButton.snp.makeConstraints {
            $0.top.equalTo(sourceTextField.snp.bottom).offset(defaultValue * 2)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(defaultValue * 4)
        }
        explainView.snp.makeConstraints {
            $0.top.equalTo(bookmarkButton.snp.bottom).offset(defaultValue)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(defaultValue * 8)
        }
        translationLabel.snp.makeConstraints {
            $0.top.equalTo(explainView.snp.top).inset(defaultValue)
            $0.leading.equalTo(explainView.snp.leading).inset(defaultValue)
            $0.trailing.equalTo(explainView.snp.trailing).inset(defaultValue)
            $0.height.equalTo(defaultValue * 4)
        }
        translationTextLabel.snp.makeConstraints {
            $0.top.equalTo(translationLabel.snp.bottom)
            $0.leading.equalTo(explainView.snp.leading)
            $0.trailing.equalTo(explainView.snp.trailing)
            $0.height.equalTo(defaultValue * 14)
        }
        explanationLabel.snp.makeConstraints {
            $0.top.equalTo(translationTextLabel.snp.bottom).inset(defaultValue)
            $0.leading.equalTo(explainView.snp.leading).inset(defaultValue)
            $0.trailing.equalTo(explainView.snp.trailing).inset(defaultValue)
            $0.height.equalTo(defaultValue * 4)
        }
        explanationTextLabel.snp.makeConstraints {
            $0.top.equalTo(explanationLabel.snp.bottom)
            $0.leading.equalTo(explainView.snp.leading)
            $0.trailing.equalTo(explainView.snp.trailing)
            $0.bottom.equalTo(explainView.snp.bottom)
        }
    }

    private func setupStackViewLayout() {
        sourceStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(defaultValue * 2)
            $0.leading.equalToSuperview()
            $0.height.equalTo(defaultValue * 4)
        }

        explainStackView.snp.makeConstraints {
            $0.top.equalTo(sourceTextField.snp.bottom).offset(defaultValue * 2)
            $0.leading.equalToSuperview()
            $0.height.equalTo(defaultValue * 4)
        }
    }
}
