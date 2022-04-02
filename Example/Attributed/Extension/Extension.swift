//
//  Extension.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation


public class AttributedStringWrapper<Base> {
   let base: Base
   init(_ base: Base) {
        self.base = base
    }
}

public protocol AttributedStringCompatible {
    associatedtype AttributedStringCompatibleType
    var attributed: AttributedStringCompatibleType { get }
}

extension AttributedStringCompatible {
    
    public var attributed: AttributedStringWrapper<Self> {
        get { return AttributedStringWrapper(self) }
    }
}
