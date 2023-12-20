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
    let vocaTranslatedViewModel: VocaTranslatedViewModel
    let vocaListViewModel: VocaListViewModel

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
    init(categoryViewModel: CategoryViewModel,
         vocaListViewModel: VocaListViewModel,
         vocaTranslatedViewModel: VocaTranslatedViewModel) {
        self.categoryViewModel = categoryViewModel
        self.vocaListViewModel = vocaListViewModel
        self.vocaTranslatedViewModel = vocaTranslatedViewModel
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
        if indexPath.row == 0 {
            categoryDetailView = CategoryDetailViewController(
                firstString: "나의 단어장",
                secondString: "사전 단어장",
                navigationTitle: categoryTittle,
                vocaListViewModel: vocaListViewModel,
                vocaTranslatedViewModel: vocaTranslatedViewModel,
                firstVocaData: categoryViewModel.selectedVoca,
                secondVocaData: nil,
                dicData: categoryViewModel.selectedDic,
                distinguishSavedData: true)
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        } else if indexPath.row == 1 {
            categoryDetailView = CategoryDetailViewController(
                firstString: "",
                secondString: "",
                navigationTitle: categoryTittle,
                vocaListViewModel: vocaListViewModel,
                vocaTranslatedViewModel: vocaTranslatedViewModel,
                firstVocaData: categoryViewModel.transportationVoca,
                secondVocaData: nil,
                dicData: nil,
                distinguishSavedData: true)
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        } else if indexPath.row == 2 {
            categoryDetailView = CategoryDetailViewController(
                firstString: "",
                secondString: "",
                navigationTitle: categoryTittle,
                vocaListViewModel: vocaListViewModel,
                vocaTranslatedViewModel: vocaTranslatedViewModel,
                firstVocaData: categoryViewModel.transportationVoca,
                secondVocaData: nil,
                dicData: nil,
                distinguishSavedData: true)
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        } else if indexPath.row == 3 {
            categoryDetailView = CategoryDetailViewController(
                firstString: "여행 관련 활동",
                secondString: "여행 준비물",
                navigationTitle: categoryTittle,
                vocaListViewModel: vocaListViewModel,
                vocaTranslatedViewModel: vocaTranslatedViewModel,
                firstVocaData: categoryViewModel.travelActivitiesVoca,
                secondVocaData: categoryViewModel.travelEssentials,
                dicData: nil,
                distinguishSavedData: false)
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        } else if indexPath.row == 4 {
            categoryDetailView = CategoryDetailViewController(
                firstString: "식사",
                secondString: "지역 문화",
                navigationTitle: categoryTittle,
                vocaListViewModel: vocaListViewModel,
                vocaTranslatedViewModel: vocaTranslatedViewModel,
                firstVocaData: categoryViewModel.diningVoca,
                secondVocaData: categoryViewModel.cultureVoca,
                dicData: nil,
                distinguishSavedData: false)
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        } else if indexPath.row == 5 {
            categoryDetailView = CategoryDetailViewController(
                firstString: "",
                secondString: "",
                navigationTitle: categoryTittle,
                vocaListViewModel: vocaListViewModel,
                vocaTranslatedViewModel: vocaTranslatedViewModel,
                firstVocaData: categoryViewModel.leisureVoca,
                secondVocaData: nil,
                dicData: nil,
                distinguishSavedData: false)
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        } else if indexPath.row == 6 {
            categoryDetailView = CategoryDetailViewController(
                firstString: "",
                secondString: "",
                navigationTitle: categoryTittle,
                vocaListViewModel: vocaListViewModel,
                vocaTranslatedViewModel: vocaTranslatedViewModel,
                firstVocaData: categoryViewModel.communicationVoca,
                secondVocaData: nil,
                dicData: nil,
                distinguishSavedData: false)
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        } else if indexPath.row == 7 {
            categoryDetailView = CategoryDetailViewController(
                firstString: "",
                secondString: "",
                navigationTitle: categoryTittle,
                vocaListViewModel: vocaListViewModel,
                vocaTranslatedViewModel: vocaTranslatedViewModel,
                firstVocaData: categoryViewModel.facilitiesVoca,
                secondVocaData: nil,
                dicData: nil,
                distinguishSavedData: false)
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        }
    }
}

/// 네트워킹 시 맨 끝 공백을 할경우 처리하기. 지금은 언어 불가능으로 뜬다.
/// selec 된 상태에서 북마크 표시 시 즉각적으로 뷰에서 제거가 되도록
/// 헤더뷰가 추가된 상태에서는 바로 보이지만, 데이터더미에서는 헤더뷰 안보이는 현상 발생.
