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
 
 * Action
 - Auto focus today
 - Tapping to highlight, callback
 - Tapping jump to TODAY
 
 * Date component: --> Protocol
 - 4 pharse
 - blur date component
 
 - Background circle
 - Shadow: Flatting and gradiant
 
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
    
    /// Color
    public var cicleViewTintColor: UIColor      = UIColor(red: 90.0/255.0, green: 98.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    public var mensesDateColor: UIColor         = UIColor(red: 254.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    public var follicularDateColor: UIColor     = UIColor(red: 90.0/255.0, green: 98.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    public var ovulationDateColor: UIColor      = UIColor(red: 105.0/255.0, green: 188.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    public var lutealDateColor: UIColor         = UIColor(red: 90.0/255.0, green: 98.0/255.0, blue: 210.0/255.0, alpha: 1.0)
    
    /// Highlight date component
    var highlightViewCircleRadius: CGFloat = 20.0
}

/// ----------------------------------------------------------------------------------
//  MARK: - DELEGATE
/// ----------------------------------------------------------------------------------
protocol HDPeriodCircleDelegate: NSObjectProtocol {
    func periodCircleView(view: HDPeriodCircleView, didHitDateIndex index: Int, date: Date)
    func periodCircleViewdidHitCenterButton(view: HDPeriodCircleView)
    
    func periodCircleView(view: HDPeriodCircleView, attrStringForNodeAt index: Int, date: Date, isHighlight: Bool) -> NSAttributedString?
    func periodCircleView(view: HDPeriodCircleView, attrStringForCenterAt index: Int, date: Date) -> NSAttributedString?
}

/// ----------------------------------------------------------------------------------
//  MARK: - NODE-Able
/// ----------------------------------------------------------------------------------
protocol HDPeriodCircleNodeAbleProtocol {
    func setIsHidden(isHidden: Bool)
}
extension CAShapeLayer: HDPeriodCircleNodeAbleProtocol {
    func setIsHidden(isHidden: Bool) {
        self.isHidden = isHidden
    }
}
extension UILabel: HDPeriodCircleNodeAbleProtocol {
    func setIsHidden(isHidden: Bool) {
        self.isHidden = isHidden
    }
}

/// ----------------------------------------------------------------------------------
//  MARK: - PERIOD CIRCLE VIEW
/// ----------------------------------------------------------------------------------
open class HDPeriodCircleView: UIView {
    
    weak var delegate: HDPeriodCircleDelegate?
    public var appearance: HDPeriodCircleViewAppearance = HDPeriodCircleViewAppearance.standard
    
    /// Period Basically inforamtion
    public var firstDayOfLastPeriod: Date = Date()
    public var menstrualCycleDay: Int = 28 {
        didSet {
            /// Range of menstrual cycle lenght is 21-45
            var _newValue = self.menstrualCycleDay
            _newValue = max(21, _newValue)
            _newValue = min(45, _newValue)
            self.menstrualCycleDay = _newValue
        }
    }
    public var mensesDayNum: Int = 4 {
        didSet {
            /// Range of period lasting is 2-7
            var _newValue = self.mensesDayNum
            _newValue = max(2, _newValue)
            _newValue = min(7, _newValue)
            self.mensesDayNum = _newValue
        }
    }
    public var ovulationPhraseLeftRange: Int = 2 {
        didSet {
            /// Range 2-3
            var _newValue = self.ovulationPhraseLeftRange
            _newValue = max(2, _newValue)
            _newValue = min(3, _newValue)
            self.ovulationPhraseLeftRange = _newValue
        }
    }
    public var ovulationPhraseRightRange: Int = 2 {
        didSet {
            /// Range 2-4
            var _newValue = self.ovulationPhraseRightRange
            _newValue = max(2, _newValue)
            _newValue = min(4, _newValue)
            self.ovulationPhraseRightRange = _newValue
        }
    }
    
    fileprivate var _firstDayOfCurrentPeriod: Date = Date()
    fileprivate var _todayIndex: Int?
    
    enum NodeType {
        case menses
        case follicular
        case ovulation
        case luteal
    }
    
    /// Gesture
    private(set) var tapGesture: UITapGestureRecognizer?
    
    /// Center view
    private var labelCenter: UILabel?
    
    //  MARK: - VIEW CYCLE
    /// ----------------------------------------------------------------------------------
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        _setUpCircleView()
    }
    
    //  MARK: - SETUP
    /// ----------------------------------------------------------------------------------
    private func _setUpCircleView() {
        
        /// Gesture
        let gesture = UITapGestureRecognizer(target: self, action: #selector(_handleTapGesture(gesture:)))
        self.addGestureRecognizer(gesture)
        self.tapGesture = gesture
    }
    
    //  MARK: - DRAWING THE CIRCLE
    /// ----------------------------------------------------------------------------------
    public func reDrawCycleView() {
        
        /// Pre-Calc date
        let _calcResult = _calcCurrentPeriodCycleStartDate(firstDayOfLastCycle: self.firstDayOfLastPeriod, cycleLenght: self.menstrualCycleDay)
        self._firstDayOfCurrentPeriod = _calcResult.0
        self._todayIndex = _calcResult.1
        
        /// Circle
        _drawBackgroundCicleShadow()
        _drawBackgroundCircleView()
        _drawCircleDirectionIndicator()
        _drawCenterView()
        
        /// Date components
        _drawPeriodCircleNodes()
        
        /// Jump to today
        if let _todayIndex = self._todayIndex {
            _drawCurrentHighlightNodeAt(index: _todayIndex)
        }
    }
    
    ///  MARK: - DRAWING DATE COMPONENTS
    /// ----------------------------------------------------------------------------------
    private var _circleNodes: [HDPeriodCircleNodeAbleProtocol] = []
    fileprivate func _drawPeriodCircleNodes() {
        
        /// Center position
        _preCalculateNodeCenterPoints()
        
        /// Clear
        _circleNodes.removeAll()
        
        /// Drawing
        for index in 0..<self.menstrualCycleDay {
            let component = _drawDateComponentAtIndex(index: index)
            _circleNodes.append(component)
        }
    }
    fileprivate func _drawDateComponentAtIndex(index: Int) -> HDPeriodCircleNodeAbleProtocol {
        
        let dateType = _nodeTypeAt(index: index)
        
        switch dateType {
        case .menses:       return _drawNodeTypeDateAt(index: index, dateType: dateType)
        case .follicular:   return _drawNodeTypeDotAt(index: index, dateType: dateType)
        case .ovulation:    return _drawNodeTypeDateAt(index: index, dateType: dateType)
        case .luteal:       return _drawNodeTypeDotAt(index: index, dateType: dateType)
        }
    }
    fileprivate func _drawNodeTypeDateAt(index: Int, dateType: NodeType) -> HDPeriodCircleNodeAbleProtocol {
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 60.0, height: 60.0)))
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = _nodeColorWith(type: dateType)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.center = _nodePositionCenterPointAt(index: index)
        label.attributedText = _attrStringForNodeAt(index: index, isHighlight: false)
        self.addSubview(label)
        
        return label
    }
    fileprivate func _drawNodeTypeDotAt(index: Int, dateType: NodeType) -> HDPeriodCircleNodeAbleProtocol {
        
        let circlePath = UIBezierPath(
            arcCenter: _nodePositionCenterPointAt(index: index),
            radius: 3.0,
            startAngle: 0.0,
            endAngle: CGFloat.pi*2.0,
            clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = _nodeColorWith(type: dateType).cgColor
        circleShape.strokeColor = UIColor.clear.cgColor
        circleShape.lineWidth = 0.0
        self.layer.addSublayer(circleShape)
        
        return circleShape
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
        
    }
    
    //  MARK: - CENTER VIEW
    /// ----------------------------------------------------------------------------------
    fileprivate func _drawCenterView() {
        
        let _appearance = self.appearance
        
        /// Label
        let maxRadius = (_appearance.circleRadius*2.0 - _appearance.circleLineWidth)/2.0
        let size = maxRadius/cos(_degreeToRadian(degree: 45))
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        let newLabel = UILabel(frame: frame)
        newLabel.textAlignment = .center
        newLabel.center = _appearance.circleCenterPoint
        newLabel.numberOfLines = 0
        self.addSubview(newLabel)
        self.labelCenter = newLabel
        
        /// Button
        let button = UIButton(frame: frame)
        button.addTarget(self, action: #selector(_handleTappingOnCenterArea), for: .touchUpInside)
        button.center = _appearance.circleCenterPoint
        self.addSubview(button)
    }
    
    //  MARK: - DRAW HIGHLIGHT DATE COMPONENT
    /// ----------------------------------------------------------------------------------
    private var _curHighlightedNode: HDPeriodCircleNodeAbleProtocol?
    private var _curHighlightView: UILabel?
    private var _curHighlightViewPlaceholder: UIImageView?
    
    fileprivate func _drawCurrentHighlightNodeAt(index: Int) {
        
        let _appearance = self.appearance
        
        /// Node placeholder
        _curHighlightViewPlaceholder?.isHidden = true
        _curHighlightViewPlaceholder = nil
        
        /// Unhide old node
        _curHighlightedNode?.setIsHidden(isHidden: false)
        _curHighlightedNode = nil
        
        /// Hide tapped node
        _curHighlightedNode = _circleNodes[index]
        _curHighlightedNode?.setIsHidden(isHidden: true)
        
        /// Remove current highlight view
        _curHighlightView?.removeFromSuperview()
        _curHighlightView = nil
        
        /// Blurry placeholder
        let imgPlaceholder = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 14.0, height: 14.0)))
        let image = UIImage(named: "node_placeholder_blur", in: Bundle(for: type(of: self)), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        imgPlaceholder.image = image
        imgPlaceholder.tintColor = _nodeColorWith(type: _nodeTypeAt(index: index)).withAlphaComponent(0.5)
        imgPlaceholder.center = _nodePositionCenterPointAt(index: index)
        self.addSubview(imgPlaceholder)
        _curHighlightViewPlaceholder = imgPlaceholder
        
        /// Highlight label
        var centerPoint = _nodePositionCenterPointAt(index: index)
        centerPoint.y -= (_appearance.highlightViewCircleRadius + 3.0)
        
        let newLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: _appearance.highlightViewCircleRadius*2.0, height: _appearance.highlightViewCircleRadius*2.0)))
        newLabel.layer.cornerRadius = _appearance.highlightViewCircleRadius
        newLabel.clipsToBounds = true
        newLabel.textColor = UIColor.white
        newLabel.backgroundColor = _nodeColorWith(type: _nodeTypeAt(index: index))
        newLabel.textAlignment = .center
        newLabel.center = centerPoint
        newLabel.numberOfLines = 0
        newLabel.attributedText = _attrStringForNodeAt(index: index, isHighlight: true)
        self.addSubview(newLabel)
        _curHighlightView = newLabel
        
        /// Center view
        self.labelCenter?.attributedText = _attrStringForCenterAt(selectedIndex: index)
    }
    
    //  MARK: - ACTIONS
    /// ----------------------------------------------------------------------------------
    fileprivate func _handleTappingNodeAt(index: Int) {
        
        /// Update UI
        _drawCurrentHighlightNodeAt(index: index)
        
        /// Callback
        self.delegate?.periodCircleView(view: self, didHitDateIndex: index, date: Date())
    }
    @objc fileprivate func _handleTappingOnCenterArea() {
        self.delegate?.periodCircleViewdidHitCenterButton(view: self)
    }
    
    //  MARK: - TAP GESTURE
    /// ----------------------------------------------------------------------------------
    @objc fileprivate func _handleTapGesture(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            let location = gesture.location(in: self)
            guard let _nodeIndex = _tappedNodeIndexAt(point: location) else {
                return
            }
            self._handleTappingNodeAt(index: _nodeIndex)
            
        default:
            break
        }
    }
    fileprivate func _tappedNodeIndexAt(point: CGPoint) -> Int? {
        
        let _appearance = self.appearance
        
        /// Tapping at date components
        let _circleCenter = _appearance.circleCenterPoint
        let distance = pow(point.x - _circleCenter.x, 2) + pow(point.y - _circleCenter.y, 2)
        
        let minBorder = _appearance.circleRadius - _appearance.circleLineWidth/2.0
        let maxBorder = _appearance.circleRadius + _appearance.circleLineWidth/2.0
        let minDistance = pow(minBorder, 2)
        let maxDistance = pow(maxBorder, 2)
        
        guard distance > minDistance, distance < maxDistance else {
            NSLog("Tapping outside the circle")
            return nil
        }
        
        var curIndex: Int?
        var curDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        let maxValidDistance: CGFloat = 30.0*30.0
        for (index, centerPoint) in _nodePositionCenterPoints.enumerated() {
            
            let _tapDistance = pow(point.x - centerPoint.x, 2) + pow(point.y - centerPoint.y, 2)
            guard _tapDistance < maxValidDistance else {
                continue
            }
            
            if _tapDistance < curDistance {
                curDistance = _tapDistance
                curIndex = index
            }
        }
        
        return curIndex
    }
    
    //  MARK: - DATE HELPER
    /// ----------------------------------------------------------------------------------
    private func _calcCurrentPeriodCycleStartDate(firstDayOfLastCycle: Date, cycleLenght: Int) -> (Date, Int?) {
        
        let currentDate = Date()
        guard currentDate.timeIntervalSince(firstDayOfLastCycle) > 0.0 else {
            return (firstDayOfLastCycle, nil)
        }
        
        let calendar = self.calendar
        let dateComponent = calendar.dateComponents([.day], from: firstDayOfLastCycle, to: currentDate)
        guard let _day = dateComponent.day else {
            return (firstDayOfLastCycle, nil)
        }
        
        let todayIndex = _day%cycleLenght
        let output = currentDate.addingTimeInterval(86400.0 * TimeInterval(-todayIndex))
        
        return (output, todayIndex)
    }
    private func _dateAtIndex(index: Int) -> Date {
        let firstDate = self._firstDayOfCurrentPeriod
        return firstDate.addingTimeInterval(TimeInterval(index)*86400.0)
    }
    
    //  MARK: - NODE POSITION HELPER
    /// ----------------------------------------------------------------------------------
    fileprivate func _nodeTypeAt(index: Int) -> NodeType {
        
        guard index >= 0, index < self.menstrualCycleDay else {
            assertionFailure("Wrong index range")
            return .follicular
        }
        
        let ovulationDayIndex = self.menstrualCycleDay-15
        let maxRightOvulationDayIndex = ovulationDayIndex-self.ovulationPhraseRightRange
        let maxLeftOvulationDayIndex = ovulationDayIndex+self.ovulationPhraseLeftRange
        
        switch index {
        case 0..<self.mensesDayNum:                             return .menses
        case self.mensesDayNum..<maxRightOvulationDayIndex:     return .follicular
        case maxRightOvulationDayIndex...maxLeftOvulationDayIndex:  return .ovulation
        case (maxLeftOvulationDayIndex+1)...:                       return .luteal
        default:
            assertionFailure("Wrong logic, this case never execute")
            return .follicular
        }
    }
    
    private var _nodePositionCenterPoints: [CGPoint] = []
    private func _nodePositionCenterPointAt(index: Int) -> CGPoint {
        guard index < _nodePositionCenterPoints.count else {
            assertionFailure("Wrong logic")
            return CGPoint.zero
        }
        return _nodePositionCenterPoints[index]
    }
    private func _preCalculateNodeCenterPoints() {
        
        /// Remove all
        _nodePositionCenterPoints.removeAll()
        
        /// Ovulation phrase
        let ovulationDayIndex = self.menstrualCycleDay-15
        let maxLeftOvulationDayIndex = ovulationDayIndex+self.ovulationPhraseLeftRange
        
        /// Base radius
        let _appearance = self.appearance
        let _baseRadius = _appearance.circleRadius
        
        /// Base step degree
        let totalDegree = _appearance._datePositionEndAngleDegree - _appearance._datePositionStartAngleDegree
        let baseStepDegree = totalDegree/CGFloat(self.menstrualCycleDay - 1)
        
        /// Dately step degree
        let datelyDegree = baseStepDegree * 1.3
        
        /// Dotly step degree
        let numOfDatelyStep = self.mensesDayNum + self.ovulationPhraseLeftRange + self.ovulationPhraseRightRange + 1
        let totalDatelyStepDegree = datelyDegree * CGFloat(numOfDatelyStep)
        let dotlyDegree = (totalDegree-totalDatelyStepDegree)/CGFloat(self.menstrualCycleDay - 1 - numOfDatelyStep)
        
        /// Calculate center points
        var curAngleOffset = _appearance._datePositionStartAngleDegree
        for index in 0..<self.menstrualCycleDay {
            
            let radius = _baseRadius
            
            let dateType = _nodeTypeAt(index: index)
            switch dateType {
            case .menses:
                if index > 0 {
                    curAngleOffset += datelyDegree
                }
                
            case .follicular:
                if index == self.mensesDayNum {
                    curAngleOffset += datelyDegree
                }
                else {
                    curAngleOffset += dotlyDegree
                }
                
            case .ovulation:
                curAngleOffset += datelyDegree
//                radius += 2
            
            case .luteal:
                if index == (maxLeftOvulationDayIndex+1) {
                    curAngleOffset += datelyDegree
                }
                else {
                    curAngleOffset += dotlyDegree
                }
            }
            
            let center = CGPoint(
                x: _appearance.circleCenterPoint.x + cos(_degreeToRadian(degree: curAngleOffset))*radius,
                y: _appearance.circleCenterPoint.y + sin(_degreeToRadian(degree: curAngleOffset))*radius)
            
            _nodePositionCenterPoints.append(center)
        }
    }
    
    //  MARK: - LOCALIZE HELPER
    /// ----------------------------------------------------------------------------------
    public var locale = Locale.current
    public var calendar = Calendar(identifier: .gregorian)
    
    private lazy var _weekdayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = self.locale
        dateFormatter.dateFormat = "E"
        return dateFormatter
    }()
    private lazy var _dayStyleShortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = self.locale
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter
    }()
    
    private func _attrStringForNodeAt(index: Int, isHighlight: Bool) -> NSAttributedString {
        let _calendarDate = _dateAtIndex(index: index)
        if let _value = self.delegate?.periodCircleView(view: self, attrStringForNodeAt: index, date: _calendarDate, isHighlight: isHighlight) {
            return _value
        }
        else {
            let attributedString = NSMutableAttributedString()
            let _weeday = _stringWeekdayForNodeAt(index: index)
            if _weeday.count > 0 {
                attributedString.append(NSAttributedString(
                    string: "\(_weeday.uppercased())\n",
                    attributes: [.font : UIFont.systemFont(ofSize: 9.0, weight: .regular)]))
            }
            let _day = _stringDayForNodeAt(index: index)
            if _day.count > 0 {
                attributedString.append(NSAttributedString(
                    string: _day,
                    attributes: [.font : UIFont.systemFont(ofSize: 15.0, weight: isHighlight ? .semibold : .regular)]))
            }
            return attributedString
        }
    }
    
    private func _attrStringForCenterAt(selectedIndex: Int) -> NSAttributedString {
        let _calendarDate = _dateAtIndex(index: selectedIndex)
        if let _attrString = self.delegate?.periodCircleView(view: self, attrStringForCenterAt: selectedIndex, date: _calendarDate) {
            return _attrString
        }
        else {
            let attributedString = NSMutableAttributedString()
            let _date = _stringDayStyleShortForNodeAt(index: selectedIndex)
            if _date.count > 0 {
                attributedString.append(NSAttributedString(
                    string: "\(_date)\n",
                    attributes: [
                        .font : UIFont.systemFont(ofSize: 45.0, weight: .bold),
                        .foregroundColor : UIColor.white]))
            }
            
            let _weeday = _stringWeekdayForNodeAt(index: selectedIndex)
            if _weeday.count > 0 {
                attributedString.append(NSAttributedString(
                    string: "\(_weeday.uppercased())",
                    attributes: [
                        .font : UIFont.systemFont(ofSize: 22.0, weight: .regular),
                        .foregroundColor : UIColor.white]))
            }
            return attributedString
        }
    }
    
    private func _stringWeekdayForNodeAt(index: Int) -> String {
        let date = _dateAtIndex(index: index)
        let weakday = self._weekdayDateFormatter.string(from: date)
        return weakday
    }
    private func _stringDayStyleShortForNodeAt(index: Int) -> String {
        let date = _dateAtIndex(index: index)
        let weakday = self._dayStyleShortDateFormatter.string(from: date)
        return weakday
    }
    private func _stringDayForNodeAt(index: Int) -> String {
        let date = _dateAtIndex(index: index)
        let dateComponent = self.calendar.dateComponents([.day], from: date)
        var output = ""
        if let _day = dateComponent.day {
            output += "\(_day)"
        }
        return output
    }
    
    //  MARK: - APPEARANCE HELPER
    /// ----------------------------------------------------------------------------------
    private func _nodeColorWith(type: NodeType) -> UIColor {
        let _appearance = self.appearance
        switch type {
        case .menses:       return _appearance.mensesDateColor
        case .follicular:   return _appearance.follicularDateColor
        case .ovulation:    return _appearance.ovulationDateColor
        case .luteal:       return _appearance.lutealDateColor
        }
    }
}
