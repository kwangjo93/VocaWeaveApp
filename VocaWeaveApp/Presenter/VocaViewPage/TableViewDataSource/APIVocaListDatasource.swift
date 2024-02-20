//
//  APIVocaListDatasource.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 2/19/24.
//

import UIKit

class APIVocaListDatasource: UITableViewDiffableDataSource<Section, RealmTranslateModel> {
    private var tableView: UITableView
    private var vocaTranlsatedVM: VocaTranslatedVM
    private var segmentIndex: Int

    init(tableView: UITableView, vocaTranlsatedVM: VocaTranslatedVM, segmentIndex: Int) {
        self.tableView = tableView
        self.vocaTranlsatedVM = vocaTranlsatedVM
        self.segmentIndex = segmentIndex
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VocaTableViewCell.identifier,
                                                           for: indexPath) as? VocaTableViewCell else {
                fatalError("Failed to dequeue VocaTableViewCell")
            }
            let data = itemIdentifier
            cell.viewModel = VocaCellVM(vocaListData: nil,
                                        vocaTanslatedData: data,
                                        vocaListVM: nil,
                                        vocaTanslatedVM: vocaTranlsatedVM,
                                        isSelect: data.isSelected,
                                        selectedSegmentIndex: segmentIndex)
            if let viewModel = cell.viewModel {
                viewModel.setupCell(cell: cell,
                                    sourceText: data.sourceText,
                                    translatedText: data.translatedText)
            }
            return cell
        }
    }

    func vocaTranslatedTableViewSnapshot(with newData: [RealmTranslateModel], emptyView: () -> Void) {
        var vocaTranslatedSnapshot = NSDiffableDataSourceSnapshot<Section, RealmTranslateModel>()
        let sections = Section.allCases
        for section in sections {
            let itemsInSection = newData.filter { $0.section == section.title }
            if !itemsInSection.isEmpty {
                vocaTranslatedSnapshot.appendSections([section])
                vocaTranslatedSnapshot.appendItems(itemsInSection, toSection: section)
            }
        }
        emptyView()
        self.apply(vocaTranslatedSnapshot, animatingDifferences: true)
    }
}
