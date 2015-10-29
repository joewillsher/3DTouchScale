//
//  MeasurementViewController.swift
//  Gravity
//
//  Created by Josef Willsher on 28/10/2015.
//  Copyright © 2015 Josef Willsher. All rights reserved.
//

import UIKit

/// VC used to display readout
class MeasurementViewController: TouchCircleViewController {

    @IBOutlet weak var weightLabel: UILabel?
    
    /// Calculated weight value, setting updates UI
    private var weightValue: Weight? {
        didSet {
            if let v = weightValue {
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .DecimalStyle
                formatter.maximumFractionDigits = 2
                formatter.minimumFractionDigits = 2
                weightLabel?.text = (formatter.stringFromNumber(v) ?? "") + "g"
            } else {
                weightLabel?.text = "--g"
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        weightValue = nil
    }
    
    /// Model object which contains state
    var model = Model()
    
    // MARK: Touch handling
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        weightValue = nil
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        weightValue = nil
    }
    
    /// Handles spoon touch
    override func touchEventHandle(t: UITouch?) {
        super.touchEventHandle(t)
        
        guard let touch = t, let weight = model.weightForForce(touch.force) else { return }
        
        weightValue = weight
        forceValue = touch.force
    }
    
    /// Value of the force of the most recent touch event
    private var forceValue: Force = 0
    
    // MARK: Buttons
    
    @IBAction func zeroModel(sender: AnyObject) {
        model.zeroForForce(forceValue)
        if let _ = weightValue { weightValue = 0 }
    }
    
    @IBAction func calibrateModel(sender: AnyObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CalibrationViewController") as! CalibrationViewController
        presentViewController(vc, animated: false, completion: nil)
    }

}

