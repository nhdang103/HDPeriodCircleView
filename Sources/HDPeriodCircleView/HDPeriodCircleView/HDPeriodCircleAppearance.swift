//
//  HDPeriodCircleAppearance.swift
//  HDPeriodCircleView
//
//  Created by GRU on 1/28/19.
//  Copyright © 2019 GRU. All rights reserved.
//

import UIKit

open class HDPeriodCircleViewAppearance: NSObject {
    
    /// Shared
    public static let standard = HDPeriodCircleViewAppearance()
    
    /// Circle radius
    public var circleMargin: UIEdgeInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    public var circleLineWidth: CGFloat = 65.0
    public var circleBackgroundColor: UIColor = UIColor.white
    
    public var circleCenterPoint: CGPoint {
        return CGPoint(
            x: self.circleMargin.left + self.circleRadius + self.circleLineWidth/2.0,
            y: self.circleMargin.top + self.circleRadius + self.circleLineWidth/2.0)
    }
    public var circleRadius: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return screenWidth/2.0 - self.circleMargin.left - self.circleLineWidth/2.0
    }
    
    /// Circle shadow
    public var circleShadowLevel_1_Color: UIColor = UIColor(white: 1.0, alpha: 0.5)
    public var circleShadowLevel_2_Color: UIColor = UIColor(white: 1.0, alpha: 0.3)
    
    /// Date
    let _datePositionStartAngleDegree: CGFloat = 15.0
    let _datePositionEndAngleDegree: CGFloat = 357.0
}
