//
//  Attachment.swift
//  AttributedString_Example
//
//  Created by maling on 2022/3/31.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

extension AttributedStringItem {
    
    public enum Attachment {
//        case image(UIImage, bounds: CGRect)
//
//        var value: NSTextAttachment {
//            switch self {
//            case .image(let image, let bounds):
//                let temp = NSTextAttachment()
//                temp.image = image
//                temp.bounds = bounds
//                return temp
////            default:break
//            }
//        }
    }
    
    public class ImageAttachment: NSTextAttachment {
        
        public typealias Style = Attachment.Style
        
        private let style: Style
        
        init(_ image: UIImage, _ style: Style = .original()) {
            self.style = style
            super.init(data: nil, ofType: nil)
            self.image = image
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public static func image(_ image: UIImage, _ style: Style = .original()) -> ImageAttachment {
            return .init(image, style)
        }
        
        public override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
            guard let image = image else {
                return super.attachmentBounds(for: textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
            }
            
            func point(_ size: CGSize) -> CGPoint {
                return style.alignment.point(size, with: lineFrag.height)
            }
            switch style.mode {
            case .proposed:
                let ratio = image.size.width / image.size.height
                let width = min(lineFrag.height * ratio, lineFrag.width)
                let height = width / ratio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .original:
                let ratio = image.size.width / image.size.height
                let width = min(image.size.width, lineFrag.width)
                let height = width / ratio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .custom(let size):
                return .init(point(size), size)
            }
        }
    }
    
    public class ViewAttachment: NSTextAttachment {
        
        public typealias Style = Attachment.Style
        
        let view: UIView
        let style: Style
        
        /// Custom View  (Only  support UITextView)
        /// - Parameter view: 视图
        /// - Returns: 视图附件
        public static func view(_ view: UIView, _ style: Style = .original()) -> ViewAttachment {
            return .init(view, with: style)
        }
        
        init(_ view: UIView, with style: Style = .original()) {
            self.view = view
            self.style = style
            super.init(data: nil, ofType: nil)
            self.image = UIImage()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
            guard image != nil else {
                return super.attachmentBounds(
                    for: textContainer,
                    proposedLineFragment: lineFrag,
                    glyphPosition: position,
                    characterIndex: charIndex
                )
            }
            
            func point(_ size: CGSize) -> CGPoint {
                return style.alignment.point(size, with: lineFrag.height)
            }
            
            view.layoutIfNeeded()
            
            switch style.mode {
            case .proposed:
                let ratio = view.bounds.width / view.bounds.height
                let width = min(lineFrag.height * ratio, lineFrag.width)
                let height = width / ratio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .original:
                let ratio = view.bounds.width / view.bounds.height
                let width = min(view.bounds.width, lineFrag.width)
                let height = width / ratio
                return .init(point(.init(width, height)), .init(width, height))
                
            case .custom(let size):
                return .init(point(size), size)
            }
        }
        
    }
    
}


extension AttributedStringItem.Attachment {
    
    /// 对齐
    public enum Alignment {
        case center // Visually centered
        
        case origin // Baseline
        
        case offset(CGPoint)
    }
    
    public struct Style {

        enum Mode {
            case proposed
            case original
            case custom(CGSize)
        }
        
        let mode: Mode
        let alignment: Alignment
        
        /// 建议的大小 (一般为当前行的高度)
        /// - Parameter alignment: 对齐方式
        public static func proposed(_ alignment: Alignment = .origin) -> Style {
            return .init(mode: .proposed, alignment: alignment)
        }
        
        /// 原始的大小 (但会限制最大宽度不超过单行最大宽度, 如果超过则会使用单行最大宽度 并等比例缩放内容)
        /// - Parameter alignment: 对齐方式
        public static func original(_ alignment: Alignment = .origin) -> Style {
            return .init(mode: .original, alignment: alignment)
        }
        
        /// 自定义的
        /// - Parameter alignment: 对齐
        /// - Parameter size: 大小
        public static func custom(_ alignment: Alignment = .origin, size: CGSize) -> Style {
            return .init(mode: .custom(size), alignment: alignment)
        }
    }
    
}

fileprivate extension AttributedStringItem.Attachment.Alignment {
    
    /// 计算坐标
    /// - Parameters:
    ///   - size: 大小
    ///   - lineHeight: 行高
    /// - Returns: 位置坐标
    func point(_ size: CGSize, with lineHeight: CGFloat) -> CGPoint {
        var font = UIFont.systemFont(ofSize: 18)
        let fontSize = font.pointSize / (abs(font.descender) + abs(font.ascender)) * lineHeight
        font = .systemFont(ofSize: fontSize)
        
        switch self {
        case .origin:
            return .init(0, font.descender)  // 下降器 descender  https://fonts.google.com/knowledge/glossary/ascenders_descenders
            
        case .center:
            return .init(0, (font.capHeight - size.height) / 2)  // capHeight https://fonts.google.com/knowledge/glossary/cap_height
            
        case .offset(let value):
            return value
        }
    }
}


/// 附件视图
public class AttachmentView: UIView {
    
    typealias Style = AttributedStringItem.Attachment.Style
    
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
    
    public override func layoutSubviews() {
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
