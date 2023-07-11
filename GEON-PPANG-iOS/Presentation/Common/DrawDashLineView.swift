//
//  DrawDashLineView.swift
//  GEON-PPANG-iOS
//
//  Created by kyun on 2023/07/11.
//

import UIKit

class DrawDashLineView: UIView { // 코너가 들어간 점선 그리기
    
    private let borderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        borderLayer.strokeColor = UIColor.gbbMain3?.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        layer.addSublayer(borderLayer)
    }
    
    override func draw(_ rect: CGRect) {
        
        borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 15).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
