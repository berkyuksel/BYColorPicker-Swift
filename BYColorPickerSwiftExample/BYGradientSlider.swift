//
//  BYGradientSlider.swift
//  BYColorPickerSwiftExample
//
//  Created by Berk Yuksel on 08/01/2017.
//  Copyright © 2017 Berk Yuksel. All rights reserved.
//

import UIKit

class BYGradientSlider: UISlider {

    private var _gradientLayer : CAGradientLayer? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        _gradientLayer = CAGradientLayer()
        _gradientLayer?.frame = CGRect.zero
        let startColor = UIColor.white
        let endColor = UIColor.black
        
        _gradientLayer?.colors = [startColor.cgColor, endColor.cgColor]
        _gradientLayer?.cornerRadius = 4.0
        _gradientLayer?.shadowColor = UIColor.init(white: 0, alpha: 0.6).cgColor
        _gradientLayer?.shadowOffset = CGSize.init(width: 0, height: 1.0)
        _gradientLayer?.shadowRadius = 2.0
        _gradientLayer?.shadowOpacity = 0.6
        _gradientLayer?.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        _gradientLayer?.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        
        self.layer.insertSublayer(_gradientLayer!, at: 1)
        self.setMaximumTrackImage(UIImage.init(), for: UIControlState.normal )
        self.setMinimumTrackImage(UIImage.init(), for: UIControlState.normal )
    }
    
    func updateGradientLayer(with startColor:UIColor, and endColor:UIColor) -> Void {
        
        _gradientLayer?.colors = [startColor.cgColor, endColor.cgColor]
        self.setNeedsDisplay()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        _gradientLayer?.frame = rect
    }

}
