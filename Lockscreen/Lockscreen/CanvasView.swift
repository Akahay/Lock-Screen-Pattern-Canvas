//
//  CanvasView.swift
//  Lockscreen
//
//  Created by Akshay Naithani on 11/10/19.
//  Copyright © 2019 Akshay Naithani. All rights reserved.
//

import UIKit

class CanvasView: UIView {
    
    private weak var context:CGContext!
    
    public var lineModel:LineModel!
    public var drawLines:[LineModel] = []
    public var gridPoints:[GridPoint] = []
    
    let whiteSelectedCGColor = UIColor.white.cgColor
    let yellowSelectedCGColor = UIColor.yellow.cgColor
    
    let normalAlphaValue:CGFloat = 1
    let selectedAlphaValue:CGFloat = 1
    
    override func draw(_ rect: CGRect) {
        
        context = nil
        context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(whiteSelectedCGColor)
        context.setLineWidth(2)
        
        for point in gridPoints {
            drawCircleAroundPoint(point: point.location,selected: point.isSelected)
        }
        
        if let line = lineModel {
            drawLineShape(startPoint: line.startPoint, endPoint: line.endPoint, isSelected: true,width: line.strength)
        }
        for line in drawLines {
            drawLineShape(startPoint: line.startPoint, endPoint: line.endPoint, isSelected: line.isSelected,width: line.strength)
        }
        context.drawPath(using: .stroke)
        
    }
    private func drawCircleAroundPoint(point: CGPoint,selected: Bool) {
        let width:CGFloat = 2
        if selected {
            drawCircle(point: point, width: width*1.5, alpha: 1, strokeColor: UIColor.yellow.cgColor)
        }
        drawCircle(point: point, width: width, alpha: 0.5, strokeColor: UIColor.white.cgColor)
    }
    private func drawCircle(point: CGPoint,width: CGFloat,alpha: CGFloat,strokeColor: CGColor) {
        let radius:CGFloat = 20.0
        let smallerRadius:CGFloat = 5.0
        context.setFillColor(UIColor.clear.cgColor)
        context.setStrokeColor(strokeColor)
        context.setAlpha(alpha)
        context.setLineWidth(width)
        
        let rectangle = CGRect(x: point.x - radius, y: point.y - radius, width: 2 * radius, height: 2 * radius)
        context.addEllipse(in: rectangle)
        let smallerRectangle = CGRect(x: point.x - smallerRadius, y: point.y - smallerRadius, width: 2 * smallerRadius, height: 2 * smallerRadius)
        context.addEllipse(in: rectangle)
        context.addEllipse(in: smallerRectangle)
        context.drawPath(using: .fillStroke)
    }
    
    private func drawLineShape(startPoint: CGPoint, endPoint: CGPoint, isSelected: Bool, width: CGFloat){
        if isSelected{
            drawSelectedPathWithContext(pointA: startPoint, pointB: endPoint, width: width)
        }
        let widthValue = isSelected ? 2*width : width
        drawUnselectedPathWithContext(pointA: startPoint, pointB: endPoint, width: widthValue)
    }
    
    private func selectedLineWidth(width: CGFloat) -> CGFloat {
        return width * 3
    }
    private func drawSelectedPathWithContext(pointA:CGPoint,pointB:CGPoint,width:CGFloat,isFreehandShape:Bool = false){
            drawLinePath(pointA: pointA, pointB: pointB, strokeColor: whiteSelectedCGColor, widthValue: selectedLineWidth(width: width),alpha: selectedAlphaValue)
    }
    
    private func drawUnselectedPathWithContext(pointA:CGPoint,pointB:CGPoint,width:CGFloat,isFreehandShape:Bool = false){
        drawLinePath(pointA: pointA, pointB: pointB, strokeColor: yellowSelectedCGColor, widthValue: width,alpha: normalAlphaValue)
    }
    
    private func drawLinePath(pointA:CGPoint,pointB:CGPoint,strokeColor:CGColor,widthValue:CGFloat,alpha: CGFloat) {
        context.beginPath()
        context.setAlpha(alpha)
        context.setLineWidth(widthValue)
        context.setStrokeColor(strokeColor)
        context.setLineCap(.round)
        context.move(to: pointA)
        context.addLine(to: pointB)
        context.strokePath()
        context.closePath()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if location != .zero{
            startPoint = location
        }
    }
}
