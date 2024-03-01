# VocaWeaveApp
영어 단어를 저장하고 저장한 단어를 바탕으로 문장 만들기 연습!! - 보카위브

## 개발 배경
영어 공부 하는 것을 좋아합니다. app store 에서 영어 단어장 어플들을 보면 단어를 제공해주면서 공부를 하거나, 또는 단어를 저장하는 형식의 어플이 있습니다. 

하지만 단어를 저장을 하는데 빠르게 저장하거나 상황에 맞게 저장할 수 있는 단어장이 있으면 좋을 것 같다고 생각해서 단어장 앱을 만들게 되었습니다. 

그리고 개인적으로 영어는 직접 영어로 생각하고 말하는 등의 행동이 필요하고 나아가 실력이 향상된다고 생각하여 문장을 만들 수 있는 기능도 구현했습니다.

## 프로젝트 기간
2023. 12 . 08 ~ 2024. 02. 01

## 개발 환경
+ iOS - 15.0
+ UI - CodaBase
+ Design Pattern - MVVM
+ Database - Realm
+ API - Papago.naver API

## 구현 기능
+ 단어만 제공해 주는 영어 단어장 앱이 아니라 나만의 영어 공부에 따라 원하는 단어를 빠르게 저장
+ 사전 API 를 통해 검색을 하고 공부를 위해 저장
+ 상황별 영어 단어 제공
+ 다크모드 제공
+ 북마크 기능으로 어려운 단어 숙지 가능
+ 스피커 기능으로 발음 확인 가능
+ 내가 저장한 단어로 영어 작문 공부

## 시연영상 및 앱 사진
<img src="https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/40474f07-191a-4e5b-b97d-4f379a975f7a" alt="Simulator Screenshot - iPhone 15 Pro - 2024-02-27 at 15 12 10" width="250" height="500">
<img src="https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/7dc9a346-6060-4155-bfba-376ea4be0274" alt="Simulator Screenshot - iPhone 15 Pro - 2024-02-27 at 15 12 10" width="250" height="500">
<img src="https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/52a35cb2-ba0f-43b4-9196-e536a2484048" alt="Simulator Screenshot - iPhone 15 Pro - 2024-02-27 at 15 12 10" width="250" height="500">
<img src="https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/23a86a4d-15eb-4331-89b0-2190c0028ca6" alt="Simulator Screenshot - iPhone 15 Pro - 2024-02-27 at 15 12 10" width="250" height="500">
<img src="https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/00b3c768-4578-49a8-8159-cf535d32bda9" alt="Simulator Screenshot - iPhone 15 Pro - 2024-02-27 at 15 12 10" width="250" height="500">
<img src="https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/b66dee63-3c24-40d8-b8af-8d8fa34dd019" alt="Simulator Screenshot - iPhone 15 Pro - 2024-02-27 at 15 12 10" width="250" height="500">
<img src="https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/cc57fda7-c80d-44f6-a182-197d8d3e40ed" alt="Simulator Screenshot - iPhone 15 Pro - 2024-02-27 at 15 12 10" width="250" height="500">
<img src="https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/7a8255d0-84fb-4475-bed2-90d1e94e7477" alt="Simulator Screenshot - iPhone 15 Pro - 2024-02-27 at 15 12 10" width="250" height="500">

## 다이어그램
+ 클래스 다이어그램
 <img src="https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/f8bf822e-6154-4e60-8fd8-1ae6004a87ed" width="1000" height="650">

