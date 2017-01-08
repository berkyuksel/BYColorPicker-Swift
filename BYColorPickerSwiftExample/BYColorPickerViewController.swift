//
//  BYColorPickerViewController.swift
//  BYColorPickerSwiftExample
//
//  Created by Berk Yuksel on 07/01/2017.
//  Copyright © 2017 Berk Yuksel. All rights reserved.
//

import UIKit

// MARK: - Constants
let kExitSegueIdentifier = "ReturnToHomeViewSegue"

// MARK: - BYColorPickerVCDelegate Declaration
@objc protocol BYColorPickerViewControllerDelegate: NSObjectProtocol {
    
    func setSelectedColor( color: UIColor )
}

// MARK: - BYColorWheel Delegation
extension BYColorPickerViewController : BYColorWheelDelegate {

    func setHueFromColorWheel(hue: Float) {
        
        _hue = CGFloat(hue)
        updateColors()
    }
}

// MARK: - Class Declaration
class BYColorPickerViewController: UIViewController {
   
    weak var delegate : BYColorPickerViewControllerDelegate?
    
    @IBOutlet weak var colorWheel: BYColorWheel!
    @IBOutlet weak var colorSwatch: BYColorSwatch!
    
    //MARK: - Private Variables
    private var _color : UIColor?
    fileprivate var _hue : CGFloat? = 0.5
    private var _saturation : CGFloat? = 1.0
    private var _brightness : CGFloat? = 1.0

    //MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Place crosshair position of colorWheel object.
        self.colorWheel.placeCrosshairByHue(hue: _hue!)
    }
    
    override func viewDidLayoutSubviews() {
        
        self.colorWheel.prepare()
        updateColors()
        
        //Set initial state for IB objects after the have been layed out.
        
        //Set initial value for Saturation Slider
        let saturationSlider : BYGradientSlider = self.view.viewWithTag(10) as! BYGradientSlider
        saturationSlider.value = Float(_saturation!)
        
        //Set initial value for Brightness Slider
        let brightnessSlider : BYGradientSlider = self.view.viewWithTag(20) as! BYGradientSlider
        brightnessSlider.value = Float(_brightness!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func setInitialColor(color : UIColor) {
        
        var h = 1.0 as CGFloat, s = 1.0 as CGFloat, b = 1.0 as CGFloat, a = 1.0 as CGFloat
        
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        _hue = h; _saturation = s; _brightness = b
    }
    
    // MARK: - Utility Methods
    func getColor() -> UIColor {
        
        return UIColor.init(hue: _hue!, saturation: _saturation!, brightness: _brightness!, alpha: 1.0)
    }
    
    fileprivate func updateColors() {
        
        //Assign Hue for colorSwatch
        self.colorSwatch.color = self.getColor()
        
        //Assign edge colors for saturationSlider
        let saturationStartColor = UIColor.init(hue: _hue!, saturation: 0.0, brightness: _brightness!, alpha: 1.0)
        let saturationEndColor = UIColor.init(hue: _hue!, saturation: 1.0, brightness: _brightness!, alpha: 1.0)
        let saturationSlider : BYGradientSlider = self.view.viewWithTag(10) as! BYGradientSlider
        saturationSlider.updateGradientLayer(with: saturationStartColor, and: saturationEndColor)
        
        //Assign edge colors for saturationSlider
        let brightnessStartColor = UIColor.init(hue: _hue!, saturation: _saturation!, brightness: 0.0, alpha: 1.0)
        let brightnessEndColor = UIColor.init(hue: _hue!, saturation: _saturation!, brightness: 1.0, alpha: 1.0)
        let brightnessSlider : BYGradientSlider = self.view.viewWithTag(20) as! BYGradientSlider
        brightnessSlider.updateGradientLayer(with: brightnessStartColor, and: brightnessEndColor)
    }
    
    // MARK: - Action Handlers
    @IBAction func doneButtonTapped(_ sender: Any) {
    
        self.delegate?.setSelectedColor(color: self.getColor() as UIColor)
        
        //Perform exit segue to initiating view controller
        self.performSegue(withIdentifier: kExitSegueIdentifier, sender: self)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
    
        //Perform exit segue to initiating view controller
        self.performSegue(withIdentifier: kExitSegueIdentifier, sender: self)
    }
    
    @IBAction func saturationValueDidChange(_ sender: Any) {
        
        _saturation = CGFloat((sender as! UISlider).value)
        updateColors()
    }
    
    @IBAction func brightnessValueDidChange(_ sender: Any) {
        
        _brightness = CGFloat((sender as! UISlider).value)
        updateColors()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
