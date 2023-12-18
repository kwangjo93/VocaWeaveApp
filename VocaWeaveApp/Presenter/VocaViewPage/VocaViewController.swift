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
    var selectedSegmentIndex = 0

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
        let text = "감자"
        print(text.getFirstLetter())
        setup()
        modelDataBinding()
    }
    // MARK: - Helper
    private func setup() {
        vocaView.vocaTableView.register(
            VocaTableViewCell.self,
            forCellReuseIdentifier: VocaTableViewCell.identifier)
        vocaView.vocaTableView.register(VocaTableViewHeaderView.self,
                                        forHeaderFooterViewReuseIdentifier: VocaTableViewHeaderView.identifier)
        vocaView.vocaSegmentedControl.selectedSegmentIndex = 0
        vocaView.vocaSegmentedControl.addTarget(self,
                                                action: #selector(vocaSegmentedControlValueChanged),
                                                for: .valueChanged)
        configureNav()
        configureUI()
        vocaListTableViewDatasourceSetup()
        vocaListTableViewSnapshot(with: vocaListViewModel.getVocaList())

        vocaView.vocaTableView.delegate = self
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
                self?.vocaListTableViewSnapshot(with: updatedVocaList)
            }
            .store(in: &cancellables)

        vocaTranslatedViewModel.alertPublisher
            .sink { [weak self] alert in
                self?.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancellables)

        vocaTranslatedViewModel.tableViewUpdate
            .sink { [weak self] updatedVocaList in
                self?.vocaTranslatedTableViewSnapshot(with: updatedVocaList)
            }
            .store(in: &cancellables)
    }
    // MARK: - Action
    @objc private func plustButtonAction() {
        switch selectedSegmentIndex {
        case 0:
            vocaListViewModel.showAlertWithTextField(newData: nil)
        case 1:
            vocaTranslatedViewModel.showAlertWithTextField(currentView: self)
        default:
            break
        }
    }
    @objc private func vocaSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        switch selectedSegmentIndex {
        case 0:
            vocaListTableViewDatasourceSetup()
            vocaListTableViewSnapshot(with: vocaListViewModel.getVocaList())
        case 1:
            vocaTranslatedTableViewDatasourceSetup()
            vocaTranslatedTableViewSnapshot(with: vocaTranslatedViewModel.getVocaList())
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

}

// MARK: - VocaList TableView Diffable DataSource
extension VocaViewController {
    private func vocaListTableViewDatasourceSetup() {
        vocaListDataSource = UITableViewDiffableDataSource<Section, RealmVocaModel>(
            tableView: vocaView.vocaTableView
        ) { [weak self] (tableView: UITableView, indexPath: IndexPath, _: RealmVocaModel) -> UITableViewCell? in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(
                      withIdentifier: VocaTableViewCell.identifier,
                      for: indexPath
                  ) as? VocaTableViewCell else {
                return UITableViewCell()
            }

            let data = self.vocaListDataSource.itemIdentifier(for: indexPath)
            cell.vocaListData = data
            cell.vocaListViewModel = self.vocaListViewModel
            cell.sourceLabel.text = data?.sourceText
            cell.translatedLabel.text = data?.translatedText
            cell.isSelect = data!.isSelected
            cell.configureBookmark()
            cell.speakerButtonAction()
            return cell
        }
    }

    private func vocaListTableViewSnapshot(with newData: [RealmVocaModel]) {
        vocaListSnapshot = NSDiffableDataSourceSnapshot<Section, RealmVocaModel>()
        let sections = Section.allCases
        for section in sections {
                   let itemsInSection = newData.filter { $0.section == section.title }
                   if !itemsInSection.isEmpty {
                       vocaListSnapshot.appendSections([section])
                       vocaListSnapshot.appendItems(itemsInSection, toSection: section)
                   }
               }
        vocaListDataSource.apply(vocaListSnapshot, animatingDifferences: true)
    }

}

