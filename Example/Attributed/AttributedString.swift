//
//  AttributedString.swift
//  AttributedString_Example
//
//  Created by maling on 2022/3/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit


public struct AttributedStringItem {

    public typealias Newline = AttributedStringItem.Form.Newline
    public typealias Style = Attachment.Style
    public typealias Attribute = AttributedString.Attribute
    
    public enum Form {
        public  enum Newline {
            case none
            case leading
            case trailing
        }
        
        case none
        case string
        case image(Newline)
        case view(Newline)
    }
    
    let string: String?
    let attributes: [Attribute]
    let image: UIImage
    let view: UIView
    let style: Attachment.Style

    let form: Form
    
    // string
    public static func string(_ sting: String) -> AttributedStringItem {
        .string(sting, [])
    }
    
    public static func string(_ sting: String, _ attributes: Attribute...) -> AttributedStringItem {
        .string(sting, attributes)
    }
    
    public static func string(_ sting: String, _ attributes: [Attribute]) -> AttributedStringItem {
        .init(string: sting, attributes: attributes, image: UIImage(), view: UIView(), style: .original(), form:.string)
    }
    
    // attributes
    public static func attributes(_ attributes: Attribute...) -> AttributedStringItem {
        .attributes(attributes)
    }
    public static func attributes(_ attributes: [Attribute]) -> AttributedStringItem {
        .string("", attributes)
    }
    
    // image
    public static func image(_ image: UIImage, _ style: Style = .original(), newline: Newline = .none) -> AttributedStringItem {
        return .init(string: nil, attributes: [], image: image, view: UIView(), style: style, form: .image(newline))
    }
    
    public static func image(_ image: UIImage, _ style: Style = .original(), newline: Newline = .none, action: Attribute) -> AttributedStringItem {
        return .init(string: nil, attributes: [action], image: image, view: UIView(), style: style, form: .image(newline))
    }
    
    // view
    public static func view(_ view: UIView, _ style: Style = .original(), newline: Newline = .none) -> AttributedStringItem {
        return .init(string: nil, attributes: [], image: UIImage(), view: view, style: style, form: .view(newline))
    }
    
    public static func view(_ view: UIView, _ style: Style = .original(), newline: Newline = .none, action: Attribute) -> AttributedStringItem {
        return .init(string: nil, attributes: [action], image: UIImage(), view: view, style: style, form: .view(newline))
    }
    
}

private var AttributesKey: Void?
extension NSAttributedString {
    public fileprivate(set) var attributes: [AttributedStringItem] {
        get {associated.get(&AttributesKey) ?? []}
        set {associated.set(copy: &AttributesKey, newValue, .nonatomic)}
    }
}

public struct AttributedString {
    public internal(set) var value: NSAttributedString
    public var length: Int {
        value.length
    }
    
    /// String
    
    public init(string value: String, _ attributes: Attribute...) {
        self.value = AttributedString(string: value, attributes).value
    }
    
    public init(string value: String, _ attributes: [Attribute] = []) {
        self.value = AttributedString(.string(value, attributes)).value
    }
    
    // attributedString
    internal init(_ value: NSAttributedString) {
        self.value = value
    }
    
    public init(_ value: NSAttributedString, _ attributes: Attribute...) {
        self.value = AttributedString.init(value, attributes).value
    }
    
    public init?(_ value: NSAttributedString?, _ attributes: Attribute...) {
        guard let value = value else { return nil }
        self.value = AttributedString(value, attributes).value
    }
    
    public init?(_ value: NSAttributedString?, _ attributes: [Attribute]) {
        guard let value = value else { return nil }
        self.value = AttributedString(value, attributes).value
    }
    
    public init(_ value: NSAttributedString, _ attributes: [Attribute]) {
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: value)
        
        // 合并action成数组之后的 attributes
        let mergedAttributes =  attributes.mergedAction()
        // 获取通用属性
        var validAttribute: [NSAttributedString.Key : Any] = [:]
        // 取最后添加相同的key的acttributes, 如.font(12), .font(30), 取.font(30)作为字体大小
        mergedAttributes.forEach { attribute in
            validAttribute.merge(attribute.attributes, uniquingKeysWith: { $1 })
        }
        
