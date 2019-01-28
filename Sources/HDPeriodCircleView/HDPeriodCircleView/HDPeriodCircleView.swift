//
//  HDPeriodCircleView.swift
//  HDPeriodCircleView
//
//  Created by GRU on 1/28/19.
//  Copyright © 2019 GRU. All rights reserved.
//

import UIKit

/*
 The menses phase: This phase, which typically lasts from day 1 to day 5, is the time when the lining of the uterus is actually shed out through the vagina if pregnancy has not occurred. Most women bleed for 3 to 5 days, but a period lasting only 2 days to as many as 7 days is still considered normal.
 The follicular phase. This phase typically takes place from days 6 to 14. During this time, the level of the hormone estrogen rises, which causes the lining of the uterus (called the endometrium) to grow and thicken. In addition, another hormone—follicle-stimulating hormone—causes follicles in the ovaries to grow. During days 10 to 14, one of the developing follicles will form a fully mature egg (ovum).
 Ovulation. This phase occurs roughly at about day 14 in a 28-day menstrual cycle. A sudden increase in another hormone—luteinizing hormone—causes the ovary to release its egg. This event is called ovulation.
 The luteal phase. This phase lasts from about day 15 to day 28. After the egg is released from the ovary it begins to travel through the fallopian tubes to the uterus. The level of the hormone progesterone rises to help prepare the uterine lining for pregnancy. If the egg becomes fertilized by a sperm and attaches itself to the uterine wall, the woman becomes pregnant. If pregnancy does not occur, estrogen and progesterone levels drop and the thickened lining of the uterus is shed during the menstrual period.
 
 */

