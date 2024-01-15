//
//  VocaVC.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit
import Combine

final class VocaVC: UIViewController {
    // MARK: - Property
    let vocaTranslatedVM: VocaTranslatedVM
    let vocaListVM: VocaListVM
    let vocaView = VocaView(firstString: "나의 단어장", secondString: "사진 단어장")
    let searchController = UISearchController()
    var isSearchBarVisible = false
    var segmentIndex = 0

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
    init(vocaTranslatedVM: VocaTranslatedVM, vocaListVM: VocaListVM) {
        self.vocaTranslatedVM = vocaTranslatedVM
        self.vocaListVM = vocaListVM
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindModelData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTableData()
    }
    // MARK: - Helper
    private func setup() {
        configureNav()
        configureUI()
        setupSearchBar()
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
        vocaView.vocaSegmentedControl.selectedSegmentIndex = 0
        vocaView.vocaSegmentedControl.addTarget(self,
                                                action: #selector(valueChangeForSegmentedControl),
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

    private func setTableData() {
        switch segmentIndex {
        case 0:
            vocaListTableViewDatasourceSetup()
            vocaListTableViewSnapshot(with: vocaListVM.getMyVocaList())
        case 1:
            vocaTranslatedTableViewDatasourceSetup()
            vocaTranslatedTableViewSnapshot(with: vocaTranslatedVM.getVocaList())
        default:
            break
        }
    }

    private func bindModelData() {
        vocaListVM.alertPublisher
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        vocaListVM.tableViewUpdate
            .sink { [weak self] updatedVocaList in
                self?.vocaListTableViewSnapshot(with: updatedVocaList)
            }
            .store(in: &cancellables)
        vocaListVM.whitespacesAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        vocaTranslatedVM.alertPublisher
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        vocaTranslatedVM.tableViewUpdate
            .sink { [weak self] updatedVocaList in
                self?.vocaTranslatedTableViewSnapshot(with: updatedVocaList)
            }
            .store(in: &cancellables)
        vocaTranslatedVM.errorAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        vocaTranslatedVM.whitespacesAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        vocaTranslatedVM.duplicationAlertPublisher
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
    // MARK: - Action
    @objc private func plustButtonAction() {
        switch segmentIndex {
        case 0:
            vocaListVM.showAlertWithTextField(newData: nil)
        case 1:
            vocaTranslatedVM.showAlertWithTextField(currentView: self)
        default:
            break
        }
    }

    @objc private func valueChangeForSegmentedControl(_ sender: UISegmentedControl) {
        segmentIndex = sender.selectedSegmentIndex
        switch segmentIndex {
        case 0:
            vocaListTableViewDatasourceSetup()
            vocaListTableViewSnapshot(with: vocaListVM.getMyVocaList())
        case 1:
            vocaTranslatedTableViewDatasourceSetup()
            vocaTranslatedTableViewSnapshot(with: vocaTranslatedVM.getVocaList())
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
extension VocaVC {
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
            cell.vocaListViewModel = self.vocaListVM
            vocaListVM.setupCell(cell: cell,
                                        sourceText: data.sourceText,
                                        translatedText: data.translatedText,
                                        isSelected: data.isSelected,
                                        selectedSegmentIndex: self.segmentIndex)
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
extension VocaVC {
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
            cell.vocaTanslatedViewModel = self.vocaTranslatedVM
            vocaTranslatedVM.setupCell(cell: cell,
                                              sourceText: data.sourceText,
                                              translatedText: data.translatedText,
                                              isSelected: data.isSelected,
                                              selectedSegmentIndex: self.segmentIndex)
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
extension VocaVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = VocaTableViewHeaderView(reuseIdentifier: VocaTableViewHeaderView.identifier)
        let sectionTitle: String
        if segmentIndex == 0 {
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
            if segmentIndex == 0 {
                if let item = self.vocaListDataSource.itemIdentifier(for: indexPath) {
                    var snapshot = self.vocaListDataSource.snapshot()
                    snapshot.deleteItems([item])
                    self.vocaListDataSource.apply(snapshot, animatingDifferences: true)
                    vocaListVM.deleteVoca(item)
                }
                completionHandler(true)
            } else {
                if let item = self.vocaTranslatedDataSource.itemIdentifier(for: indexPath) {
                    var snapshot = self.vocaTranslatedDataSource.snapshot()
                    snapshot.deleteItems([item])
                    self.vocaTranslatedDataSource.apply(snapshot, animatingDifferences: true)
                    vocaTranslatedVM.deleteVoca(item)
                }
                completionHandler(true)
                }
            }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if segmentIndex == 0 {
            let vocaData = self.vocaListDataSource.itemIdentifier(for: indexPath)
            vocaListVM.showAlertWithTextField(newData: vocaData)
        } else {
            guard let sourceText = vocaTranslatedDataSource.itemIdentifier(
                                                            for: indexPath)?.sourceText else { return}
            vocaTranslatedVM.fetchDictionaryData(sourceText: sourceText,
                                                        currentView: self)
        }
    }
}
// MARK: - UISearchBarDelegate Delegate
extension VocaVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        switch segmentIndex {
        case 0:
            guard !searchText.isEmpty else {
                vocaListTableViewSnapshot(with: vocaListVM.getMyVocaList())
                   return
               }
            let filteredData = vocaListVM.getMyVocaList().filter { model in
                return model.sourceText.lowercased().contains(searchText.lowercased())
            }
            vocaListTableViewSnapshot(with: filteredData)
        case 1:
            guard !searchText.isEmpty else {
                vocaTranslatedTableViewSnapshot(with: vocaTranslatedVM.getVocaList())
                   return
               }
            let filteredData = vocaTranslatedVM.getVocaList().filter { model in
                return model.sourceText.lowercased().contains(searchText.lowercased())
            }
            vocaTranslatedTableViewSnapshot(with: filteredData)
        default:
            break
        }
    }
}

/// 외부에서 파일 넣는 것