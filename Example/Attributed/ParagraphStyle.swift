//
//  ParagraphStyle.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/2.
//  Copyright © 2022 CocoaPods. All rights reserved.
//


import UIKit

extension AttributeStringItem.Attribute {
    /// 段落
    /// - Parameter value: 段落样式
    /// - Returns: 属性
    public static func paragraph(_ value: ParagraphStyle...) -> Self {
        return .init(attributes: value.isEmpty ? [:] : [.paragraphStyle: ParagraphStyle.get(value)])
    }
    
    /// 段落
    /// - Parameter value: 段落样式
    /// - Returns: 属性
    public static func paragraph(_ value: [ParagraphStyle]) -> Self {
        return .init(attributes: value.isEmpty ? [:] : [.paragraphStyle: ParagraphStyle.get(value)])
    }
}

extension AttributeStringItem.Attribute {
    
    public struct ParagraphStyle {
        
        fileprivate enum Key {
            case lineSpacing                // CGFloat
            case paragraphSpacing           // CGFloat
            case alignment                  // NSTextAlignment
            case firstLineHeadIndent        // CGFloat
            case headIndent                 // CGFloat
            case tailIndent                 // CGFloat
            case lineBreakMode              // NSLineBreakMode
            case minimumLineHeight          // CGFloat
            case maximumLineHeight          // CGFloat
            case baseWritingDirection       // NSWritingDirection
            case lineHeightMultiple         // CGFloat
            case paragraphSpacingBefore     // CGFloat
            case hyphenationFactor          // Float
            case tabStops                   // [NSTextTab]
            case defaultTabInterval         // CGFloat
            case allowsDefaultTighteningForTruncation   // Bool
        }
        
        fileprivate let style: [Key: Any]
        
        fileprivate static func get(_ attributes: [ParagraphStyle]) -> NSParagraphStyle {
            var temp: [Key: Any] = [:]
            attributes.forEach { temp.merge($0.style, uniquingKeysWith: { $1 }) }
            
            func fetch<Value>(_ key: Key, completion: (Value)->()) {
                guard let value = temp[key] as? Value else { return }
                completion(value)
            }
            
            let paragraph = NSMutableParagraphStyle()
            fetch(.lineSpacing) { paragraph.lineSpacing = $0 }
            fetch(.paragraphSpacing) { paragraph.paragraphSpacing = $0 }
            fetch(.alignment) { paragraph.alignment = $0 }
            fetch(.firstLineHeadIndent) { paragraph.firstLineHeadIndent = $0 }
            fetch(.headIndent) { paragraph.headIndent = $0 }
            fetch(.tailIndent) { paragraph.tailIndent = $0 }
            fetch(.lineBreakMode) { paragraph.lineBreakMode = $0 }
            fetch(.minimumLineHeight) { paragraph.minimumLineHeight = $0 }
            fetch(.maximumLineHeight) { paragraph.maximumLineHeight = $0 }
            fetch(.baseWritingDirection) { paragraph.baseWritingDirection = $0 }
            fetch(.lineHeightMultiple) { paragraph.lineHeightMultiple = $0 }
            fetch(.paragraphSpacingBefore) { paragraph.paragraphSpacingBefore = $0 }
            fetch(.hyphenationFactor) { paragraph.hyphenationFactor = $0 }
            fetch(.tabStops) { paragraph.tabStops = $0 }
            fetch(.defaultTabInterval) { paragraph.defaultTabInterval = $0 }
            fetch(.allowsDefaultTighteningForTruncation) { paragraph.allowsDefaultTighteningForTruncation = $0 }
            return paragraph
        }
    }
}

extension AttributeStringItem.Attribute.ParagraphStyle {
    
    
    /// 行间距
    public static func lineSpacing(_ value: CGFloat) -> Self {
        return .init(style: [.lineSpacing: value])
    }
    
    /// 段与段之间的间距
    public static func paragraphSpacing(_ value: CGFloat) -> Self {
        return .init(style: [.paragraphSpacing: value])
    }
    
    /// （两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
    public static func alignment(_ value: NSTextAlignment) -> Self {
        return .init(style: [.alignment: value])
    }
    
    /// 首行缩进( 段落第一行的缩进。)
    public static func firstLineHeadIndent(_ value: CGFloat) -> Self {
        return .init(style: [.firstLineHeadIndent: value])
    }
    
    /// 除第一行外，段落行的缩进。
    public static func headIndent(_ value: CGFloat) -> Self {
        return .init(style: [.headIndent: value])
    }
    
    /// 段落的尾随缩进
    public static func tailIndent(_ value: CGFloat) -> Self {
        return .init(style: [.tailIndent: value])
    }
     
    /// 结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
    public static func lineBreakMode(_ value: NSLineBreakMode) -> Self {
        return .init(style: [.lineBreakMode: value])
    }
    
    /// 段落最小行高
    public static func minimumLineHeight(_ value: CGFloat) -> Self {
        return .init(style: [.minimumLineHeight: value])
    }
    
    /// 段落最大行高
    public static func maximumLineHeight(_ value: CGFloat) -> Self {
        return .init(style: [.maximumLineHeight: value])
    }
    
    /// 书写方向
    public static func baseWritingDirection(_ value: NSWritingDirection) -> Self {
        return .init(style: [.baseWritingDirection: value])
    }
    
    /// 行高乘数(系数)
    public static func lineHeightMultiple(_ value: CGFloat) -> Self {
        return .init(style: [.lineHeightMultiple: value])
    }
    
    /// 段落顶部与其文本内容开头之间的距离  [段首行空白空间]
    public static func paragraphSpacingBefore(_ value: CGFloat) -> Self {
        return .init(style: [.paragraphSpacingBefore: value])
    }
    
    /// 连字属性 在iOS，唯一支持的值分别为0和1  --  该段落的连字符阈值。
    public static func hyphenationFactor(_ value: Float) -> Self {
        return .init(style: [.hyphenationFactor: value])
    }
    
    
    /// 指定标签页信息 - 表示段落选项卡停止的文本选项卡对象。 [ NSTextTab  段落中的选项卡]
    public static func tabStops(_ value: [NSTextTab]) -> Self {
        return .init(style: [.tabStops: value])
    }
    
    /// 指定标签页信息 - 用作文档默认选项卡间距的数字。
    public static func defaultTabInterval(_ value: CGFloat) -> Self {
        return .init(style: [.defaultTabInterval: value])
    }
    
    // 指示系统在截断文本之前是否拧紧字符间距
    public static func allowsDefaultTighteningForTruncation(_ value: Bool) -> Self {
        return .init(style: [.allowsDefaultTighteningForTruncation: value])
    }
}
