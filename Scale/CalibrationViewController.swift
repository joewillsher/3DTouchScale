//
//  CalibrationViewController.swift
//  Gravity
//
//  Created by Josef Willsher on 28/10/2015.
//  Copyright © 2015 Josef Willsher. All rights reserved.
//

import UIKit
import Foundation

class CalibrationViewController: TouchCircleViewController {

    @IBOutlet weak var coin1: CoinLabel!
    @IBOutlet weak var coin2: CoinLabel!
    @IBOutlet weak var coin3: CoinLabel!
    @IBOutlet weak var coin4: CoinLabel!
    
    @IBOutlet weak var instructionLabel: UILabel! 
    
    /// Current coin, nil if spoon not on screen
    private var activeCoin: Int? {
        didSet {

            switch activeCoin {
            case nil:
                for coin in [coin1, coin2, coin3, coin4] {
                    coin.setUnfocused()
                    coin.setUnselected()
                }
                
                forces.removeAll()
                
            case 0?:
                coin1.setFocused()
                
                model.zeroForForce(forceValue)
                
            case 1?:
                coin1.setSelected()
                coin2.setFocused()
            case 2?:
                coin2.setSelected()
                coin3.setFocused()
            case 3?:
                coin3.setSelected()
                coin4.setFocused()
            case 4?:
                coin4.setSelected()
                model.calibrateWithDifference(5.670, values: forces)
                
                finishedCalibrating()
                
            default:
                break
            }
            
            if let a = activeCoin {
                instructionLabel.text = "Place coin #\(a+1) on the spoon"
            } else {
                instructionLabel.text = "Place spoon on screen"
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for coin in [coin1, coin2, coin3, coin4] { coin.setup() }
        activeCoin = nil
        instructionLabel.text = "Place spoon on screen"
    }
    
    /// contains model in cailibration
    private var model = Model()
    /// current force reading
    private var forceValue: Force = 0
    /// all force readings
    private var forces: [Force] = []

    // MARK: Touch handling
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        
        timer?.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "fire:", userInfo: nil, repeats: false)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        touchEnd()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        super.touchesCancelled(touches, withEvent: event)
        touchEnd()
    }
    
    /// handles the end of a touch
    private func touchEnd() {
        timer?.invalidate()
        activeCoin = nil
    }
    
    override func touchEventHandle(t: UITouch?) {
        super.touchEventHandle(t)
        
        if let t = t { forceValue = t.force }
    }
    
    /// Timer for reading force after no touch event for 0.4s
    private var timer: NSTimer?
    
    /// Timer triggered
    func fire(timer: NSTimer) {
        
        if isValidJump(forceValue) {
            
            if let a = activeCoin { activeCoin = a+1 } else { activeCoin = 0 }
            forces.append(forceValue)
        }
    }
    
    /// Returns whether the model should inspect the new force value, requires that the jump be positive and simmilar in magnitude to previous jumps
    private func isValidJump(force: Force) -> Bool {
        
        switch forces.count {
        case 0: return true
        case 1: return force - (forces.last ?? 0) >= 0.05
        case _:
            guard let sl = forces.dropLast().last, l = forces.last else { return false }
            return force - (forces.last ?? 0) >= (l - sl) * 0.667
        }
        
    }
    
    /// Pushes measurement screen
    private func finishedCalibrating() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MeasurementViewController") as! MeasurementViewController
        vc.model = model
        presentViewController(vc, animated: false, completion: nil)
    }
    
}



