//
//  ReviewSortButton.swift
//  GEON-PPANG-iOS
//
//  Created by kyun on 2023/07/20.
//

import UIKit

import SnapKit
import Then

final class ReviewSortButton: UIButton {
    
    // MARK: - UI Property
    
    private let iconLabelStackVIewContainer = UIView()
    private lazy var iconLabelStackVIew = IconLabelStackView(type: .basic)
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting
    
    private func setUI() {
        
        iconLabelStackVIewContainer.do {
            $0.makeBorder(width: 1, color: .gbbGray200!)
            $0.makeCornerRound(radius: 18)
        }
        
        iconLabelStackVIew.do {
            $0.spacing = 5
        }
    }
    
    private func setLayout() {
        
        self.addSubviews(iconLabelStackVIewContainer, iconLabelStackVIew)
        
        iconLabelStackVIewContainer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        iconLabelStackVIew.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(12)
        }
    }
}
