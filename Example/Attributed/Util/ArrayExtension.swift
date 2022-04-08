//
//  ArrayExtension.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

extension Array {
    
    /// 过滤重复元素
    /// - Parameter path: KeyPath条件
    func filtered<E: Equatable>(duplication path: KeyPath<Element, E>) -> [Element] {
        return reduce(into: [Element]()) { (result, e) in
            
            // swift 4.0之后 keyPath 取值 如下使用kvc 取值  https://www.hangge.com/blog/cache/detail_1823.html
            let contains = result.contains { $0[keyPath: path] == e[keyPath: path] }
            result += contains ? [] : [e]
        }
    }
    
    
    /// 过滤重复元素
    /// - Returns: 过滤条件
    func filtered<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        return try reduce(into: [Element]()) { (result, e) in
            let contains = try result.contains{ try closure($0) == closure(e) }
            result += contains ? [] : [e]
        }
    }
    
    
    @discardableResult
    mutating func filter<E: Equatable>(duplication path: KeyPath<Element, E>) -> [Element] {
        self = filtered(duplication: path)
        return self
    }
    
    
    @discardableResult
    mutating func filter<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        self = try filtered(duplication: closure)
        return self
    }
    
}


extension Array where Element: Equatable {
    
}
