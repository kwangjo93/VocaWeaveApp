//
//  CategoryVC.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 12/9/23.
//

import UIKit
import SnapKit

final class CategoryVC: UIViewController {
    // MARK: - Property
    private let categoryVM: CategoryVM
    private var collectionView: UICollectionView!
    private let categoryTittle: [String] = ["나의 단어장\n/ 사전 단어장",
                                            "교통 수단",
                                            "숙소",
                                            "여행 관련 활동\n/ 여행 준비물",
                                            "식사\n/ 지역 문화",
                                            "휴양 및 활동",
                                            "언어 및 소통",
                                            "장소 관련 시설"]
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    // MARK: - init
    init(categoryVM: CategoryVM) {
        self.categoryVM = categoryVM
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Helper
private extension CategoryVC {
    func setup() {
        configureNav()
        configureUI()
        collectionViewLayout()
    }

    func configureNav() {
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

    func configureUI() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CategoryCell.self,
                                forCellWithReuseIdentifier: CategoryCell.identifier)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func setGradientColor(for cell: CategoryCell) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = UIColor.gradientColor
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = cell.bounds
        gradientLayer.cornerRadius = 15
        setShadow(view: gradientLayer)
        cell.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setShadow(view: CAGradientLayer) {
        let mode = traitCollection.userInterfaceStyle
        view.shadowColor = mode == .dark ? UIColor.label.cgColor : UIColor.black.cgColor
        view.shadowOffset = CGSize(width: 0, height: 5)
        view.shadowOpacity = 0.5
        view.shadowRadius = 8
    }

    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] _, _ -> NSCollectionLayoutSection? in
                    guard let self = self else { return nil }
                    return createSectionItem()
        }
    }

    func createSectionItem() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(0.7))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let spacing = CGFloat(20)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    func collectionViewLayout() {
        let defaultValue = 8
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(defaultValue * 2)
            $0.leading.trailing.equalToSuperview().inset(defaultValue * 2)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(defaultValue)
        }
    }
}
// MARK: - UICollectionViewDataSource
extension CategoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categoryTittle.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                                                withReuseIdentifier: CategoryCell.identifier,
                                                for: indexPath) as? CategoryCell
                                                else { return UICollectionViewCell()}
        let categoryTittle = categoryTittle[indexPath.row]
        cell.categoryLabel.text = categoryTittle
        setGradientColor(for: cell)
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension CategoryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryTittle = categoryTittle[indexPath.row]
        var categoryDetailView: CategoryDetailVC
        switch indexPath.row {
        case 0:
            categoryDetailView = CategoryDetailVC(
                firstString: "나의 단어장",
                secondString: "사전 단어장",
                navigationTitle: categoryTittle,
                indexPath: indexPath.row,
                categoryVM: categoryVM,
                distinguishSavedData: true)
            categoryDetailView.bindVocaData()
            self.navigationController?.pushViewController(categoryDetailView, animated: true)
        case 1, 2, 5, 6, 7:
            categoryDetailView = CategoryDetailVC(
                firstString: "",
                secondString: "",
                navigationTitle: categoryTittle,
                indexPath: indexPath.row,
                categoryVM: categoryVM,
                distinguishSavedData: false)
            categoryDetailView.bindVocaData()
            self.navigationController?.pushViewController(categoryDetailView, animated: false)
        case 3:
            categoryDetailView = CategoryDetailVC(
                firstString: "여행 관련 활동",
                secondString: "여행 준비물",
                navigationTitle: categoryTittle,
                indexPath: indexPath.row,
                categoryVM: categoryVM,
                distinguishSavedData: false)
            categoryDetailView.bindVocaData()
            self.navigationController?.pushViewController(categoryDetailView, animated: false)
        case 4:
            categoryDetailView = CategoryDetailVC(
                firstString: "식사",
                secondString: "지역 문화",
                navigationTitle: categoryTittle,
                indexPath: indexPath.row,
                categoryVM: categoryVM,
                distinguishSavedData: false)
            categoryDetailView.bindVocaData()
            self.navigationController?.pushViewController(categoryDetailView, animated: false)
        default:
            break
        }
    }
}
