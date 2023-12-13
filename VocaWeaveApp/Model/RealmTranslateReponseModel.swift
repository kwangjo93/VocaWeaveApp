//
//  RealmTranslateReponseModel.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation
import RealmSwift

class RealmTranslateReponseModel: Object {
    @Persisted private var translatedText: String

    convenience init(apiModel: TranslateReponseModel) {
        self.init()
        self.translatedText = apiModel.translatedText
    }
}
