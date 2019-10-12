//
//  ViewController.swift
//  Lockscreen
//
//  Created by Akshay Naithani on 11/10/19.
//  Copyright © 2019 Akshay Naithani. All rights reserved.
//

import UIKit

class LockViewController: UIViewController {
    
    @IBOutlet weak var canvasView: CanvasView!
    var grid = [GridPoint]()
    var line:LineModel?
    var lines:[LineModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        canvasView.isUserInteractionEnabled = true
        setUpGrid()
        createPanGestureRecognizer(targetView: canvasView)
    }
    private func setUpGrid() {
        let startPoint = CGPoint(x: 50, y: 50)
        let range = 0..<3
        for i in range {
            for j in range {
                let point = CGPoint(x: startPoint.x + (100 * CGFloat(i)), y: startPoint.y + (100 * CGFloat(j)))
                let gridPoint = GridPoint(location: point, isSelected: false)
                grid.append(gridPoint)
            }
        }
        canvasView.gridPoints = grid
        canvasView.setNeedsDisplay()
    }
    private func createPanGestureRecognizer(targetView: CanvasView) {
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture(panGesture:)))
        targetView.addGestureRecognizer(panGesture)
    }
    private func createLine(point: CGPoint) {
        line = LineModel(startPoint: point, endPoint: point, strength: 1, isSelected: true)
    }
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        let currentPoint = panGesture.translation(in: canvasView) + startPoint
        let validGrid = isCloseToValidPoint(currPoint: currentPoint)
        let validPoint = validGrid?.location
        switch panGesture.state {
            case .began:
                if let validPoint = validPoint {
                    createLine(point: validPoint)
                }
            case .changed:
                if let validPoint = validPoint {
                    if var line = line {
                        if line.startPoint == validPoint {
                            line.endPoint = currentPoint
                        } else {
                            line.endPoint = validPoint
                            lines.append(line)
                            self.line = nil
                            createLine(point: validPoint)
                        }
                    }else{
                        createLine(point: validPoint)
                    }
                } else{
                    line?.endPoint = currentPoint
                }
            case .ended:
                line = nil
                lines = []
                deselectAllGridItems()
            case .cancelled:
                fallthrough
            case .failed:
                fallthrough
            case .possible:
                fallthrough
            @unknown default:
                break
        }
        canvasView.gridPoints = grid
        canvasView.lineModel = line
        canvasView.drawLines = lines
        canvasView.setNeedsDisplay()
    }
        
    private func deselectAllGridItems() {
        for i in 0..<grid.count {
            grid[i].isSelected = false
        }
    }
    
    private func isCloseToValidPoint(currPoint: CGPoint) -> GridPoint? {
        for i in 0..<grid.count {
            if grid[i].isSelected == false {
                if abs(grid[i].location.x - currPoint.x) <= radius {
                    if abs(grid[i].location.y - currPoint.y) <= radius {
                        grid[i].isSelected = true
                        return grid[i]
                    }
                }
            }
        }
        return nil
    }
}

extension CGPoint {
    static func +(lhs:CGPoint,rhs:CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
