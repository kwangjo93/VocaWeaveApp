//
//  DictionaryViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/11/23.
//

import UIKit

class DictionaryViewController: UIViewController {
    // MARK: - Property
    let dictionaryView = DictionaryView()

    lazy var backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backBarButtonAction))

    lazy var addRightBarButton = UIBarButtonItem(title: "추 가",
                                     style: .plain,
                                     target: self,
                                     action: #selector(addRightBarButtonAction))
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
            label.text = "사 전"
            label.textColor = .black
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem

        let nightModeButton = nightModeBarButtonItem(
                                target: self,
                                action: #selector(nightModeBuutonAction))
        navigationItem.rightBarButtonItem = nightModeButton
        navigationController?.configureBasicAppearance()
    }

    private func configure() {
        view.addSubview(dictionaryView)
    }

    private func setupLayout() {
        let defaultValue = 8
        dictionaryView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(defaultValue * 2)
        }
    }
    // MARK: - Action
    @objc private func addRightBarButtonAction() {

    }

    @objc private func nightModeBuutonAction() {

    }

    @objc private func backBarButtonAction() {

    }
}
