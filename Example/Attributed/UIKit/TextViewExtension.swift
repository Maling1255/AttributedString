//
//  TextViewExtension.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/1.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

private var UIGestureRecognizerKey: Void?
private var UITextViewTouchedKey: Void?
private var UITextViewActionsKey: Void?
private var UITextViewObserversKey: Void?
private var UITextViewObservationsKey: Void?
private var UITextViewAttachmentViewsKey: Void?

extension UITextView : AttributedStringCompatible {
    
}

extension AttributedStringWrapper where Base: UITextView {
    
    var string: AttributedString {
        get { base.touched?.0 ?? .init(base.attributedText) }
        set {
            
            if var touched = base.touched, touched.0.isContentEqual(to: newValue) {
                touched.0 = newValue
                base.touched = touched
                
                // 将当前的高亮属性覆盖到新的文本中, 替换显示的文本
                let temp = NSMutableAttributedString(attributedString: newValue.value)
                let ranges = touched.1.keys.sorted(by: { $0.length > $1.length })
                for range in ranges {
                    base.attributedText?.get(range).forEach({ (range, attributes) in
                        temp.setAttributes(attributes, range: range)
                    })
                }
                base.attributedText = temp
                
            } else {
            
                base.touched = nil
                base.attributedText = newValue.value
            }
            
            
            // 要在设置完`attributedText`之后在布局
            setupViewAttachments(newValue)
            setupActions(newValue)
            setupGestureRecognizers()
            
        }
    }
}


extension AttributedStringWrapper where Base: UITextView {
    
    private(set) var gestures: [UIGestureRecognizer] {
        get { base.associated.get(&UIGestureRecognizerKey) ?? [] }
        set { base.associated.set(retain: &UIGestureRecognizerKey, newValue) }
    }
    
