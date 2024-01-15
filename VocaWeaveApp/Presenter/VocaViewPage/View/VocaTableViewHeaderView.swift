//
//  VocaTableViewHeaderView.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/15/23.
//

import UIKit
import SnapKit

final class VocaTableViewHeaderView: UITableViewHeaderFooterView {
    static let identifier = "VocaTableViewHeaderView"
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    func configure(title: String) {
        titleLabel.text = title
    }

}
