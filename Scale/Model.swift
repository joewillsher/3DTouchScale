//
//  Model.swift
//  Gravity
//
//  Created by Josef Willsher on 28/10/2015.
//  Copyright © 2015 Josef Willsher. All rights reserved.
//

import Foundation
import UIKit

typealias Force = CGFloat
typealias Weight = Double

/// Model object, contains all state and handles callibaration/zeroing
struct Model {
    
    // coefficients for linear graph
    private var c: Force = 0
    private var m: Force = 1
    
    /// Returns whether the model has been callibrated for users to request calibration
    private var calibrated: Bool = false
    
    /// Returns the calculated weight from a given force value
    ///
    /// nil if uncalibrated
    func weightForForce(f: Force) -> Weight? {
        return calibrated ? Weight((f+c) * m) : nil
    }
    
    /// Zeroes the scale
    mutating func zeroForForce(f: Force) {
        c = -f
    }
    
    /// Calibrates model by observing how force value changes by repeatedly adding `diff` grammes onto the screen
    mutating func calibrateWithDifference(diff: Weight, values: [Force]) {
        
        let points = values.enumerate().map {
            (x: $0.1, y: Force($0.0) * Force(diff))
        }
        let grads = points.mapOverPairs { first, second in
            (second.y - first.y) / (second.x - first.x)
        }
        m = grads.average()
        calibrated = true
    }
    
}

// used for finding gradients between adjacent points
private extension CollectionType where Generator.Element == SubSequence.Generator.Element {
    
    /// Maps fn over each pair in the sequence
    func mapOverPairs<T>(fn: (Generator.Element, Generator.Element) -> T) -> [T] {
        return zip(dropLast(), dropFirst()).map(fn)
    }
}

private extension CollectionType where Generator.Element == Force, Index == Int {
    
    func average() -> Generator.Element {
        return reduce(0, combine: +) / Force(count)
    }
}




