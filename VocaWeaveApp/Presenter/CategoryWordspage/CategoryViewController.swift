//
//  CategoryViewController.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/9/23.
//

import UIKit
import SnapKit

final class CategoryViewController: UIViewController {
    // MARK: - Property
    let categoryViewModel: CategoryViewModel

    private var collectionView: UICollectionView!
    let categoryTittle: [String] = ["나의 단어장 / 사전 단어장",
                                    "교통 수단",
                                    "숙소",
                                    "여행 관련 활동 / 여행 준비물",
                                    "식사 / 지역 문화",
                                    "휴양 및 활동",
                                    "언어 및 소통",
                                    "장소 관련 시설"]
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    // MARK: - init
    init(categoryViewModel: CategoryViewModel) {
        self.categoryViewModel = categoryViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        configureNav()
        configureUI()
        collectionViewLayout()
    }

    private func configureUI() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CagtegoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: CagtegoryCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
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
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: categoryTittle.count)
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
        return categoryTittle.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                                withReuseIdentifier: CagtegoryCollectionViewCell.identifier,
                                for: indexPath) as? CagtegoryCollectionViewCell
                                else { return UICollectionViewCell()}
        let categoryTittle = categoryTittle[indexPath.row]
        cell.categoryLabel.text = categoryTittle
        return cell
    }
}

extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryTittle = categoryTittle[indexPath.row]
        var categoryDetailView: CategoryDetailViewController
        switch indexPath.row {
        case 0:
            categoryDetailView = CategoryDetailViewController(
                firstString: "나의 단어장",
                secondString: "사전 단어장",
                navigationTitle: categoryTittle,
                indexPath: indexPath.row,
                categoryViewModel: categoryViewModel,
                distinguishSavedData: true)
            categoryDetailView.bindVocaData()
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        case 1, 2, 5, 6, 7:
            categoryDetailView = CategoryDetailViewController(
                firstString: "",
                secondString: "",
                navigationTitle: categoryTittle,
                indexPath: indexPath.row,
                categoryViewModel: categoryViewModel,
                distinguishSavedData: false)
            categoryDetailView.bindVocaData()
            self.navigationController?.pushViewController(categoryDetailView, animated: false)
        case 3:
            categoryDetailView = CategoryDetailViewController(
                firstString: "여행 관련 활동",
                secondString: "여행 준비물",
                navigationTitle: categoryTittle,
                indexPath: indexPath.row,
                categoryViewModel: categoryViewModel,
                distinguishSavedData: false)
            categoryDetailView.bindVocaData()
            self.navigationController?.pushViewController(categoryDetailView, animated: false)
        case 4:
            categoryDetailView = CategoryDetailViewController(
                firstString: "식사",
                secondString: "지역 문화",
                navigationTitle: categoryTittle,
                indexPath: indexPath.row,
                categoryViewModel: categoryViewModel,
                distinguishSavedData: false)
            categoryDetailView.bindVocaData()
            self.navigationController?.pushViewController(categoryDetailView, animated: false)
        default:
            break
        }
    }
}

/// 더미데이터에서 북마크를 눌렀을 경우에 나의 단어장에 북마크 표시  -> distinguishSavedData Bool 값 활용
/// didSelect에서 북마크 해제 시 다시 메인 페이지로 오면 북마크가 업데이트되어 있지 않는 문제 발견.
///  북마크 해제 시 메인페이지에 가서 북마크가 해제된 것을 체크하지 않으면 데이터가 그대로 남아 있다.
