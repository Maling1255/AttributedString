//
//  UIlabelExtension.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import CoreText

private var UIGestureRecognizerKey: Void?
private var UILabelTouchedKey: Void?
private var UILabelActionsKey: Void?
private var UILabelObserversKey: Void?
private var UILabelObservationsKey: Void?
private var UILabelAttachmentViewsKey: Void?

private var UILabelCTFrameKey: Void?

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
                
                let attributedStr = newValue?.value
                
                base.attributedText = attributedStr
                
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
//        guard !attachments.isEmpty else {
//            return
//        }
        
        // 添加自定义的附件子视图
        attachments.forEach { (range, attachment) in
//            let view = AttachmentView(attachment.view, with: attachment.style)
            let view = AttachmentView(attachment)
            print("attachment.size:", attachment.size)
            
            base.addSubview(view)
            base.attachmentViews[range] = view
        }
        
//        print("intrinsicContentSize:", base.intrinsicContentSize)
        
        // 刷新布局
        base.layout()
        
        // 设置视图相关监听 同步更新布局
//        observations["bounds"] = base.observe(\.bounds, options: [.new, .old]) { (object, changed) in
//            object.layout(true)
//        }
//        observations["frame"] = base.observe(\.frame, options: [.new, .old]) { (object, changed) in
//            guard changed.newValue?.size != changed.oldValue?.size else { return }
//            object.layout()
//        }
        
    }
}

