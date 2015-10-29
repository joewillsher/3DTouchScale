//
//  CoinLabel.swift
//  Gravity
//
//  Created by Josef Willsher on 28/10/2015.
//  Copyright © 2015 Josef Willsher. All rights reserved.
//

import Foundation
import UIKit

class CoinLabel: UILabel {
    
    private var animationDuration = 0.3
    
    func setup() {
        text = "¢25"
        font = UIFont.systemFontOfSize(18, weight: 8)
        setUnselected()
        layer.cornerRadius = frame.height/2
        layer.borderWidth = 2
    }
    
    func setUnselected() {
        UIView.animateWithDuration(animationDuration) {
            self.layer.backgroundColor = UIColor.whiteColor().CGColor
            self.textColor = UIColor.redColor()
            self.layer.borderColor = UIColor.redColor().CGColor
        }
    }
    
    func setSelected() {
        setUnfocused()
        
        UIView.animateWithDuration(animationDuration) {
            self.layer.backgroundColor = UIColor.redColor().CGColor
            self.textColor = UIColor.whiteColor()
            self.layer.borderColor = UIColor.whiteColor().CGColor
        }
    }
    
    func setFocused() {
        setUnselected()
        
        UIView.animateWithDuration(animationDuration) {
            self.transform = CGAffineTransformMakeScale(1.3, 1.3)
        }
    }
    
    func setUnfocused() {
        UIView.animateWithDuration(animationDuration) {
            self.transform = CGAffineTransformMakeScale(1, 1)
        }
    }
    
}

