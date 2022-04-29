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
private var UILabelImageAttachmentViewsKey: Void?

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
            setupActions(newValue)
            setupGestureRecognizers()
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
    
    private func setupActions(_ string: AttributedString?) {
        // 清理原有的actions
        
    }
    
    private func setupGestureRecognizers() {
        
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
        var attachmentViews = [(NSRange, AttachmentView)]()
        var imageAttachments = [(NSRange, AttributedStringItem.ImageAttachment)]()
        
        // image 附件视图
        let imageAttachmentInfo: [NSRange: AttributedStringItem.ImageAttachment] = string.value.get(.attachment)
        let tempImageRanges = imageAttachmentInfo.keys.sorted{ $0.location < $1.location }
        for range in tempImageRanges {
            if let attachment = imageAttachmentInfo[range] {
                imageAttachments.append((range, attachment))
            }
        }
        base.imageAttachments = imageAttachments.reversed()

        // view 附件视图
        let viewAttachmentInfo: [NSRange : AttributedStringItem.ViewAttachment] = string.value.get(.attachment)
        let tempViewRanges = viewAttachmentInfo.keys.sorted{ $0.location < $1.location }
        
//        assert(viewAttachmentInfo.isEmpty, "Label中不能使用自定义view附件")
//        guard !attachments.isEmpty else {
//            return
//        }
        tempViewRanges.forEach { range in
            if let attachment = viewAttachmentInfo[range] {
                let view = AttachmentView(attachment)
                base.addSubview(view)
                attachmentViews.append((range, view))
            }
        }
        base.attachmentViews = attachmentViews.reversed()
        
        // 添加自定义的附件子视图
//        viewAttachments.forEach { (range, attachment) in
//            let view = AttachmentView(attachment)
//            print("attachment.size:", attachment.size)
//
//            base.addSubview(view)
//            base.attachmentViews[range] = view
//        }
        
//        print("intrinsicContentSize:", base.intrinsicContentSize)
        
        // 刷新布局
        base.layout()
        base.layout1()
        
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

// 处理点击响应事件
extension UILabel {
    
    fileprivate typealias Action = AttributedString.Action
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Highlight = AttributedString.Action.Highlight
    fileprivate typealias Observers = [Checking : [Checking.Action]]
    
    /// action是否启用
    fileprivate var isActionEnable: Bool {
        return !actions.isEmpty
    }
    
    /// 触摸
    fileprivate var touched: (AttributedString, [NSRange: [Action]])? {
        get { associated.get(&UILabelTouchedKey) }
        set { associated.set(retain: &UILabelTouchedKey, newValue) }
    }
    
    /// actions
    fileprivate var actions: [NSRange : [Action]] {
        get { associated.get(&UILabelActionsKey) ?? [:]}
        set { associated.set(retain: &UILabelActionsKey, newValue) }
    }
    
    /// 监听信息
    fileprivate var observers: Observers {
        get { associated.get(&UILabelObserversKey) ?? [:] }
        set { associated.set(retain: &UILabelObserversKey, newValue) }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isActionEnable, let string = attributed.string, let touch = touches.first else {
            super.touchesBegan(touches, with: event)
            return
        }
        
    }
    
    
    
    
}

// MARK: 处理 attachmentViews
fileprivate extension UILabel {
    
    /// 自定义附件视图
    var attachmentViews: [(NSRange, AttachmentView)] {
        get { associated.get(&UILabelAttachmentViewsKey) ?? [] }
        set { associated.set(retain: &UILabelAttachmentViewsKey, newValue) }
    }
    
    var imageAttachments: [(NSRange, AttributedStringItem.ImageAttachment)] {
        get { associated.get(&UILabelImageAttachmentViewsKey) ?? [] }
        set { associated.set(retain: &UILabelImageAttachmentViewsKey, newValue) }
    }
    
    /// CTFrame
    var ctFrame: CTFrame? {
        get { associated.get(&UILabelCTFrameKey) }
        set { associated.set(retain: &UILabelCTFrameKey, newValue) }
    }
    
    class ViewRun {
        struct Line {
            var lineFlag: Int
            
            // line 中 run 高度和, (也就是累加的)
            var lineHeight: CGFloat = 0
        }
        
        let x: CGFloat
        let y: CGFloat
        var vline: Line
        let vHeight: CGFloat  // 控件高度
        let view: AttachmentView?
        
        init(x: CGFloat, y: CGFloat, vline: Line, vHeight: CGFloat, view: AttachmentView?) {
            self.x = x
            self.y = y
            self.vline = vline
            self.vHeight = vHeight
            self.view = view
        }
    }
    
    
    func layout1() {
//        let textStorage = NSTextStorage()
//        let textContainer = NSTextContainer(size: bounds.size)
//        let layoutManager = NSLayoutManager()
//
//        textContainer.lineBreakMode = lineBreakMode
//        textContainer.lineFragmentPadding = 0.0
//        textContainer.maximumNumberOfLines = numberOfLines
//        layoutManager.usesFontLeading = false   // UILabel没有使用FontLeading排版
//        layoutManager.addTextContainer(textContainer)
//        textStorage.addLayoutManager(layoutManager)
//        textStorage.setAttributedString(attributedText!)
//
//        // 确保布局
//        layoutManager.ensureLayout(for: textContainer)
//        // 获取文本所占高度
//        let height = layoutManager.usedRect(for: textContainer).height
//        print("height: \(height)")
//
//        let glyphRange = layoutManager.glyphRange(forCharacterRange: NSRange(location: 9, length: 1), actualCharacterRange: nil)
//        var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
//
//        print("rect: \(rect)")
    }
    
    
    func layout(_ isVisible: Bool = false) {
//        guard !attachmentViews.isEmpty else {
//            return
//        }
        
        layoutIfNeeded()
        sizeToFit()

        
        let textStorage = NSTextStorage()
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()
        
        textContainer.lineBreakMode = lineBreakMode
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = numberOfLines
        layoutManager.usesFontLeading = false   // UILabel没有使用FontLeading排版
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textStorage.setAttributedString(attributedText!)
        
        // 确保布局
        layoutManager.ensureLayout(for: textContainer)
        // 获取文本所占高度
        let rect = layoutManager.usedRect(for: textContainer)
        print("height: \(rect.height), width: \(rect.width)")
        

        
        
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
        
        
        let lineCount = CFArrayGetCount(ctLines)
        // 3.获得每一行的origin, CoreText的origin是在字形的baseLine处的, [ 获取每行的坐标 ]
        var lineOrigins = [CGPoint](repeating: CGPoint.zero, count: lineCount)
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &lineOrigins)
        
        // line : (CGFloat, [ViewRun])
        var viewRunInfo: [Int : [ViewRun]] = [:]
        
        
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

            var point: CGPoint = .zero
            var lineFlag: Int = 0
            
            func updateLayout(_ viewRun: ViewRun) {
                
                guard var viewRuns = viewRunInfo[i] else {
                    var viewRuns = [ViewRun]()
                    viewRuns.append(viewRun)
                    viewRunInfo[i] = viewRuns
                    return
                }
                
                viewRuns.append(viewRun)
                viewRunInfo[i] = viewRuns
                
                //                viewRun.vline.lineHeight = viewRun.vHeight
                //
                //                for run in tempViewRuns {
                //                    print(run.vline.lineFlag, run.vHeight)
                //                }
                
                // 统计ctLine中 `run`行的最大高度
                let result = viewRuns.reduce([ 0 : CGFloat(0)]) { partialResult, viewRun in
                    var partialResult = partialResult
                    if let height = partialResult[viewRun.vline.lineFlag] {
                        let maxHeight = max(height, viewRun.vHeight)
                        partialResult[viewRun.vline.lineFlag] = maxHeight
                    } else {
                        partialResult[viewRun.vline.lineFlag] = viewRun.vHeight
                    }
                    return partialResult
                }
                print(" >>>", result)
                
                func sumHeight(_ result: Dictionary<Int, CGFloat>, _ index: Int) -> CGFloat {
                    var sumHeight: CGFloat = 0
                    for i in 0 ..< index {
                        guard let height = result[i] else { continue }
                        sumHeight += height
                    }
                    return sumHeight
                }
                
                // 赋值 同一个ctLinerun相同行 的最大高度
                viewRunInfo.forEach { (line, viewRuns) in
                    guard line == i else { return }
                    viewRuns.forEach { viewRun in
                        guard let height = result[viewRun.vline.lineFlag] else { return }
                        viewRun.vline.lineHeight = height + sumHeight(result, viewRun.vline.lineFlag)
                        guard let view = viewRun.view else { return }
                        // 布局
                        view.frame.origin.y = viewRun.vline.lineHeight - view.bounds.size.height
                        
                    }
                }
                
            }
            
            // 遍历 run 找到attachment
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
                
                print("runRect:", runRect, "--", runAscent, "--", runDescent, "--", leading, "view.hieght: \(self.bounds.size.height)")
                // image
                if let font: UIFont = runAttributeds[NSAttributedString.Key.font] as? UIFont, font.pointSize == 0.11 {
                    guard let imageAttachment = imageAttachments.popLast()?.1 else {
                        continue
                    }
                    
//                    print("image.size \(String(describing: imageAttachment.size)),  \(String(describing: imageAttachment.frame)),  \(imageAttachment.bounds)")
                    
                    
                    // 超出范围, 换下一行
                    if point.x + imageAttachment.size.width > 384.0 {
                        lineFlag += 1
                        
                        point.x = 0
//                        print("🔥image 超出范围 \(point.x + imageAttachment.size.width) , \(self.frame.size.width)")
                    }
                    
                    point.x += imageAttachment.size.width
                    
                    let run = ViewRun(x: point.x,
                                      y: point.y,
                                      vline: .init(lineFlag: lineFlag),
                                      vHeight: imageAttachment.size.height,
                                      view: nil)
                    
//                    updateLayout(run)
                    
                } else
                // view
                if let font: UIFont = runAttributeds[NSAttributedString.Key.font] as? UIFont, font.pointSize == 0.22 {
                    guard let attachmentView = attachmentViews.popLast()?.1 else {
                        continue
                    }
                    
                    print(ctRun)
//                    let a = CTRunGetPositionsPtr(ctRun)
//                    print("Position.........", a?.pointee)
                    
//                    print("view \(String(describing: attachmentView.bounds.size))")
                    
                    let viewSize = attachmentView.bounds.size
                    
                    // 超出范围, 换下一行
                    if point.x + viewSize.width > 384.0 {
                        lineFlag += 1
//                        print("🔥 view 超出范围 \(point.x + viewSize.width) , \(self.frame.size.width)")
//                        attachmentView.frame.origin = CGPoint(0, runMaxHigiht)
                        attachmentView.frame.origin.x = 0;
                        // 重置
                        point = attachmentView.frame.origin
                    } else {
                        
//                        if (attachmentView.view.tag == 3) {
//                            attachmentView.frame.origin = CGPoint(328, runMaxHigiht - attachmentView.bounds.size.height)
//                        } else {
//                            attachmentView.frame.origin = CGPoint(point.x, runMaxHigiht - attachmentView.bounds.size.height)
                        attachmentView.frame.origin.x = point.x;
//                        }
                        
                        
                    }
                    attachmentView.lineRunFlag = lineFlag
                    
//                    print("😁containView.frame: ", attachmentView.frame, "view.hieght: \(self.frame.size.height)")
                    
                    point.x += attachmentView.bounds.size.width
                    
                    let run = ViewRun(x: point.x,
                                      y: point.y,
                                      vline: .init(lineFlag: lineFlag),
                                      vHeight: attachmentView.bounds.size.height,
                                      view: attachmentView)
//                    updateLayout(run)
                    
                    let range = CTRunGetStringRange(ctRun)
                    let glyphRange = layoutManager.glyphRange(forCharacterRange: NSRange(location: range.location, length: 1), actualCharacterRange: nil)
                    let rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                    
                    attachmentView.frame = CGRect(rect.origin.x, rect.origin.y, attachmentView.viewAttachment.size.width, attachmentView.viewAttachment.size.height)
                    
                    print("--->", attachmentView.frame)
                } else {
                    if point.x + runRect.size.width > 384.0 {
                        
//                        let a = CTRunGetPositionsPtr(ctRun)
//                        print("Position.........", a?.pointee)
//
//                        let b = CTRunGetStringIndicesPtr(ctRun)
//                        print("index.........", b?.pointee)
//                        print("mmmmmmm \(CTRunGetStringRange(ctRun))")
//
//                        print("string:::  \(ctRun)")
//
//                        print("CGGlyph:::  \(CTRunGetGlyphsPtr(ctRun)?.pointee)")
//
//                        var glyphs: [CGGlyph] = [CGGlyph](repeating: 0, count: 8)
//                        CTRunGetGlyphs(ctRun, CFRange(location: 0,length: 0), &glyphs)
//
//                        print("glyphs IIIII  \(glyphs)")
//
//                        print("JJJJ  \( CTRunGetAdvancesPtr(ctRun))")
//
//                        var sizes: [CGSize] = [CGSize](repeating: .zero, count: 8)
//                        CTRunGetAdvances(ctRun, CFRange(location: 0,length: 8), &sizes)
//                        print("Size:: \(sizes)")
//
//                        var points: [CGPoint] = [CGPoint](repeating: .zero, count: 8)
//                        CTRunGetPositions(ctRun, CFRange(location: 0,length: 8), &points)
//                        print("points:: \(points)")
                        
                        
//                        lineFlag += 1
//
                        point.x = 0
                        point.x += runRect.size.width
//
//                        // 文字换行
//                        let size = sizes[0]
//                        var count = 1
//                        while true  {
//                            if (point.x + size.width * CGFloat(count) > 384.0) {
//                                break
//                            }
//                            count += 1
//                        }
//                        count = count - 1 > 0 ? count - 1 : 0
//                        point.x -= size.width * CGFloat(count)
                        
                    } else {
                        point.x += runRect.size.width
                    }
                    
                    
                    point.y = runRect.size.height
                    
                    let run = ViewRun(x: point.x,
                                      y: point.y,
                                      vline: .init(lineFlag: lineFlag),
                                      vHeight: runRect.size.height,
                                      view: nil)
//                    updateLayout(run)
                }
                
            }
            
            print("\n ---------------- line --------------  \n")
        }
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
