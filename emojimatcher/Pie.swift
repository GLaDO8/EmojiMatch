//
//  Pie.swift
//  emojimatcher
//
//  Created by shreyas gupta on 04/06/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct Pie: Shape{
    let startAngle: Angle
    let endAngle: Angle
    let clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius: CGFloat = min(rect.height, rect.width)/2
        let start = CGPoint(
            x: center.x + radius*cos(CGFloat(startAngle.radians)),
            y: center.y + radius*cos(CGFloat(startAngle.radians))
        )
        var p = Path()
        p.move(to: center)
        p.addLine(to: start) // defaults to center + radius
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        p.addLine(to: center)
        return p
    }
}
