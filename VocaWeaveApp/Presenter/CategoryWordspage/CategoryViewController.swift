//
//  CategoryViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/9/23.
//

import UIKit
import SnapKit

class CategoryViewController: UIViewController {
    // MARK: - Property
    private var collectionView: UICollectionView!
    let dataArray: [String] = ["ddd", "d12dd", "ddd23", "dd234d", "ddsdd", "ddaad", "ddffd", "ddsdd"]
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        setup()
        collectionViewLayout()
    }
    // MARK: - Helper
    private func configureNav() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "암기장"
            label.textColor = UIColor.label
            label.font = .boldSystemFont(ofSize: 32)
            return label
        }()
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem
        navigationController?.configureBasicAppearance()
    }

    private func setup() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CagtegoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CagtegoryCollectionViewCell.identifier)
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ -> NSCollectionLayoutSection? in
                    guard let self = self else { return nil }
                    return createSectionItem()
        }
    }

    private func createSectionItem() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.95))
        let spacing = CGFloat(20)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: dataArray.count)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let inset = (view.bounds.width - itemSize.widthDimension.dimension) / 2.0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: 0, trailing: inset)
        return section
    }

    private func collectionViewLayout() {
        let defaultValue = 8
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(defaultValue)
        }
    }
    // MARK: - Action

}

extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                                withReuseIdentifier: CagtegoryCollectionViewCell.identifier,
                                for: indexPath) as? CagtegoryCollectionViewCell
                                else { return UICollectionViewCell()}
        let data = dataArray[indexPath.row]
        cell.categoryLabel.text = data
        return cell
    }
}
