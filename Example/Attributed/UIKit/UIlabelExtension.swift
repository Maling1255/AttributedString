//
//  UIlabelExtension.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

private var UIGestureRecognizerKey: Void?
private var UILabelTouchedKey: Void?
private var UILabelActionsKey: Void?
private var UILabelObserversKey: Void?
private var UILabelObservationsKey: Void?
private var UILabelAttachmentViewsKey: Void?

extension UILabel: AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UILabel {
    
    public var string: AttributedString? {
        get { base.touched?.0 ?? .init(base.attributedText) }
        set {
            // 判断当前是否触摸状态, 内部是否发生变化
            if var touched = base.touched, touched.0.isContentEqual(to: newValue) {
                guard let string = newValue else {
                    base.touched = nil
                    return
                }
                
                // 将当前的高亮属性覆盖到新的文本中, 替换显示的文本
                let temp = NSMutableAttributedString(attributedString: string.value)
                let ranges = touched.1.keys.sorted(by: { $0.length > $1.length })
                for range in ranges {
                    base.attributedText?.get(range).forEach{ (range, attributes) in
                        temp.setAttributes(attributes, range: range)
                    }
                }
                base.attributedText = temp
                
                touched.0 = string
                base.touched = touched
                
                
                
            } else {
                base.touched = nil
                base.attributedText = newValue?.value
                
            }
            
            setupViewAttachments(newValue)
        }
    }
}

extension AttributedStringWrapper where Base: UILabel {
    
    private(set) var gestures: [UIGestureRecognizer] {
        get { base.associated.get(&UIGestureRecognizerKey) ?? [] }
        set { base.associated.set(retain: &UIGestureRecognizerKey, newValue) }
    }
    
    private(set) var observations: [String: NSKeyValueObservation] {
        get { base.associated.get(&UILabelObservationsKey) ?? [:] }
        set { base.associated.set(retain: &UILabelObservationsKey, newValue) }
    }
    
    /// 设置自定义视图
    private func setupViewAttachments(_ string: AttributedString?) {
        guard let string = string else {
            return
        }
            
        // 清理所有的监听
        observations = [:]
        
        // 刷新的时候清理已经添加的自定义视图, 为了后面重新添加
        for view in base.subviews where view is AttachmentView {
            view.removeFromSuperview()
        }
        base.attachmentViews = [:]
        
        // 从attributedString获取自定义附件视图
        let attachments: [NSRange : AttributedStringItem.ViewAttachment] = string.value.get(.attachment)
        guard !attachments.isEmpty else {
            return
        }
        
        // 添加自定义的附件子视图
        attachments.forEach { (range, attachment) in
            let view = AttachmentView(attachment.view, with: attachment.style)
            
            base.addSubview(view)
            base.attachmentViews[range] = view
        }
        
        print("intrinsicContentSize:", base.intrinsicContentSize)
        
        // 刷新布局
//        base.layout()
        
    }
}

// MARK: 处理 attachmentViews
fileprivate extension UILabel {
    
    /// 附件视图
    var attachmentViews: [NSRange: AttachmentView] {
        get { associated.get(&UILabelAttachmentViewsKey) ?? [:] }
        set { associated.set(retain: &UILabelAttachmentViewsKey, newValue) }
    }
    
    /// 布局
    /// - Parameter isVisible: 是否仅可视范围
//    func layout(_ isVisible: Bool = false) {
//        guard !attachmentViews.isEmpty else {
//            return
//        }
//
//        // range : 自定义视图所在的位置
//        func update(_ range: NSRange, _ view: AttachmentView) {
//            view.isHidden = false
//            // glyphRange 获取图像字形(即自定义视图view)范围
//            let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
//            // 获取自定义view边界大小
//            var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
//            rect.origin.x += textContainerInset.left
//            rect.origin.y += textContainerInset.top
//            // 🔥设置view位置
//            view.frame = rect
//        }
//
//        if isVisible {
//            // 获取可见范围
//            let offset = CGPoint(contentOffset.x - textContainerInset.left, contentOffset.y - textContainerInset.top)
//            let visible = layoutManager.glyphRange(forBoundingRect: .init(offset, bounds.size), in: textContainer)
//            // 更新可见范围内的视图位置 同时隐藏可见范围外的视图
//            for (range, view) in attachmentViews {
//                if visible.contains(range.location) {
//                    // 确保布局
//                    layoutManager.ensureLayout(forCharacterRange: range)
//                    // 更新视图
//                    update(range, view)
//
//                } else {
//                    view.isHidden = true
//                }
//            }
//
//        } else {
//            // 完成布局刷新
//            layoutIfNeeded()
//            // 废弃当前布局 重新计算
//            layoutManager.invalidateLayout(
//                forCharacterRange: .init(location: 0, length: textStorage.length),
//                actualCharacterRange: nil
//            )
//            // 确保布局
//            layoutManager.ensureLayout(for: textContainer)
//            // 更新全部自定义视图位置
//            attachmentViews.forEach(update)
//        }
//    }
}

