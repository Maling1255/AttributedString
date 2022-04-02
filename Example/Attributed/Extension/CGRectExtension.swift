//
//  CGRectExtension.swift
//  AttributedString_Example
//
//  Created by maling on 2022/3/31.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import CoreGraphics


extension CGRect {
    
    /// Creates a rect with unnamed arguments.
    init(_ origin: CGPoint = .zero, _ size: CGSize = .zero) {
        self.init()
        self.origin = origin
        self.size = size
    }
    
    /// Creates a rect with unnamed arguments.
    init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init()
        self.origin = CGPoint(x: x, y: y)
        self.size = CGSize(width: width, height: height)
    }
}

extension CGSize {
    
    /// Creates a size with unnamed arguments.
    init(_ width: CGFloat, _ height: CGFloat) {
        self.init()
        self.width = width
        self.height = height
    }
    
    /// Returns a copy with the width value changed.
    func with(width: CGFloat) -> CGSize {
        return .init(width: width, height: height)
    }
    /// Returns a copy with the height value changed.
    func with(height: CGFloat) -> CGSize {
        return .init(width: width, height: height)
    }
}


extension CGPoint {
    
    /// Creates a point with unnamed arguments.
    init(_ x: CGFloat, _ y: CGFloat) {
        self.init()
        self.x = x
        self.y = y
    }
    
    /// Returns a copy with the x value changed.
    func with(x: CGFloat) -> CGPoint {
        return .init(x: x, y: y)
    }
    /// Returns a copy with the y value changed.
    func with(y: CGFloat) -> CGPoint {
        return .init(x: x, y: y)
    }
}
