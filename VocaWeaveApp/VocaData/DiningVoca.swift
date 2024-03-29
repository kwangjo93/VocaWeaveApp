//
//  DiningVoca.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/20/23.
//

import Foundation

struct DiningVoca {
    let query = "DiningVoca"
    lazy var diningVoca: [RealmVocaModel] = [
        RealmVocaModel(sourceText: "Restaurant", translatedText: "레스토랑", realmQeury: query),
        RealmVocaModel(sourceText: "Cafe", translatedText: "카페", realmQeury: query),
        RealmVocaModel(sourceText: "Bistro", translatedText: "비스트로", realmQeury: query),
        RealmVocaModel(sourceText: "Bar", translatedText: "바", realmQeury: query),
        RealmVocaModel(sourceText: "Pub", translatedText: "펍", realmQeury: query),
        RealmVocaModel(sourceText: "Tavern", translatedText: "타버나", realmQeury: query),
        RealmVocaModel(sourceText: "Diner", translatedText: "다이너", realmQeury: query),
        RealmVocaModel(sourceText: "Eatery", translatedText: "식당", realmQeury: query),
        RealmVocaModel(sourceText: "Brasserie", translatedText: "브라스리", realmQeury: query),
        RealmVocaModel(sourceText: "Buffet", translatedText: "뷔페", realmQeury: query),
        RealmVocaModel(sourceText: "Cafeteria", translatedText: "카페테리아", realmQeury: query),
        RealmVocaModel(sourceText: "Fast food restaurant", translatedText: "패스트 푸드 레스토랑", realmQeury: query),
        RealmVocaModel(sourceText: "Fine dining", translatedText: "고급 음식점", realmQeury: query),
        RealmVocaModel(sourceText: "Casual dining", translatedText: "캐주얼 다이닝", realmQeury: query),
        RealmVocaModel(sourceText: "Family-style restaurant", translatedText: "가족 레스토랑", realmQeury: query),
        RealmVocaModel(sourceText: "Pizzeria", translatedText: "피자 가게", realmQeury: query),
        RealmVocaModel(sourceText: "Steakhouse", translatedText: "스테이크 하우스", realmQeury: query),
        RealmVocaModel(sourceText: "Seafood restaurant", translatedText: "해산물 레스토랑", realmQeury: query),
        RealmVocaModel(sourceText: "Vegetarian restaurant", translatedText: "채식주의 레스토랑", realmQeury: query),
        RealmVocaModel(sourceText: "Vegan restaurant", translatedText: "비건 레스토랑", realmQeury: query),
        RealmVocaModel(sourceText: "Sushi bar", translatedText: "스시 바", realmQeury: query),
        RealmVocaModel(sourceText: "Noodle bar", translatedText: "국수 전문점", realmQeury: query),
        RealmVocaModel(sourceText: "Tapas bar", translatedText: "타파스 바", realmQeury: query),
        RealmVocaModel(sourceText: "Wine bar", translatedText: "와인 바", realmQeury: query),
        RealmVocaModel(sourceText: "Cocktail bar", translatedText: "칵테일 바", realmQeury: query),
        RealmVocaModel(sourceText: "Menu", translatedText: "메뉴", realmQeury: query),
        RealmVocaModel(sourceText: "Reservation", translatedText: "예약", realmQeury: query),
        RealmVocaModel(sourceText: "Table", translatedText: "테이블", realmQeury: query),
        RealmVocaModel(sourceText: "Chair", translatedText: "의자", realmQeury: query),
        RealmVocaModel(sourceText: "Waiter", translatedText: "웨이터", realmQeury: query),
        RealmVocaModel(sourceText: "Waitress", translatedText: "웨이트리스", realmQeury: query),
        RealmVocaModel(sourceText: "Server", translatedText: "서빙하는 사람", realmQeury: query),
        RealmVocaModel(sourceText: "Host", translatedText: "주인", realmQeury: query),
        RealmVocaModel(sourceText: "Hostess", translatedText: "여주인", realmQeury: query),
        RealmVocaModel(sourceText: "Chef", translatedText: "셰프", realmQeury: query),
        RealmVocaModel(sourceText: "Cook", translatedText: "요리사", realmQeury: query),
        RealmVocaModel(sourceText: "Kitchen", translatedText: "주방", realmQeury: query),
        RealmVocaModel(sourceText: "Dish", translatedText: "요리", realmQeury: query),
        RealmVocaModel(sourceText: "Appetizer", translatedText: "전채", realmQeury: query),
        RealmVocaModel(sourceText: "Main course", translatedText: "주요 요리", realmQeury: query),
        RealmVocaModel(sourceText: "Dessert", translatedText: "디저트", realmQeury: query),
        RealmVocaModel(sourceText: "Beverage", translatedText: "음료", realmQeury: query),
        RealmVocaModel(sourceText: "Alcoholic beverage", translatedText: "주류", realmQeury: query),
        RealmVocaModel(sourceText: "Non-alcoholic beverage", translatedText: "논알콜 음료", realmQeury: query),
        RealmVocaModel(sourceText: "Water", translatedText: "물", realmQeury: query),
        RealmVocaModel(sourceText: "Soda", translatedText: "탄산음료", realmQeury: query),
        RealmVocaModel(sourceText: "Juice", translatedText: "주스", realmQeury: query),
        RealmVocaModel(sourceText: "Coffee", translatedText: "커피", realmQeury: query),
        RealmVocaModel(sourceText: "Tea", translatedText: "차", realmQeury: query),
        RealmVocaModel(sourceText: "Wine", translatedText: "와인", realmQeury: query),
        RealmVocaModel(sourceText: "Beer", translatedText: "맥주", realmQeury: query),
        RealmVocaModel(sourceText: "Sake", translatedText: "사케", realmQeury: query),
        RealmVocaModel(sourceText: "Whiskey", translatedText: "위스키", realmQeury: query),
        RealmVocaModel(sourceText: "Vodka", translatedText: "보드카", realmQeury: query),
        RealmVocaModel(sourceText: "Rum", translatedText: "럼", realmQeury: query),
        RealmVocaModel(sourceText: "Brandy", translatedText: "브랜디", realmQeury: query),
        RealmVocaModel(sourceText: "Cognac", translatedText: "꼬냑", realmQeury: query),
        RealmVocaModel(sourceText: "Gin", translatedText: "진", realmQeury: query),
        RealmVocaModel(sourceText: "Cocktail", translatedText: "칵테일", realmQeury: query),
        RealmVocaModel(sourceText: "Mocktail", translatedText: "논알콜 칵테일", realmQeury: query),
        RealmVocaModel(sourceText: "Tip", translatedText: "팁", realmQeury: query),
        RealmVocaModel(sourceText: "Bill", translatedText: "계산서", realmQeury: query),
        RealmVocaModel(sourceText: "Service charge", translatedText: "서비스 요금", realmQeury: query),
        RealmVocaModel(sourceText: "Fine", translatedText: "벌금", realmQeury: query),
        RealmVocaModel(sourceText: "Tipping etiquette", translatedText: "팁에 관한 에티켓", realmQeury: query),
        RealmVocaModel(sourceText: "Allergies", translatedText: "알레르기", realmQeury: query),
        RealmVocaModel(sourceText: "Gluten-free", translatedText: "글루텐 프리", realmQeury: query),
        RealmVocaModel(sourceText: "Vegan", translatedText: "비건", realmQeury: query),
        RealmVocaModel(sourceText: "Vegetarian", translatedText: "채식주의자", realmQeury: query),
        RealmVocaModel(sourceText: "Menu card", translatedText: "메뉴 카드", realmQeury: query),
        RealmVocaModel(sourceText: "Order", translatedText: "주문", realmQeury: query),
        RealmVocaModel(sourceText: "Cuisine", translatedText: "요리법", realmQeury: query),
        RealmVocaModel(sourceText: "Reservation", translatedText: "예약", realmQeury: query),
        RealmVocaModel(sourceText: "Outdoor dining", translatedText: "야외 식사", realmQeury: query),
        RealmVocaModel(sourceText: "Indoor dining", translatedText: "실내 식사", realmQeury: query),
        RealmVocaModel(sourceText: "Takeout", translatedText: "테이크아웃", realmQeury: query),
        RealmVocaModel(sourceText: "Dine-in", translatedText: "매장식사", realmQeury: query)
    ]

}