extension UILabel {
    
    fileprivate typealias Action = AttributedString.Action
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Highlight = AttributedString.Action.Highlight
    fileprivate typealias Observers = [Checking: [Checking.Action]]
    
    /// 当前触摸
    fileprivate var touched: (AttributedString, [NSRange: [Action]])? {
        get { associated.get(&UILabelTouchedKey) }
        set { associated.set(retain: &UILabelTouchedKey, newValue) }
    }
}


extension AttributedStringWrapper where Base: UILabel {
    
    public typealias ParagraphStyle = AttributedStringItem.Attribute.ParagraphStyle
    
    /// 行间距
    @discardableResult
    public func lineSpacing(_ value: CGFloat) -> Self {
        setParagraphStyle(.lineSpacing(value))
        return self
    }
    
    /// 段与段之间的间距
    @discardableResult
    public func paragraphSpacing(_ value: CGFloat) -> Self {
        setParagraphStyle(.paragraphSpacing(value))
        return self
    }
    
    /// （两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
    @discardableResult
    public func alignment(_ value: NSTextAlignment) -> Self {
        setParagraphStyle(.alignment(value))
        return self
    }
    
    /// 首行缩进( 段落第一行的缩进。)
    @discardableResult
    public func firstLineHeadIndent(_ value: CGFloat) -> Self {
        setParagraphStyle(.firstLineHeadIndent(value))
        return self
    }
    
    /// 除第一行外，段落行的缩进。
    @discardableResult
    public func headIndent(_ value: CGFloat) -> Self {
        setParagraphStyle(.headIndent(value))
        return self
    }
    
    /// 段落的尾随缩进
    @discardableResult
    public func tailIndent(_ value: CGFloat) -> Self {
        setParagraphStyle(.tailIndent(value))
        return self
    }
    
    /// 结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
    @discardableResult
    public func lineBreakMode(_ value: NSLineBreakMode) -> Self {
        setParagraphStyle(.lineBreakMode(value))
        return self
    }
    
    /// 段落最小行高
    @discardableResult
    public func minimumLineHeight(_ value: CGFloat) -> Self {
        setParagraphStyle(.minimumLineHeight(value))
        return self
    }
    
    /// 段落最大行高
    @discardableResult
    public func maximumLineHeight(_ value: CGFloat) -> Self {
        setParagraphStyle(.maximumLineHeight(value))
        return self
    }
    
    /// 书写方向
    @discardableResult
    public func baseWritingDirection(_ value: NSWritingDirection) -> Self {
        setParagraphStyle(.baseWritingDirection(value))
        return self
    }
    
    /// 行高乘数(系数)
    @discardableResult
    public func lineHeightMultiple(_ value: CGFloat) -> Self {
        setParagraphStyle(.lineHeightMultiple(value))
        return self
    }
    
    /// 段落顶部与其文本内容开头之间的距离  [段首行空白空间]
    @discardableResult
    public func paragraphSpacingBefore(_ value: CGFloat) -> Self {
        setParagraphStyle(.paragraphSpacingBefore(value))
        return self
    }
    
