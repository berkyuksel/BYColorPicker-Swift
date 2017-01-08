//
//  BYColorSwatch.swift
//  BYColorPickerSwiftExample
//
//  Created by Berk Yuksel on 08/01/2017.
//  Copyright © 2017 Berk Yuksel. All rights reserved.
//

import UIKit

class BYColorSwatch: UIView {
    
    var color : UIColor? = nil {
        
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // Mark: - Drawing
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.saveGState()
        
        let strokeSize : CGFloat = 1.0
        
        context.addEllipse(in: self.bounds.insetBy(dx: strokeSize, dy: strokeSize))

        if (color != nil) {
            context.setFillColor(color!.cgColor)
            context.fillPath()
        }
        
        context.setLineWidth(strokeSize)
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.addEllipse(in: self.bounds.insetBy(dx: strokeSize, dy: strokeSize))
        
        let shadowColor : UIColor = UIColor.init(white: 0.1, alpha: 0.4)
        let innerShadowPath : CGPath = CGPath.init(ellipseIn: self.bounds.insetBy(dx: strokeSize, dy: strokeSize), transform: nil)
        
        BYGfxUtility.drawInnerShadow(inContext: context, withPath: innerShadowPath, color: shadowColor.cgColor, offset: CGSize.init(width: 0, height: 3), blurRadius: 4)
        
        context.restoreGState()
    }

}