        mutableAttributedString.addAttributes(validAttribute, range: .init(location: 0, length: mutableAttributedString.length))
        self.value = mutableAttributedString
//        self.value.attributes = attributedStringItems
    }
    
    
    // attributedStringItems
    public init(_ attributedStringItems: AttributedStringItem...) {
        self.value = AttributedString.init(attributedStringItems).value
        self.value.attributes = attributedStringItems
    }
    
    public init(_ attributedStringItems: [AttributedStringItem]) {
        
        let mutableAttributedString = NSMutableAttributedString(string: "")
        attributedStringItems.forEach { (attribute: AttributedStringItem) in
            
            // 合并action成数组之后的 attributes
            let mergedAttributes =  attribute.attributes.mergedAction()
            // 获取通用属性
            var validAttribute: [NSAttributedString.Key : Any] = [:]
            // 取最后添加相同的key的acttributes, 如.font(12), .font(30), 取.font(30)作为字体大小
            mergedAttributes.forEach { attribute in
                validAttribute.merge(attribute.attributes, uniquingKeysWith: { $1 })
            }
            
            switch attribute.form {
            case .string:
                
                mutableAttributedString.append(.init(string: attribute.string!, attributes: validAttribute))
                
            case .image(let position):
                
                let attachment = AttributedStringItem.ImageAttachment.image(attribute.image, attribute.style)
                
                switch position {
                case .leading:
                    mutableAttributedString.append(NSAttributedString(string: "\n"))
                    
                    let emptyAtt = NSMutableAttributedString(string: "&")
                    emptyAtt.addAttributes([.font : UIFont.boldSystemFont(ofSize: 0.11), .backgroundColor : UIColor.red], range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(emptyAtt)
                    
                    let attachmentString = NSMutableAttributedString(attachment: attachment)
                    validAttribute.merge([.attachment : attachment]) { _, newValue in newValue }
                    attachmentString.setAttributes(validAttribute, range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(attachmentString)
                case .trailing:
                    
                    let emptyAtt = NSMutableAttributedString(string: "&")
                    emptyAtt.addAttributes([.font : UIFont.boldSystemFont(ofSize: 0.11), .backgroundColor : UIColor.red], range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(emptyAtt)
                    
                    let attachmentString = NSMutableAttributedString(attachment: attachment)
                    validAttribute.merge([.attachment : attachment]) { _, newValue in newValue }
                    attachmentString.setAttributes(validAttribute, range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(attachmentString)
                    
                    mutableAttributedString.append(NSAttributedString(string: "\n"))
                case .none:
               
                    let emptyAtt = NSMutableAttributedString(string: "&")
                    emptyAtt.addAttributes([.font : UIFont.boldSystemFont(ofSize: 0.11), .backgroundColor : UIColor.red], range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(emptyAtt)
                    
                    let attachmentString = NSMutableAttributedString(attachment: attachment)
                    validAttribute.merge([.attachment : attachment]) { _, newValue in newValue }
                    attachmentString.setAttributes(validAttribute, range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(attachmentString)
                    
                }
            case .view(let position):
                let attachment = AttributedStringItem.ViewAttachment.view(attribute.view, attribute.style)
                switch position {
                case .leading:
                    mutableAttributedString.append(NSAttributedString(string: "\n"))
                    
//                    let emptyAtt = NSMutableAttributedString(string: "*")
//                    emptyAtt.addAttributes([.font : UIFont.boldSystemFont(ofSize: 0.22), .backgroundColor : UIColor.blue], range: NSRange(location: 0, length: 1))
//                    mutableAttributedString.append(emptyAtt)
                    
                    let attachmentString = NSMutableAttributedString(attachment: attachment)
                    validAttribute.merge([.attachment : attachment]) { _, newValue in newValue }
                    attachmentString.setAttributes(validAttribute, range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(attachmentString)
                case .trailing:
                    
//                    let emptyAtt = NSMutableAttributedString(string: "*")
//                    emptyAtt.addAttributes([.font : UIFont.boldSystemFont(ofSize: 0.22), .backgroundColor : UIColor.blue], range: NSRange(location: 0, length: 1))
//                    mutableAttributedString.append(emptyAtt)
                    
                    let attachmentString = NSMutableAttributedString(attachment: attachment)
                    validAttribute.merge([.attachment : attachment]) { _, newValue in newValue }
                    attachmentString.setAttributes(validAttribute, range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(attachmentString)
                    
                    mutableAttributedString.append(NSAttributedString(string: "\n"))
                case .none:

                    let emptyAtt = NSMutableAttributedString(string: "*")
                    emptyAtt.addAttributes([.font : UIFont.boldSystemFont(ofSize: 0.22), .backgroundColor : UIColor.blue], range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(emptyAtt)
                    
                    
                    let attachmentString = NSMutableAttributedString(attachment: attachment)
                    validAttribute.merge([.attachment : attachment]) { _, newValue in newValue }
                    attachmentString.setAttributes(validAttribute, range: NSRange(location: 0, length: 1))
                    mutableAttributedString.append(attachmentString)
                }
            default: break
                
            }
        }
        
        self.value = mutableAttributedString
        self.value.attributes = attributedStringItems
    }
    
    
    public mutating func font(_ font: UIFont) -> Self {
        let att = NSMutableAttributedString(attributedString: self.value)
        att.addAttribute(.font, value: UIFont.systemFont(ofSize: 21), range: NSMakeRange(0, self.value.string.count))
        self.value = att
        return self
    }
}


//var  imageCallback1 =  CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (refCon) -> Void in
//       }, getAscent: { ( refCon) -> CGFloat in
//           return 300
////                               return attach.size.height  //返回高度
//       }, getDescent: { (refCon) -> CGFloat in
//           return 50  //返回底部距离
//       }) { (refCon) -> CGFloat in
////                               let attach = unsafeBitCast(refCon, to: AttributedStringItem.ViewAttachment.self)
////                               return attach.size.width  //返回宽度
//           return 100
//   }

//                    let urlRunDelegate  = CTRunDelegateCreate(&imageCallback1, &attachment)
//
//                    var emptyChar: UInt16 = 0xFFFC
//                    let emptyString = NSString.init(characters: &emptyChar, length: 1) as String
//                    let attachmentString = NSMutableAttributedString(string: emptyString)
//                    attachmentString.addAttribute(kCTRunDelegateAttributeName as NSAttributedString.Key, value: urlRunDelegate as Any, range: NSRange(location: 0, length: 1))


//                    attachmentString.beginEditing()å
//                    attachmentString.setAttributes([.attachment : attachment], range: NSRange(location: 0, length: 1))
//                    attachmentString.addAttributes([.foregroundColor : UIColor.red, .font : UIFont.size(9), .backgroundColor : UIColor.blue ], range: NSRange(location: 0, length: 1))
//                    mutableAttributedString.append(attachmentString)



extension AttributedString {
    
    @discardableResult
    public mutating func append(_ attributedString: AttributedString) -> Self {
        attributedString.value.attributes.forEach {attribute in
            value.attributes.append(attribute)
        }

        let attributedString = AttributedString(value.attributes)
        self.value = attributedString.value
        return self
    }
}


extension AttributedString: Equatable {
    
    public static func == (lhs: AttributedString, rhs: AttributedString) -> Bool {
        
        guard lhs.length == rhs.length else { return false }
        guard lhs.value.string == rhs.value.string else { return false }
        guard lhs.value.get(.init(location: 0, length: lhs.length)) == rhs.value.get(.init(location: 0, length: rhs.length)) else { return false }
        return true
    }
    
    
    /// 判断内容是否相等
    /// - Parameter other: 其他AttributedString
    /// - Returns: bool
    public func isContentEqual(to other: AttributedString?) -> Bool {
        guard let other = other else {
            return false
        }
        guard length == other.length else {
            return false
        }
        return value.string == other.value.string
    }
}

fileprivate extension Dictionary where Key == NSAttributedString.Key, Value == Any {
    
    static func == (lhs: [NSAttributedString.Key : Any], rhs: [NSAttributedString.Key : Any]) -> Bool {
        lhs.keys == rhs.keys ? NSDictionary(dictionary: lhs).isEqual(to: rhs) : false
    }
}

fileprivate extension Dictionary where Key == NSRange, Value == [NSAttributedString.Key : Any] {
    
    static func == (lhs: [NSRange : [NSAttributedString.Key : Any]], rhs: [NSRange : [NSAttributedString.Key : Any]]) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        // allSatisfy 所有的满足条件判断
        return zip(lhs, rhs).allSatisfy { (l, r) -> Bool in
            // key          value
            l.0 == r.0 && l.1 == r.1
        }
    }
}