    private(set) var observations: [String: NSKeyValueObservation] {
        get { base.associated.get(&UITextViewObservationsKey) ?? [:] }
        set { base.associated.set(retain: &UITextViewObservationsKey, newValue) }
    }
    
    
    /// 添加手势识别
    private func setupGestureRecognizers() {
        base.isUserInteractionEnabled = true
        // false: touch事件立即传递给subView，不会有150ms的等待。
        // ture: 延迟150ms, 判断是都在滚动,不会将消息传递给subviews, 没有滚动会将消息传递给subview
        base.delaysContentTouches = false
        
        gestures.forEach { base.removeGestureRecognizer($0) }
        gestures = []
        
        let triggers = base.actions.values.flatMap({ $0 }).map({ $0.trigger })
        Set(triggers).forEach { trigger in
            switch trigger {
            case .click:
                let gesture = UITapGestureRecognizer(target: base, action: #selector(Base.attributedAction))
                gesture.cancelsTouchesInView = false
                base.addGestureRecognizer(gesture)
                gestures.append(gesture)
            case .press:
                let gesture = UILongPressGestureRecognizer(target: base, action: #selector(Base.attributedAction))
                gesture.cancelsTouchesInView = false
                base.addGestureRecognizer(gesture)
                gestures.append(gesture)
            }
        }
    }
    
    
    /// 设置点击事件
    private func setupActions(_ string: AttributedString) {
        
        // 清理原有动作记录
        base.actions = [:]
        // 获取当前动作,重新赋值
        base.actions = string.value.get(.action)
        // 获取匹配检查, 添加检查动作
        let observers = base.observers
        string.matching(.init(observers.keys)).forEach { (range: NSRange, tupleValue: (AttributedString.Checking, AttributedString.Checking.Result)) in
            let (type, result) = tupleValue
            if var temp = base.actions[range] {
                for action in observers[type] ?? [] {
                    temp.append(.init(action.trigger, highlights: action.highlights) { _ in
                        action.callback(result)
                    })
                }
                base.actions[range] = temp
            } else {
                base.actions[range] = observers[type]?.map { action in
                        .init(action.trigger, highlights: action.highlights) { _ in
                            action.callback(result)
                        }
                }
            }
        }
        
        // 统一为所有动作增加handle闭包    base.actions: [NSRange : [Action]]
        base.actions = base.actions.reduce(into: [:]) {
            // 使用 $0  $1 可以取消闭包里面的 in 关键字keyword
            // 还有参数 ($0: [:], $1: (key: Key, value: Value))
            let result: Action.Result = string.value.get($1.key)
            let actions: [Action] = $1.value.reduce(into: []) {
                var temp = $1
                temp.handle = {
                    temp.callback(result)
                }
                $0.append(temp)
            }
            $0[$1.key] = actions
        }
    }
    
    
    /// 设置自定义视图附件
    private func setupViewAttachments(_ string: AttributedString) {
        // 清理原有监听
        observations = [:]
        
        // 刷新的时候清理已经添加的自定义视图, 为了后面重新添加
        for view in base.subviews where view is AttachmentView {
            view.removeFromSuperview()
        }
        base.attachmentViews = [:]

        // 获取自定义视图附件
        let attachments: [NSRange: AttributedStringItem.ViewAttachment] = string.value.get(.attachment)
        guard !attachments.isEmpty else {
            return
        }

        // 添加子视图
        attachments.forEach {
            let view = AttachmentView($0.value.view, with: $0.value.style)
            base.addSubview(view)
            // $0.key 就是range
            base.attachmentViews[$0.key] = view
        }
        // 刷新布局
        base.layout()
        
        // 设置视图相关监听 同步更新布局
        observations["bounds"] = base.observe(\.bounds, options: [.new, .old]) { (object, changed) in
            object.layout(true)
        }
        observations["frame"] = base.observe(\.frame, options: [.new, .old]) { (object, changed) in
            guard changed.newValue?.size != changed.oldValue?.size else { return }
            object.layout()
        }
    }
}


// MARK: 处理 action
extension UITextView {
    
    fileprivate typealias Action = AttributedString.Action
    fileprivate typealias Checking = AttributedString.Checking
    fileprivate typealias Observers = [Checking : [Checking.Action]]
    
    /// 是否启用 Action
    fileprivate var isActionEnabled: Bool {
        return !actions.isEmpty && (!isEditable && !isSelectable)
    }
    
    /// 触摸信息
    fileprivate var touched: (AttributedString, [NSRange : [Action]])? {
        get { associated.get(&UITextViewTouchedKey) }
        set { associated.set(retain: &UITextViewTouchedKey, newValue) }
    }
    
    /// 全部动作
    fileprivate var actions: [NSRange : [Action]] {
        get { associated.get(&UITextViewActionsKey) ?? [:] }
        set { associated.set(retain: &UITextViewActionsKey, newValue) }
    }
    
    /// 监听信息
    fileprivate var observers: Observers {
        get { associated.get(&UITextViewObserversKey) ?? [:] }
        set { associated.set(retain: &UITextViewObserversKey, newValue) }
    }
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isActionEnabled, let touch = touches.first else {
            super.touchesBegan(touches, with: event)
            return
        }
        
        let results = matching(touch.location(in: self))
        guard !results.isEmpty else {
            super.touchesBegan(touches, with: event)
            return
        }
        
        ActionQueue.main.began {
            let string = attributed.string
            // 设置触摸范围内容
            touched = (string, results)
            // 设置高亮样式
            let ranges = results.keys.sorted(by: { $0.length > $1.length })
            for range in ranges {
                var temp: [NSAttributedString.Key : Any] = [:]
                results[range]?.first?.highlights.forEach({ highlight in
                    temp.merge(highlight.attributes, uniquingKeysWith: { $1 })
                })
                
                attributedText = string.value.reset(range: range, attributes: { attribute in
                    attribute.merge(temp, uniquingKeysWith: { $1 })
                })
            }
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isActionEnabled, let touched = self.touched else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        // 保证 touchesBegan -> action -> touchesEnded 的调用顺序
        ActionQueue.main.ended {
            self.touched = nil
            // 恢复默认状态 (非高亮状态)
            self.attributedText = touched.0.value
            self.layout()
        }
    }
    
    // scrollview开始滚动   subview不响应消息,   [这个方法执行🔥]  https://www.jianshu.com/p/2b171f6153ad
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isActionEnabled, let touched = self.touched else {
            super.touchesCancelled(touches, with: event)
            return
        }
        // 保证 touchesBegan -> action -> touchesEnded 的调用顺序
        ActionQueue.main.ended {
            self.touched = nil
            self.attributedText = touched.0.value
            self.layout()
        }
    }
    
}


// MARK: 处理 attachmentViews
fileprivate extension UITextView {
    
    /// 附件视图
    var attachmentViews: [NSRange: AttachmentView] {
        get { associated.get(&UITextViewAttachmentViewsKey) ?? [:] }
        set { associated.set(retain: &UITextViewAttachmentViewsKey, newValue) }
    }
    
    /// 布局
    /// - Parameter isVisible: 是否仅可视范围
    func layout(_ isVisible: Bool = false) {
        guard !attachmentViews.isEmpty else {
            return
        }
        
        // range : 自定义视图所在的位置
        func update(_ range: NSRange, _ view: AttachmentView) {
            view.isHidden = false
            // glyphRange 获取图像字形(即自定义视图view)范围
            let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
            // 获取自定义view边界大小
            var rect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
            rect.origin.x += textContainerInset.left
            rect.origin.y += textContainerInset.top
            // 🔥设置view位置
            view.frame = rect
        }
        
        if isVisible {
            // 获取可见范围
            let offset = CGPoint(contentOffset.x - textContainerInset.left, contentOffset.y - textContainerInset.top)
            let visible = layoutManager.glyphRange(forBoundingRect: .init(offset, bounds.size), in: textContainer)
            // 更新可见范围内的视图位置 同时隐藏可见范围外的视图
            for (range, view) in attachmentViews {
                if visible.contains(range.location) {
                    // 确保布局
                    layoutManager.ensureLayout(forCharacterRange: range)
                    // 更新视图
                    update(range, view)
                    
                } else {
                    view.isHidden = true
                }
            }
            
        } else {
            // 完成布局刷新
            layoutIfNeeded()
            // 废弃当前布局 重新计算
            layoutManager.invalidateLayout(
                forCharacterRange: .init(location: 0, length: textStorage.length),
                actualCharacterRange: nil
            )
            // 确保布局
            layoutManager.ensureLayout(for: textContainer)
            // 更新全部自定义视图位置
            attachmentViews.forEach(update)
        }
    }
}


fileprivate extension UITextView {
    
    @objc
    func attributedAction(_ sender: UIGestureRecognizer) {
        guard sender.state == .ended else { return }
        
        // 保证 touchedBegan -> Action -> touchedEnded 的调用顺序
        ActionQueue.main.action { [weak self] in
            guard let self = self else { return }
            guard self.isActionEnabled else { return }
            guard let touched = self.touched else { return }
            let actions = touched.1.flatMap({ $0.value })
            
            // 匹配手势
            for action in actions where action.trigger.matching(sender) {
                action.handle?()
            }
        }
    }
    
    func matching(_ point: CGPoint) -> [NSRange : [Action]] {
        
        // 确保布局
        layoutManager.ensureLayout(for: textContainer)
        
        // 获取点击坐标, 并排除各种偏移
        var point = point
        point.x -= textContainerInset.left
        point.y -= textContainerInset.top
        
        // 获取字形下标
        var fraction: CGFloat = 0
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer, fractionOfDistanceThroughGlyph: &fraction)
        // 获取字符下标
        let index = layoutManager.characterIndexForGlyph(at: glyphIndex)
        // 通过字形距离判断是否在字形范围内
        guard fraction > 0, fraction < 1 else {
            return [:]
        }
        
        // 获取点击字符串范围和回调事件
        let ranges = actions.keys.filter({ $0.contains(index) })
        return ranges.reduce(into: [:]) {
            
            // reduce<Result>(into initialResult: Result, _ updateAccumulatingResult: (inout Result, Element) throws -> ())
            // var $0: [NSRange : [UITextView.Action]]
            // let $1: Dictionary<NSRange, [UITextView.Action]>.Keys.Element
            
            $0[$1] = actions[$1]
        }
    }
}


