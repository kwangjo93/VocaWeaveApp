//
//  TravelEssentials.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/20/23.
//

import Foundation

struct TravelEssentials {
    let query = "TravelEssentials"
    lazy var travelEssentialsVoca: [RealmVocaModel] = [
        RealmVocaModel(sourceText: "Passport", translatedText: "여권", realmQeury: query),
        RealmVocaModel(sourceText: "Visa", translatedText: "비자", realmQeury: query),
        RealmVocaModel(sourceText: "ID card", translatedText: "신분증", realmQeury: query),
        RealmVocaModel(sourceText: "Driver's license", translatedText: "운전면허증", realmQeury: query),
        RealmVocaModel(sourceText: "Travel insurance", translatedText: "여행 보험", realmQeury: query),
        RealmVocaModel(sourceText: "Health insurance", translatedText: "의료 보험", realmQeury: query),
        RealmVocaModel(sourceText: "Credit card", translatedText: "신용카드", realmQeury: query),
        RealmVocaModel(sourceText: "Debit card", translatedText: "직불카드", realmQeury: query),
        RealmVocaModel(sourceText: "Cash", translatedText: "현금", realmQeury: query),
        RealmVocaModel(sourceText: "Currency", translatedText: "통화", realmQeury: query),
        RealmVocaModel(sourceText: "Money belt", translatedText: "머니벨트", realmQeury: query),
        RealmVocaModel(sourceText: "Wallet", translatedText: "지갑", realmQeury: query),
        RealmVocaModel(sourceText: "Backpack", translatedText: "배낭", realmQeury: query),
        RealmVocaModel(sourceText: "Suitcase", translatedText: "여행 가방", realmQeury: query),
        RealmVocaModel(sourceText: "Luggage", translatedText: "짐", realmQeury: query),
        RealmVocaModel(sourceText: "Travel adapter", translatedText: "여행용 어댑터", realmQeury: query),
        RealmVocaModel(sourceText: "Power bank", translatedText: "충전기", realmQeury: query),
        RealmVocaModel(sourceText: "Mobile phone", translatedText: "휴대전화", realmQeury: query),
        RealmVocaModel(sourceText: "Smartphone", translatedText: "스마트폰", realmQeury: query),
        RealmVocaModel(sourceText: "Tablet", translatedText: "태블릿", realmQeury: query),
        RealmVocaModel(sourceText: "Laptop", translatedText: "노트북", realmQeury: query),
        RealmVocaModel(sourceText: "Camera", translatedText: "카메라", realmQeury: query),
        RealmVocaModel(sourceText: "Chargers", translatedText: "충전기", realmQeury: query),
        RealmVocaModel(sourceText: "Headphones", translatedText: "헤드폰", realmQeury: query),
        RealmVocaModel(sourceText: "Earphones", translatedText: "이어폰", realmQeury: query),
        RealmVocaModel(sourceText: "Portable speaker", translatedText: "휴대용 스피커", realmQeury: query),
        RealmVocaModel(sourceText: "Travel pillow", translatedText: "여행용 베개", realmQeury: query),
        RealmVocaModel(sourceText: "Eye mask", translatedText: "아이 마스크", realmQeury: query),
        RealmVocaModel(sourceText: "Earplugs", translatedText: "귀마개", realmQeury: query),
        RealmVocaModel(sourceText: "Travel guidebook", translatedText: "여행 안내서", realmQeury: query),
        RealmVocaModel(sourceText: "Maps", translatedText: "지도", realmQeury: query),
        RealmVocaModel(sourceText: "Phrasebook", translatedText: "회화집", realmQeury: query),
        RealmVocaModel(sourceText: "Travel journal", translatedText: "여행 일기", realmQeury: query),
        RealmVocaModel(sourceText: "Pen", translatedText: "펜", realmQeury: query),
        RealmVocaModel(sourceText: "Notepad", translatedText: "메모장", realmQeury: query),
        RealmVocaModel(sourceText: "Travel locks", translatedText: "여행용 자물쇠", realmQeury: query),
        RealmVocaModel(sourceText: "Laundry bag", translatedText: "세탁물 가방", realmQeury: query),
        RealmVocaModel(sourceText: "Toiletry bag", translatedText: "세면도구 가방", realmQeury: query),
        RealmVocaModel(sourceText: "Toothbrush", translatedText: "칫솔", realmQeury: query),
        RealmVocaModel(sourceText: "Toothpaste", translatedText: "치약", realmQeury: query),
        RealmVocaModel(sourceText: "Dental floss", translatedText: "치실", realmQeury: query),
        RealmVocaModel(sourceText: "Shampoo", translatedText: "샴푸", realmQeury: query),
        RealmVocaModel(sourceText: "Conditioner", translatedText: "컨디셔너", realmQeury: query),
        RealmVocaModel(sourceText: "Body wash", translatedText: "바디워시", realmQeury: query),
        RealmVocaModel(sourceText: "Soap", translatedText: "비누", realmQeury: query),
        RealmVocaModel(sourceText: "Hand sanitizer", translatedText: "손 세정제", realmQeury: query),
        RealmVocaModel(sourceText: "Sunscreen", translatedText: "선크림", realmQeury: query),
        RealmVocaModel(sourceText: "Insect repellent", translatedText: "해충 방제제", realmQeury: query),
        RealmVocaModel(sourceText: "First aid kit", translatedText: "응급 처치 키트", realmQeury: query),
        RealmVocaModel(sourceText: "Medications", translatedText: "약품", realmQeury: query),
        RealmVocaModel(sourceText: "Prescriptions", translatedText: "처방전", realmQeury: query),
        RealmVocaModel(sourceText: "Allergy medicine", translatedText: "알레르기 약", realmQeury: query),
        RealmVocaModel(sourceText: "Pain relievers", translatedText: "진통제", realmQeury: query),
        RealmVocaModel(sourceText: "Antacids", translatedText: "소화제", realmQeury: query),
        RealmVocaModel(sourceText: "Motion sickness pills", translatedText: "멀미약", realmQeury: query),
        RealmVocaModel(sourceText: "Bandages", translatedText: "붕대", realmQeury: query),
        RealmVocaModel(sourceText: "Adhesive tape", translatedText: "붙이는 테이프", realmQeury: query),
        RealmVocaModel(sourceText: "Scissors", translatedText: "가위", realmQeury: query),
        RealmVocaModel(sourceText: "Tweezers", translatedText: "진공", realmQeury: query),
        RealmVocaModel(sourceText: "Nail clippers", translatedText: "손톱깎이", realmQeury: query),
        RealmVocaModel(sourceText: "Emergency contacts", translatedText: "긴급 연락처", realmQeury: query),
        RealmVocaModel(sourceText: "Personal information", translatedText: "개인 정보", realmQeury: query),
        RealmVocaModel(sourceText: "Insurance documents", translatedText: "보험 서류", realmQeury: query),
        RealmVocaModel(sourceText: "Emergency cash", translatedText: "비상 현금", realmQeury: query),
        RealmVocaModel(sourceText: "Important phone numbers", translatedText: "중요 전화번호", realmQeury: query)
    ]

}
