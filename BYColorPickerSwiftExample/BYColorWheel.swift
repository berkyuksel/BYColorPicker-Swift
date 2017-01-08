//
//  BYColorWheel.swift
//  BYColorPickerSwiftExample
//
//  Created by Berk Yuksel on 08/01/2017.
//  Copyright © 2017 Berk Yuksel. All rights reserved.
//

//Some Cow Fonque - Branford Marsalis / Buckshot LeFonque

import UIKit

// MARK: - Extensions

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

// MARK: - BYColorWheelDelegate Declaration

@objc protocol BYColorWheelDelegate: NSObjectProtocol {
    
    func setHueFromColorWheel( hue:Float )
}

// MARK: - Class Declaration
class BYColorWheel: UIView {

    @IBOutlet weak var delegate : BYColorWheelDelegate?
    
    //MARK: - Private Variables
    private var _wheelImgView : UIImageView?
    private var _crosshairImgView : UIImageView?
    private var _touching : Bool?
    private var _indicatorAngle : CGFloat?
    
    //MARK: - Public Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    convenience init() {
        self.init(frame:CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func prepare() {
        _wheelImgView?.frame = self.bounds
        _crosshairImgView?.frame = crosshairFrameFromCurrentRadius()
        self.placeCrosshair()
    }
    
    func placeCrosshairByHue(hue: CGFloat){
        
        _indicatorAngle = hue * 360.0
        placeCrosshair()
    }
    
    //MARK: - Touch Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch = (event?.allTouches?.first)! as UITouch
        let touchLocation : CGPoint = touch.location(in: self)
        
        let center : CGPoint = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
        let distance : CGFloat = CGFloat( sqrtf(powf(Float(touchLocation.x - center.x), 2.0) + powf(Float(touchLocation.y - center.y), 2.0)) )
        let radius : CGSize = radiusSizeFromCurrentBounds()
        
        if distance >= radius.width && distance <= radius.height{
            
            self.touchedWheel(at: touchLocation)
            _touching = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if _touching == false {
            return
        }
        
        let touch : UITouch = (event?.allTouches?.first)! as UITouch
        let touchLocation : CGPoint = touch.location(in: self)
        self.touchedWheel(at: touchLocation)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        _touching = false
    }
    
    func touchedWheel( at touchLocation : CGPoint) {
    
        let center : CGPoint = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
        let f : CGFloat = self.pointPairToBearingDegrees(startingPoint: center, endingPoint: touchLocation)
        
        
        self.delegate?.setHueFromColorWheel(hue: Float(f / 360.0))

        _indicatorAngle = f
        self.placeCrosshair()
    }
    
    //MARK: - Private Methods
    private func initialize(){
        
        _touching = false
        _indicatorAngle = 0
        
        _wheelImgView = UIImageView.init(frame: self.bounds)
        _wheelImgView?.image = self.colorWheelImage()
        self.addSubview(_wheelImgView!)
        
        let crosshairImage : UIImage = self.crosshairImage()!
        _crosshairImgView = UIImageView.init(image: crosshairImage)
        self.addSubview(_crosshairImgView!)
        
        self.placeCrosshair()
    }
    
    private func placeCrosshair() {
    
        let radians : Float = Float((_indicatorAngle?.degreesToRadians)!)
        let radius : CGSize = radiusSizeFromCurrentBounds()
        let distance : CGFloat = CGFloat(radius.width) + CGFloat(radius.height - radius.width) / 2.0
        let wheelCenter : CGPoint = CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
        let target : CGPoint = CGPoint.init( x: distance * CGFloat(cosf(radians)), y: distance * CGFloat(sinf(radians)) )
        
        _crosshairImgView?.center = CGPoint.init(x: wheelCenter.x + target.x, y: wheelCenter.y + target.y)
    }
    
    private func pointPairToBearingDegrees(startingPoint : CGPoint, endingPoint : CGPoint) -> CGFloat {
        
        let origin : CGPoint = CGPoint.init(x: endingPoint.x - startingPoint.x, y: endingPoint.y - startingPoint.y)
        let bearingRadians = atan2f(Float(origin.y), Float(origin.x))
        var bearingDegrees : CGFloat = CGFloat(bearingRadians) * CGFloat(180.0 / M_PI)
        bearingDegrees = bearingDegrees > 0.0 ? bearingDegrees : 360.0 + bearingDegrees
        return bearingDegrees
    }
    
    private func radiusSizeFromCurrentBounds() -> CGSize {
        
        let bigRadius = min(self.bounds.size.width, self.bounds.size.height) / 2.0
        return CGSize.init(width: bigRadius/1.5, height: bigRadius-1)
    }
    
    private func crosshairFrameFromCurrentRadius() -> CGRect {
        
        let radius : CGSize = radiusSizeFromCurrentBounds()
        let crossHairWH : CGFloat = (radius.height-radius.width) / 2.0
        return CGRect.init(x: 0, y: 0, width: crossHairWH, height: crossHairWH)
    }
    
    //MARK: - Visual Object Generation
    
    private func crosshairImage() -> UIImage?{
        
        let lineWidth : CGFloat = 2.0
        let crossHairFrame : CGRect = crosshairFrameFromCurrentRadius()
        UIGraphicsBeginImageContextWithOptions(crossHairFrame.size, false, 0.0)
        
        let outerCircle : UIBezierPath = UIBezierPath.init(ovalIn: crossHairFrame.insetBy(dx: 1.0 + lineWidth, dy: 1.0 + lineWidth))
        let innerCircle : UIBezierPath = UIBezierPath.init(ovalIn: crossHairFrame.insetBy(dx: 2.0 * lineWidth, dy: 2.0 * lineWidth))
        
        outerCircle.lineWidth = lineWidth
        UIColor.black.setStroke()
        outerCircle.stroke()
        
        innerCircle.lineWidth = lineWidth
        UIColor.init(white: 0.9, alpha: 0.9).setStroke()
        innerCircle.stroke()
        
        //Shadow drawing
        
        let context : CGContext = UIGraphicsGetCurrentContext()!
        let shadowColor : UIColor = UIColor.init(white: 0.1, alpha: 0.8)
        let innerShadowPath = CGPath.init(ellipseIn: crossHairFrame.insetBy(dx: lineWidth+2.0, dy: lineWidth+2.0), transform: nil)
        BYGfxUtility.drawInnerShadow(inContext: context, withPath: innerShadowPath, color: shadowColor.cgColor, offset: CGSize.init(width: 0, height: 2), blurRadius: 3)
        
        let img : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    private func colorWheelImage() -> UIImage? {
        
        let wheelSize : CGSize = self.bounds.size
        let radius : CGSize = radiusSizeFromCurrentBounds()
        let numSectors : NSInteger = 180
        let angle : CGFloat = (2.0*CGFloat(M_PI))/CGFloat(numSectors)
        let center : CGPoint = CGPoint.init(x: (wheelSize.width)/2, y: (wheelSize.height)/2)
        
        //Color Wheel drawing
        UIGraphicsBeginImageContextWithOptions(wheelSize, false, 0.0)
        var bezierPath : UIBezierPath
        for i : NSInteger in 0 ..< numSectors{
            
            let lhAngle : CGFloat = CGFloat(i) * angle
            let rhAngle : CGFloat = CGFloat(i+1) * angle
            
            bezierPath = UIBezierPath.init(arcCenter: center, radius: radius.height, startAngle: lhAngle, endAngle: rhAngle, clockwise: true)
            bezierPath.addArc(withCenter: center, radius: radius.width, startAngle: rhAngle, endAngle: lhAngle, clockwise: false)
            bezierPath.close()
            
            let color :UIColor = UIColor.init(hue: CGFloat(i)/CGFloat(numSectors), saturation: 1.0, brightness: 1.0, alpha: 1.0)
            color.setFill()
            color.setStroke()
            bezierPath.fill()
            bezierPath.stroke()
        }
        
        //Shadow drawing
        let shadowColor : UIColor = UIColor.init(white: 0.1, alpha: 0.8)
        let circleInset :CGFloat = radius.height - radius.width
        let context : CGContext = UIGraphicsGetCurrentContext()!
        let shadowOffset : CGSize = CGSize.init(width: 0, height: 3)
        
        context.saveGState()
        context.setShadow(offset: shadowOffset, blur: 4, color: shadowColor.cgColor)
        context.addRect(self.bounds)
        context.addEllipse(in: self.bounds.insetBy(dx: circleInset + 2.0, dy: circleInset + 2.0))
        context.clip(using: CGPathFillRule.evenOdd)
        context.setFillColor(UIColor.init(white: 1.0, alpha: 0.6).cgColor)
        context.fillEllipse(in: self.bounds.insetBy(dx: circleInset, dy: circleInset))
        context.restoreGState()
        
        let innerShadowPath = CGPath.init(ellipseIn: self.bounds, transform: nil)

        BYGfxUtility.drawInnerShadow(inContext: context, withPath: innerShadowPath, color: shadowColor.cgColor, offset: shadowOffset, blurRadius: 4)
        
        let img : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
