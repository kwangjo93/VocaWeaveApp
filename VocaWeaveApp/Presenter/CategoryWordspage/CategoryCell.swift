//
//  CagtegoryCell.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/10/23.
//

import UIKit
import SnapKit

final class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = UIColor.label
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        contentView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
