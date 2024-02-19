//
//  VocaSearchHandler.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 2/19/24.
//

import UIKit

class VocaSearchHandler {
    private let vocaListVM: VocaListVM
    private let vocaTranslatedVM: VocaTranslatedVM
    private let vocaView: VocaView
    private let emptyView: EmptyListView
    private var segmentIndex: Int
    private var viewHandler: UIViewController

    init(vocaListVM: VocaListVM,
         vocaTranslatedVM: VocaTranslatedVM,
         vocaView: VocaView,
         emptyView: EmptyListView,
         segmentIndex: Int,
         viewHandler: UIViewController) {
        self.vocaListVM = vocaListVM
        self.vocaTranslatedVM = vocaTranslatedVM
        self.vocaView = vocaView
        self.emptyView = emptyView
        self.segmentIndex = segmentIndex
        self.viewHandler = viewHandler
    }

    func handleSearchTextChange(_ searchText: String,
                                segmentIndex: Int,
                                voca: ([RealmVocaModel]) -> Void,
                                apiVoca: ([RealmTranslateModel]) -> Void) {
        switch segmentIndex {
        case 0:
            handleSearchForVocaList(searchText, completion: voca)
        case 1:
            handleSearchForApiVocaList(searchText, completion: apiVoca)
        default:
            break
        }
    }

    private func handleSearchForVocaList(_ searchText: String, completion: ([RealmVocaModel]) -> Void) {
        guard !searchText.isEmpty else {
            completion(vocaListVM.vocaList)
            return
        }
        let filteredData = vocaListVM.vocaList.filter { voca in
            return voca.sourceText.lowercased().contains(searchText.lowercased())
        }
        completion(filteredData)
    }

    private func handleSearchForApiVocaList(_ searchText: String,
                                            completion: ([RealmTranslateModel]) -> Void) {
        guard !searchText.isEmpty else {
            completion(vocaTranslatedVM.vocaList)
            return
        }
        let filteredData = vocaTranslatedVM.vocaList.filter { voca in
            return voca.sourceText.lowercased().contains(searchText.lowercased())
        }
        completion(filteredData)
    }
}