// MARK: 处理 attachmentViews
fileprivate extension UILabel {
    
    /// 附件视图
    var attachmentViews: [NSRange: AttachmentView] {
        get { associated.get(&UILabelAttachmentViewsKey) ?? [:] }
        set { associated.set(retain: &UILabelAttachmentViewsKey, newValue) }
    }
    
    /// CTFrame
    var ctFrame: CTFrame? {
        get { associated.get(&UILabelCTFrameKey) }
        set { associated.set(retain: &UILabelCTFrameKey, newValue) }
    }
    
    func layout(_ isVisible: Bool = false) {
//        guard !attachmentViews.isEmpty else {
//            return
//        }

//
//        self.setNeedsDisplay()
        
        
//        let context = UIGraphicsGetCurrentContext()
//
//        // 2 转换坐标
//        context?.textMatrix = .identity
//        context?.translateBy(x: 0, y: self.bounds.size.height)
//        context?.scaleBy(x: 1.0, y: -1.0)
        
        
        
        let attributedString = attributedText!
        // 必须写上, 调整大小
        
        sizeToFit()
//        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let ctframe: CTFrame!
        if self.ctFrame == nil {
            let attributedString = attributedText!
//            let path = UIBezierPath(rect: CGRect(0, 0, 384, 120.5))
//            let path = UIBezierPath(rect: CGRect(0, 0, 384, self.bounds.size.height))
            let path = UIBezierPath(rect: self.bounds)
            print("self.bounds: \(self.bounds)")
            
//            let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
            
            let typesetter = CTTypesetterCreateWithAttributedString(attributedString)
            let framesetter = CTFramesetterCreateWithTypesetter(typesetter)
            
            let frameAttrs = [kCTFramePathFillRuleAttributeName : CTFramePathFillRule.windingNumber.rawValue] as CFDictionary
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path.cgPath, nil)
            ctframe = frame
            self.ctFrame = frame
        } else {
            ctframe = self.ctFrame
        }
    
        
        let ctLines = CTFrameGetLines(ctframe) as NSArray
        
        print(ctLines)
        let lineCount = CFArrayGetCount(ctLines)
        // 3.获得每一行的origin, CoreText的origin是在字形的baseLine处的, [ 获取每行的坐标 ]
        var lineOrigins = [CGPoint](repeating: CGPoint.zero, count: lineCount)
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &lineOrigins)
 
        
        var lineY: CGFloat = 0;
        for i in 0..<lineCount {
//            let line = CFArrayGetValueAtIndex(lines, i)
//            let ctLine = ctLines[i] as! CTLine
            let ctLine = unsafeBitCast(CFArrayGetValueAtIndex(ctLines, i), to: CTLine.self)
            let ctRuns = CTLineGetGlyphRuns(ctLine) as NSArray
            let runCount = CFArrayGetCount(ctRuns)
            
            var lineAscent: CGFloat = 0.0//上缘线
            var lineDescent: CGFloat = 0.0//下缘线       
            var lineLeading: CGFloat = 0.0// 行底部留白
            let lineOrigin = lineOrigins[i];
            
            //获取行的字形参数
            CTLineGetTypographicBounds(ctLine, &lineAscent, &lineDescent, &lineLeading);
//            print("lineAscent:\(lineAscent),lineDescent:\(lineDescent), lineLeading: \(lineLeading)")
            
            // 行高
            let lineHeight = lineAscent + lineDescent + lineLeading
            let lineBottomY = lineOrigin.y - lineDescent

            guard CFArrayGetCount(ctRuns) > 0 else {
                continue
            }
            
            
            
            var lastAttHeight: CGFloat = 0
            var hasNewLine: Bool = true
            
            // 遍历 找到attachment     
            for j in 0..<runCount {
                let ctRun = unsafeBitCast(CFArrayGetValueAtIndex(ctRuns, j), to: CTRun.self)
                let runAttributeds = CTRunGetAttributes(ctRun) as NSDictionary
                
                
                var runAscent: CGFloat = 0//此CTRun上缘线
                var runDescent: CGFloat = 0//此CTRun下缘线
                var leading: CGFloat = 0
                
                let lineOrigin = lineOrigins[i];//此行起点
                
                var runRect: CGRect = CGRect()
                //获取此CTRun的上缘线，下缘线,并由此获取CTRun的宽度
                runRect.size.width = CTRunGetTypographicBounds(ctRun, CFRangeMake(0, 0), &runAscent, &runDescent, &leading)
                runRect.size.height = runAscent + runDescent
                runRect.origin.x = lineOrigin.x + CTLineGetOffsetForStringIndex(ctLine, CTRunGetStringRange(ctRun).location, nil)
                runRect.origin.y = lineBottomY
                
                
                if let view = runAttributeds[NSAttributedString.Key.attachment], view is AttributedStringItem.ViewAttachment {
                    for (_, containView) in attachmentViews {
                        if (view as! AttributedStringItem.ViewAttachment).view == containView.view {
                            lastAttHeight = containView.bounds.size.height
                        }
                    }
                } else {
                    
                    if hasNewLine {
                        if lastAttHeight > 0 {
                            lineY += lastAttHeight
                            
                            hasNewLine = false
                        } else {
                            lineY += runRect.size.height
                            
                            hasNewLine = false
                        }
                    }
                }
                
                
                
//                print(ctRun)
                print("runRect:", runRect, "--", runAscent, "--", runDescent, "--", leading)
                if let view = runAttributeds[NSAttributedString.Key.attachment], view is AttributedStringItem.ViewAttachment {
                    for (_, containView) in attachmentViews {
                        if (view as! AttributedStringItem.ViewAttachment).view == containView.view {
//                            containView.frame = runRect
                            
                            let size = containView.bounds.size
                            containView.frame = CGRect(runRect.origin.x,
//                                                       self.bounds.size.height - runRect.origin.y - runRect.size.height - leading,
//                                                       self.bounds.size.height -  254.240234375,
//                                                       runRect.origin.y + runRect.size.height,
                                                       // 25.060546875
                                                       lineY,
                                                       size.width,
                                                       size.height)
                            print("😁containView.frame: ", containView.frame, "view.hieght: \(self.bounds.size.height)")
                            continue
                        }
                    }
                }
            }
            
            print("\n ---------------- line --------------  \n")
        }
            
                 
            }
            

    
