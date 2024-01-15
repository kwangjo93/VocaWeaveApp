//
//  CategoryVM.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/9/23.
//

import Foundation

final class CategoryVM {
    // MARK: - Property
    private let vocaTranslatedManager: VocaTranslatedManager
    private let vocaListManager: VocaListManager
    let vocaListVM: VocaListVM
    let vocaTranslatedVM: VocaTranslatedVM

    lazy var selectedVoca: [RealmVocaModel] = vocaListManager.getAllVocaData()
    lazy var selectedDic: [RealmTranslateModel] = vocaTranslatedManager.getVocaList()
    lazy var transportationVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "Transportation")
    lazy var accommodationVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "Accommodation")
    lazy var travelActivitiesVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "TravelActivitiesVoca")
    lazy var travelEssentialsVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "TravelEssentials")
    lazy var diningVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "DiningVoca")
    lazy var leisureVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "LeisuretravelVoca")
    lazy var communicationVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "CommunicationtravelVoca")
    lazy var facilitiesVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "FacilitiestravelVoca")
    lazy var cultureVoca: [RealmVocaModel] = vocaListManager.getVocaList(query: "CulturetravelVoca")
    // MARK: - init
    init(vocaTranslatedManager: VocaTranslatedManager,
         vocaListManager: VocaListManager,
         vocaListVM: VocaListVM,
         vocaTranslatedVM: VocaTranslatedVM) {
        self.vocaTranslatedManager = vocaTranslatedManager
        self.vocaListManager = vocaListManager
        self.vocaListVM = vocaListVM
        self.vocaTranslatedVM = vocaTranslatedVM
    }
}
