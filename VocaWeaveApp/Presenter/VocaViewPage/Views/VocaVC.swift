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
    private let vocaTranslatedVM: VocaTranslatedVM
    private let vocaListVM: VocaListVM
    private let vocaView = VocaView()
    private let emptyView = EmptyListView()
    private let searchController = UISearchController()
    private var segmentIndex = 0
    private var vocaListDataSource: VocaListDataSource!
    private var apiVocaListDataSource: APIVocaListDatasource!
    private var vocaSearchHandler: VocaSearchHandler?
    private var documentPicker: VocaDocumentPicker?
    private var cancellables = Set<AnyCancellable>()

    private lazy var plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(plustButtonAction))

    private lazy var searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(searchButtonAction))
    private lazy var nightModeButton = nightModeBarButtonItem(target: self,
                                                 action: #selector(nightModeButtonAction))
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
        bindVocaListModelData()
        bindAPIVocaListModelData()
        vocaListVM.manageEmptyView(vocaVC: self,
                                   emptyView: emptyView,
                                   tableView: vocaView.vocaTableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTableData()
        setNightButton(button: nightModeButton)
    }
    // MARK: - Helper
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchController.searchBar.searchTextField.resignFirstResponder()
        navigationItem.searchController = nil
    }
}
// MARK: - UISetting
private extension VocaVC {
    private func setup() {
        configureNav()
        configureUI()
        setVocaListDatasource()
        setupSearchBar()
        setDocumentPicker()
        vocaView.vocaTableView.delegate = self
    }

    func setDocumentPicker() {
        documentPicker = VocaDocumentPicker(viewController: self, vocaListVM: vocaListVM)
    }

    func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "단어장"
            label.textColor = UIColor.label
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem
        navigationItem.rightBarButtonItems = [plusButton, searchButton, nightModeButton]
        navigationController?.configureBasicAppearance()
    }

    func configureUI() {
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

    func setupSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "검색어 입력"
        definesPresentationContext = true
        searchController.isActive = false
        vocaSearchHandler = VocaSearchHandler(vocaListVM: vocaListVM,
                                              vocaTranslatedVM: vocaTranslatedVM,
                                              vocaView: vocaView,
                                              emptyView: emptyView,
                                              segmentIndex: segmentIndex,
                                              viewHandler: self)
    }
}
// MARK: - Data Binding
private extension VocaVC {
    func bindVocaListModelData() {
        vocaListVM.alertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        vocaListVM.tableViewUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedVocaList in
                self?.bindSnapshotVocaData(voca: updatedVocaList)
            }
            .store(in: &cancellables)
        vocaListVM.whitespacesAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }

    func bindAPIVocaListModelData() {
        vocaTranslatedVM.alertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
        vocaTranslatedVM.tableViewUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedVocaList in
                self?.bindSnapshotAPIVocaData(voca: updatedVocaList)
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
        vocaTranslatedVM.vocaAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
}
// MARK: - TableView Setting
private extension VocaVC {
    func setTableData() {
        switch segmentIndex {
        case 0:
            setVocaListDatasource()
            bindSnapshotVocaData(voca: vocaListVM.vocaList)
        case 1:
            setAPIVocaListDataSource()
            bindSnapshotAPIVocaData(voca: vocaTranslatedVM.vocaList)
        default:
            break
        }
    }

    func setVocaListDatasource() {
        vocaListDataSource = VocaListDataSource(tableView: vocaView.vocaTableView,
                                                vocaListVM: vocaListVM,
                                                segmentIndex: segmentIndex)
        vocaView.vocaTableView.dataSource = vocaListDataSource
    }

    func setAPIVocaListDataSource() {
        apiVocaListDataSource = APIVocaListDatasource(tableView: vocaView.vocaTableView,
                                                      vocaTranlsatedVM: vocaTranslatedVM,
                                                      segmentIndex: segmentIndex)
        vocaView.vocaTableView.dataSource = apiVocaListDataSource
    }

