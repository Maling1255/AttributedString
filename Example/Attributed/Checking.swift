//
//  Checking.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/6.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

extension AttributedString {
    
    public enum Checking: Hashable {
        /// 自定义范围
        case range(NSRange)
        /// 正则表达式
        case regex(String)
        /// 动作
        case action
        /// 附件
        case attachment
        case date
        case link
        case address
        case phoneNumber
        case transitInformation
        
    }
}

extension AttributedString.Checking {
    
    public enum Result {
        /// 自定义范围
        case range(NSAttributedString)
        /// 正则表达式
        case regex(NSAttributedString)
        #if os(iOS) || os(macOS)
        case action([AttributedString.Action])
        #endif
        #if !os(watchOS)
        case attachment(NSTextAttachment)
        #endif
        case date(Date)
        case link(URL)
        case address(Address)
        case phoneNumber(String)
        case transitInformation(TransitInformation)
    }
}

extension AttributedString.Checking.Result {
    
    public struct Date {
        let date: Foundation.Date?
        let duration: TimeInterval
        let timeZone: TimeZone?
    }
    
    public struct Address {
        let name: String?
        let jobTitle: String?
        let organization: String?
        let street: String?
        let city: String?
        let state: String?
        let zip: String?
        let country: String?
        let phone: String?
    }
    
    public struct TransitInformation {
        let airline: String?
        let flight: String?
    }
}

extension AttributedString.Checking {
    
    public struct Action {
        public typealias Trigger = AttributedString.Action.Trigger
        public typealias Highlight = AttributedString.Action.Highlight
        
        /// 触发类型
        let trigger: Trigger
        /// 高亮属性
        let highlights: [Highlight]
        /// 触发回调
        let callback: (Result) -> Void
        
        internal var handle: (() -> Void)?
        
        public init (_ trigger: Trigger = .click, highlights: [Highlight] = .defaultValue, with callback: @escaping (Result) -> Void) {
            self.trigger = trigger
            self.highlights = highlights
            self.callback = callback
        }
        
    }
}


extension AttributedString {
    
    
    /// 匹配检查(Key不会出现覆盖情况, 优先级range > regex > action > other)
    /// - Parameter checking: 检查类型
    /// - Returns: 匹配结果(范围, 检查类型, 检查结果)
    func matching(_ checking: [Checking]) -> [NSRange : (Checking, Checking.Result)] {
        guard !checking.isEmpty else {
            return [:]
        }
        
        // 传入的 ReferenceWritableKeyPath 类型, 通过KVC使用Keypath取值
        let checkings = checking.filtered(duplication: \.self).sorted{ $0.order < $1.order }
        var result: [NSRange : (Checking, Checking.Result)] = [:]
        
        func contains(_ range: NSRange) -> Bool {
            guard !result.keys.isEmpty else {
                return false
            }
            guard result[range] != nil else {
                return false
            }
            return result.keys.contains(where: { $0.overlap(range) })
        }
        
        checkings.forEach { (checking) in
            switch checking {
            case .range(let range) where !contains(range):
                let substring = value.attributedSubstring(from: range)
                result[range] = (checking, .range(substring))
                
            case .regex(let string):
                // 匹配正则对象
                guard let regex = try? NSRegularExpression(pattern: string, options: .caseInsensitive) else { return }
                let matchs = regex.matches(in: value.string, options: .init(), range: .init(location: 0, length: value.length))
                
                for match in matchs where !contains(match.range) {
                    let subString = value.attributedSubstring(from: match.range)
                    result[match.range] = (checking, .regex(subString))
                }
                
            case .action:
                let ranges: [NSRange : [Action]] = value.get(.action)
                for range in ranges where !contains(range.key) {
                    let actions = range.value
                    result[range.key] = (.action, .action(actions))
                }
                
            default:
                break
                
            }
            
            
        }
        
        return result
    }
}

fileprivate extension AttributedString.Checking {
    
    var order: Int {
        switch self {
        case .range:     return 0
        case .regex:     return 1
        case .action:    return 2
        default:         return 3
        }
    }
}

fileprivate extension NSRange {
    
    func overlap(_ other: NSRange) -> Bool {
        guard let lhs = Range(self), let rhs = Range(other) else {
            return false
        }
        return lhs.overlaps(rhs)
    }
}
