//
//  MyReviewsViewController.swift
//  GEON-PPANG-iOS
//
//  Created by JEONGEUN KIM on 2023/07/12.
//

import UIKit

import SnapKit
import Then

final class MyReviewsViewController: BaseViewController {
    
    // MARK: - Property
    
    private var myReviewsList: [MyReviewsResponseDTO] = []
    
    // MARK: - UI Property
    
    private let naviView = CustomNavigationBar()
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: layout())
    
    // MARK: - Setting
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMyReviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRegistration()
    }
    
    override func setLayout() {
        
        view.addSubview(naviView)
        naviView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalTo(safeArea)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setUI() {
        
        naviView.do {
            $0.configureBottomLine()
            $0.configureBackButtonAction(UIAction { _ in
                self.navigationController?.popViewController(animated: true)
            })
            $0.configureCenterTitle(to: I18N.MyReviews.naviTitle)
        }
        
        collectionView.do {
            $0.backgroundColor = .gbbBackground1
            $0.isScrollEnabled = false
        }
    }
    
    override func setDelegate() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setRegistration() {
        
        collectionView.register(cell: BakeryCommonCollectionViewCell.self)
        collectionView.register(cell: EmptyCollectionViewCell.self)
        collectionView.register(header: MyReviewsHeaderView.self)
        
    }
    
    private func layout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {_, layoutEnvirnment  in
            if self.myReviewsList.isEmpty {
                return LayoutUtils.emptySection(hasHeader: false)
            } else {
                var config = UICollectionLayoutListConfiguration(appearance: .grouped)
                config.backgroundColor = .clear
                config.showsSeparators = true
                config.headerMode = .supplementary
                config.itemSeparatorHandler = { (indexPath, separatorConfiguration) in
                    var configuration = separatorConfiguration
                    configuration.topSeparatorVisibility = .hidden
                    configuration.bottomSeparatorInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
                    if indexPath == self.collectionView.indexPathsForVisibleItems.last {
                        configuration.bottomSeparatorVisibility = .hidden
                    }
                    return configuration
                }
                let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvirnment)
                layoutSection.contentInsets = .zero
                return layoutSection
            }
        }
        return layout
    }

    func configureScrollable(_ count: Int) {
        if count == 0 {
            self.collectionView.isScrollEnabled = false
        } else {
            self.collectionView.isScrollEnabled = true
        }
    }
}

// MARK: - UICollectionViewDelegate

extension MyReviewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard myReviewsList != [] else { return }
        let data = myReviewsList[indexPath.section]
        let bakery = data.bakeryList
        let bakeryData = SimpleBakeryModel(
            bakeryID: bakery.bakeryID,
            bakeryName: bakery.name,
            bakeryImageURL: bakery.picture,
            bakeryIngredients: bakery.breadType.configureTrueOptionStrings(),
            bakeryRegion: bakery.station.components(separatedBy: ", ")
        )
        Utils.push(self.navigationController, ReviewViewController(type: .read, bakeryData: bakeryData, reviewID: data.reviewID))
    }
}

// MARK: - UICollectionViewDataSource

extension MyReviewsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if myReviewsList.isEmpty {
            return 1
        } else {
            return myReviewsList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if myReviewsList.isEmpty {
            let cell: EmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configureViewType(.noReview)
            cell.configureEmptyText("내가 쓴 리뷰가 없어요!")
            return cell
        } else {
            let cell: BakeryCommonCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configureReviewsUI()
            cell.configureCellUI(data: myReviewsList[indexPath.section].bakeryList)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyReviewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if myReviewsList.isEmpty {
            return UICollectionReusableView()
        } else {
            let header: MyReviewsHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, indexPath: indexPath)
            header.configuteDateText(self.myReviewsList[indexPath.row].createdAt)
            return header
        }
    }
}

// MARK: - API

extension MyReviewsViewController {
    
    private func getMyReviews() {
        
        MyPageAPI.shared.getMyReviews { response in
            guard let response = response else { return }
            guard let data = response.data else { return }
            self.myReviewsList = data.map {$0}
            self.collectionView.reloadData()
            self.configureScrollable(self.myReviewsList.count)
        }
    }
}
