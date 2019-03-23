//
//  ViewConstants.swift
//  GuitarGame
//
//  Created by Mac Macoy on 11/4/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class ViewConstants {
    
    // chords
    let zRange: ClosedRange<Double> = 0...3
    let secondsInZRange: ClosedRange<Double> = -0.1...6
    let spaceBetweenChords = 0.02
    let spaceBetweenChordNameAndEdge = 0.18
    
    // lyrics
    var lyricRectHeight: CGFloat {
        return CGFloat(screenHeight/4)
    }
    var lyricStartingRect: CGRect {
        let width = screenWidth/1.25
        let height = lyricRectHeight
        let x = screenWidth/2 - width/2
        let y = screenHeight/18
        return CGRect(x: x, y: y, width: width, height: height)
    }
    let lyricAlphaRange = CGFloat(0.4)...CGFloat(1.0)
    let lyricFadeTimeInterval = 0.5
    
    // camera
    let cameraY: Float = 1.4
    let cameraZ: Float = -0.5
    let cameraX: Float = 0.0
    let lightHeight: Float = 5.0
    
    // time 0 marker
    let timeZeroAdditionalZ = 0.1
    
    // camera angle increase
    let cameraAngleIncrease = Float(0.05)
    
    // gameplay screen
    var screenWidth: CGFloat { return UIScreen.main.bounds.width }
    var screenHeight: CGFloat { return UIScreen.main.bounds.height }
    
    // font
    static let font = "Sinhala Sangam MN"
    
    init() {
        assert(secondsInZRange.lowerBound < 0 && secondsInZRange.upperBound > 0, "secondsInZRange is invalid")
    }
    
    var zLength: Double {
        return zRange.upperBound - zRange.lowerBound
    }
    
    var windowSize: Double {
        return secondsInZRange.upperBound - secondsInZRange.lowerBound
    }
    
    //    func cameraY(yFov: Float) -> Float {
    //        let r = Float(zRange.upperBound - zRange.lowerBound)
    //        let a = (tan(yFov)*tan(yFov))
    //        let b = -4*abs(cameraZ)*abs(cameraZ)
    //        let c = 4*abs(cameraZ)*r
    //        let d = r*r*(1/tan(yFov))*(1/tan(yFov))
    //        let e = (b - c + d)
    //        let sqrtVal = a*e
    //        let answer = (0.5)*(1/tan(yFov))*(sqrt(sqrtVal)-r)
    //        return answer
    //    }
    
    func cameraEulerAngle(yFov: Float) -> Float {
        let fov = degreesToRadians(degrees: yFov)
        let a = (abs((cameraY/cameraZ))-tan(fov))
        let b = (1+abs((cameraY/cameraZ))*tan(fov))
        let euler = abs(atan( a / b ))
        return (Float.pi - euler - fov/2) + cameraAngleIncrease
    }
    
    func timeZeroEulerAngle(zAtZeroSeconds: Float) -> Float {
        return -atan((abs(cameraZ) + zAtZeroSeconds)/cameraY)
    }
    
    private func degreesToRadians(degrees: Float) -> Float {
        return degrees*Float.pi/180
    }
    
    static let tableViewCellHeight: CGFloat = 59.5
    
}
