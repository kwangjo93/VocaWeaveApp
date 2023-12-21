//
//  CategoryDetailViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/20/23.
//

import UIKit
import Combine

class CategoryDetailViewController: UIViewController {
    // MARK: - Property
    let firstString: String
    let secondString: String
    let navigationTitle: String
    lazy var detailView = VocaView(firstString: firstString, secondString: secondString)
    var selectedSegmentIndex = 0
    var indexPath: Int
    let distinguishSavedData: Bool
    var cancellables = Set<AnyCancellable>()
    let categoryViewModel: CategoryViewModel

    var firstVocaData: [RealmVocaModel]?
    var secondVocaData: [RealmVocaModel]?
    var dicData: [RealmTranslateModel]?

    var vocaListDataSource: UITableViewDiffableDataSource<Section, RealmVocaModel>!
    var vocaListSnapshot: NSDiffableDataSourceSnapshot<Section, RealmVocaModel>!
    var vocaTranslatedDataSource: UITableViewDiffableDataSource<Section, RealmTranslateModel>!
    var vocaTranslatedSnapshot: NSDiffableDataSourceSnapshot<Section, RealmTranslateModel>!

    lazy var backBarButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backBarButtonAction))
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    // MARK: - init
    init(firstString: String,
         secondString: String,
         navigationTitle: String,
         indexPath: Int,
         categoryViewModel: CategoryViewModel,
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

    // MARK: - Helper
    private func setup() {
        configureNav()
        configureUI()
        detailView.vocaTableView.delegate = self
        vocaListTableViewDatasourceSetup()
        vocaListTableViewSnapshot(with: firstVocaData)
    }

    private func configureNav() {
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

    private func configureUI() {
        view.addSubview(detailView)
        detailView.vocaTableView.register(
                                        VocaTableViewCell.self,
                                        forCellReuseIdentifier: VocaTableViewCell.identifier)
        detailView.vocaTableView.register(
                                VocaTableViewHeaderView.self,
                                forHeaderFooterViewReuseIdentifier: VocaTableViewHeaderView.identifier)
        detailView.vocaSegmentedControl.selectedSegmentIndex = 0
        detailView.vocaSegmentedControl.addTarget(self,
                                                action: #selector(vocaSegmentedControlValueChanged),
                                                for: .valueChanged)

        let defaultValue = 8
        detailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func bindCellData(cell: VocaTableViewCell) {
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

    private func setupVocaData(_ firstVocaDatas: [RealmVocaModel]?, _ secondVocaDatas: [RealmVocaModel]?) {
        self.firstVocaData = firstVocaDatas
        guard let firstData = firstVocaData else { return }

        vocaListTableViewDatasourceSetup()
        vocaListTableViewSnapshot(with: firstData)

        if let secondData = secondVocaData {
            self.secondVocaData = secondData
            vocaListTableViewDatasourceSetup()
            vocaListTableViewSnapshot(with: secondVocaData)
        }
    }

    func bindVocaData(index: Int) {
        switch index {
        case 0:
            let selectedVoca = categoryViewModel.selectedVoca.filter { $0.isSelected }
            self.dicData = categoryViewModel.selectedDic.filter { $0.isSelected }
            guard let dicData = dicData else { return }
            setupVocaData(selectedVoca, nil)
            vocaTranslatedTableViewDatasourceSetup()
            vocaTranslatedTableViewSnapshot(with: dicData)
        case 1...7:
            switch index {
            case 1: setupVocaData(categoryViewModel.transportationVoca, nil)
            case 2: setupVocaData(categoryViewModel.accommodationVoca, nil)
            case 3: setupVocaData(categoryViewModel.travelActivitiesVoca, categoryViewModel.travelEssentials)
            case 4: setupVocaData(categoryViewModel.diningVoca, categoryViewModel.cultureVoca)
            case 5: setupVocaData(categoryViewModel.leisureVoca, nil)
            case 6: setupVocaData(categoryViewModel.communicationVoca, nil)
            case 7: setupVocaData(categoryViewModel.facilitiesVoca, nil)
            default: return
            }
        default:
            break
        }
    }
    // MARK: - Action

    @objc private func vocaSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        switch selectedSegmentIndex {
        case 0:
            vocaListTableViewDatasourceSetup()
            vocaListTableViewSnapshot(with: firstVocaData)
        case 1:
            if distinguishSavedData {
                guard let dicData = dicData else { return }
                vocaTranslatedTableViewDatasourceSetup()
                vocaTranslatedTableViewSnapshot(with: dicData)
            } else {
                guard let secondVocaData = secondVocaData else { return }
                vocaListTableViewDatasourceSetup()
                vocaListTableViewSnapshot(with: secondVocaData)
            }
        default:
            break
        }
    }

    @objc private func backBarButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - VocaList TableView Diffable DataSource
extension CategoryDetailViewController {
        private func vocaListTableViewDatasourceSetup() {
            vocaListDataSource = UITableViewDiffableDataSource<Section, RealmVocaModel>(
                tableView: detailView.vocaTableView
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
                cell.vocaListViewModel = categoryViewModel.vocaListViewModel
                cell.sourceLabel.text = data.sourceText
                cell.translatedLabel.text = data.translatedText
                cell.isSelect = data.isSelected
                cell.selectedSegmentIndex = selectedSegmentIndex
                cell.distinguishSavedData = distinguishSavedData
                cell.configureBookmark()
                cell.speakerButtonAction()
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
extension CategoryDetailViewController {
    private func vocaTranslatedTableViewDatasourceSetup() {
        vocaTranslatedDataSource = UITableViewDiffableDataSource<Section, RealmTranslateModel>(
            tableView: detailView.vocaTableView
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
            cell.vocaTanslatedViewModel = categoryViewModel.vocaTranslatedViewModel
            cell.sourceLabel.text = data.sourceText
            cell.translatedLabel.text = data.translatedText
            cell.isSelect = data.isSelected
            cell.selectedSegmentIndex = selectedSegmentIndex
            cell.distinguishSavedData = distinguishSavedData
            cell.configureBookmark()
            cell.speakerButtonAction()
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
extension CategoryDetailViewController: UITableViewDelegate {
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