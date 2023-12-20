//
//  Accommodation.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/20/23.
//

import Foundation

struct Accommodation {
    var accommodationVoca: [RealmVocaModel] = [
        RealmVocaModel(sourceText: "Accommodation", translatedText: "숙박시설"),
        RealmVocaModel(sourceText: "Hotel", translatedText: "호텔"),
        RealmVocaModel(sourceText: "Motel", translatedText: "모텔"),
        RealmVocaModel(sourceText: "Inn", translatedText: "여관"),
        RealmVocaModel(sourceText: "Hostel", translatedText: "호스텔"),
        RealmVocaModel(sourceText: "Lodge", translatedText: "숙소"),
        RealmVocaModel(sourceText: "Resort", translatedText: "리조트"),
        RealmVocaModel(sourceText: "Guesthouse", translatedText: "게스트하우스"),
        RealmVocaModel(sourceText: "B&B (Bed and Breakfast)", translatedText: "B&B(민박)"),
        RealmVocaModel(sourceText: "Cabin", translatedText: "오두막"),
        RealmVocaModel(sourceText: "Campground", translatedText: "캠핑장"),
        RealmVocaModel(sourceText: "Host/Hostess", translatedText: "호스트/호스티스"),
        RealmVocaModel(sourceText: "Front Desk", translatedText: " 프런트 데스크"),
        RealmVocaModel(sourceText: "Check-in", translatedText: "체크인"),
        RealmVocaModel(sourceText: "Check-out", translatedText: "체크아웃"),
        RealmVocaModel(sourceText: "Reservation", translatedText: "예약"),
        RealmVocaModel(sourceText: "Room Service", translatedText: "룸 서비스"),
        RealmVocaModel(sourceText: "Suite", translatedText: "스위트룸"),
        RealmVocaModel(sourceText: "Single Room", translatedText: "싱글룸"),
        RealmVocaModel(sourceText: "Double Room", translatedText: "더블룸"),
        RealmVocaModel(sourceText: "Twin Room", translatedText: "트윈룸"),
        RealmVocaModel(sourceText: "Triple Room", translatedText: "트리플룸"),
        RealmVocaModel(sourceText: "Amenities", translatedText: "편의시설"),
        RealmVocaModel(sourceText: "Facilities", translatedText: "시설"),
        RealmVocaModel(sourceText: "Air Conditioning", translatedText: "에어컨"),
        RealmVocaModel(sourceText: "Heating", translatedText: "난방"),
        RealmVocaModel(sourceText: "Wi-Fi", translatedText: "와이파이"),
        RealmVocaModel(sourceText: "TV", translatedText: "텔레비전"),
        RealmVocaModel(sourceText: "Mini-bar", translatedText: "미니바"),
        RealmVocaModel(sourceText: "Safe", translatedText: "금고"),
        RealmVocaModel(sourceText: "Shower", translatedText: "샤워"),
        RealmVocaModel(sourceText: "Bathtub", translatedText: "욕조"),
        RealmVocaModel(sourceText: "Toiletries", translatedText: "화장품"),
        RealmVocaModel(sourceText: "Towels", translatedText: "수건"),
        RealmVocaModel(sourceText: "Bedding", translatedText: "침구"),
        RealmVocaModel(sourceText: "Pillow", translatedText: "베개"),
        RealmVocaModel(sourceText: "Blanket", translatedText: "담요"),
        RealmVocaModel(sourceText: "Linen", translatedText: "리넨"),
        RealmVocaModel(sourceText: "Key Card", translatedText: "키 카드"),
        RealmVocaModel(sourceText: "Do Not Disturb", translatedText: "방해 금지"),
        RealmVocaModel(sourceText: "Housekeeping", translatedText: "하우스키퍼"),
        RealmVocaModel(sourceText: "Concierge", translatedText: "콘시어지"),
        RealmVocaModel(sourceText: "Bellboy/Porter", translatedText: "케리어 보이"),
        RealmVocaModel(sourceText: "Lobby", translatedText: "로비"),
        RealmVocaModel(sourceText: "Restaurant", translatedText: "레스토랑"),
        RealmVocaModel(sourceText: "Bar", translatedText: "바"),
        RealmVocaModel(sourceText: "Café", translatedText: "카페"),
        RealmVocaModel(sourceText: "Room Type", translatedText: "객실 유형"),
        RealmVocaModel(sourceText: "Reservation Confirmation", translatedText: "예약 확인"),
        RealmVocaModel(sourceText: "Extra Bed", translatedText: "여분 침대"),
        RealmVocaModel(sourceText: "Late Check-out", translatedText: "늦은 체크아웃"),
        RealmVocaModel(sourceText: "Early Check-in", translatedText: "이른 체크인"),
        RealmVocaModel(sourceText: "Vacancy", translatedText: "빈 객실"),
        RealmVocaModel(sourceText: "Occupied", translatedText: "이용 중"),
        RealmVocaModel(sourceText: "Full Occupancy", translatedText: "만실"),
        RealmVocaModel(sourceText: "Vacancy Rate", translatedText: "빈방 비율"),
        RealmVocaModel(sourceText: "Hotel Chain", translatedText: "호텔 체인"),
        RealmVocaModel(sourceText: "Reservation Cancellation", translatedText: "예약 취소"),
        RealmVocaModel(sourceText: "Front Office", translatedText: " 프런트 오피스"),
        RealmVocaModel(sourceText: "Housekeeping Service", translatedText: "하우스키퍼 서비스"),
        RealmVocaModel(sourceText: "Overbooking", translatedText: "과도 예약"),
        RealmVocaModel(sourceText: "Bed and Breakfast", translatedText: "민박"),
        RealmVocaModel(sourceText: "Backpacker Hostel", translatedText: "배낭 여행자 호스텔"),
        RealmVocaModel(sourceText: "Room Rate", translatedText: "객실 요금"),
        RealmVocaModel(sourceText: "Vacation Rental", translatedText: "휴가 임대"),
        RealmVocaModel(sourceText: "Room Key", translatedText: "객실 열쇠"),
        RealmVocaModel(sourceText: "View", translatedText: "전망"),
        RealmVocaModel(sourceText: "Front Desk Clerk", translatedText: "프런트 데스크 직원"),
        RealmVocaModel(sourceText: "Room Availability", translatedText: "객실 이용 가능 여부"),
        RealmVocaModel(sourceText: "Group Reservation", translatedText: "단체 예약"),
        RealmVocaModel(sourceText: "Hotel Manager", translatedText: "호텔 매니저"),
        RealmVocaModel(sourceText: "Key Deposit", translatedText: "열쇠 보증금"),
        RealmVocaModel(sourceText: "Turn-down Service", translatedText: "특별 서비스"),
        RealmVocaModel(sourceText: "Accommodation Voucher", translatedText: "숙박권"),
        RealmVocaModel(sourceText: "Cancellation Fee", translatedText: "취소 수수료"),
        RealmVocaModel(sourceText: "Front Desk Agent", translatedText: "프런트 데스크 직원"),
        RealmVocaModel(sourceText: "Hotel Directory", translatedText: "호텔 안내 디렉토리"),
        RealmVocaModel(sourceText: "Hotel Room Service", translatedText: "호텔 룸 서비스"),
        RealmVocaModel(sourceText: "Late Arrival", translatedText: "늦은 도착"),
        RealmVocaModel(sourceText: "No-show", translatedText: "노쇼"),
        RealmVocaModel(sourceText: "Room Assignment", translatedText: "객실 배정"),
        RealmVocaModel(sourceText: "Room Change", translatedText: "객실 변경"),
        RealmVocaModel(sourceText: "Room Upgrade", translatedText: "객실 업그레이드"),
        RealmVocaModel(sourceText: "Vacation Home", translatedText: "휴가용 주택"),
        RealmVocaModel(sourceText: "Tourist Accommodation", translatedText: "관광 숙박시설"),
        RealmVocaModel(sourceText: "Front Desk Receptionist", translatedText: "프런트 데스크 접수원"),
        RealmVocaModel(sourceText: "Reservation Policy", translatedText: "예약 정책"),
        RealmVocaModel(sourceText: "Accommodation Options", translatedText: "숙박 옵션"),
        RealmVocaModel(sourceText: "Front Desk Attendant", translatedText: "프런트 데스크 담당자"),
        RealmVocaModel(sourceText: "Hostelry", translatedText: "숙박업"),
        RealmVocaModel(sourceText: "Room Availability Status", translatedText: "객실 이용 가능 상태"),
        RealmVocaModel(sourceText: "Hostel Dormitory", translatedText: "호스텔 기숙사"),
        RealmVocaModel(sourceText: "Booking Confirmation", translatedText: "예약 확인"),
        RealmVocaModel(sourceText: "Room Reservation", translatedText: "객실 예약"),
        RealmVocaModel(sourceText: "Room Rate Plan", translatedText: "객실 요금 계획"),
        RealmVocaModel(sourceText: "Accommodation Costs", translatedText: "숙박 비용"),
        RealmVocaModel(sourceText: "Reservation System", translatedText: "예약 시스템"),
        RealmVocaModel(sourceText: "Accommodation Facilities", translatedText: "숙박 시설")
    ]
}
