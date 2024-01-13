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
    private lazy var vocaListViewModel = VocaListVM(datamanager: vocaListManager)
    private lazy var vocaTranslatedViewModel = VocaTranslatedVM(datamanager: vocaTranslatedManager)
    private lazy var categoryViewModel = CategoryVM(
                                                    vocaTranslatedManager: vocaTranslatedManager,
                                                    vocaListManager: vocaListManager,
                                                    vocaListVM: vocaListViewModel,
                                                    vocaTranslatedVM: vocaTranslatedViewModel)
    private lazy var vocaWeaveViewModel = VocaWeaveVM(vocaListManager: vocaListManager)
    private lazy var dictionaryViewModel = DictionaryVM(
                                            vocaTranslatedViewModel: vocaTranslatedViewModel)
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
        makeListsForRealm(lists: categoryManager.getAllVocaData())
        let vocaViewController = UINavigationController(
            rootViewController: VocaVC(
                vocaTranslatedVM: vocaTranslatedViewModel,
                vocaListVM: vocaListViewModel
            )
        )
        vocaViewController.tabBarItem = UITabBarItem(
            title: "단어장",
            image: UIImage(systemName: "pencil.circle"),
            selectedImage: UIImage(systemName: "pencil.circle.fill")
        )

        let categoryWordsViewController = UINavigationController(
            rootViewController: CategoryVC(categoryViewModel: categoryViewModel))
        categoryWordsViewController.tabBarItem = UITabBarItem(
            title: "암기장",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )

        let vocaWeaveViewController = UINavigationController(
            rootViewController: VocaWeaveVC(vocaWeaveViewModel: vocaWeaveViewModel))
        vocaWeaveViewController.tabBarItem = UITabBarItem(
            title: "학습",
            image: UIImage(systemName: "puzzlepiece"),
            selectedImage: UIImage(systemName: "puzzlepiece.fill")
        )

        let dictionaryViewController = UINavigationController(
            rootViewController: DictionaryVC(
                                    vocaTranslatedData: nil,
                                    dictionaryEnum: .new,
                                    vocaTranslatedVM: nil,
                                    dictionaryVM: dictionaryViewModel))
        dictionaryViewController.tabBarItem = UITabBarItem(
            title: "사전",
            image: UIImage(systemName: "character.book.closed"),
            selectedImage: UIImage(systemName: "character.book.closed.fill")
        )

        viewControllers = [vocaViewController,
                           categoryWordsViewController,
                           vocaWeaveViewController,
                           dictionaryViewController]
    }
    // MARK: - Helper
    private func makeListsForRealm(lists: [RealmVocaModel]) {
        for list in lists {
            vocaListManager.makeNewList(list)
        }
    }
}
