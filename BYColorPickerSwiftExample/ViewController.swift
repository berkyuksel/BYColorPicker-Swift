//
//  ViewController.swift
//  BYColorPickerSwiftExample
//
//  Created by Berk Yuksel on 07/01/2017.
//  Copyright © 2017 Berk Yuksel. All rights reserved.
//

import UIKit

// MARK: - ColorPickerViewController Delegation

extension ViewController : BYColorPickerViewControllerDelegate {
    
    func setSelectedColor(color: UIColor) {
        
        self.view.backgroundColor = color;
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowColorPickerViewSegue"{

            let colorPickerVC = segue.destination as! BYColorPickerViewController
            colorPickerVC.delegate = self
            colorPickerVC.setInitialColor(color: self.view.backgroundColor!)
        }
    }
    
    @IBAction func returnToHomeViewSegue(segue: UIStoryboardSegue) {}

}

