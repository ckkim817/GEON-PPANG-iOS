//
//  BakeryListViewController.swift
//  GEON-PPANG-iOS
//
//  Created by JEONGEUN KIM on 2023/07/08.
//

import UIKit

import SnapKit
import Then

final class BakeryListViewController: BaseViewController {
    
    // MARK: - Property
    
    enum Section {
        case main
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, BakeryList>
    private var dataSource: DataSource?
    private var bakeryList: [BakeryList] = []
    private var sortBakeryBy: SortBakery = .byDefault
    private var sortBakeryName: String = SortBakery.byDefault.sortValue
    private lazy var safeArea = self.view.safeAreaLayoutGuide
    private var filterStatus: [Bool] = [false, false, false ]
    
    // MARK: - UI Property
    
    private let bakeryTopView = BakeryListTopView()
    private let bakeryFilterView = BakeryFilterView()
    private lazy var bakeryListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getBakeryList(sort: self.sortBakeryName,
                      isHard: false,
                      isDessert: false,
                      isBrunch: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        setDataSource()
        setReloadData()
        
    }
    
    // MARK: - Setting
 
    override func setLayout() {
        
        view.addSubview(bakeryTopView)
        bakeryTopView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.height.equalTo(91)
        }
        
        view.addSubview(bakeryFilterView)
        bakeryFilterView.snp.makeConstraints {
            $0.top.equalTo(bakeryTopView.snp.bottom)
            $0.directionalHorizontalEdges.equalTo(safeArea)
            $0.height.equalTo(convertByHeightRatio(72))
        }
        
        view.addSubview(bakeryListCollectionView)
        bakeryListCollectionView.snp.makeConstraints {
            $0.top.equalTo(bakeryFilterView.snp.bottom)
            $0.leading.equalTo(safeArea)
            $0.trailing.equalTo(safeArea)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setUI() {
        
        bakeryTopView.do {
            $0.addActionToSearchButton {
                Utils.push(self.navigationController, SearchViewController())
            }
        }
        
        bakeryFilterView.do {
            $0.backgroundColor = .clear
            $0.applyAction {
                self.bakeryFilterButtonTapped()
            }
            $0.filterData = { [weak self] data in
                guard let self = self else { return }
                
                for (index, value) in data.enumerated() {
                    self.filterStatus[index] = value
                }
                self.getBakeryList(sort: self.sortBakeryName,
                                       isHard: self.filterStatus[0],
                                       isDessert: self.filterStatus[1],
                                       isBrunch: self.filterStatus[2])
            }
        }
        
        bakeryListCollectionView.do {
            $0.delegate = self
        }
    }
    
    private func layout() -> UICollectionViewLayout {
        
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = .clear
        config.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func setDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<BakeryCommonCollectionViewCell, BakeryList> { (cell, _, item) in
            cell.configureCellUI(data: item)
        }
        
        dataSource = DataSource(collectionView: bakeryListCollectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func setReloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, BakeryList>()
        defer { dataSource?.apply(snapshot, animatingDifferences: false)}
        
        snapshot.appendSections([.main])
        snapshot.appendItems(bakeryList)
    }
    
    // MARK: - Custom Method
    
    private func configureFilterButtonText() {
        
        switch sortBakeryBy {
        case .byDefault: bakeryFilterView.configureFilterButtonText(to: "기본순")
        case .byReviews: bakeryFilterView.configureFilterButtonText(to: "리뷰 많은순")
        }
    }
    
    private func bakeryFilterButtonTapped() {
        
        let sortBottomSheet = SortBottomSheetViewController(sort: sortBakeryBy)
        sortBottomSheet.modalPresentationStyle = .overFullScreen
        sortBottomSheet.dataBind = { sortBy in
            self.sortBakeryBy = sortBy
            self.configureFilterButtonText()
            self.sortBakeryName = sortBy.sortValue
            
            self.getBakeryList(sort: self.sortBakeryName,
                                   isHard: self.filterStatus[0],
                                   isDessert: self.filterStatus[1],
                                   isBrunch: self.filterStatus[2])
        }
        self.present(sortBottomSheet, animated: false)
    }
}

extension BakeryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextViewController = BakeryDetailViewController()
        nextViewController.bakeryID = self.bakeryList[indexPath.item].bakeryID
        Utils.push(self.navigationController, nextViewController)
    }
}

extension BakeryListViewController {
    private func getBakeryList(sort: String,
                               isHard: Bool,
                               isDessert: Bool,
                               isBrunch: Bool) {
        
        BakeryAPI.shared.getBakeryList(sort: sort,
                                       isHard: isHard,
                                       isDessert: isDessert,
                                       isBrunch: isBrunch) { response in
            guard let response = response else { return }
            guard let data = response.data else { return }
            self.bakeryList = []
            
            for item in data {
                self.bakeryList.append(item.convertToBakeryList())
            }
            self.setReloadData()
            self.bakeryListCollectionView.reloadData()
        }
    }
}
