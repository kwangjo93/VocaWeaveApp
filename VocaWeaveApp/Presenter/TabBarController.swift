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
    private lazy var vocaListViewModel = VocaListViewModel(datamanager: vocaListManager)
    private lazy var vocaTranslatedViewModel = VocaTranslatedViewModel(datamanager: vocaTranslatedManager)
    private lazy var categoryViewModel = CategoryViewModel(
                                                    vocaTranslatedViewManager: vocaTranslatedManager,
                                                    vocaListManager: vocaListManager,
                                                    vocaListViewModel: vocaListViewModel,
                                                    vocaTranslatedViewModel: vocaTranslatedViewModel)
    private lazy var vocaWeaveViewModel = VocaWeaveViewModel(vocaListManager: vocaListManager)
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
            rootViewController: VocaViewController(
                vocaTranslatedManager: vocaTranslatedViewModel,
                vocaListManager: vocaListViewModel
            )
        )
        vocaViewController.tabBarItem = UITabBarItem(
            title: "단어장",
            image: UIImage(systemName: "pencil.circle"),
            selectedImage: UIImage(systemName: "pencil.circle.fill")
        )

        let categoryWordsViewController = UINavigationController(
            rootViewController: CategoryViewController(categoryViewModel: categoryViewModel))
        categoryWordsViewController.tabBarItem = UITabBarItem(
            title: "암기장",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )

        let vocaWeaveViewController = UINavigationController(
            rootViewController: VocaWeaveViewController(vocaWeaveViewModel: vocaWeaveViewModel))
        vocaWeaveViewController.tabBarItem = UITabBarItem(
            title: "학습",
            image: UIImage(systemName: "puzzlepiece"),
            selectedImage: UIImage(systemName: "puzzlepiece.fill")
        )

        let dictionaryViewController = UINavigationController(
            rootViewController: DictionaryViewController(
                                    vocaTranslatedData: nil,
                                    dictionaryEnum: .new,
                                    vocaTranslatedViewModel: vocaTranslatedViewModel))
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
