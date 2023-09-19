//
//  ReportViewController.swift
//  GEON-PPANG-iOS
//
//  Created by kyun on 2023/09/17.
//

import UIKit

import SnapKit
import Then

final class ReportViewController: BaseViewController {
    
    // MARK: - Property
    
    private var navigationTitle: String
    private let labeling = [I18N.Report.advertisement,
                            I18N.Report.profanity,
                            I18N.Report.defamation,
                            I18N.Report.others]
    
    // MARK: - UI Property
    
    private let navigationBar = CustomNavigationBar()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let reportingReasonLabel = UILabel()
    private lazy var advertisementReportButton = UIButton(configuration: .plain())
    private lazy var profanityReportButton = UIButton(configuration: .plain())
    private lazy var defamationReportButton = UIButton(configuration: .plain())
    private lazy var othersReportButton = UIButton(configuration: .plain())
    private var selectedButton: UIButton? // 직전에 선택됐던 버튼을 기억
    
    private let detailReasonLabel = UILabel()
    private lazy var detailReasonTextView = DetailReasonTextView()
    
    private let pleaseReportContainer = UIView()
    private let pleaseReportLabel = UILabel()
    
    private lazy var bottomView = BottomView()
    private lazy var writeButton = CommonButton()
    
    private lazy var backgroundView = BottomSheetAppearView()
    private lazy var confirmBottomSheetView = CommonBottomSheet()
    
    // MARK: - Life Cycle
    
    init(title: String) {
        self.navigationTitle = title
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tappedExceptTextView()
    }
    
    // MARK: - Setting
    
