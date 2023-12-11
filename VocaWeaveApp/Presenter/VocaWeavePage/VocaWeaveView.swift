//
//  VocaWeaveView.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/10/23.
//

import UIKit

class VocaWeaveView: UIView {
    // MARK: - Property
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
    }

    private func setupLayout() {
        let defaultValue = 8

    }
}
