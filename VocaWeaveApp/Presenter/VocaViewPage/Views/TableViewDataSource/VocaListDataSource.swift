//
//  VocaListDataSource.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 2/19/24.
//

import UIKit

class VocaListDataSource: UITableViewDiffableDataSource<Section, RealmVocaModel> {
    private var tableView: UITableView
    private var vocaListVM: VocaListVM
    private var segmentIndex: Int
       // MARK: - init
    init(tableView: UITableView, vocaListVM: VocaListVM, segmentIndex: Int) {
        self.tableView = tableView
        self.vocaListVM = vocaListVM
        self.segmentIndex = segmentIndex
        super.init(tableView: tableView) {  tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VocaTableViewCell.identifier,
                                                           for: indexPath) as? VocaTableViewCell else {
                fatalError("Failed to dequeue VocaTableViewCell")
            }
            let data = itemIdentifier
            cell.vocaListData = data
            cell.vocaListViewModel = vocaListVM
            vocaListVM.setupCell(cell: cell,
                                 sourceText: data.sourceText,
                                 translatedText: data.translatedText,
                                 isSelected: data.isSelected,
                                 selectedSegmentIndex: segmentIndex)
            return cell
        }
    }

    func vocaListTableViewSnapshot(with newData: [RealmVocaModel], emptyView: () -> Void) {
        var vocaListSnapshot = NSDiffableDataSourceSnapshot<Section, RealmVocaModel>()
        let sections = Section.allCases
        for section in sections {
            let itemsInSection = newData.filter { $0.section == section.title }
            if !itemsInSection.isEmpty {
                vocaListSnapshot.appendSections([section])
                vocaListSnapshot.appendItems(itemsInSection, toSection: section)
            }
        }
        emptyView()
        self.apply(vocaListSnapshot, animatingDifferences: true)
    }
}
