//
//  CategoryDetailVC.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/20/23.
//

import UIKit
import Combine

final class CategoryDetailVC: UIViewController {
    // MARK: - Property
    private let firstString: String
    private let secondString: String
    private let navigationTitle: String
    private lazy var detailView = VocaView(firstString: firstString, secondString: secondString)
    private var selectedSegmentIndex = 0
    private var indexPath: Int
    private let distinguishSavedData: Bool
    private var cancellables = Set<AnyCancellable>()
    private let categoryViewModel: CategoryVM

    private var firstVocaData: [RealmVocaModel]?
    private var secondVocaData: [RealmVocaModel]?
    private var dicData: [RealmTranslateModel]?

    private var vocaListDataSource: UITableViewDiffableDataSource<Section, RealmVocaModel>!
    private var vocaListSnapshot: NSDiffableDataSourceSnapshot<Section, RealmVocaModel>!
    private var vocaTranslatedDataSource: UITableViewDiffableDataSource<Section, RealmTranslateModel>!
    private var vocaTranslatedSnapshot: NSDiffableDataSourceSnapshot<Section, RealmTranslateModel>!

    private lazy var backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(backBarButtonAction))
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let firstVocaData = firstVocaData else { return }
        vocaListTableViewDatasourceSetup()
        vocaListTableViewSnapshot(with: firstVocaData)
    }
    // MARK: - init
    init(firstString: String,
         secondString: String,
         navigationTitle: String,
         indexPath: Int,
         categoryViewModel: CategoryVM,
         distinguishSavedData: Bool) {
        self.firstString = firstString
        self.secondString = secondString
        self.navigationTitle = navigationTitle
        self.indexPath = indexPath
        self.categoryViewModel = categoryViewModel
        self.distinguishSavedData = distinguishSavedData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Method
    func bindVocaData() {
            switch self.indexPath {
            case 0:
                setupSelectedVoca()
            case 1...7:
                setupSelectedCategoryVoca()
            default:
                break
            }
        }
}
private extension CategoryDetailVC {
    // MARK: - Helper
    func setup() {
        configureNav()
        configureUI()
        detailView.vocaTableView.delegate = self
    }

