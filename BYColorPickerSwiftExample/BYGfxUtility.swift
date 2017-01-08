//
//  BYGfxUtility.swift
//  BYColorPickerSwiftExample
//
//  Created by Berk Yuksel on 08/01/2017.
//  Copyright © 2017 Berk Yuksel. All rights reserved.
//

import UIKit

class BYGfxUtility {

    static func drawInnerShadow(inContext context:CGContext, withPath path:CGPath, color:CGColor, offset:CGSize, blurRadius:CGFloat){
        
        context.saveGState()
        context.addPath(path)
        context.clip()
        let opaqueShadowColor = color.copy(alpha: 1.0)
        context.setAlpha(color.alpha)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        context.setShadow(offset: offset, blur: blurRadius, color: opaqueShadowColor)
        context.setBlendMode(CGBlendMode.sourceOut)
        context.setFillColor(opaqueShadowColor!)
        context.addPath(path)
        context.fillPath()
        context.endTransparencyLayer()
        context.restoreGState()
    }
}
