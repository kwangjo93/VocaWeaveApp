//
//  VocaViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit
import Combine

class VocaViewController: UIViewController {
    // MARK: - Property
    let vocaTranslatedViewModel: VocaTranslatedViewModel
    let vocaListViewModel: VocaListViewModel
    let vocaView = VocaView()

    var vocaListDataSource: UITableViewDiffableDataSource<Section, RealmVocaModel>!
    var vocaListSnapshot: NSDiffableDataSourceSnapshot<Section, RealmVocaModel>!
    var vocaTranslatedDataSource: UITableViewDiffableDataSource<Section, RealmTranslateModel>!
    var vocaTranslatedSnapshot: NSDiffableDataSourceSnapshot<Section, RealmTranslateModel>!

    var cancellables = Set<AnyCancellable>()

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
    init(vocaTranslatedManager: VocaTranslatedViewModel, vocaListManager: VocaListViewModel) {
        self.vocaTranslatedViewModel = vocaTranslatedManager
        self.vocaListViewModel = vocaListManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        modelDataBinding()
    }
    // MARK: - Helper
    private func setup() {
        vocaView.vocaTableView.register(
            VocaTableViewCell.self,
            forCellReuseIdentifier: VocaTableViewCell.identifier)
        vocaView.vocaSegmentedControl.selectedSegmentIndex = 0
        vocaView.vocaSegmentedControl.addTarget(self,
                                                action: #selector(vocaSegmentedControlValueChanged),
                                                for: .valueChanged)
        configureNav()
        configureUI()
        vocaListTableViewDatasourceSetup()
        vocaListTableViewSnapshot()
    }

    private func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "단어장"
            label.textColor = UIColor.label
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem

        let nightModeButton = nightModeBarButtonItem(
            target: self,
            action: #selector(nightModeButtonAction))
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

    private func modelDataBinding() {
        vocaListViewModel.alertPublisher
            .sink { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellables)
        vocaListViewModel.tableViewUpdate
            .sink { [weak self] updatedVocaList in
                self?.updateItem(with: updatedVocaList)
            }
            .store(in: &cancellables)
    }
    // MARK: - Action
    @objc private func plustButtonAction() {
        vocaListViewModel.showAlertWithTextField()
    }
    @objc private func vocaSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        switch selectedSegmentIndex {
        case 0:
            vocaListTableViewDatasourceSetup()
            vocaListTableViewSnapshot()
        case 1:
            vocaTranslatedTableViewDatasourceSetup()
            vocaTranslatedTableViewSnapshot()
        default:
            break
        }
    }

    @objc private func nightModeButtonAction() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                if let window = windowScene.windows.first {
                    if window.overrideUserInterfaceStyle == .dark {
                        window.overrideUserInterfaceStyle = .light
                    } else {
                        window.overrideUserInterfaceStyle = .dark
                    }
                }
            }
        }
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

// MARK: - VocaList TableView Diffable DataSource
extension VocaViewController {
    private func vocaListTableViewDatasourceSetup() {
        vocaListDataSource = UITableViewDiffableDataSource<Section, RealmVocaModel>(
            tableView: vocaView.vocaTableView
        ) { (tableView: UITableView, indexPath: IndexPath, identifier: RealmVocaModel) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: VocaTableViewCell.identifier,
                for: indexPath
            ) as? VocaTableViewCell else {
                return UITableViewCell()
            }
            let dataArray = self.vocaListViewModel.getVocaList()[indexPath.row]
            cell.sourceLabel.text = dataArray.sourceText
            cell.translatedLabel.text = dataArray.translatedText
            return cell
        }
    }

    private func vocaListTableViewSnapshot() {
        vocaListSnapshot = NSDiffableDataSourceSnapshot<Section, RealmVocaModel>()
        vocaListSnapshot.appendSections([.voca])
        vocaListSnapshot.appendItems(vocaListViewModel.getVocaList(), toSection: .voca)
        vocaListDataSource.apply(vocaListSnapshot, animatingDifferences: true)
    }

    func updateItem(with newData: [RealmVocaModel]) {
        var currentSnapshot = vocaListDataSource.snapshot()
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([.voca])
        currentSnapshot.appendItems(vocaListViewModel.getVocaList(), toSection: .voca)
        vocaListDataSource.apply(currentSnapshot, animatingDifferences: true)
    }
}

// MARK: - VocaTranslated TableView Diffable DataSource
extension VocaViewController {
    private func vocaTranslatedTableViewDatasourceSetup() {
        vocaTranslatedDataSource = UITableViewDiffableDataSource<Section, RealmTranslateModel>(
            tableView: vocaView.vocaTableView
        ) { (tableView: UITableView, indexPath: IndexPath, identifier: RealmTranslateModel) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: VocaTableViewCell.identifier,
                for: indexPath
            ) as? VocaTableViewCell else {
                return UITableViewCell()
            }
            let dataArray = self.vocaTranslatedViewModel.getVocaList()[indexPath.row]
            cell.sourceLabel.text = dataArray.sourceText
            cell.translatedLabel.text = dataArray.translatedText
            return cell
        }
    }

    private func vocaTranslatedTableViewSnapshot() {
        vocaTranslatedSnapshot = NSDiffableDataSourceSnapshot<Section, RealmTranslateModel>()
        vocaTranslatedSnapshot.appendSections([.voca])
        vocaTranslatedSnapshot.appendItems(vocaTranslatedViewModel.getVocaList(), toSection: .voca)
        vocaTranslatedDataSource.apply(vocaTranslatedSnapshot, animatingDifferences: true)
    }

}


///데이터 창고 두개 만들기 -> 세크먼트를 눌렀을 경우 다른 뷰 보이기
///테이블 뷰의 섹션 알파벳순으로 나누기
///삭제하기
///수정하기
///발음 듣기
///북마크 표시 시 데이터 저장
///사전 API 연결
///검색 서치바 구현
