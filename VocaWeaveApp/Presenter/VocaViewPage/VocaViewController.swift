//
//  VocaViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit
import Combine

final class VocaViewController: UIViewController {
    // MARK: - Property
    let vocaTranslatedViewModel: VocaTranslatedViewModel
    let vocaListViewModel: VocaListViewModel
    let vocaView = VocaView(firstString: "나의 단어장", secondString: "사진 단어장")
    let searchController = UISearchController()
    var isSearchBarVisible = false
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
        setup()
        modelDataBinding()
        setupSearchBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vocaView.vocaSegmentedControl.selectedSegmentIndex = 0
        vocaListTableViewDatasourceSetup()
        vocaListTableViewSnapshot(with: vocaListViewModel.getVocaList())
    }
    // MARK: - Helper
    private func setup() {
        configureNav()
        configureUI()
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
        view.addSubview(vocaView)
        vocaView.vocaTableView.register(
            VocaTableViewCell.self,
            forCellReuseIdentifier: VocaTableViewCell.identifier)
        vocaView.vocaTableView.register(VocaTableViewHeaderView.self,
                                        forHeaderFooterViewReuseIdentifier: VocaTableViewHeaderView.identifier)
        vocaView.vocaSegmentedControl.addTarget(self,
                                                action: #selector(vocaSegmentedControlValueChanged),
                                                for: .valueChanged)

        let defaultValue = 8
        vocaView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "검색어 입력"
        definesPresentationContext = true
        searchController.isActive = false // 초기에는 검색 바를 숨김
    }

    private func modelDataBinding() {
        vocaListViewModel.alertPublisher
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        vocaListViewModel.tableViewUpdate
            .sink { [weak self] updatedVocaList in
                self?.vocaListTableViewSnapshot(with: updatedVocaList)
            }
            .store(in: &cancellables)
        vocaListViewModel.whitespacesAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        vocaTranslatedViewModel.alertPublisher
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        vocaTranslatedViewModel.tableViewUpdate
            .sink { [weak self] updatedVocaList in
                self?.vocaTranslatedTableViewSnapshot(with: updatedVocaList)
            }
            .store(in: &cancellables)
        vocaTranslatedViewModel.errorAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        vocaTranslatedViewModel.whitespacesAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchController.searchBar.searchTextField.resignFirstResponder()
        navigationItem.searchController = nil
    }

    private func setupCell(cell: VocaTableViewCell,
                           sourceText: String,
                           translatedText: String,
                           isSelected: Bool,
                           selectedSegmentIndex: Int) {
        cell.sourceLabel.text = sourceText
        cell.translatedLabel.text = translatedText
        cell.isSelect = isSelected
        cell.selectedSegmentIndex = selectedSegmentIndex
        cell.configureBookmark()
        cell.speakerButtonAction()
        cell.selectionStyle = .none
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
        if navigationItem.searchController != nil {
                navigationItem.searchController = nil
            } else {
                navigationItem.searchController = searchController
            }
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

            guard let data = self.vocaListDataSource.itemIdentifier(for: indexPath) else { return cell}
            cell.vocaListData = data
            cell.vocaListViewModel = self.vocaListViewModel
            setupCell(cell: cell,
                      sourceText: data.sourceText,
                      translatedText: data.translatedText,
                      isSelected: data.isSelected,
                      selectedSegmentIndex: self.selectedSegmentIndex)
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

            guard let data = self.vocaTranslatedDataSource.itemIdentifier(for: indexPath)
                                                                                else { return cell}
            cell.vocaTanslatedData = data
            cell.vocaTanslatedViewModel = self.vocaTranslatedViewModel
            setupCell(cell: cell,
                      sourceText: data.sourceText,
                      translatedText: data.translatedText,
                      isSelected: data.isSelected,
                      selectedSegmentIndex: self.selectedSegmentIndex)
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
        } else {
            let snapshot = vocaTranslatedDataSource.snapshot()
            sectionTitle = snapshot.sectionIdentifiers[section].title
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
        print(indexPath.row)
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
// MARK: - UISearchBarDelegate Delegate
extension VocaViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch selectedSegmentIndex {
        case 0:
            guard !searchText.isEmpty else {
                vocaListTableViewSnapshot(with: vocaListViewModel.getVocaList())
                   return
               }
            let filteredData = vocaListViewModel.getVocaList().filter { model in
                return model.sourceText.lowercased().contains(searchText.lowercased())
            }
            vocaListTableViewSnapshot(with: filteredData)
        case 1:
            guard !searchText.isEmpty else {
                vocaTranslatedTableViewSnapshot(with: vocaTranslatedViewModel.getVocaList())
                   return
               }
            let filteredData = vocaTranslatedViewModel.getVocaList().filter { model in
                return model.sourceText.lowercased().contains(searchText.lowercased())
            }
            vocaTranslatedTableViewSnapshot(with: filteredData)
        default:
            break
        }
    }
}

/// dictionaryView text UI 처리(정렬, 간격 등)
/// 다크모드 버튼을 눌러서가 아니라 시스템 자체에서 다크 모드일 경우 에도 대응..? 고민해보자
/// 페이지네이션 구현
/// 텍스트 인식 (후행 스페이스 포함시키도록)
