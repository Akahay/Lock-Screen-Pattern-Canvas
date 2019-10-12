//
//  LineModel.swift
//  Lockscreen
//
//  Created by Akshay Naithani on 12/10/19.
//  Copyright © 2019 Akshay Naithani. All rights reserved.
//

import UIKit

struct LineModel {
    var startPoint:CGPoint = .zero
    var endPoint:CGPoint = .zero
    var strength:CGFloat = 1
    var isSelected:Bool = true
    
    public var print:String {
        return """
        startPoint:\(startPoint)
        endPoint:\(endPoint)
        """
    }
}

struct GridPoint {
    var location:CGPoint = .zero
    var isSelected:Bool = false
}
