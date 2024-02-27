//
//  TabBarController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit

final class TabBarController: UITabBarController {
    // MARK: - Property
    private let vocaListManager: VocaListManager
    private let apiVocaListManager: APIVocaListManager
    private let categoryManager: CategoryDataManager
    private lazy var vocaListVM = VocaListVM(datamanager: vocaListManager)
    private lazy var apiVocaListVM = APIVocaListVM(datamanager: apiVocaListManager)
    private lazy var categoryVM = CategoryVM(apiVocaListManager: apiVocaListManager,
                                             vocaListManager: vocaListManager,
                                             vocaListVM: vocaListVM,
                                             apiVocaListVM: apiVocaListVM)
    private lazy var vocaWeaveVM = VocaWeaveVM(vocaListManager: vocaListManager,
                                               apiVocaListManager: apiVocaListManager)
    private lazy var dictionaryVM = DictionaryVM(apiVocaListVM: apiVocaListVM,
                                                 apiVocaData: nil,
                                                 dictionaryEnum: .new)
    // MARK: - init
    init(vocaListManager: VocaListManager,
         vocaTranslatedManager: APIVocaListManager,
         categoryManager: CategoryDataManager) {
        self.vocaListManager = vocaListManager
        self.apiVocaListManager = vocaTranslatedManager
        self.categoryManager = categoryManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeListsForRealm(lists: categoryManager.setWithSavedData())

        let vocaViewController = UINavigationController(
            rootViewController: VocaVC(apiVocaListVM: apiVocaListVM,
                                        vocaListVM: vocaListVM))

        let categoryWordsViewController = UINavigationController(
            rootViewController: CategoryVC(categoryVM: categoryVM))

        let vocaWeaveViewController = UINavigationController(
            rootViewController: VocaWeaveVC(vocaWeaveViewModel: vocaWeaveVM))

        let dictionaryViewController = UINavigationController(
            rootViewController: DictionaryVC(dictionaryVM: dictionaryVM))

        vocaViewController.tabBarItem = UITabBarItem(
            title: "단어장",
            image: UIImage(systemName: "pencil.circle"),
            selectedImage: UIImage(systemName: "pencil.circle.fill"))

        categoryWordsViewController.tabBarItem = UITabBarItem(
            title: "암기장",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill"))

        vocaWeaveViewController.tabBarItem = UITabBarItem(
            title: "학습",
            image: UIImage(systemName: "puzzlepiece"),
            selectedImage: UIImage(systemName: "puzzlepiece.fill"))

        dictionaryViewController.tabBarItem = UITabBarItem(
            title: "사전",
            image: UIImage(systemName: "character.book.closed"),
            selectedImage: UIImage(systemName: "character.book.closed.fill"))

        viewControllers = [vocaViewController,
                           categoryWordsViewController,
                           vocaWeaveViewController,
                           dictionaryViewController]
    }
    // MARK: - Helper
    private func makeListsForRealm(lists: [RealmVocaModel]?) {
        if lists != nil {
            guard let lists = lists else { return }
            for list in lists {
                vocaListManager.makeNewList(list)
            }
        }
    }
}