    func bindSnapshotVocaData(voca: [RealmVocaModel]) {
        vocaListDataSource.vocaListTableViewSnapshot(with: voca) {
            vocaListVM.manageEmptyView(vocaVC: self,
                                       emptyView: emptyView,
                                       tableView: vocaView.vocaTableView)
        }
    }

    func bindSnapshotAPIVocaData(voca: [RealmTranslateModel]) {
        apiVocaListDataSource.vocaTranslatedTableViewSnapshot(with: voca) {
            vocaTranslatedVM.manageEmptyView(vocaVC: self,
                                             emptyView: emptyView,
                                             tableView: vocaView.vocaTableView)
        }
    }
}
// MARK: - objc Action
private extension VocaVC {
    @objc func plustButtonAction() {
        switch segmentIndex {
        case 0:
            guard let documentPicker = documentPicker else { return }
            vocaListVM.presentActionMenu(view: self, loadAction: documentPicker.showDocumentPicker)
        case 1:
            vocaTranslatedVM.showAlertWithTextField(currentView: self)
        default:
            break
        }
    }

    @objc func valueChangeForSegmentedControl(_ sender: UISegmentedControl) {
        segmentIndex = sender.selectedSegmentIndex
        switch segmentIndex {
        case 0:
            setVocaListDatasource()
            bindSnapshotVocaData(voca: vocaListVM.vocaList)
        case 1:
           setAPIVocaListDataSource()
            bindSnapshotAPIVocaData(voca: vocaTranslatedVM.vocaList)
        default:
            break
        }
    }

    @objc func nightModeButtonAction() {
        vocaListVM.nightModeButtonAction(button: nightModeButton)
    }

    @objc func searchButtonAction() {
        vocaListVM.searchButtonAction(view: self, searchController: searchController)
    }
}
// MARK: - TableView Delegate
extension VocaVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = VocaTableViewHeaderView(reuseIdentifier: VocaTableViewHeaderView.identifier)
        let sectionTitle: String
        if segmentIndex == 0 {
            let snapshot = vocaListDataSource.snapshot()
            sectionTitle = snapshot.sectionIdentifiers[section].title
        } else {
            let snapshot = apiVocaListDataSource.snapshot()
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
                    self.vocaListDataSource.apply(snapshot,
                                                  animatingDifferences: true)
                    vocaListVM.deleteVoca(item)
                    vocaListVM.manageEmptyView(vocaVC: self,
                                               emptyView: emptyView,
                                               tableView: vocaView.vocaTableView)
                }
                completionHandler(true)
            } else if segmentIndex == 1 {
                if let item = self.apiVocaListDataSource.itemIdentifier(for: indexPath) {
                    var snapshot = self.apiVocaListDataSource.snapshot()
                    snapshot.deleteItems([item])
                    self.apiVocaListDataSource.apply(snapshot,
                                                     animatingDifferences: true)
                    vocaTranslatedVM.deleteVoca(item)
                    vocaTranslatedVM.manageEmptyView(vocaVC: self,
                                                     emptyView: emptyView,
                                                     tableView: vocaView.vocaTableView)
                }
                completionHandler(true)
                }
            }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentIndex == 0 {
            let vocaData = self.vocaListDataSource.itemIdentifier(for: indexPath)
            vocaListVM.showAlertWithTextField(newData: vocaData)
        } else {
            guard let vocaData = apiVocaListDataSource.itemIdentifier(for: indexPath) else { return }
            vocaTranslatedVM.editDictionaryData(currentView: self, vocaData: vocaData)
        }
    }
}
// MARK: - UISearchBarDelegate Delegate
extension VocaVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vocaSearchHandler?.handleSearchTextChange(searchText,
                                                  segmentIndex: segmentIndex,
                                                  voca: { voca in bindSnapshotVocaData(voca: voca) },
                                                  apiVoca: { voca in bindSnapshotAPIVocaData(voca: voca)})
    }
}
