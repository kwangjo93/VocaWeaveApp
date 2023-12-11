//
//  VocaWeaveView.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/10/23.
//

import UIKit
import SnapKit

class VocaWeaveView: UIView {
    // MARK: - Property
    let statusValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "50 / 5"
        return label
    }()

    let sourceTextButton1: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("UPDATE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    let sourceTextButton2: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("UPDATE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    let sourceTextButton3: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("UPDATE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    let sourceTextButton4: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("UPDATE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    let sourceTextButton5: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("UPDATE", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    let weaveVocaTextField: UITextField = {
        let tf = UITextField()
        tf.frame.size.height = 22
        tf.textColor = .black
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.clearsOnBeginEditing = false
        tf.placeholder = "영어를 입력해 주세요."
        return tf
    }()

    let responseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "50 / 5"
        return label
    }()

    let responseDataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    let speakerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        return button
    }()

    let copyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        return button
    }()
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configure()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper
    private func configure() {
        [statusValueLabel,sourceTextButton1,sourceTextButton2,
         sourceTextButton3,sourceTextButton4,sourceTextButton5,
         weaveVocaTextField,responseLabel,responseDataLabel,
         speakerButton,copyButton].forEach { self.addSubview($0) }
    }

    private func setupLayout() {
        let defaultValue = 8
        statusValueLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview().inset(defaultValue * 2)
        }

        sourceTextButton1.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(statusValueLabel.snp.bottom).offset(defaultValue * 2)
        }

        sourceTextButton2.snp.makeConstraints {
            $0.leading.equalTo(sourceTextButton1.snp.trailing).offset(defaultValue * 2)
            $0.top.equalTo(statusValueLabel.snp.bottom).offset(defaultValue * 2)
        }

        sourceTextButton3.snp.makeConstraints {
            $0.leading.equalTo(sourceTextButton2.snp.trailing).offset(defaultValue * 2)
            $0.top.equalTo(statusValueLabel.snp.bottom).offset(defaultValue * 2)
            $0.trailing.equalToSuperview()
        }

        sourceTextButton4.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(defaultValue * 4)
            $0.top.equalTo(sourceTextButton1.snp.bottom).offset(defaultValue * 2)
        }

        sourceTextButton5.snp.makeConstraints {
            $0.leading.equalTo(sourceTextButton4.snp.trailing).offset(defaultValue * 4)
            $0.top.equalTo(sourceTextButton1.snp.bottom).offset(defaultValue * 2)
            $0.trailing.equalToSuperview().inset(defaultValue * 4)
        }

        weaveVocaTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(sourceTextButton5.snp.bottom).offset(defaultValue * 2)
        }

        responseLabel.snp.makeConstraints {
            $0.top.equalTo(weaveVocaTextField.snp.bottom).offset(defaultValue * 2)
            $0.leading.equalToSuperview()
        }

        responseDataLabel.snp.makeConstraints {
            $0.top.equalTo(responseLabel.snp.bottom).offset(defaultValue)
            $0.leading.trailing.equalToSuperview()
        }

        copyButton.snp.makeConstraints {
            $0.top.equalTo(responseDataLabel.snp.bottom).offset(defaultValue)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(defaultValue * 2)
        }

        speakerButton.snp.makeConstraints {
            $0.top.equalTo(responseDataLabel.snp.bottom).offset(defaultValue)
            $0.trailing.equalTo(copyButton.snp.leading).offset(-(defaultValue * 2))
            $0.bottom.equalToSuperview().inset(defaultValue * 2)
        }
    }
}
