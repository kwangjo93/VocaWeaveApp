//
//  VocaWeaveViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/10/23.
//

import UIKit
import SnapKit

class VocaWeaveViewController: UIViewController {
    // MARK: - Property
    let vocaWeaveView = VocaWeaveView()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configure()
        setupLayout()
    }

    // MARK: - Helper
    private func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "학습장"
            label.textColor = .black
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem
        navigationController?.configureBasicAppearance()
    }

    private func configure() {
        view.addSubview(vocaWeaveView)
    }

    private func setupLayout() {
        let defaultValue = 8
        vocaWeaveView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.bottom.equalToSuperview()
        }
    }
    // MARK: - Action

}
