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
    private let vocaTranslatedManager: VocaTranslatedManager
    private let categoryManager: CategoryDataManager
    private lazy var vocaListVM = VocaListVM(datamanager: vocaListManager)
    private lazy var vocaTranslatedVM = VocaTranslatedVM(datamanager: vocaTranslatedManager)
    private lazy var categoryVM = CategoryVM(vocaTranslatedManager: vocaTranslatedManager,
                                             vocaListManager: vocaListManager,
                                             vocaListVM: vocaListVM,
                                             vocaTranslatedVM: vocaTranslatedVM)
    private lazy var vocaWeaveVM = VocaWeaveVM(vocaListManager: vocaListManager,
                                               vocaTranslatedManager: vocaTranslatedManager)
    private lazy var dictionaryVM = DictionaryVM(vocaTranslatedVM: vocaTranslatedVM,
                                                 vocaTranslatedData: nil)
    // MARK: - init
    init(vocaListManager: VocaListManager,
         vocaTranslatedManager: VocaTranslatedManager,
         categoryManager: CategoryDataManager) {
        self.vocaListManager = vocaListManager
        self.vocaTranslatedManager = vocaTranslatedManager
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
            rootViewController: VocaVC(vocaTranslatedVM: vocaTranslatedVM,
                                        vocaListVM: vocaListVM))

        let categoryWordsViewController = UINavigationController(
            rootViewController: CategoryVC(categoryViewModel: categoryVM))

        let vocaWeaveViewController = UINavigationController(
            rootViewController: VocaWeaveVC(vocaWeaveViewModel: vocaWeaveVM))

        let dictionaryViewController = UINavigationController(
            rootViewController: DictionaryVC(dictionaryEnum: .new,
                                             dictionaryVM: dictionaryVM))

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
