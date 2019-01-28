//
//  HDPeriodCircleView.swift
//  HDPeriodCircleView
//
//  Created by GRU on 1/28/19.
//  Copyright © 2019 GRU. All rights reserved.
//

import UIKit

open class HDPeriodCircleView: UIView {
    
    public var appearance: HDPeriodCircleViewAppearance = HDPeriodCircleViewAppearance.standard
    
    public func reDrawCycleView() {
        
        /// Circle
        _drawBackgroundCicleShadow()
        _drawBackgroundCircleView()
    }
    
    /// DRAWING CIRCLE
    fileprivate func _drawBackgroundCircleView() {
        
        let _appearance = self.appearance
        
        let circlePath = UIBezierPath(
            arcCenter: _appearance.circleCenterPoint,
            radius: _appearance.circleRadius,
            startAngle: 0.0,
            endAngle: CGFloat.pi * 2.0,
            clockwise: true)
        
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.strokeColor = _appearance.circleBackgroundColor.cgColor
        circleShape.lineWidth = _appearance.circleLineWidth
        
        self.layer.addSublayer(circleShape)
    }
    
    fileprivate func _drawBackgroundCicleShadow() {
        
        let _appearance = self.appearance
        let centerPoint = _appearance.circleCenterPoint
        
        /// LVL 2
        var centerPoint_LVL2 = centerPoint
        centerPoint_LVL2.y += 10.0
        let circlePath_LVL2 = UIBezierPath(
            arcCenter: centerPoint_LVL2,
            radius: _appearance.circleRadius,
            startAngle: 0.0,
            endAngle: CGFloat.pi * 2.0,
            clockwise: true)
        let circleShape_2 = CAShapeLayer()
        circleShape_2.path = circlePath_LVL2.cgPath
        circleShape_2.fillColor = UIColor.clear.cgColor
        circleShape_2.strokeColor = _appearance.circleShadowLevel_2_Color.cgColor
        circleShape_2.lineWidth = _appearance.circleLineWidth
        self.layer.addSublayer(circleShape_2)
        
        /// LVL 1
        var centerPoint_LVL1 = centerPoint
        centerPoint_LVL1.y += 5.0
        let circlePath_LVL1 = UIBezierPath(
            arcCenter: centerPoint_LVL1,
            radius: _appearance.circleRadius,
            startAngle: 0.0,
            endAngle: CGFloat.pi * 2.0,
            clockwise: true)
        
        let circleShape_1 = CAShapeLayer()
        circleShape_1.path = circlePath_LVL1.cgPath
        circleShape_1.fillColor = UIColor.clear.cgColor
        circleShape_1.strokeColor = _appearance.circleShadowLevel_1_Color.cgColor
        circleShape_1.lineWidth = _appearance.circleLineWidth
        self.layer.addSublayer(circleShape_1)
    }
    
}
