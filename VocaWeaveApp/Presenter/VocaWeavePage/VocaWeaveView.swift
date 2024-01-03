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
    let defaultValue = 8

    let statusValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.textColor = UIColor.label
        label.text = "50 / 5"
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    let sourceTextButton1: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.label, for: .normal)
        button.tag = 0
        return button
    }()

    let sourceTextButton2: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.label, for: .normal)
        button.tag = 1
        return button
    }()

    let sourceTextButton3: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.label, for: .normal)
        button.tag = 2
        return button
    }()

    lazy var buttonstackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()

    let sourceTextButton4: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.label, for: .normal)
        button.tag = 3
        return button
    }()

    let sourceTextButton5: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.label, for: .normal)
        button.tag = 4
        return button
    }()

    lazy var buttonstackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()

    let weaveVocaTextField: UITextField = {
        let textFeild = UITextField()
        textFeild.textColor = UIColor.label
        textFeild.borderStyle = .roundedRect
        textFeild.autocapitalizationType = .none
        textFeild.autocorrectionType = .no
        textFeild.spellCheckingType = .no
        textFeild.clearsOnBeginEditing = false
        textFeild.placeholder = "영어를 입력해 주세요."
        return textFeild
    }()

    let responseLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = UIColor.label
        label.text = "해 석"
        return label
    }()

    let speakerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    let copyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        return button
    }()

    lazy var compsitionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()

    let responseDataLabel: UILabel = {
        let textView = UILabel()
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = UIColor.label
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.label.cgColor
        textView.layer.cornerRadius = 8.0
        return textView
    }()
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        configure()
        setupLayout()
        stackViewLayou()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper
    private func configure() {
        [sourceTextButton1, sourceTextButton2, sourceTextButton3].forEach { buttonstackView1.addArrangedSubview($0) }

        [sourceTextButton4, sourceTextButton5].forEach { buttonstackView2.addArrangedSubview($0) }

        [responseLabel, speakerButton, copyButton].forEach {compsitionStackView.addArrangedSubview($0)}

        [statusValueLabel, weaveVocaTextField, responseDataLabel,
         buttonstackView1, buttonstackView2, compsitionStackView].forEach { self.addSubview($0) }
    }

    private func setupLayout() {
        statusValueLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue)
            $0.height.equalTo(50)
        }

        weaveVocaTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(buttonstackView2.snp.bottom).offset(defaultValue * 3)
            $0.height.equalTo(45)
        }

        responseDataLabel.snp.makeConstraints {
            $0.top.equalTo(responseLabel.snp.bottom).offset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-(defaultValue * 10))
        }
    }

    private func stackViewLayou() {
        buttonstackView1.snp.makeConstraints {
            $0.top.equalTo(statusValueLabel.snp.bottom).offset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue)
        }

        buttonstackView2.snp.makeConstraints {
            $0.top.equalTo(buttonstackView1.snp.bottom).offset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 8)
        }

        compsitionStackView.snp.makeConstraints {
            $0.top.equalTo(weaveVocaTextField.snp.bottom).offset(defaultValue * 4)
            $0.leading.equalToSuperview()
            $0.height.equalTo(40)
        }
    }

    func setButtonBorder(button: UIButton, color: CGColor) {
        let borderWidth: CGFloat = 0.7
        let cornerRadius: CGFloat = 15
        let shadowOpacity: Float = 0.2

        button.layer.borderWidth = borderWidth
        button.layer.borderColor = color
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowColor = color
        button.layer.masksToBounds = true
        button.layer.shadowOpacity = shadowOpacity
        button.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
