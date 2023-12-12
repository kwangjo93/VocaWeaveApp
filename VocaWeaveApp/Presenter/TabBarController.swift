//
//  TabBarController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/8/23.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let vocaViewController = UINavigationController(rootViewController: VocaViewController())
        vocaViewController.tabBarItem = UITabBarItem(
            title: "단어장",
            image: UIImage(systemName: "pencil.circle"),
            selectedImage: UIImage(systemName: "pencil.circle.fill")
        )

        let categoryWordsViewController = UINavigationController(rootViewController: CategoryViewController())
        categoryWordsViewController.tabBarItem = UITabBarItem(
            title: "암기장",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )

        let vocaWeaveViewController = UINavigationController(rootViewController: VocaWeaveViewController())
        vocaWeaveViewController.tabBarItem = UITabBarItem(
            title: "학습",
            image: UIImage(systemName: "puzzlepiece"),
            selectedImage: UIImage(systemName: "puzzlepiece.fill")
        )

        let dictionaryViewController = UINavigationController(rootViewController: DictionaryViewController())
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

}
