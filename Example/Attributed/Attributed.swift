import UIKit

extension AttributedString {
    public struct Attribute {
        let attributes: [NSAttributedString.Key: Any]
    }
    
}

extension AttributedString.Attribute {
    
    /// 字号
    public static func font(_ value: UIFont) -> Self {
        return .init(attributes: [.font : value])
    }
    
    /// 文本颜色
    public static func foreground(_ value: UIColor) -> Self {
        return .init(attributes: [.foregroundColor : value])
    }
    
    /// 背景色
    public static func background(_ value: UIColor) -> Self {
        return .init(attributes: [.backgroundColor : value])
    }
    
    /// 下划线
    public static func underlineStyle(_ value: NSUnderlineStyle) -> Self {
        return .init(attributes: [.underlineStyle : value.rawValue])
    }
    
    public static func underlineColor(_ value: UIColor) -> Self {
        return .init(attributes: [.underlineColor : value])
    }
    
    public static func underline(_ style: NSUnderlineStyle, color: UIColor? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.underlineColor] = color
        temp[.underlineStyle] = style.rawValue
        return .init(attributes: temp)
    }
    
    /// 连体字
    public static func ligature(_ value: Bool) -> Self {
        return .init(attributes: [.ligature: value ? 1 : 0])
    }
    
    /// 字间距
    public static func kern(_ value: CGFloat) -> Self {
        return .init(attributes: [.kern: value])
    }
    
    /// 删除线
    public static func strikethroughStyle(_ value: NSUnderlineStyle) -> Self {
        return .init(attributes: [.strikethroughStyle : value.rawValue])
    }
    
    public static func strikethroughColor(_ value: UIColor) -> Self {
        return .init(attributes: [.strikethroughColor : value])
    }
    
    public static func strikethrough(_ style: NSUnderlineStyle, color: UIColor? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.strikethroughColor] = color
        temp[.strikethroughStyle] = style.rawValue
        return .init(attributes: temp)
    }
    
    /// 描边
    public static func stroke(_ width: CGFloat = 0, color: UIColor? = nil) -> Self {
        var temp: [NSAttributedString.Key: Any] = [:]
        temp[.strokeColor] = color
        temp[.strokeWidth] = width
        return .init(attributes: temp)
    }
    
    /// 阴影
    public static func shadow(offset: CGSize = .zero, blurRadius: CGFloat = 0, color: UIColor? = nil) -> Self {
        let shadow = NSShadow()
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = blurRadius
        shadow.shadowColor = {
            if let shadowColor = color {
                return shadowColor
            }
            return UIColor.black.withAlphaComponent(0.3333)
        }()
        return .init(attributes: [.shadow: shadow])
    }
    
    /// 文本特殊效果，只有图文排版印刷使用
    public static func textEffect(_ value: NSAttributedString.TextEffectStyle) -> Self {
        return textEffect(value.rawValue)
    }
    public static func textEffect(_ value: String) -> Self {
        return .init(attributes: [.textEffect: value])
    }
    
    /// 下划线
    public static func link(_ value: String) -> Self {
        guard let url = URL(string: value) else {
            return .init(attributes: [:])
        }
        return link(url)
    }
    public static func link(_ value: URL) -> Self {
        return .init(attributes: [.link: value])
    }
    
    /// 基准线
    public static func baselineOffset(_ value: CGFloat) -> Self {
        return .init(attributes: [.baselineOffset: value])
    }
    
    /// 斜体字
    public static func obliqueness(_ value: CGFloat = 0.1) -> Self {
        return .init(attributes: [.obliqueness: value])
    }
    
    /// 拉伸 / 压缩
    public static func expansion(_ value: CGFloat = 0.0) -> Self {
        return .init(attributes: [.expansion: value])
    }
    
    /// 书写方向
    public static func writingDirection(_ value: WritingDirection) -> Self {
        return writingDirection(value.value)
    }
    
    public static func writingDirection(_ value: [Int]) -> Self {
        return .init(attributes: [.writingDirection: value])
    }
    /// 纵向排版
    public static func verticalGlyphForm(_ value: Bool) -> Self {
        return .init(attributes: [.verticalGlyphForm: value ? 1 : 0])
    }
    
}

extension AttributedString.Attribute {
    
    public enum WritingDirection {
        case LRE
        case RLE
        case LRO
        case RLO
        
        fileprivate var value: [Int] {
            switch self {
            case .LRE:  return [NSWritingDirection.leftToRight.rawValue | NSWritingDirectionFormatType.embedding.rawValue]
                
            case .RLE:  return [NSWritingDirection.rightToLeft.rawValue | NSWritingDirectionFormatType.embedding.rawValue]
                
            case .LRO:  return [NSWritingDirection.leftToRight.rawValue | NSWritingDirectionFormatType.override.rawValue]
                
            case .RLO:  return [NSWritingDirection.rightToLeft.rawValue | NSWritingDirectionFormatType.override.rawValue]
            }
        }
    }
}


public extension Array where Element == AttributedString.Attribute {
    var attributesDictionary: [NSAttributedString.Key: Any] {
        var attributesDict: [NSAttributedString.Key: Any] = [:]
        self.forEach { attribute in
            let att = attribute.attributes
            att.forEach { attribute in
                let (key, value) = attribute
                attributesDict[key] = value
            }
        }
        return attributesDict
    }
}

public extension NSAttributedString {
    convenience init(string str: String, stringAttributes attrs: [AttributedString.Attribute]) {
        self.init(string: str, attributes: attrs.attributesDictionary)
    }
}

public extension UIFont {
    
    class func size(_ fontSize: CGFloat) -> UIFont {
        .systemFont(ofSize: fontSize)
    }
    
    class func size(_ fontSize: CGFloat, _ weight: UIFont.Weight) -> UIFont {
        .systemFont(ofSize: fontSize, weight: weight)
    }
    
    class func name(_ fontName: String, size fontSize: CGFloat) -> UIFont? {
        .init(name: fontName, size: fontSize)
    }
    
    
    
}
