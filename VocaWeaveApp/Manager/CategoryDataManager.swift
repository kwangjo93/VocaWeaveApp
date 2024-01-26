//
//  CategoryDataManager.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/24/23.
//

import Foundation
import RealmSwift

final class CategoryDataManager {
    // MARK: - Property
    private let vocaListManager: VocaListManager
    // MARK: - init
    init(vocaListManager: VocaListManager) {
        self.vocaListManager = vocaListManager
    }
    // MARK: - Helper
    private func getAllVocaData() -> [RealmVocaModel] {
        var transportation = Transportation()
        var accommodation = Accommodation()
        var travelActivities = TravelActivitiesVoca()
        var travelEssentials = TravelEssentials()
        var dining = DiningVoca()
        var leisure = LeisuretravelVoca()
        var communication = CommunicationtravelVoca()
        var facilities = FacilitiestravelVoca()
        var culture = CulturetravelVoca()
        var categoryVocaData: [RealmVocaModel] = []
        categoryVocaData += transportation.transportationVoca
        categoryVocaData += accommodation.accommodationVoca
        categoryVocaData += travelActivities.travelActivitiesVoca
        categoryVocaData += travelEssentials.travelEssentialsVoca
        categoryVocaData += dining.diningVoca
        categoryVocaData += leisure.leisureTravelVoca
        categoryVocaData += communication.communicationVoca
        categoryVocaData += facilities.facilitiesVoca
        categoryVocaData += culture.cultureVoca
        return categoryVocaData
    }

    func setWithSavedData() -> [RealmVocaModel]? {
        let vocaData = vocaListManager.getVocaList(query: "Transportation")
        if checkForDuplicatedData(vocaDatas: vocaData) {
            return nil
        } else {
            return getAllVocaData()
        }
    }

    private func checkForDuplicatedData(vocaDatas: [RealmVocaModel]) -> Bool {
        let existingData = vocaListManager.getAllVocaData()
        for vocaData in vocaDatas where existingData.contains(where: { $0.uuid == vocaData.uuid }) {
            return true
        }
        return false
    }
}
