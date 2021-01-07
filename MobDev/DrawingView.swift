//
//  DrawingView.swift
//  MobDev
//
//  Created by POG on 07.01.2021.
//

import UIKit


extension CGPoint {

    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }
}


struct Chart {
    var fractions: [UIColor: CGFloat] = [.yellow: 0.25, .green: 0.20, .blue: 0.55]
}

struct Graph {
    var x = stride(from: -2*CGFloat.pi, through: 2*CGFloat.pi, by: 0.01)
    func function(x: CGFloat) -> CGFloat {
        return CoreGraphics.sin(x)
    }
}


enum ViewState: Int {
    case Graph
    case Chart
}

class DrawingView: UIView {
    var state: ViewState = .Graph

    var chart = Chart()
    var graph = Graph()

    override func draw(_ rect: CGRect) {
        var pencil: UIBezierPath

        let center = CGPoint(x: rect.width/2, y: rect.height/2)

        switch state {
            case .Graph:
                let unit = CGPoint(x: rect.width/(4 * CGFloat.pi), y: rect.height/4)

                pencil = UIBezierPath()
                pencil.move(to: CGPoint(x: rect.width/2, y: rect.height))
                pencil.addLine(to: CGPoint(x: rect.width/2, y: 0))
                pencil.stroke()
                pencil.addLine(to: pencil.currentPoint + CGPoint(x: -6, y: 12))
                pencil.addLine(to: pencil.currentPoint + CGPoint(x: 12, y: 0))
                pencil.addLine(to: pencil.currentPoint + CGPoint(x: -6, y: -12))
                pencil.fill()

                pencil = UIBezierPath()
                pencil.move(to: CGPoint(x: 0, y: rect.height/2))
                pencil.addLine(to: CGPoint(x: rect.width, y: rect.height/2))
                pencil.stroke()
                pencil.addLine(to: pencil.currentPoint + CGPoint(x: -12, y: -6))
                pencil.addLine(to: pencil.currentPoint + CGPoint(x: 0, y: 12))
                pencil.addLine(to: pencil.currentPoint + CGPoint(x: 12, y: -6))
                pencil.fill()

                pencil = UIBezierPath()
                pencil.move(to: center + CGPoint(x: -2*CGFloat.pi, y: CGFloat.zero) * unit)

                UIColor.red.set()
                for x in graph.x {
                    let point = center + CGPoint(x: x, y: -graph.function(x: x)) * unit

                    pencil.addLine(to: point)
                }

                pencil.stroke()
            case .Chart:
                var fromAngle = CGFloat(0)
                var toAngle = CGFloat(0)

                for (color, percentage) in chart.fractions {
                    fromAngle = toAngle
                    toAngle += 2*CGFloat.pi * percentage

                    pencil = UIBezierPath()
                    pencil.move(to: center)

                    color.set()
                    pencil.addArc(withCenter: center, radius: rect.width < rect.height ? rect.width/2 : rect.height/2, startAngle: fromAngle, endAngle: toAngle, clockwise: true)

                    pencil.fill()
                }

                pencil = UIBezierPath()
                pencil.move(to: center)
                pencil.addArc(withCenter: center, radius: rect.width < rect.height ? rect.width/4 : rect.height/4, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
                if #available(iOS 13.0, *) {
                    UIColor.systemBackground.set()
                } else {
                    UIColor.white.set()
                }
                pencil.fill()
        }
    }
}
