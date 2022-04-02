//
//  Action.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

extension AttributeStringItem {
    
    public struct Action {
        
    }
    
}

extension AttributeStringItem.Action {
    
    public enum Trigger: Hashable {
        /// 单击  default
        case click
        /// 按住
        case press
    }
    
    public struct Result {
        public let range: NSRange
        public let content: Content
    }
     
    public struct Highlight {
        let attributes: [NSAttributedString.Key: Any]
    }
}

extension AttributeStringItem.Action.Result {
    
    public enum Content {
        case string(NSAttributedString)
        case attachment(NSTextAttachment)
    }
}

extension AttributeStringItem.Attribute {
    
    public typealias Action = AttributeStringItem.Action
    public typealias Result = Action.Result
    
    public static func action(_ value: @escaping () -> Void) -> Self {
        return action { _ in value() }
    }
    
    public static func action(_ value: @escaping (Result) -> Void) -> Self {
        return .init(attributes: [.action: Action(with: value)])
    }
    
    public static func action(_ trigger: Trigger, _ closure: @escaping () -> Void) -> Self {
        return .init(attributes: [.action: Action(trigger, with: { _ in closure() })])
    }
    
    public static func action(_ trigger: Trigger, _ closure: @escaping (Result) -> Void) -> Self {
        return .init(attributes: [.action: Action(trigger, with: closure)])
    }
    
    public static func action(_ highlights: [Action.Highlight], _ closure: @escaping () -> Void) -> Self {
        return .init(attributes: [.action: Action(highlights: highlights, with: { _ in closure() })])
    }
    
    public static func action(_ highlights: [Action.Highlight], _ closure: @escaping (Result) -> Void) -> Self {
        return .init(attributes: [.action: Action(highlights: highlights, with: closure)])
    }
    
    public static func action(_ value: Action) -> Self {
        return .init(attributes: [.action: value])
    }
}


extension NSAttributedString {
    
    func contains(_ name: Key) -> Bool {
        var result = false
        enumerateAttribute(
            name,
            in: .init(location: 0, length: length),
            options: .longestEffectiveRangeNotRequired
        ) { (value, range, stop) in
            guard value != nil else { return }
            result = true
            stop.pointee = true
        }
        return result
    }
    
    func get<T>(_ name: Key) -> [NSRange: T] {
        var result: [NSRange: T] = [:]
        
        // 根据附件(.attachment) 找到所在的范围位置
        enumerateAttribute(
            name,
            in: .init(location: 0, length: length),
            options: .longestEffectiveRangeNotRequired
        ) { (value, range, stop) in
            guard let value = value as? T else { return }
            result[range] = value
        }
        return result
    }
    
    func get(_ range: NSRange) -> [NSRange: [NSAttributedString.Key: Any]] {
        var result: [NSRange: [NSAttributedString.Key: Any]] = [:]
        enumerateAttributes(in: range, options: .longestEffectiveRangeNotRequired) { (attributes, range, stop) in
            result[range] = attributes
        }
        return result
    }
    
    func reset(range: NSRange, attributes handle: (inout [NSAttributedString.Key: Any]) -> Void) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: self)
        enumerateAttributes(
            in: range,
            options: .longestEffectiveRangeNotRequired
        ) { (attributes, range, stop) in
            var temp = attributes
            handle(&temp)
            string.setAttributes(temp, range: range)
        }
        return string
    }
}
