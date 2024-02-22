//
//  VocaWeaveView.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/10/23.
//

import UIKit
import SnapKit
import Lottie

final class VocaWeaveView: UIView {
    // MARK: - Property
    private let defaultValue = 8
    var animationView = LottieAnimationView()

    let statusValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25)
        label.textColor = UIColor.label
        label.numberOfLines = 1
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()

    let selectedCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 27)
        label.textColor = UIColor.label
        label.numberOfLines = 1
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()

    private lazy var countLabelstackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()

    let lackOfDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GapyeongHanseokbongL", size: 20)
        label.textColor = UIColor.errorColor
        label.numberOfLines = 1
        return label
    }()

    let sourceTextButton1: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont(name: "GapyeongHanseokbongL", size: 20)
        button.setTitleColor(UIColor.label, for: .normal)
        button.tag = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()

    let sourceTextButton2: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "GapyeongHanseokbongL", size: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()

    let sourceTextButton3: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "GapyeongHanseokbongL", size: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()

    let sourceTextButton4: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "GapyeongHanseokbongL", size: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()

    let sourceTextButton5: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont(name: "GapyeongHanseokbongL", size: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()

    private lazy var buttonstackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var buttonstackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .fillEqually
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

    private let responseLabel: UILabel = {
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

    private lazy var compsitionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()

    let responseDataText: UITextView = {
        let textView = UITextView()
        textView.contentMode = .topLeft
        textView.font = .systemFont(ofSize: 20)
        textView.textColor = UIColor.label
        textView.isScrollEnabled = true
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.label.cgColor
        textView.layer.cornerRadius = 15
        textView.textAlignment = .left
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
private extension VocaWeaveView {
    func configure() {
        [sourceTextButton1, sourceTextButton2, sourceTextButton3].forEach { buttonstackView1.addArrangedSubview($0) }

        [sourceTextButton4, sourceTextButton5].forEach { buttonstackView2.addArrangedSubview($0) }

        [responseLabel, speakerButton, copyButton].forEach {compsitionStackView.addArrangedSubview($0)}

        [statusValueLabel, selectedCountLabel].forEach { countLabelstackView.addArrangedSubview($0)}

        [lackOfDataLabel, weaveVocaTextField, responseDataText, buttonstackView1, animationView,
         countLabelstackView, buttonstackView2, compsitionStackView].forEach { self.addSubview($0) }
    }

    func setupLayout() {
        lackOfDataLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.height.equalTo(60)
        }

        weaveVocaTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(buttonstackView2.snp.bottom).offset(defaultValue * 3)
            $0.height.equalTo(45)
        }

        responseDataText.snp.makeConstraints {
            $0.top.equalTo(responseLabel.snp.bottom).offset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset((defaultValue * 10))
        }
    }

    func stackViewLayou() {
        countLabelstackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 15)
            $0.height.equalTo(50)
        }

        buttonstackView1.snp.makeConstraints {
            $0.top.equalTo(countLabelstackView.snp.bottom).offset(defaultValue * 2)
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

}
