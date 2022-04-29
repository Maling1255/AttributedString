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
        
        public init (_ trigger: Trigger = .click, highlights: [Highlight] = .default, with callback: @escaping (Result) -> Void) {
            self.trigger = trigger
            self.highlights = highlights
            self.callback = callback
        }
        
    }
}


extension AttributedString {
    
    typealias ViewAttachment = AttributedStringItem.ViewAttachment
    
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
            case .attachment:
                
                func allow(_ range: NSRange, _ attachment: NSTextAttachment) -> Bool {
                    return !contains(range) && !(attachment is ViewAttachment)
                }
                
                let attachments: [NSRange : NSTextAttachment] = value.get(.attachment)
                for attachment in attachments where allow(attachment.key, attachment.value) {
                    result[attachment.key] = (.attachment, .attachment(attachment.value))
                }
            case .link:
                let links: [NSRange : URL] = value.get(.link)
                for link in links where !contains(link.key) {
                    result[link.key] = (.link, .link(link.value))
                }
                fallthrough
                
            case .date, .address, .phoneNumber, .transitInformation:
                guard let detector = try? NSDataDetector(types: NSTextCheckingAllTypes) else { return }
                
                let matches = detector.matches(in: value.string, options: .init(), range: .init(location: 0, length: value.length))
                
                for match in matches where !contains(match.range){
                    guard let types = match.resultType.map() else { continue }
                    guard checkings.contains(types) else { continue }
                    guard let mapped = match.map() else { continue }
                    
                    result[match.range] = (types, mapped)
                }
                
            default:
                break
                
            }
            
            
        }
        
        return result
    }
}

extension AttributedString {
    
    public mutating func add(checkings: [Checking] = .default, _ attributes: [Attribute]) {
        guard !checkings.isEmpty, !attributes.isEmpty else { return }
        
        let attributes = attributes.mergedAction()
        
        // 过滤重复的attribute, 重复的取最后添加的
        var temp: [NSAttributedString.Key : Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        
        let matched = matching(checkings)
        let string = NSMutableAttributedString(attributedString: value)
        matched.forEach{ string.addAttributes(temp, range: $0.0) }
        value = string
    }
    
    public mutating func set(checkings: [Checking] = .default, _ attributes: [Attribute]) {
        guard !checkings.isEmpty, !attributes.isEmpty else { return }
        
        let attributes = attributes.mergedAction()
        
        // 过滤重复的attribute, 重复的取最后添加的
        var temp: [NSAttributedString.Key : Any] = [:]
        attributes.forEach { temp.merge($0.attributes, uniquingKeysWith: { $1 }) }
        
        let matched = matching(checkings)
        let string = NSMutableAttributedString(attributedString: value)
        matched.forEach{ string.addAttributes(temp, range: $0.0) }
        value = string
    }
}

public extension Array where Element == AttributedString.Checking {
    
    static let `default`: [AttributedString.Checking] = [.date, .link, .address, .phoneNumber,. transitInformation]
    
    static let empty: [AttributedString.Checking] = []
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

fileprivate extension NSTextCheckingResult.CheckingType {
    
    func map() -> AttributedString.Checking? {
        switch self {
        case .date:
            return .date
        
        case .link:
            return .link
        
        case .address:
            return .address
            
        case .phoneNumber:
            return .phoneNumber
            
        case .transitInformation:
            return .transitInformation
            
        default:
            return nil
        }
    }
}

fileprivate extension NSTextCheckingResult {
    
    func map() -> AttributedString.Checking.Result? {
        switch resultType {
        case .date:
            return .date(
                .init(
                    date: date,
                    duration: duration,
                    timeZone: timeZone
                )
            )
        
        case .link:
            guard let url = url else { return nil }
            return .link(url)
        
        case .address:
            guard let components = addressComponents else { return nil }
            return .address(
                .init(
                    name: components[.name],
                    jobTitle: components[.jobTitle],
                    organization: components[.organization],
                    street: components[.street],
                    city: components[.city],
                    state: components[.state],
                    zip: components[.zip],
                    country: components[.country],
                    phone: components[.phone]
                )
            )
            
        case .phoneNumber:
            guard let number = phoneNumber else { return nil }
            return .phoneNumber(number)
            
        case .transitInformation:
            guard let components = components else { return nil }
            return .transitInformation(
                .init(
                    airline: components[.airline],
                    flight: components[.flight]
                )
            )
            
        default:
            return nil
        }
    }
}

fileprivate extension NSRange {
    
    // 范围是否重叠
    func overlap(_ other: NSRange) -> Bool {
        guard let lhs = Range(self), let rhs = Range(other) else {
            return false
        }
        return lhs.overlaps(rhs)
    }
}
