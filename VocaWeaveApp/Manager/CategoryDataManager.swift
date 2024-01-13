//
//  CategoryDataManager.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/24/23.
//

import Foundation

final class CategoryDataManager {
    // MARK: - Property
    private var transportation = Transportation()
    private var accommodation = Accommodation()
    private var travelActivities = TravelActivitiesVoca()
    private var travelEssentials = TravelEssentials()
    private var dining = DiningVoca()
    private var leisure = LeisuretravelVoca()
    private var communication = CommunicationtravelVoca()
    private var facilities = FacilitiestravelVoca()
    private var culture = CulturetravelVoca()
    // MARK: - Helper
    func getAllVocaData() -> [RealmVocaModel] {
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
}