//    func layout(_ isVisible: Bool = false) {
//        guard !attachmentViews.isEmpty else {
//            return
//        }
//
////
////        self.setNeedsDisplay()
//
//
//        let context = UIGraphicsGetCurrentContext()
//
//        // 2 转换坐标
//        context?.textMatrix = .identity
//        context?.translateBy(x: 0, y: self.bounds.size.height)
//        context?.scaleBy(x: 1.0, y: -1.0)
//
//
//
//        let attributedString = attributedText!
//        // 必须写上, 调整大小
//        sizeToFit()
//
//        let ctframe: CTFrame!
//        if self.ctFrame == nil {
//            let attributedString = attributedText!
//            let path = UIBezierPath(rect: CGRect(0, 0, 384, 120.5))
////            let path = UIBezierPath(rect: CGRect(0, 0, 384, self.bounds.size.height))
////            let path = UIBezierPath(rect: self.bounds)
//            print("self.bounds: \(self.bounds)")
//
//
//            let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
//            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedString.length), path.cgPath, nil)
//            ctframe = frame
//            self.ctFrame = frame
//        } else {
//            ctframe = self.ctFrame
//        }
////        CTFrameDraw(frame, context)
//
//
//        let ctLines = CTFrameGetLines(ctframe) as NSArray
//        let lineCount = CFArrayGetCount(ctLines)
//        // 3.获得每一行的origin, CoreText的origin是在字形的baseLine处的, [ 获取每行的坐标 ]
//        var lineOrigins = [CGPoint](repeating: CGPoint.zero, count: lineCount)
//        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &lineOrigins)
////        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, lineCount), &lineOrigins)
//
//        for i in 0..<lineCount {
////            let line = CFArrayGetValueAtIndex(lines, i)
//            let ctLine: CTLine = ctLines[i] as! CTLine
//            var lineAscent: CGFloat = 0.0//上缘线
//            var lineDescent: CGFloat = 0.0//下缘线
//            var lineLeading: CGFloat = 0.0// 行底部留白
//            //获取行的字形参数
//            CTLineGetTypographicBounds(ctLine, &lineAscent, &lineDescent, &lineLeading);
////            print("lineAscent:\(lineAscent),lineDescent:\(lineDescent), lineLeading: \(lineLeading)")
//
//            //获取此行中每个CTRun
//            let ctRuns = CTLineGetGlyphRuns(ctLine) as NSArray
//            guard CFArrayGetCount(ctRuns) > 0 else {
//                continue
//            }
//
//            let runsCount = CFArrayGetCount(ctRuns)
//            for j in 0 ..< runsCount  {
//                var runAscent: CGFloat = 0//此CTRun上缘线
//                var runDescent: CGFloat = 0//此CTRun下缘线
//                let lineOrigin = lineOrigins[i];//此行起点
//
//
////                let run = CFArrayGetValueAtIndex(runs, j);//获取此CTRun
//                let ctRun: CTRun = ctRuns[j] as! CTRun //获取此CTRun
//                let attributes: NSDictionary = CTRunGetAttributes(ctRun) as NSDictionary;
////                print(attributes)
//
//                var leading: CGFloat = 0
//                var runRect: CGRect = CGRect()
//                //获取此CTRun的上缘线，下缘线,并由此获取CTRun和宽度
//                runRect.size.width = CTRunGetTypographicBounds(ctRun, CFRangeMake(0, 0), &runAscent, &runDescent, &leading);
//
//                //CTRun的X坐标
//                let runOrgX = lineOrigin.x + CTLineGetOffsetForStringIndex(ctLine, CTRunGetStringRange(ctRun).location, nil);
//                runRect = CGRect(runOrgX, lineOrigin.y-runDescent, runRect.size.width, runAscent + runDescent)
//
//
////                let _size = sizeForText(mutableAttrStr: attributedString)
////                let lineHeight = _size.height/CGFloat(lineCount)
////                print("1>>>> \(runAscent), \(runDescent), \(lineOrigin), \(_size), \(lineHeight), \(runRect)")
//                print("1>>>> \(runAscent), \(runDescent), \(lineOrigin)")
//
//
    
    
    
//                if let view = attributes[NSAttributedString.Key.attachment], view is AttributedStringItem.ViewAttachment {
////                    print("NSTextAttachment  ",view as! NSTextAttachment)
//
//                    for (_, containView) in attachmentViews {
//
//                        // 🔥设置view位置
//                        print("开始布局View:", containView.viewAttachment.size)
//
////                        let size = containView.viewAttachment.size
//
//                        let size = containView.bounds.size
//
////                        print(">>", runRect.origin.x, lineOrigin.x, lineOrigin.y - runDescent, size.width, size.height)
//
//                        // 75.5 差距是48
////                        containView.frame = CGRect(runRect.origin.x + lineOrigin.x, 75.5, size.width, size.height)
//
//                        containView.frame = CGRect(runRect.origin.x + lineOrigin.x, self.bounds.size.height - size.height, size.width, size.height)
//
//                        print("...", containView.frame)
//                    }
//
//                }
//
//
//
//
////                NSString *imgName = [attributes objectForKey:kImgName];
////
////                if (imgName) {
////                    UIImage *image = [UIImage imageNamed:imgName];
////                    if(image){
////                        CGRect imageRect ;
////                        imageRect.size = image.size;
////                        imageRect.origin.x = runRect.origin.x + lineOrigin.x;
////                        imageRect.origin.y = lineOrigin.y;
////                        CGContextDrawImage(context, imageRect, image.CGImage);
////                    }
////                }
//            }
//            print("\n\n")
//        }
//
//
//        print(self.sizeThatFits(.zero))
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
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
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
