//
//  VocaViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit

class VocaViewController: UIViewController {
    // MARK: - Property
    let dataManager: VocaListType
    let vocaView = VocaView()
    lazy var plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(plustButtonAction))

    lazy var searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(searchButtonAction))
    let networking = NetworkingManager.shared

    // MARK: - init
    init(dataManager: VocaListType) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureUI()
        setup()
    }
    // MARK: - Helper
    private func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "단어장"
            label.textColor = .black
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem

        let nightModeButton = nightModeBarButtonItem(
                                target: self,
                                action: #selector(nightModeBuutonAction))
        navigationItem.rightBarButtonItems = [plusButton, searchButton, nightModeButton]
        navigationController?.configureBasicAppearance()
    }

    private func configureUI() {
        let defaultValue = 8
        view.addSubview(vocaView)

        vocaView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    private func setup() {
        vocaView.vocaTableView.dataSource = self
        vocaView.vocaTableView.register(
                                VocaTableViewCell.self,
                                forCellReuseIdentifier: VocaTableViewCell.identifier)
        vocaView.vocaSegmentedControl.selectedSegmentIndex = 0
        vocaView.vocaSegmentedControl.addTarget(self,
                                                action: #selector(vocaSegmentedControlValueChanged),
                                                for: .valueChanged)
    }

    // MARK: - Action
    @objc private func plustButtonAction() {
        fetchDataAndHandleResult()
    }
    @objc private func vocaSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        print("Selected Segment Index: \(selectedSegmentIndex)")
    }

    @objc private func nightModeBuutonAction() {
    }

    @objc private func searchButtonAction() {

    }
    func fetchDataAndHandleResult() {
        Task {
            do {
                let result = try await networking.fetchData(source: "ko", target: "en", text: "안녕하세요")
                print("번역 결과: \(result.translatedText )")
            } catch {
                print("에러 발생: \(error)")
            }
        }
    }

}

extension VocaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                                    withIdentifier: VocaTableViewCell.identifier,
                                    for: indexPath)
                            as? VocaTableViewCell else { return UITableViewCell()}
        cell.bindingData()
        return cell
    }
}
