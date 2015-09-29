//
//  CircleView.swift
//  RocketPoll
//
//  Created by Igor Kantor on 8/25/15.
//
//

import UIKit

//// Color Declarations
let color = UIColor(red: 0.000, green: 0.463, blue: 1.000, alpha: 1.000)

@IBDesignable
class CircleView: UIView {


    @IBInspectable var selected: Bool = false



    override func drawRect(rect: CGRect) {
        let ovalPath = UIBezierPath(ovalInRect: CGRectMake(0.5, 0.5, 24, 24))
        if selected
        {
            color.setFill()
            ovalPath.fill()
        }
        color.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()
    }
}