    func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = self.navigationTitle
            label.textColor = UIColor.label
            label.font = .boldSystemFont(ofSize: 25)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItems = [backBarButton, titleItem]
        navigationController?.configureBasicAppearance()
    }

    func configureUI() {
        view.addSubview(detailView)
        detailView.vocaTableView.register(
                                        VocaTableViewCell.self,
                                        forCellReuseIdentifier: VocaTableViewCell.identifier)
        detailView.vocaTableView.register(
                                        VocaTableViewHeaderView.self,
                                        forHeaderFooterViewReuseIdentifier: VocaTableViewHeaderView.identifier)
        detailView.vocaSegmentedControl.selectedSegmentIndex = 0
        detailView.vocaSegmentedControl.addTarget(self,
                                                action: #selector(valueChangeForSegmentedControl),
                                                for: .valueChanged)

        let defaultValue = 8
        detailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func bindCellData(cell: VocaTableViewCell) {
        cell.vocaListTableViewUpdate
            .sink { [weak self] updatedVocaList in
                self?.vocaListTableViewSnapshot(with: updatedVocaList)
            }
            .store(in: &cancellables)
        cell.vocaTranslatedTableViewUpdate
            .sink { [weak self] updatedVocaList in
                self?.vocaTranslatedTableViewSnapshot(with: updatedVocaList)
            }
            .store(in: &cancellables)
    }

    func setupVocaData(_ firstVocaDatas: [RealmVocaModel]?,
                               _ secondVocaDatas: [RealmVocaModel]?) {
        switch selectedSegmentIndex {
        case 0:
            self.firstVocaData = firstVocaDatas
            guard let firstData = firstVocaData else { return }
            vocaListTableViewDatasourceSetup()
            vocaListTableViewSnapshot(with: firstData)
        case 1:
            if let secondData = secondVocaDatas {
                self.secondVocaData = secondData
                vocaListTableViewDatasourceSetup()
                vocaListTableViewSnapshot(with: secondData)
            }
        default:
            break
        }
    }

    func setupSelectedVoca() {
        switch selectedSegmentIndex {
        case 0:
            setupVocaData(categoryViewModel.selectedVoca.filter { $0.isSelected }, nil)
        case 1:
            self.dicData = categoryViewModel.selectedDic.filter { $0.isSelected }
            guard let dicData = dicData else { return }
            vocaTranslatedTableViewDatasourceSetup()
            vocaTranslatedTableViewSnapshot(with: dicData)
        default:
            break
        }
    }

    func setupSelectedCategoryVoca() {
        switch self.indexPath {
        case 1: setupVocaData(categoryViewModel.transportationVoca, nil)
        case 2: setupVocaData(categoryViewModel.accommodationVoca, nil)
        case 3: setupVocaData(categoryViewModel.travelActivitiesVoca, categoryViewModel.travelEssentialsVoca)
        case 4: setupVocaData(categoryViewModel.diningVoca, categoryViewModel.cultureVoca)
        case 5: setupVocaData(categoryViewModel.leisureVoca, nil)
        case 6: setupVocaData(categoryViewModel.communicationVoca, nil)
        case 7: setupVocaData(categoryViewModel.facilitiesVoca, nil)
        default: return
        }
    }
    // MARK: - Action
    @objc func valueChangeForSegmentedControl(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        switch selectedSegmentIndex {
        case 0, 1:
            bindVocaData()
        default:
            break
        }
    }

    @objc func backBarButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - VocaList TableView Diffable DataSource
extension CategoryDetailVC {
        private func vocaListTableViewDatasourceSetup() {
            vocaListDataSource = UITableViewDiffableDataSource<Section, RealmVocaModel>(
                tableView: detailView.vocaTableView
            ) { [weak self] (tableView: UITableView, indexPath: IndexPath, _: RealmVocaModel)
                -> UITableViewCell? in
                guard let self = self,
                      let cell = tableView.dequeueReusableCell(
                                            withIdentifier: VocaTableViewCell.identifier,
                                            for: indexPath) as? VocaTableViewCell
                                            else { return UITableViewCell() }
                guard let data = self.vocaListDataSource.itemIdentifier(for: indexPath) else { return cell}
                cell.vocaListData = data
                cell.bindVocaListData()
                cell.configureBookmark()
                cell.vocaListViewModel = categoryViewModel.vocaListVM
                cell.selectedSegmentIndex = selectedSegmentIndex
                cell.distinguishSavedData = distinguishSavedData
                cell.firstVocaData = self.firstVocaData
                cell.secondVocaData = self.secondVocaData
                cell.allVocaData = categoryViewModel.selectedVoca
                bindCellData(cell: cell)
                cell.selectionStyle = .none
                return cell
            }
        }

        private func vocaListTableViewSnapshot(with newData: [RealmVocaModel]?) {
            guard let newData = newData else { return }
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
extension CategoryDetailVC {
    private func vocaTranslatedTableViewDatasourceSetup() {
        vocaTranslatedDataSource = UITableViewDiffableDataSource<Section, RealmTranslateModel>(
            tableView: detailView.vocaTableView
        ) { [weak self] (tableView: UITableView, indexPath: IndexPath, _: RealmTranslateModel)
            -> UITableViewCell? in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(
                      withIdentifier: VocaTableViewCell.identifier,
                      for: indexPath) as? VocaTableViewCell
                      else { return UITableViewCell() }
            guard let data = self.vocaTranslatedDataSource.itemIdentifier(for: indexPath)
                                                                                else { return cell}
            cell.vocaTanslatedData = data
            cell.bindVocaTranslatedData()
            cell.configureBookmark()
            cell.vocaTanslatedViewModel = categoryViewModel.vocaTranslatedVM
            cell.selectedSegmentIndex = selectedSegmentIndex
            cell.distinguishSavedData = distinguishSavedData
            bindCellData(cell: cell)
            cell.selectionStyle = .none
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
extension CategoryDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = VocaTableViewHeaderView(reuseIdentifier: VocaTableViewHeaderView.identifier)

        let sectionTitle: String
        if selectedSegmentIndex == 0 {
            let snapshot = vocaListDataSource.snapshot()
            sectionTitle = snapshot.sectionIdentifiers[section].title
        } else {
            if distinguishSavedData {
                let snapshot = vocaTranslatedDataSource.snapshot()
                sectionTitle = snapshot.sectionIdentifiers[section].title
            } else {
                let snapshot = vocaListDataSource.snapshot()
                sectionTitle = snapshot.sectionIdentifiers[section].title
            }
        }
        headerView.configure(title: sectionTitle)
        return headerView
    }
}