fileprivate func _degreeToRadian(degree: CGFloat) -> CGFloat {
    return (degree/180.0)*CGFloat.pi
}

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
    let _datePositionStartAngleDegree: CGFloat = -65.0
    let _datePositionEndAngleDegree: CGFloat = 260.0
    
    public let mensesDateColor: UIColor       = UIColor(red: 254.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    public let follicularDateColor: UIColor   = UIColor(red: 90.0/255.0, green: 98.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    public let ovulationDateColor: UIColor    = UIColor(red: 105.0/255.0, green: 188.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    public let lutealDateColor: UIColor       = UIColor(red: 90.0/255.0, green: 98.0/255.0, blue: 210.0/255.0, alpha: 1.0)
}

open class HDPeriodCircleView: UIView {
    
    public var appearance: HDPeriodCircleViewAppearance = HDPeriodCircleViewAppearance.standard
    
    private(set) var firstDayOfLastPeriod: Date = {
        var curDate = Date()
        return curDate.addingTimeInterval(86400 * (-12))
    }()
    fileprivate var _firstLogicDateOnCycle: Date {
        return self.firstDayOfLastPeriod
    }
    
    private(set) var menstrualCycleDay: Int = 28
    private(set) var periodLastingDay: Int = 4
    
    enum DateIndexType {
        case menses
        case follicular
        case ovulation
        case luteal
    }
    
    //  MARK: - ACCESSORY
    /// ----------------------------------------------------------------------------------
    func setMenstrualCycleDay(value: Int) {
        /// Range of menstrual cycle lenght is 21-45
        var newValue = value
        newValue = max(21, newValue)
        newValue = min(45, newValue)
        self.menstrualCycleDay = newValue
    }
    func setPeriodLastingday(value: Int) {
        /// Range of period lasting is 2-7
        var newValue = value
        newValue = max(2, newValue)
        newValue = min(7, newValue)
        self.periodLastingDay = newValue
    }
    
    //  MARK: - DRAWING THE CIRCLE
    /// ----------------------------------------------------------------------------------
    public func reDrawCycleView() {
        
        /// Circle
        _drawBackgroundCicleShadow()
        _drawBackgroundCircleView()
        _drawCircleDirectionIndicator()
        
        /// Date components
        _drawDateComponents()
    }
    
    ///  MARK: - DRAWING DATE COMPONENTS
    /// ----------------------------------------------------------------------------------
    fileprivate func _drawDateComponents() {
        for index in 0..<self.menstrualCycleDay {
            _drawDateComponentAtIndex(index: index)
        }
    }
    fileprivate func _drawDateComponentAtIndex(index: Int) {
        
        let dateType = _dateComponentTypeAt(index: index)
        
        switch dateType {
        case .menses:       _drawDateComponentTextAt(index: index, dateType: dateType)
        case .follicular:   _drawDateComponentDotAt(index: index, dateType: dateType)
        case .ovulation:    _drawDateComponentTextAt(index: index, dateType: dateType)
        case .luteal:       _drawDateComponentDotAt(index: index, dateType: dateType)
        }
    }
    fileprivate func _drawDateComponentTextAt(index: Int, dateType: DateIndexType) {
        
//        let textLayer = CATextLayer()
////        textLayer.font = UIFont.systemFont(ofSize: 16.0).ref
//        textLayer.fontSize = 14.0
//        textLayer.foregroundColor = _dateComponentColorWith(type: dateType).cgColor
//        textLayer.alignmentMode = .center
//        textLayer.string = _textForDateComponentAt(index: index)
//        textLayer.contentsScale = UIScreen.main.scale
//
//        textLayer.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: 60.0, height: 60.0))
//        textLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        textLayer.position = _centerForDateComponentAt(index: index, dateType: dateType)
//        self.layer.addSublayer(textLayer)
        
        let attributedString = NSMutableAttributedString()
        
        let _weeday = _textWeakdayForDateComponentAt(index: index)
        if _weeday.count > 0 {
            attributedString.append(NSAttributedString(
                string: "\(_weeday)\n",
                attributes: [.font : UIFont.systemFont(ofSize: 9.0)]))
        }
        let _day = _textDayForDateComponentAt(index: index)
        if _day.count > 0 {
            attributedString.append(NSAttributedString(
                string: _day,
                attributes: [.font : UIFont.systemFont(ofSize: 15.0)]))
        }
        
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 60.0, height: 60.0)))
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = _dateComponentColorWith(type: dateType)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.center = _centerForDateComponentAt(index: index, dateType: dateType)
        label.attributedText = attributedString
        self.addSubview(label)
    }
    fileprivate func _drawDateComponentDotAt(index: Int, dateType: DateIndexType) {
        
        let circlePath = UIBezierPath(
            arcCenter: _centerForDateComponentAt(index: index, dateType: dateType),
            radius: 3.0,
            startAngle: 0.0,
            endAngle: CGFloat.pi*2.0,
            clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = _dateComponentColorWith(type: dateType).cgColor
        circleShape.strokeColor = UIColor.clear.cgColor
        circleShape.lineWidth = 0.0
        self.layer.addSublayer(circleShape)
    }
    
    //  MARK: - DRAWING BACKGROUND CIRCLE
    /// ----------------------------------------------------------------------------------
    fileprivate func _drawBackgroundCircleView() {
        
        let _appearance = self.appearance
        
        let circlePath = UIBezierPath(arcCenter: _appearance.circleCenterPoint, radius: _appearance.circleRadius, startAngle: 0.0, endAngle: CGFloat.pi * 2.0, clockwise: true)
        
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.strokeColor = _appearance.circleBackgroundColor.cgColor
        circleShape.lineWidth = _appearance.circleLineWidth
        
        self.layer.addSublayer(circleShape)
    }
    
    //  MARK: - DRAWING SHADOW
    /// ----------------------------------------------------------------------------------
    fileprivate func _drawBackgroundCicleShadow() {
        
        let _appearance = self.appearance
        let centerPoint = _appearance.circleCenterPoint
        
        /// LVL 2
        var centerPoint_LVL2 = centerPoint
        centerPoint_LVL2.y += 10.0
        let circlePath_LVL2 = UIBezierPath(arcCenter: centerPoint_LVL2, radius: _appearance.circleRadius, startAngle: 0.0, endAngle: CGFloat.pi * 2.0, clockwise: true)
        
        let circleShape_2 = CAShapeLayer()
        circleShape_2.path = circlePath_LVL2.cgPath
        circleShape_2.fillColor = UIColor.clear.cgColor
        circleShape_2.strokeColor = _appearance.circleShadowLevel_2_Color.cgColor
        circleShape_2.lineWidth = _appearance.circleLineWidth
        self.layer.addSublayer(circleShape_2)
        
        /// LVL 1
        var centerPoint_LVL1 = centerPoint
        centerPoint_LVL1.y += 5.0
        let circlePath_LVL1 = UIBezierPath(arcCenter: centerPoint_LVL1, radius: _appearance.circleRadius, startAngle: 0.0, endAngle: CGFloat.pi * 2.0, clockwise: true)
        
        let circleShape_1 = CAShapeLayer()
        circleShape_1.path = circlePath_LVL1.cgPath
        circleShape_1.fillColor = UIColor.clear.cgColor
        circleShape_1.strokeColor = _appearance.circleShadowLevel_1_Color.cgColor
        circleShape_1.lineWidth = _appearance.circleLineWidth
        self.layer.addSublayer(circleShape_1)
    }
    
    //  MARK: - DRAW CIRCLE DIRECTION INDICATOR
    /// ----------------------------------------------------------------------------------
    fileprivate func _drawCircleDirectionIndicator() {
        
//        let _appearance = self.appearance
//
//        let circlePath = UIBezierPath(arcCenter: _appearance.circleCenterPoint, radius: _appearance.circleRadius, startAngle: -(CGFloat.pi/2.0), endAngle: -(CGFloat.pi/2.0) * (1 - 12.0/90.0), clockwise: true)
//        circlePath.lineCapStyle = .round
//        circlePath.lineJoinStyle = .round
//        circlePath.stroke()
//
//        let circleShape = CAShapeLayer()
//        circleShape.path = circlePath.cgPath
//        circleShape.fillColor = UIColor.clear.cgColor
//        circleShape.strokeColor = UIColor(white: 0.9, alpha: 1.0).cgColor
//        circleShape.lineWidth = _appearance.circleLineWidth
//        self.layer.addSublayer(circleShape)
//
//        let circlePath_2 = UIBezierPath(arcCenter: _appearance.circleCenterPoint, radius: _appearance.circleRadius, startAngle: -(CGFloat.pi/2.0), endAngle: -(CGFloat.pi/2.0)*(1 - 9.0/90.0), clockwise: true)
//        circlePath_2.lineCapStyle = .round
//        circlePath_2.lineJoinStyle = .round
//        circlePath_2.stroke()
//
//        let circleShape_2 = CAShapeLayer()
//        circleShape_2.path = circlePath_2.cgPath
//        circleShape_2.fillColor = UIColor.clear.cgColor
//        circleShape_2.strokeColor = _appearance.circleBackgroundColor.cgColor
//        circleShape_2.lineWidth = _appearance.circleLineWidth
//        self.layer.addSublayer(circleShape_2)
    }
    
    //  MARK: - HELPER
    /// ----------------------------------------------------------------------------------
    fileprivate func _dateComponentTypeAt(index: Int) -> DateIndexType {
        
        let ovulationDayIndex = self.menstrualCycleDay-15
        
//        if 0 <= index, index < self.periodLastingDay {
//            return .menses
//        }
//        else if self.periodLastingDay <= index, index < (ovulationDayIndex-2) {
//            return .follicular
//        }
//        else if (ovulationDayIndex-2) <= index, index < (ovulationDayIndex+2) {
//            return .ovulation
//        }
//        else if (ovulationDayIndex+3) <= index {
//            return .luteal
//        }
//        else {
//            return .follicular
//        }
        
        switch index {
        case 0..<self.periodLastingDay:                         return .menses
        case self.periodLastingDay..<(ovulationDayIndex-2):     return .follicular
        case (ovulationDayIndex-2)...(ovulationDayIndex+2):     return .ovulation
        case (ovulationDayIndex+3)...:                          return .luteal
        default:                                                return .follicular
        }
    }
    fileprivate func _dateComponentColorWith(type: DateIndexType) -> UIColor {
        let _appearance = self.appearance
        switch type {
        case .menses:       return _appearance.mensesDateColor
        case .follicular:   return _appearance.follicularDateColor
        case .ovulation:    return _appearance.ovulationDateColor
        case .luteal:       return _appearance.lutealDateColor
        }
    }
    fileprivate func _centerForDateComponentAt(index: Int, dateType: DateIndexType) -> CGPoint {
        
        let _appearance = self.appearance
        
        var _baseRadius = _appearance.circleRadius
        switch dateType {
        case .menses:       break
        case .follicular:   break
        case .ovulation:    _baseRadius += 2.0
        case .luteal:       break
        }
        
        let stepAngleDegree = (_appearance._datePositionEndAngleDegree - _appearance._datePositionStartAngleDegree)/CGFloat(self.menstrualCycleDay - 1)
        let angleDegree = _appearance._datePositionStartAngleDegree + CGFloat(index)*stepAngleDegree
        let center = CGPoint(
            x: _appearance.circleCenterPoint.x + cos(_degreeToRadian(degree: angleDegree))*_baseRadius,
            y: _appearance.circleCenterPoint.y + sin(_degreeToRadian(degree: angleDegree))*_baseRadius)
        
        return center
    }
    
    fileprivate func _textWeakdayForDateComponentAt(index: Int) -> String {
        let firstDate = self._firstLogicDateOnCycle
        let date = firstDate.addingTimeInterval(TimeInterval(index)*86400.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let weakday = dateFormatter.string(from: date).uppercased()
        return weakday
    }
    fileprivate func _textDayForDateComponentAt(index: Int) -> String {
        
        let firstDate = self._firstLogicDateOnCycle
        
        let date = firstDate.addingTimeInterval(TimeInterval(index)*86400.0)
        let calendar = Calendar(identifier: .gregorian)
        let dateComponent = calendar.dateComponents([.day], from: date)
        
        var output = ""
        if let _day = dateComponent.day {
            output += "\(_day)"
        }
        
        return output
    }
}
