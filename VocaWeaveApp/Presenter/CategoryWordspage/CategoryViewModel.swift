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

    lazy var selectedVoca: [RealmVocaModel] = vocaListManager.getAllVocaData()
    lazy var selectedDic: [RealmTranslateModel] = vocaTranslatedViewManager.getVocaList()
    lazy var transportationVoca: [RealmVocaModel] = vocaListManager
        .getVocaList(query: "Transportation")
    lazy var accommodationVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "Accommodation")
    lazy var travelActivitiesVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "TravelActivitiesVoca")
    lazy var travelEssentialsVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "TravelEssentials")
    lazy var diningVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "DiningVoca")
    lazy var leisureVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "LeisuretravelVoca")
    lazy var communicationVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "CommunicationtravelVoca")
    lazy var facilitiesVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "FacilitiestravelVoca")
    lazy var cultureVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "CulturetravelVoca")
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
