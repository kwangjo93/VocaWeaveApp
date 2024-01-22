//
//  EmptyView.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 1/22/24.
//

import UIKit
import SnapKit

final class EmptyListView: UIView {
    // MARK: - Property
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(systemName: "rectangle.portrait.on.rectangle.portrait.slash.fill") {
            let systemImage = image.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
            imageView.image = systemImage
            imageView.contentMode = .scaleAspectFit
            imageView.snp.makeConstraints {
                $0.width.equalTo(80)
                $0.height.equalTo(80)
            }
        }
        return imageView
    }()

    private let firstLabel: UILabel = {
        let label = UILabel()
        label.text = "추가한 데이터가 없습니다."
        label.textColor = .lightGray
        label.font = UIFont(name: "GapyeongHanseokbongL", size: 24)
        return label
    }()

    private let secondLabel: UILabel = {
        let label = UILabel()
        label.text = "+ 버튼을 눌러서 단어를 추가해주세요."
        label.textColor = .lightGray
        label.font = UIFont(name: "GapyeongHanseokbongL", size: 24)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    private func setupViews() {
        [emptyImageView, firstLabel, secondLabel].forEach { stackView.addArrangedSubview($0)}
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
