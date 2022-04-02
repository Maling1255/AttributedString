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
        get {
            
            AttributedString.init(value: base.attributedText as! NSMutableAttributedString)
        }
        set {
            
            base.attributedText = newValue.value
            
            // 要在设置完`attributedText`之后在布局
            setupViewAttachments(newValue)
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
    
    
    /// 设置自定义视图附件
    private func setupViewAttachments(_ string: AttributedString) {
        // 清理原有监听
        observations = [:]
        
        // 刷新的时候 清理原有视图, 后面再添加新的
        for view in base.subviews where view is AttachmentView {
            view.removeFromSuperview()
        }
        base.attachmentViews = [:]

        // 获取自定义视图附件
        let attachments: [NSRange: AttributeStringItem.ViewAttachment] = string.value.get(.attachment)

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


/// 附件视图
private class AttachmentView: UIView {
    
    typealias Style = AttributeStringItem.Attachment.Style
    
    let view: UIView
    let style: Style
    
    private var observation: [String: NSKeyValueObservation] = [:]
    
    init(_ view: UIView, with style: Style) {
        self.view = view
        self.style = style
        super.init(frame: view.bounds)
        
        clipsToBounds = true
        backgroundColor = .clear
        
        addSubview(view)
        
        // 监听子视图位置变化 固定位置
        observation["frame"] = view.observe(\.frame) { [weak self] (object, changed) in
            guard let self = self else { return }
            self.update()
        }
        observation["bounds"] = view.observe(\.bounds) { [weak self] (object, changed) in
            guard let self = self else { return }
            self.update()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        update()
    }
    
    private func update() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        view.center = .init(bounds.width * 0.5, bounds.height * 0.5)
        switch style.mode {
        case .proposed:
            view.transform = .init(
                scaleX: bounds.width / view.bounds.width,
                y: bounds.height / view.bounds.height
            )
            
        case .original:
            let ratio = view.bounds.width / view.bounds.height
            view.transform = .init(
                scaleX: bounds.width / view.bounds.width,
                y: bounds.width / ratio / view.bounds.height
            )
            
        case .custom(let size):
            view.transform = .init(
                scaleX: size.width / view.bounds.width,
                y: size.height / view.bounds.height
            )
        }
        CATransaction.commit()
    }
}
