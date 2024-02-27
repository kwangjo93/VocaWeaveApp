//
//  APIVocaListDatasource.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 2/19/24.
//

import UIKit

final class APIVocaListDatasource: UITableViewDiffableDataSource<Section, APIRealmVocaModel> {
    private var tableView: UITableView
    private var apiVocaListVM: APIVocaListVM
    private var segmentIndex: Int

    init(tableView: UITableView, apiVocaListVM: APIVocaListVM, segmentIndex: Int) {
        self.tableView = tableView
        self.apiVocaListVM = apiVocaListVM
        self.segmentIndex = segmentIndex
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VocaTableViewCell.identifier,
                                                           for: indexPath) as? VocaTableViewCell else {
                fatalError("Failed to dequeue VocaTableViewCell")
            }
            let data = itemIdentifier
            cell.viewModel = VocaCellVM(vocaListData: nil,
                                        apiVocaData: data,
                                        vocaListVM: nil,
                                        apiVocaListVM: apiVocaListVM,
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

    func apiVocaTableViewSnapshot(with newData: [APIRealmVocaModel], emptyView: () -> Void) {
        var apivocaSnapshot = NSDiffableDataSourceSnapshot<Section, APIRealmVocaModel>()
        let sections = Section.allCases
        for section in sections {
            let itemsInSection = newData.filter { $0.section == section.title }
            if !itemsInSection.isEmpty {
                apivocaSnapshot.appendSections([section])
                apivocaSnapshot.appendItems(itemsInSection, toSection: section)
            }
        }
        emptyView()
        self.apply(apivocaSnapshot, animatingDifferences: true)
    }
}
