//
//  PushButtonView.swift
//  Flow
//
//  Created by David Rothschild on 7/24/16.
//  Copyright © 2016 Dave Rothschild. All rights reserved.
//

import UIKit

@IBDesignable
class PushButtonView: UIButton {
    
    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    @IBInspectable var isAddButton: Bool = true
    
    //need to override highlighted
    //to call setNeedsDisplay() when the button is pressed
    
    override var highlighted:Bool {
        didSet {
            super.highlighted = highlighted
            setNeedsDisplay()
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        path.fill()
        
        //set up the width and height variables
        //for the horizontal stroke
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = plusHeight
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(CGPoint(
            x:bounds.width/2 - plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width/2 + plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        //Vertical Line
        if isAddButton {
            //move to the start of the vertical stroke
            plusPath.moveToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 - plusWidth/2 + 0.5))
            
            //add the end point to the vertical stroke
            plusPath.addLineToPoint(CGPoint(
                x:bounds.width/2 + 0.5,
                y:bounds.height/2 + plusWidth/2 + 0.5))
        }
        
        //set the stroke color
        UIColor.whiteColor().setStroke()
        
        //draw the stroke
        plusPath.stroke()
        
        //gradient and blending
        //gives user feedback on pressing a button
        //need to override the highlighted property (see above)
        //to call setNeedsDisplay()
        
        if self.state == .Highlighted {
            let context = UIGraphicsGetCurrentContext()
            let startColor = UIColor.clearColor()
            let endColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.15)
            let colors = [startColor.CGColor, endColor.CGColor]
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorLocations:[CGFloat] = [0.0, 1.0]
            let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
            var startPoint = CGPointZero
            var endPoint = CGPoint(x:0.0, y:self.bounds.height)
            let center = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect))
            let radius = self.bounds.width/2
            CGContextSetBlendMode(context, CGBlendMode.Darken)
            CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, [])
        }
        
    }
    
}