+ 시퀸스 다이어그램
![보카위브 - 시퀸스 다이어그램](https://github.com/kwangjo93/VocaWeaveApp/assets/125628009/f9af7555-a4ec-44a5-85d9-de753bb78d24)



## 배운점
- 새로운 기술의 사용
    - DiffableDataSource
        - 기존 DataSource 프로토콜을 사용했을 때는 변경 사항을 추적하여 reLaodData()를 해야하는 번거로움과 코드가 지저분해지는 문제가 있었는데, DiffableDataSource 에는 자동으로 데이터가 변경되면 추적하여 변경된 데이터만 업데이트되어 더 빠르게 느껴진다.
        - 처음에는 기존 코드와 너무 달라서 어려움이 많았지만 작동되는 방식을 알게 된 후로는 어떤 상황에서든지 snapshot 을 통해 데이터 관리가 수월하고 코드가 가독성이 좋아져 더 직관적으로 바뀌었다.
    - Combine
        - swiftUI + Combine , UIkit + RxSwift 둘 다 조금씩 공부하고 있었지만 RxSwift는 라이브러리를 사용해야 하는 점에서 이번 프로젝트에서는 최소한의 라이브러리를 사용할 목적이 있었기에 UIKit + Combine으로 적용했다.
        - 반응형 코드답게 여러 명령 코드를 적지 않아도 적은 코드로 데이터를 처리할 수 있어서 좋았다.
    - Async await
        - 기존 API 관련 코드를 작성할 때 Completion 의 콜백지옥을 경험한 적이 있었는데, 이번에는 Async await 을 사용하여 코드의 가독성이 향상했다.
        - 코드가 직관적으로 변경되어 이해하기 쉬워졌지만, 아직 부족한 부분이 많아 좀 더 다양하게 사용할 수 있도록 공부해야겠다는 생각이 든다.
     
          
- SwiftLint
    
    처음으로 SwiftLint를 사용해봤다. 어떻게 하면 코드를 보기 좋게 할 수 있을지에 대해서는 고민을 하고 있었지만 누군가의 가르침이 있지도 않았고 혼자서 다른 사람의 코드를 보고 괜찮다고 생각하면 따라하는 정도였다. 하지만 SwiftLint에 대해 알게되었고 이번에 처음으로 도입하여 사용했다. 규칙을 추가적으로 추가하지는 않았고 기본 규칙을 따라 코드를 작성했다.
    
    - 일관성이 생기다 보니 가독성이 좋고 코드 품질이 좋아졌다.
    - 규칙을 추가, 변경의 용이성. → 이번에는 기본 규칙만을 따라 코드를 작성했지만, 협업을 하거나 특정 상황에서는 규칙을 변경할 수 있다는 용이성이 좋다.
- MVVM
    
    지금까지의 모든 프로젝트는 MVC 패턴으로만 만들었는데 이번 프로젝트에는 처음으로 MVVM 패턴을 사용해서 앱을 만들고 출시까지 하였다. MVC에서는 ViewController의 코드가 500줄 까지 있었지만 MVVM 패턴을 사용하면서 200 ~ 300줄로 줄였다. `의존성 역전`과 `캡슐화`에 대해 공부하고 적용하였으며 각 객체에 대해서 사용성에 맞게 분리하여 유지보수에도 용이하도록 하였다.
    
    처음 MVVM 패턴을 사용한 것에 대해 많이 배운 점들도 있지만 아래와 같은 아쉬운 점도 있다.
    
    - 테스트 코드 : TDD, Unit Text 와 같은 테스트 코드를 작성해보지 못한 것이 아쉬웠다. 모든 것이 처음이기에 출시, MVVM 패턴과 Text Code 모두 적용하기에는 쉽지 않았고 어려웠다. 다음에는 테스트에 대해서 공부를 하고 프로젝트에 적용할 계획이다.
    - Protocol - Input, Output : 앱을 출시하고 iOS 현직 튜터님과 대화할 시간이 있었다.. Combine을 사용하여 데이터를 처리하는 것은 좋으나 코드를 더 깔끔하게 해주고 유지보수에 더 좋은 Protocol - Input, Output 를 적용하면 좋을 것이라는 피드백을 받았다. 코드 전체를 리펙토링 하려고 공부를 했는데 대부분의 예시코드는 RXSwift(RxCocoa)를 사용하여 [button.rx.tab](http://button.rx.tab) 을 사용하여 input으로 주는 형식을 사용한 것을 참고했다. Combine은 그런 기능이 내재되어 있지 않아 라이브러리를 사용하던지 아니면 extension으로 만들어야 하는 상황이었다. 과감하게 바꾸는 것이 좋은가 아니면 지금 나의 로직과 코드에서 바꾸는 것이 정말 필요한 것인지에 대해 `고민`을 했다. `사실 제대로 필요한지를 알려면 직접 경험하는 것이 좋다고 생각하여` 일단은 addtarget으로 하고 다음 프로젝트에서 input output을 사용한 MVVM 패턴을 사용할 예정이다. 그리고 난 후 MVVM 패턴에 있어서 어떤 상황에서 사용하고 어떤 장점과 단점이 있는지에 대한 개념을 확립할 것이다.
- Realm
    
    데이터 베이스 프레임워크로는 대표적인 것으로 CoreData 와 Realm이 있고 CoreData는 프로젝트에 사용한 경험이 있어서 이번에는 Realm을 적용했다. 둘 다 모두 쿼리 기능이 있어서 다양한 카테고리의 데이터를 저장하고 쿼리 별로 데이터를 로드할 수 있어서 편리하게 사용하였다.  
    
     Realm은 내부적으로 C++로 작성되어 있어서 CoreData보다 빠르다고 하는데 사실 많은 데이터를 저장하고 관리하는 것이 아니기 때문에 크게 느끼지는 못했다. 
    
     결정적으로 Realm 을 사용하면서 좋았던 부분은 간결성이다. CoreData 는 스키마 중심적인 접근으로 초키 코드를 구현하는데 복잡한 부분이 있는데 반대로 Realm은 객체 중심적으로 Realm() 객체를 만들어서 object를 통해 값을 언제든지 저장, 불러오기 가능해서 편하게 사용하였다.
    
- 첫 출시
    
    팀 프로젝트로 다른 사람의 애플 아이디를 통해 출시한 경험이 있지만 직접 혼자서 출시를 하는 것은 처음이다. 사실 앱을 출시하는 모든 과정에서 기능을 개발하는 것은 큰 문제가 아니였으나, 앱의 UI, Design 을 혼자 생각하고 준비한다는게 어려운 부분이었다. UX적인 부분은 사용하면서 개선을 했기 때문에 디자인 보다는 큰 어려움 없었다. 
    
     직접 apple connect에 들어가보고 배포를 하고 리젝을 받아 처리를 하는 것이 나에게 큰 경험을 주었다. 프로젝트를 진행하면서 내가 지금 하고 있는 부분이 맞는 것인가 계속 생각하게 되고 그런 불안감 속에서 책임감을 가지고 프로젝트를 완성했다. 완성된 후에는 뿌듯함과 함께 약간의 자부심과 자존감이 올라갔다. 하지만 아직도 많이 부족한 만큼 공부할 것들이 쌓이고 다음에는 더 큰 앱과 성장으로 좋은 서비스를 제공하고 싶다.
    
- Git
    
    이번 프로젝트에는 git 관리에 소홀했던 것 같다. 다시 되돌아가 다시 프로젝트를 시작할 수 있다면.. git flow, git **strategy 에 대해서 좀 더 공부를 하고 깔끔하게 하려고 노력했을 것 같다. 팀 프로젝트를 연속으로 하면서 정해진 규칙을 만들고 따르기만 했던 것이 익숙해져서인지 규칙을 스스로 만들지 않고 시작을 해서 많이 지저분해졌다.** 
    
    **마지막 배포 업데이트를 진행하면서 파일 이름을 변경하였고 이에 대해 editor에서 수정을 하지 않아 github build에서 문제가 생겼다. 다른 브랜치로 이동하려 했는데 에러가 발생하면서  main branch 에서 이동이 불가능하여  파일 이름 변경에 대해서 수정을 하고 push를 하게 되었다. 파일 명을 변경한 것은 이번이 처음이었고 좋은 경험을 했다 생각한다..**
    
    **다음에는 에러에 대한 처리는 미리 하고 메인으로 보내기 전에 모두 처리한 다음에 할 수 있도록 해야겠다.**

## 트러블 슈팅
+ 노션링크 참조
https://momentous-handsaw-e7b.notion.site/596f631a6dee4ff996dd198353a6d3d7?pvs=4
