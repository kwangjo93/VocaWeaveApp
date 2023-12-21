//
//  CategoryViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/9/23.
//

import Foundation

final class CategoryViewModel {
    // MARK: - Property
    private let vocaTranslatedViewManager: VocaTranslatedManager
    private let vocaListManager: VocaListManager
    let vocaListViewModel: VocaListViewModel
    let vocaTranslatedViewModel: VocaTranslatedViewModel

    lazy var selectedVoca: [RealmVocaModel] = vocaListManager.getVocaList()
    lazy var selectedDic: [RealmTranslateModel] = vocaTranslatedViewManager.getVocaList()
    var transportationVoca: [RealmVocaModel] = Transportation().transportationVoca
    var accommodationVoca: [RealmVocaModel] = Accommodation().accommodationVoca
    var travelActivitiesVoca: [RealmVocaModel] = TravelActivitiesVoca().travelActivitiesVoca
    var travelEssentials: [RealmVocaModel] = TravelEssentials().travelEssentialsVoca
    var diningVoca: [RealmVocaModel] = DiningVoca().diningVoca
    var leisureVoca: [RealmVocaModel] = LeisuretravelVoca().leisureTravelVoca
    var communicationVoca: [RealmVocaModel] = CommunicationtravelVoca().communicationVoca
    var facilitiesVoca: [RealmVocaModel] = FacilitiestravelVoca().facilitiesVoca
    var cultureVoca: [RealmVocaModel] = CulturetravelVoca().cultureVoca
    // MARK: - init
    init(vocaTranslatedViewManager: VocaTranslatedManager,
         vocaListManager: VocaListManager,
         vocaListViewModel: VocaListViewModel,
         vocaTranslatedViewModel: VocaTranslatedViewModel) {
        self.vocaTranslatedViewManager = vocaTranslatedViewManager
        self.vocaListManager = vocaListManager
        self.vocaListViewModel = vocaListViewModel
        self.vocaTranslatedViewModel = vocaTranslatedViewModel
    }
    // MARK: - Helper
    // MARK: - Action

}
