//
//  VocaView.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit
import SnapKit

final class VocaView: UIView {
    // MARK: - Property
    var vocaSegmentedControl: UISegmentedControl
    let vocaTableView = UITableView()
    // MARK: - init
    init() {
        self.vocaSegmentedControl = UISegmentedControl(items: ["나의 단어장", "사진 단어장"])
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        vocaSegmentedControl.backgroundColor = .mainTintColor
        configure()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper
    private func configure() {
        let attributes = [NSAttributedString.Key.font:
                            UIFont(name: "GapyeongHanseokbongL", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)]
        vocaSegmentedControl.setTitleTextAttributes(attributes, for: .normal)
        [vocaSegmentedControl, vocaTableView].forEach { self.addSubview($0) }
    }

    private func setupLayout() {
        let defaultValue = 8

        vocaSegmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 3)
            $0.height.equalTo(30)
        }
        vocaTableView.snp.makeConstraints {
            $0.top.equalTo(vocaSegmentedControl.snp.bottom).offset(defaultValue)
            $0.leading.trailing.equalToSuperview().inset(defaultValue)
            $0.bottom.equalToSuperview()
        }
    }
}
