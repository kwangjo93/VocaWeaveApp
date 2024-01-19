//
//  CagtegoryCell.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/10/23.
//

import UIKit
import SnapKit

final class CagtegoryCell: UICollectionViewCell {
    static let identifier = "CagtegoryCollectionViewCell"

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "GapyeongHanseokbongL", size: 20)
        label.textColor = UIColor.label
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .systemCyan
        contentView.layer.cornerRadius = 15

        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
