//
//  BakeryDetailCollectionViewHeader.swift
//  GEON-PPANG-iOS
//
//  Created by kyun on 2023/07/19.
//

import UIKit

import SnapKit
import Then

enum SectionType {
    case info
    case menu
    case reviewCategory
    case writtenReviews
}

final class BakeryDetailCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - Property
    
    private var sectionType: SectionType = .info {
        didSet {
            getType(sectionType)
        }
    }
    private var reviewCount: UInt16 = 28
    private var titleText: String {
        switch sectionType {
        case .info:
            return "가게 상세정보"
        case .menu:
            return "가게 메뉴"
        case .reviewCategory:
            return "건빵집 리뷰"
        case .writtenReviews:
            return "작성된 리뷰 (\(reviewCount))개"
        }
    }
    
    // MARK: - UI Property
    
    private let titleLabel = UILabel()
    private let subTitleStackView = IconLabelStackView(type: .notice)
    private lazy var reviewSortButton = ReviewSortButton()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
            
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting
    
    private func setUI() {
        
        self.backgroundColor = .gbbWhite
        
        titleLabel.do {
            $0.basic(text: titleText, font: .bodyB1!, color: .gbbBlack!)
            $0.frame.size = $0.sizeThatFits(self.frame.size)
        }
        
        subTitleStackView.do {
            $0.spacing = 4
        }
    }
    
    private func setLayout() {
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
            $0.height.equalTo(22)
        }
    }
    
    // MARK: - Custom Method
    
    func configureSubTitle() {
        
        self.addSubview(subTitleStackView)
        
        subTitleStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalTo(titleLabel) // 여기 이상하게 잡힘 (후순위, 아이콘라벨스택뷰 확인요망, remake~)
        }
    }
    
    func configurereviewSortButton() {
        
        self.addSubview(reviewSortButton)
        
        reviewSortButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(79)
            $0.height.equalTo(36)
        }
    }
    
    func getType(_ type: SectionType) {
        switch type {
        case .info:
            configureSubTitle()
        case .writtenReviews:
            configurereviewSortButton()
        default:
            return
        }
    }
    
    
}
