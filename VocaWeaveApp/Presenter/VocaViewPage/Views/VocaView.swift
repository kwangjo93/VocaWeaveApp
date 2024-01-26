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
    let firstSegmentTitle: String
    let secondSegmentTitle: String
    var vocaSegmentedControl: UISegmentedControl
    let vocaTableView = UITableView()

    // MARK: - init
    init(firstString: String, secondString: String) {
        self.firstSegmentTitle = firstString
        self.secondSegmentTitle = secondString
        self.vocaSegmentedControl = UISegmentedControl(items:
                                                [firstSegmentTitle, secondSegmentTitle])
        super.init(frame: .zero)
        backgroundColor = .systemBackground
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
        if firstSegmentTitle == "", secondSegmentTitle == "" {
            self.addSubview(vocaTableView)
        } else {
            [vocaSegmentedControl, vocaTableView].forEach { self.addSubview($0) }
        }
    }

    private func setupLayout() {
        let defaultValue = 8

        if firstSegmentTitle == "", secondSegmentTitle == "" {
            vocaTableView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(defaultValue)
                $0.top.bottom.equalToSuperview()
            }
        } else {
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

}