    /// 连字属性 在iOS，唯一支持的值分别为0和1  --  该段落的连字符阈值。
    @discardableResult
    public func hyphenationFactor(_ value: Float) -> Self {
        setParagraphStyle(.hyphenationFactor(value))
        return self
    }
    
    /// 指定标签页信息 - 表示段落选项卡停止的文本选项卡对象。 [ NSTextTab  段落中的选项卡]
    @discardableResult
    public func tabStops(_ value: [NSTextTab]) -> Self {
        setParagraphStyle(.tabStops(value))
        return self
    }
    
    /// 指定标签页信息 - 用作文档默认选项卡间距的数字。
    @discardableResult
    public func defaultTabInterval(_ value: CGFloat) -> Self {
        setParagraphStyle(.defaultTabInterval(value))
        return self
    }
    
    /// 截断紧缩文本(就是自动缩小后的文本)  字符
    @discardableResult
    public func allowsDefaultTighteningForTruncation(_ value: Bool) -> Self {
        setParagraphStyle(.allowsDefaultTighteningForTruncation(value))
        return self
    }
    
    
    @discardableResult
    private func setParagraphStyle(_ value: ParagraphStyle) -> NSAttributedString? {
        if let attributedString = string?.value {
            
            let rangeStyles: [NSRange : NSParagraphStyle] = attributedString.get(.paragraphStyle)
            if (rangeStyles.count != 0) {
                for style in rangeStyles {
                    let paragraphStyle = value.setParagraphStyle(style.value)
                    let att = NSMutableAttributedString(attributedString: attributedString)
                    att.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
                    base.attributedText = att
                    return att
                }
            } else {
                let paragraphStyle = value.setParagraphStyle(nil)
                let att = NSMutableAttributedString(attributedString: attributedString)
                att.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
                base.attributedText = att
                return att
            }
        }
        return nil
    }
}

extension AttributedStringWrapper where Base: UILabel {
    
    /// 字号
    @discardableResult
    public func font(_ value: UIFont) -> Self {
        base.font = value
        return self
    }
    
