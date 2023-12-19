//
//  Enum.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/13/23.
//

import Foundation

enum Section: String, CaseIterable {
    case alphabetA = "A"
    case alphabetB = "B"
    case alphabetC = "C"
    case alphabetD = "D"
    case alphabetE = "E"
    case alphabetF = "F"
    case alphabetG = "G"
    case alphabetH = "H"
    case alphabetI = "I"
    case alphabetJ = "J"
    case alphabetK = "K"
    case alphabetL = "L"
    case alphabetM = "M"
    case alphabetN = "N"
    case alphabetO = "O"
    case alphabetP = "P"
    case alphabetQ = "Q"
    case alphabetR = "R"
    case alphabetS = "S"
    case alphabetT = "T"
    case alphabetU = "U"
    case alphabetV = "V"
    case alphabetW = "W"
    case alphabetX = "X"
    case alphabetY = "Y"
    case alphabetZ = "Z"

    case koreanA = "ㄱ"
    case koreanB = "ㄴ"
    case koreanC = "ㄷ"
    case koreanD = "ㄹ"
    case koreanE = "ㅁ"
    case koreanF = "ㅂ"
    case koreanG = "ㅅ"
    case koreanH = "ㅇ"
    case koreanI = "ㅈ"
    case koreanJ = "ㅊ"
    case koreanK = "ㅋ"
    case koreanL = "ㅌ"
    case koreanM = "ㅍ"
    case koreanN = "ㅎ"

    var title: String {
        return self.rawValue
    }
}
