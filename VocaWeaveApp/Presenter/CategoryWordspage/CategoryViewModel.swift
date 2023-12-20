//
//  CategoryViewModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/9/23.
//

import Foundation

final class CategoryViewModel {
    // MARK: - Property
    private let vocaTranslatedViewModel: VocaTranslatedManager
    private let vocaListViewModel: VocaListManager

    lazy var selectedVoca: [RealmVocaModel] = vocaListViewModel.getVocaList()
                                                                    .filter {$0.isSelected == true}
    lazy var selectedDic: [RealmTranslateModel] = vocaTranslatedViewModel.getVocaList()
                                                                    .filter { $0.isSelected == true }
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
    init(vocaTranslatedViewModel: VocaTranslatedManager, vocaListViewModel: VocaListManager) {
        self.vocaTranslatedViewModel = vocaTranslatedViewModel
        self.vocaListViewModel = vocaListViewModel
    }
    // MARK: - Helper
    // MARK: - Action
}
