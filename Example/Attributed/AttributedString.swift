//
//  AttributedString.swift
//  AttributedString_Example
//
//  Created by maling on 2022/3/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit


public struct AttributeStringItem {

    public typealias Newline = AttributeStringItem.Form.Newline
    public typealias Style = Attachment.Style
    
    public enum Form {
        public  enum Newline {
            case not
            case leading
            case trailing
        }
        
        case none
        case string
        case image(Newline)
        case view(Newline)
    }
    
    let string: String
    let stringAttributes: [Attribute]
    let image: UIImage
    let view: UIView
    let style: Attachment.Style

    let form: Form
    
    // string
    public static func string(_ sting: String) -> AttributeStringItem {
        .string(sting, [])
    }
    
    public static func string(_ sting: String, _ stringAttributes: Attribute...) -> AttributeStringItem {
        .string(sting, stringAttributes)
    }
    
    public static func string(_ sting: String, _ stringAttributes: [Attribute]) -> AttributeStringItem {
        .init(string: sting, stringAttributes: stringAttributes, image: UIImage(), view: UIView(), style: .original(), form:.string)
    }
    
    // image
    public static func image(_ image: UIImage, _ style: Style = .original(), newline: Newline = .not) -> AttributeStringItem {
        return .init(string: "", stringAttributes: [], image: image, view: UIView(), style: style, form: .image(newline))
    }
    
    // view
    public static func view(_ view: UIView, _ style: Style = .original(), newline: Newline = .not) -> AttributeStringItem {
        return .init(string: "", stringAttributes: [], image: UIImage(), view: view, style: style, form: .view(newline))
    }
    
}

private var AttributesKey: Void?
extension NSMutableAttributedString {
    public fileprivate(set) var attributes: [AttributeStringItem] {
        get {associated.get(&AttributesKey) ?? []}
        set {associated.set(copy: &AttributesKey, newValue, .nonatomic)}
    }
}

public struct AttributedString {
    public internal(set) var value: NSMutableAttributedString
    public var length: Int {
        value.length
    }
    
    internal init(value: NSMutableAttributedString) {
        self.value = value
    }
    
    public init(_ attributes: AttributeStringItem...) {
        self.value = AttributedString.init(attributes).value
        self.value.attributes = attributes
    }
    
    public init(_ attributes: [AttributeStringItem]) {
        let mutableAttributedString = NSMutableAttributedString(string: "")
        attributes.forEach { (attribute: AttributeStringItem) in
            switch attribute.form {
            case .string:
                mutableAttributedString.append(.init(string: attribute.string, attributes: attribute.stringAttributes.attributesDictionary))
            case .image(let position):
                
                let attachment = AttributeStringItem.ImageAttachment.image(attribute.image, attribute.style)
                switch position {
                case .leading:
                    mutableAttributedString.append(NSMutableAttributedString(string: "\n"))
                    mutableAttributedString.append(NSAttributedString(attachment: attachment))
                case .trailing:
                    mutableAttributedString.append(NSAttributedString(attachment: attachment))
                    mutableAttributedString.append(NSMutableAttributedString(string: "\n"))
                case .not:
                    mutableAttributedString.append(NSAttributedString(attachment: attachment))
                }
            case .view(let position):
                let attachment = AttributeStringItem.ViewAttachment.view(attribute.view, attribute.style)
                switch position {
                case .leading:
                    mutableAttributedString.append(NSMutableAttributedString(string: "\n"))
                    mutableAttributedString.append(NSAttributedString(attachment: attachment))
                case .trailing:
                    mutableAttributedString.append(NSAttributedString(attachment: attachment))
                    mutableAttributedString.append(NSMutableAttributedString(string: "\n"))
                case .not:
                    mutableAttributedString.append(NSAttributedString(attachment: attachment))
                }
            default: break
                
            }
            
        }
        self.value = mutableAttributedString
        self.value.attributes = attributes
    }
    
    public func font(_ font: UIFont) -> Self {
        self.value.addAttribute(.font, value: UIFont.systemFont(ofSize: 21), range: NSMakeRange(0, self.value.string.count))
        return self
    }
}

extension AttributedString {
    
    @discardableResult
    public mutating func append(_ attributedString: AttributedString) -> Self {
        attributedString.value.attributes.forEach {attribute in
            value.attributes.append(attribute)
        }
        self = AttributedString(self.value.attributes)
        return self
    }
}