    /// 字号
    @discardableResult
    public func font(_ value: UIFont, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.font, value, range: range)
        return self
    }
    
    /// Label 文本颜色
    @discardableResult
    public func textColor(_ value: UIColor) -> Self {
        base.textColor = value
        return self
    }
    
    /// 文本颜色
    @discardableResult
    public func textColor(_ value: UIColor, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.foregroundColor, value, range: range)
        return self
    }
    
    /// label 背景色
    @discardableResult
    public func backgroundColor(_ value: UIColor) -> Self {
        base.backgroundColor = value
        return self
    }
    
    /// 文本 背景色
    @discardableResult
    public func backgroundColor(_ value: UIColor, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.backgroundColor, value, range: range)
        return self
    }
    
    /// 多行显示, 0表示自动换行
    @discardableResult
    public func numberOfLines(_ value: Int) -> Self {
        base.numberOfLines = value
        return self
    }
    
    /// 文本对齐方式
    @discardableResult
    public func textAlignment(_ value: NSTextAlignment = .center) -> Self {
        base.textAlignment = value
        return self
    }
    
    /// 文本高亮颜色
    public func highlightedTextColor(_ value: UIColor = .clear, isHighlighted: Bool = false) -> Self {
        base.isHighlighted = isHighlighted
        base.highlightedTextColor = value
        return self
    }
    
    /// 字体缩小比例
    @discardableResult
    public func minimumScaleFactor(_ value: CGFloat) -> Self {
        base.adjustsFontSizeToFitWidth = true
        base.minimumScaleFactor = value
        return self
    }
    
    /// 默认NO,如果文本的长度超出了label的宽度，则缩小文本的字体大小来让文本完全显示
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        base.adjustsFontSizeToFitWidth = value
        return self
    }
    
    /// 是否允许用户交互
    @discardableResult
    public func userInteractionEnabled(_ value: Bool) -> Self {
        base.isUserInteractionEnabled = value
        return self
    }
    
    /// 支持基于约束的布局（自动布局），如果非零，则在确定多行标签的
    @discardableResult
    public func preferredMaxLayoutWidth(_ value: CGFloat) -> Self {
        base.preferredMaxLayoutWidth = value
        return self
    }
    
    /// 当Label太小而无法显示所有内容时是否显示`展开`文本。默认为没有。
    @discardableResult
    public func showsExpansionTextWhenTruncated(_ value: Bool) -> Self {
        base.showsExpansionTextWhenTruncated = value
        return self
    }
    
    
    /// 下划线
    @discardableResult
    public func underline(_ style: NSUnderlineStyle, _ color: UIColor? = nil, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.underlineStyle, style.rawValue, range: range)
        addAttribute(.underlineColor, color as Any, range: range)
        return self
    }
    
    /// 连体字
    @discardableResult
    public func ligature(_ value: Bool, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.ligature, value, range: range)
        return self
    }
    
    /// 字间距
    @discardableResult
    public func kern(_ value: CGFloat, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.kern, value, range: range)
        return self
    }
    
    /// 删除线
    @discardableResult
    public func strikethrough(_ style: NSUnderlineStyle, color: UIColor? = nil, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.strikethroughStyle, style.rawValue, range: range)
        addAttribute(.strikethroughColor, color as Any, range: range)
        return self
    }
    
    /// 描边
    @discardableResult
    public func stroke(_ width: CGFloat = 0, color: UIColor? = nil, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.strokeWidth, width, range: range)
        addAttribute(.strokeColor, color as Any, range: range)
        return self
    }
    
    /// 阴影
    @discardableResult
    public func shadow(offset: CGSize = .zero, blurRadius: CGFloat = 0, color: UIColor? = nil, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }

        let shadow = NSShadow()
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowColor = {
            if let shadowColor = color {
                return shadowColor
            }
            return UIColor.black.withAlphaComponent(0.3333)
        }()
        addAttribute(.shadow, shadow, range: range)
        return self
    }
    
    /// 基准线
    @discardableResult
    public func baselineOffset(_ value: CGFloat, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.baselineOffset, value, range: range)
        return self
    }
    
    @discardableResult
    public func baselineAdjustment(_ value: UIBaselineAdjustment) -> Self {
        // 如果adjustsFontSizeToFitWidth属性设置为YES，这个属性就来控制文本基线的行为
        base.baselineAdjustment = value
        return self
    }
    
    
    /// 斜体字
    @discardableResult
    public func obliqueness(_ value: CGFloat = 0.1, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.obliqueness, value, range: range)
        return self
    }
    
    /// 拉伸 / 压缩
    @discardableResult
    public func expansion(_ value: CGFloat = 0.0, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.expansion, value, range: range)
        return self
    }
    
    /// 书写方向
    @discardableResult
    public func writingDirection(_ value: WritingDirection = .LTR, range: NSRange = NSDefaultRange) -> Self {
        var range = range
        if range == NSDefaultRange { range = NSMakeRange(0, textLength()) }
        addAttribute(.writingDirection, value.value, range: range)
        return self
    }
    
    @discardableResult
    public func addAttribute(_ key: NSAttributedString.Key, _ value: Any, range: NSRange) -> Self {
        
        if let attributedString = string?.value {
            let att = NSMutableAttributedString(attributedString: attributedString)
            att.addAttribute(key, value: value, range: range)
            base.attributedText = att
        }
        return self
    }
    
     public func textLength() -> Int {
        return base.text?.count ?? 0
     }
}

public let NSDefaultRange = NSMakeRange(0, 0)

extension AttributedStringWrapper where Base: UILabel {
    
    public enum WritingDirection {
        case LTR
        case RTL
        
        fileprivate var value: [Int] {
            switch self {
            case .LTR:  return [NSWritingDirection.leftToRight.rawValue | NSWritingDirectionFormatType.override.rawValue]
            case .RTL:  return [NSWritingDirection.rightToLeft.rawValue | NSWritingDirectionFormatType.override.rawValue]
            }
        }
    }
}
