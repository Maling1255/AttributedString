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
        /// 触发类型
        let trigger: Trigger
        /// 高亮属性
        let highlights: [Highlight]
        /// 触发回调
        let callback: (Result) -> Void
        
        internal var handle: (() -> Void)?
        
        public init(_ trigger: Trigger = .click, highlights: [Highlight] = .defalut, with callback: @escaping (Result) -> Void) {
            self.trigger = trigger
            self.highlights = highlights
            self.callback = callback
        }
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

extension NSAttributedString.Key {
    
    static let action = NSAttributedString.Key("com.attributed.string.action")
}

extension AttributeStringItem.Attribute {
    
    public typealias Action = AttributeStringItem.Action
    public typealias Result = Action.Result
    public typealias Trigger = Action.Trigger
    
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

extension AttributeStringItem.Action.Highlight {
        
    public static func foreground(_ value: UIColor) -> Self {
        return .init(attributes: [.foregroundColor: value])
    }
    
    public static func background(_ value: UIColor) -> Self {
        return .init(attributes: [.backgroundColor: value])
    }
    
    public static func strikethrough(_ style: NSUnderlineStyle, color: UIColor? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.strikethroughColor] = color
        temp[.strikethroughStyle] = style.rawValue
        return .init(attributes: temp)
    }
    
    public static func underline(_ style: NSUnderlineStyle, color: UIColor? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.underlineColor] = color
        temp[.underlineStyle] = style.rawValue
        return .init(attributes: temp)
    }
    
    public static func shadow(_ value: NSShadow) -> Self {
        return .init(attributes: [.shadow: value])
    }
    
    public static func stroke(_ width: CGFloat = 0, color: UIColor? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.strokeColor] = color
        temp[.strokeWidth] = width
        return .init(attributes: temp)
    }
}

public extension Array where Element == AttributeStringItem.Action.Highlight {
    
    static var defalut: [AttributeStringItem.Action.Highlight] = [.foreground(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)), .underline(.single)]
    
    static let empty: [AttributeStringItem.Action.Highlight] = []
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