    override func setLayout() {
        
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalToSuperview()
        }
        
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(SizeLiteral.Screen.width)
            $0.height.equalTo(568)
        }
        
        contentView.addSubview(reportingReasonLabel)
        reportingReasonLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(223)
            $0.height.equalTo(22)
        }
        
        contentView.addSubview(advertisementReportButton)
        advertisementReportButton.snp.makeConstraints {
            $0.top.equalTo(reportingReasonLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(192)
            $0.height.equalTo(36)
        }
        
        contentView.addSubview(profanityReportButton)
        profanityReportButton.snp.makeConstraints {
            $0.top.equalTo(advertisementReportButton.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(185)
            $0.height.equalTo(36)
        }
        
        contentView.addSubview(defamationReportButton)
        defamationReportButton.snp.makeConstraints {
            $0.top.equalTo(profanityReportButton.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(153)
            $0.height.equalTo(36)
        }
        
        contentView.addSubview(othersReportButton)
        othersReportButton.snp.makeConstraints {
            $0.top.equalTo(defamationReportButton.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(119)
            $0.height.equalTo(36)
        }
        
        contentView.addSubview(detailReasonLabel)
        detailReasonLabel.snp.makeConstraints {
            $0.top.equalTo(othersReportButton.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(242)
            $0.height.equalTo(22)
        }
        
        contentView.addSubview(detailReasonTextView)
        detailReasonTextView.snp.makeConstraints {
            $0.top.equalTo(detailReasonLabel.snp.bottom).offset(16)
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(199)
        }
        
        contentView.addSubview(pleaseReportContainer)
        pleaseReportContainer.snp.makeConstraints {
            $0.top.equalTo(detailReasonTextView.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(57)
        }
        
        pleaseReportContainer.addSubview(pleaseReportLabel)
        pleaseReportLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(327)
            $0.height.equalTo(17)
        }
    }
    
    override func setUI() {
        
        navigationBar.do {
            $0.configureBackButtonAction(popViewControllerAction())
            $0.configureCenterTitle(to: navigationTitle)
            $0.configureBottomLine()
        }
        
        scrollView.do {
            $0.bounces = false
            $0.isDirectionalLockEnabled = true
            $0.scrollIndicatorInsets = .zero
        }
        
        reportingReasonLabel.do {
            $0.basic(text: I18N.Report.reportReason, font: .bodyB1!, color: .gbbGray700!)
        }
        
        [advertisementReportButton, profanityReportButton, defamationReportButton, othersReportButton].enumerated().forEach { index, button in
            button.do {
                $0.configuration?.attributedTitle = AttributedString(labeling[index],
                                                                     attributes: AttributeContainer([.font: UIFont.captionB1!,
                                                                                                     .foregroundColor: UIColor.gbbGray500!]))
                $0.configuration?.contentInsets = .init(top: 8,
                                                        leading: 8,
                                                        bottom: 8,
                                                        trailing: 8)
                $0.configuration?.image = .filterUncheckIcon
                $0.configuration?.imagePadding = 6
                $0.configuration?.imagePlacement = .leading
                $0.isSelected = false
                $0.addAction(UIAction { _ in
                    self.tappedRadioButton(button)
                }, for: .touchUpInside)
            }
        }
        
        detailReasonLabel.do {
            $0.basic(text: I18N.Report.detailReportReason, font: .bodyB1!, color: .gbbGray700!)
        }
        
        pleaseReportContainer.do {
            $0.backgroundColor = .gbbGray100
        }
        
        pleaseReportLabel.do {
            $0.basic(text: I18N.Report.pleaseReport, font: .captionM2!, color: .gbbGray300!)
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
        }
        
        bottomView.do {
            $0.applyAdditionalSubview(writeButton, withTopOffset: 16)
        }
        
        writeButton.do {
            $0.configureButtonTitle(.write)
            $0.configureInteraction(to: false)
            $0.addAction(UIAction { [weak self] _ in
                self?.nextButtonTapped()
            }, for: .touchUpInside)
        }
        
        confirmBottomSheetView.do {
            $0.configureEmojiType(.smile)
            $0.configureBottonSheetTitle(I18N.Report.reportComplete)
            $0.dismissBottomSheet = {
                self.backgroundView.dissmissFromSuperview()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func setDelegate() {
        
        //        scrollView.delegate = self
        detailReasonTextView.detailTextView.delegate = self
    }
    
    // MARK: - Action Helper
    
    private func nextButtonTapped() {
        
//        requestWriteReview(configureWriteReviewData())
        UIView.animate(withDuration: 0.2, animations: {
            self.bottomView.transform = .identity
            self.scrollView.transform = .identity
        }) { _ in
            self.backgroundView.dimmedView.isUserInteractionEnabled = false
            self.backgroundView.appearBottomSheetView(subView: self.confirmBottomSheetView, CGFloat().heightConsideringBottomSafeArea(292))
        }
        view.endEditing(true)
    }
    
    // MARK: - Custom Method
    
    private func nothingSelected() {
        // 버튼 선택 안하고 텍스트 입력하려 했을 때 border와 글자 수 라벨의 색깔 바꿔주기
        if selectedButton == nil {
            detailReasonTextView.detailTextView.makeBorder(width: 1, color: .gbbGray500!)
            detailReasonTextView.textLimitLabel.textColor = .gbbGray500
        }
    }
    
    private func tappedRadioButton(_ sender: UIButton) {
        
        nothingSelected()
        
        selectedButton?.isSelected = false // 이전 선택 해제
        selectedButton?.configuration?.image = .filterUncheckIcon
        
        sender.isSelected = true // 새로운 버튼 선택
        sender.configuration?.image = .filterCheckIcon
        sender.configuration?.baseBackgroundColor = .gbbWhite
        writeButton.configureInteraction(to: true)
        
        selectedButton = sender // 현재 선택된 버튼 업데이트
    }
    
    @objc
    private func dismissKeyboard() {
        // 터치 이벤트가 발생했을 때 키보드를 내립니다.
        view.endEditing(true)
    }
    
    private func tappedExceptTextView() {
        // textView 외의 부분을 터치했을 때 키보드를 내립니다.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    private func textLimit(_ existingText: String?, to newText: String, with limit: Int) -> Bool {
        
        guard let text = existingText else { return false }
        let isOverLimit = text.count + newText.count <= limit
        
        return isOverLimit
    }
}

// MARK: - UITextViewDelegate

extension ReportViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        nothingSelected()
        
        if textView.text == I18N.Report.detailPlaceholder {
            textView.text = nil
            textView.textColor = .gbbGray700
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let textCount = textView.text.count
        detailReasonTextView.updateTextLimitLabel(to: textCount)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty || textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { // 공백과 줄넘김도 처리
            textView.text = I18N.Report.detailPlaceholder
            //            writeReviewData.reviewText = ""
        }
        
        if textView.text == I18N.Report.detailPlaceholder {
            textView.textColor = .gbbGray300
            detailReasonTextView.updateTextLimitLabel(to: 0)
            
            if selectedButton == nil {
                detailReasonTextView.detailTextView.makeBorder(width: 1, color: .gbbGray300!)
                detailReasonTextView.textLimitLabel.textColor = .gbbGray300
            }
        }
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        return self.textLimit(textView.text, to: text, with: 140)
    }
}
