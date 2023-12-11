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
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black
        label.text = "50 / 5"
        label.textAlignment = .center
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

    lazy var buttonstackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
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

    lazy var buttonstackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()

    let weaveVocaTextField: UITextField = {
        let textFeild = UITextField()
        textFeild.frame.size.height = 22
        textFeild.textColor = .black
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
        label.textColor = .black
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

    let responseDataLabel: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .black
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.cornerRadius = 8.0
        return textView
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
        [sourceTextButton1, sourceTextButton2, sourceTextButton3].forEach { buttonstackView1.addArrangedSubview($0) }

        [sourceTextButton4, sourceTextButton5].forEach { buttonstackView2.addArrangedSubview($0) }

        [responseLabel, speakerButton, copyButton].forEach {compsitionStackView.addArrangedSubview($0)}

        [statusValueLabel, weaveVocaTextField, responseDataLabel,
         buttonstackView1, buttonstackView2, compsitionStackView].forEach { self.addSubview($0) }

        [sourceTextButton1, sourceTextButton2, sourceTextButton3,
         sourceTextButton4, sourceTextButton5].forEach { setButtonBorder(button: $0) }
    }

    private func setupLayout() {
        let defaultValue = 8
        statusValueLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(defaultValue * 2)
            $0.width.equalTo(100)
            $0.height.equalTo(50)
        }

        buttonstackView1.snp.makeConstraints {
            $0.top.equalTo(statusValueLabel.snp.bottom).offset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue)
        }

        sourceTextButton4.snp.makeConstraints {
            $0.width.equalTo(sourceTextButton1)
        }

        sourceTextButton5.snp.makeConstraints {
            $0.width.equalTo(sourceTextButton3)
        }

        buttonstackView2.snp.makeConstraints {
            $0.top.equalTo(buttonstackView1.snp.bottom).offset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 8)
        }

        weaveVocaTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(buttonstackView2.snp.bottom).offset(defaultValue * 3)
            $0.height.equalTo(45)
        }

        compsitionStackView.snp.makeConstraints {
            $0.top.equalTo(weaveVocaTextField.snp.bottom).offset(defaultValue * 4)
            $0.leading.equalToSuperview()
            $0.height.equalTo(40)
        }

        responseDataLabel.snp.makeConstraints {
            $0.top.equalTo(responseLabel.snp.bottom).offset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-(defaultValue * 10))
        }
    }

    func setButtonBorder(button: UIButton) {
        let borderWidth: CGFloat = 0.5
        let cornerRadius: CGFloat = 15
        let shadowOpacity: Float = 0.2

        button.layer.borderWidth = borderWidth
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = cornerRadius
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.masksToBounds = true
        button.layer.shadowOpacity = shadowOpacity
        button.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
