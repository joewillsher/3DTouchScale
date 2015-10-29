//
//  TouchCircleViewController.swift
//  Gravity
//
//  Created by Josef Willsher on 28/10/2015.
//  Copyright © 2015 Josef Willsher. All rights reserved.
//

import UIKit


/// Handles circles which respond to touch pressure
class TouchCircleViewController: UIViewController {

    /// Circle layer, setting this object handles adding to UI
    var circleLayer: CAShapeLayer? = nil {
        willSet {
            circleLayer?.removeFromSuperlayer()
        }
        didSet {
            if let layer = circleLayer {
                view.layer.addSublayer(layer)
            }
        }
    }
    
    
//    private var timer: NSTimer?
//    private var touch: UITouch?
    
    // MARK: Touch handling
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchEventHandle(touches.first)
//        touch = touches.first
//        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerFired:", userInfo: nil, repeats: true)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchEventHandle(touches.first)
    }
    
//    final func timerFired(timer: NSTimer) {
//        touchEventHandle(touch)
//    }
    
    
    /// Handles spoon touch
    func touchEventHandle(t: UITouch?) {
        
        guard let touch = t else { return }
//        print(touch.force)
        
        let dim = (touch.force / touch.maximumPossibleForce) * (maxCircleRatio * min(view.frame.width, view.frame.height) - minCircleRad) + minCircleRad
        
        let origin = touch.locationInView(view)
        let centre = CGPoint(x: origin.x - dim/2, y: origin.y-dim/2)
        
        let rect = CGRect(origin: centre, size: CGSize(width: dim, height: dim))
        let path = UIBezierPath(ovalInRect: rect)
        let layer = CAShapeLayer()
        layer.path = path.CGPath
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        circleLayer = layer
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        circleLayer = nil
//        timer = nil
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        circleLayer = nil
//        timer = nil
    }

    // MARK: Constants for circle display
    private var minCircleRad: CGFloat = 120
    private var maxCircleRatio: CGFloat = 0.75
    
}