// MARK: - VocaTranslated TableView Diffable DataSource
extension VocaViewController {
    private func vocaTranslatedTableViewDatasourceSetup() {
        vocaTranslatedDataSource = UITableViewDiffableDataSource<Section, RealmTranslateModel>(
            tableView: vocaView.vocaTableView
        ) { [weak self] (tableView: UITableView, indexPath: IndexPath, _: RealmTranslateModel) -> UITableViewCell? in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(
                      withIdentifier: VocaTableViewCell.identifier,
                      for: indexPath
                  ) as? VocaTableViewCell else {
                return UITableViewCell()
            }

            let data = self.vocaTranslatedDataSource.itemIdentifier(for: indexPath)
            cell.vocaTanslatedData = data
            cell.vocaTanslatedViewModel = self.vocaTranslatedViewModel
            cell.sourceLabel.text = data?.sourceText
            cell.translatedLabel.text = data?.translatedText
            cell.isSelect = data!.isSelected
            cell.configureBookmark()
            cell.speakerButtonAction()
            return cell
        }
    }

    private func vocaTranslatedTableViewSnapshot(with newData: [RealmTranslateModel]) {
        vocaTranslatedSnapshot = NSDiffableDataSourceSnapshot<Section, RealmTranslateModel>()
        let sections = Section.allCases
        for section in sections {
                   let itemsInSection = newData.filter { $0.section == section.title }
                   if !itemsInSection.isEmpty {
                       vocaTranslatedSnapshot.appendSections([section])
                       vocaTranslatedSnapshot.appendItems(itemsInSection, toSection: section)
                   }
               }
        vocaTranslatedDataSource.apply(vocaTranslatedSnapshot, animatingDifferences: true)
    }
}

// MARK: - TableView Delegate
extension VocaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = VocaTableViewHeaderView(reuseIdentifier: VocaTableViewHeaderView.identifier)

        let sectionTitle: String
        if selectedSegmentIndex == 0 {
            let snapshot = vocaListDataSource.snapshot()
            sectionTitle = snapshot.sectionIdentifiers[section].title
            vocaListViewModel.toggleHeaderVisibility(sectionTitle: sectionTitle,
                                                     headerView: headerView)
        } else {
            let snapshot = vocaTranslatedDataSource.snapshot()
            sectionTitle = snapshot.sectionIdentifiers[section].title
            vocaTranslatedViewModel.toggleHeaderVisibility(sectionTitle: sectionTitle,
                                                           headerView: headerView)
        }
        headerView.configure(title: sectionTitle)
        return headerView
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { [weak self] (_, _, completionHandler) in
                   guard let self = self else { return }
            if selectedSegmentIndex == 0 {
                if let item = self.vocaListDataSource.itemIdentifier(for: indexPath) {
                    var snapshot = self.vocaListDataSource.snapshot()
                    snapshot.deleteItems([item])
                    self.vocaListDataSource.apply(snapshot, animatingDifferences: true)
                    vocaListViewModel.deleteVoca(item)
                }
                completionHandler(true)
            } else {
                if let item = self.vocaTranslatedDataSource.itemIdentifier(for: indexPath) {
                    var snapshot = self.vocaTranslatedDataSource.snapshot()
                    snapshot.deleteItems([item])
                    self.vocaTranslatedDataSource.apply(snapshot, animatingDifferences: true)
                    vocaTranslatedViewModel.deleteVoca(item)
                }
                completionHandler(true)
                }
            }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSegmentIndex == 0 {
            let vocaData = self.vocaListDataSource.itemIdentifier(for: indexPath)
            vocaListViewModel.showAlertWithTextField(newData: vocaData)
        } else {
            guard let sourceText = vocaTranslatedDataSource.itemIdentifier(
                                                            for: indexPath)?.sourceText else { return}
            vocaTranslatedViewModel.fetchDictionaryData(sourceText: sourceText,
                                                        currentView: self)
        }
    }
}

/// dictionaryView text UI 처리(정렬, 간격 등)
/// 한글 대응
/// 검색 서치바 구현
/// 키보드 설정(return 키, 아무것도 입력하지 않았을 때의 표시,) - textField Delegate
/// 다른 언어로 검색 시 경고알림
