//
//  FontController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/3/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
//import AttributedString

struct Sports: OptionSet {
    let rawValue: Int
    static let running = Sports(rawValue: 1)
    static let cycling = Sports(rawValue: 2)
    static let swimming = Sports(rawValue: 4)
    static let fencing = Sports(rawValue: 8)
    static let shooting = Sports(rawValue: 32)
    static let horseJumping = Sports(rawValue: 512)
}


class FontController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let att = NSMutableAttributedString()
        var fontAtt = AttributedString(
            .string("字号10的大小\n", [.font(.size(10, .regular))]),
            .string("字号13的大小\n", [.font(.size(13, .regular))]),
            .string("字号16的大小\n", [.font(.size(16, .regular))]),
            .string("字号19的大小\n", [.font(.size(19, .regular))]),
            .string("字号21的大小\n", [.font(.size(21, .regular))]),
            .string("字号24的大小\n", [.font(.size(24, .regular))]),
            .string("字号30的大小\n", .font(.size(30, .regular))),
            .string("字号24的大小\n", .font(.size(24, .bold))),
            .string("字号21的大小\n", .font(.size(21, .bold))),
            .string("字号19的大小\n", .font(.size(19, .bold))),
            .string("字号16的大小\n", .font(.size(16, .bold))),
            .string("字号13的大小\n", .font(.size(13, .bold))),
            .string("字号10的大小\n", .font(.size(10, .bold)))
        )

//        let foregroundColorAtt = AttributedString(
//            .string("black Color\n", .foreground(.black)),
//            .string("darkGray Color\n", .foreground(.darkGray)),
//            .string("lightGray Color\n", .foreground(.lightGray)),
//            .string("white Color\n", .foreground(.white)),
//            .string("gray Color\n", .foreground(.gray)),
//            .string("red Color\n", .foreground(.red)),
//            .string("green Color\n", .foreground(.green)),
//            .string("blue Color\n", .foreground(.blue)),
//            .string("cyan Color\n", .foreground(.cyan)),
//            .string("blue Color\n", .foreground(.blue)),
//            .string("yellow Color\n", .foreground(.yellow)),
//            .string("magenta Color\n", .foreground(.magenta)),
//            .string("orange Color\n", .foreground(.orange)),
//            .string("purple Color\n", .foreground(.purple)),
//            .string("brown Color\n", .foreground(.brown)),
//            .string("clear Color\n", .foreground(.clear))
//        )
//        fontAtt.append(foregroundColorAtt)
//
//        let backgroundColorAtt = AttributedString(
//            .string("black Color\n", .background(.black)),
//            .string("darkGray Color\n", .background(.darkGray)),
//            .string("lightGray Color\n", .background(.lightGray)),
//            .string("white Color\n", .background(.white)),
//            .string("gray Color\n", .background(.gray)),
//            .string("red Color\n", .background(.red)),
//            .string("green Color\n", .background(.green)),
//            .string("blue Color\n", .background(.blue)),
//            .string("cyan Color\n", .background(.cyan)),
//            .string("blue Color\n", .background(.blue)),
//            .string("yellow Color\n", .background(.yellow)),
//            .string("magenta Color\n", .background(.magenta)),
//            .string("orange Color\n", .background(.orange)),
//            .string("purple Color\n", .background(.purple)),
//            .string("brown Color\n", .background(.brown)),
//            .string("clear Color\n", .background(.clear))
//        )
//        fontAtt.append(backgroundColorAtt)
//
//        let underlineAtt = AttributedString(
//            .string("single\n", .font(.size(18))),
//            .string("thick\n", [.font(.size(18)), .underlineStyle(.thick)]),
//            .string("styleDouble\n", [.font(.size(18)), .underlineStyle(.double)]),
//
//            .string("patternDot\n", [.font(.size(18)), .underlineStyle([.patternDot, .thick])]),
//            .string("patternDash\n", [.font(.size(18)), .underlineStyle([.patternDash, .thick])]),
//            .string("patternDashDot\n", [.font(.size(18)), .underlineStyle([.patternDashDot, .thick])]),
//            .string("patternDashDotDot\n", [.font(.size(18)), .underlineStyle([.patternDashDotDot, .thick])]),
//
//            .string("byWord\n", [.font(.size(18)), .underlineStyle(.byWord)]),
//
//            .string("rawValue: 1\n", .font(.size(18)), .underlineStyle(.init(rawValue: 1))),
//            .string("rawValue: 2\n", .font(.size(18)), .underlineStyle(.init(rawValue: 2))),
//            .string("rawValue: 3\n", .font(.size(18)), .underlineStyle(.init(rawValue: 3))),
//            .string("rawValue: 4\n", .font(.size(18)), .underlineStyle(.init(rawValue: 4))),
//            .string("rawValue: 5\n", .font(.size(18)), .underlineStyle(.init(rawValue: 5))),
//            .string("rawValue: 6\n", .font(.size(18)), .underlineStyle(.init(rawValue: 6))),
//            .string("rawValue: 7\n", .font(.size(18)), .underlineStyle(.init(rawValue: 7))),
//            .string("rawValue: 1\n", .font(.size(18)), .underline(.init(rawValue: 1))),
//            .string("rawValue: 8\n", .font(.size(18)), .underline(.single, color: .red)),
//            .string("rawValue: 9\n", .font(.size(18)), .underline(.thick, color: .blue)),
//            .string("rawValue: 10\n", .font(.size(18)), .underline(.double, color: .cyan)),
//            .string("rawValue: 11\n", .font(.size(18)), .underlineColor(.red), .underlineStyle(.init(rawValue: 11))),
//            .string("rawValue: 12\n", .font(.size(18)), .underlineColor(.blue), .underlineStyle(.init(rawValue: 12))),
//            .string("rawValue: 13\n", .font(.size(18)), .underlineColor(.cyan), .underlineStyle(.init(rawValue: 13)))
//        )
//        fontAtt.append(underlineAtt)
//
//        let ligatureAtt = AttributedString(
//            .string("fltytfhijkflmnopqrstyz\n", [.ligature(true), .font(.name("futura", size: 21)!)]),
//            .string("fltytfhijkflmnopqrstyz\n", [.ligature(false), .font(.name("futura", size: 21)!)])
//        )
//        fontAtt.append(ligatureAtt)
//
//
//        let kernAtt = AttributedString(
//            .string("这是像素为0间距\n", .kern(0)),
//            .string("这是像素为2间距\n", .kern(2)),
//            .string("这是像素为4间距\n", .kern(4)),
//            .string("这是像素为6间距\n", .kern(6)),
//            .string("这是像素为8间距\n", .kern(8)),
//            .string("这是像素为10间距\n", .kern(10)),
//            .string("这是像素为8间距\n", .kern(8)),
//            .string("这是像素为6间距\n", .kern(6)),
//            .string("这是像素为4间距\n", .kern(4)),
//            .string("这是像素为2间距\n", .kern(2)),
//            .string("这是像素为0间距\n", .kern(0))
//        )
//        fontAtt.append(kernAtt)
//
//
//        let strikethroughAtt = AttributedString(
//            .string("strikethrough: single\n", .strikethroughStyle(.single)),
//            .string("strikethrough: thick\n", .strikethroughStyle(.thick)),
//            .string("strikethrough: double\n", .strikethroughStyle(.double)),
//            .string("strikethrough: 1\n", .strikethroughStyle(.init(rawValue: 1))),
//            .string("strikethrough: 2\n", .strikethroughStyle(.init(rawValue: 2))),
//            .string("strikethrough: 3\n", .strikethroughStyle(.init(rawValue: 3))),
//            .string("strikethrough: 4\n", .strikethroughStyle(.init(rawValue: 4))),
//            .string("strikethrough: 5\n", .strikethroughStyle(.init(rawValue: 5))),
//            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 1), color: .red)),
//            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 2), color: .cyan)),
//            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 3), color: .orange)),
//            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 4), color: .purple)),
//            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 5), color: .brown))
//        )
//        fontAtt.append(strikethroughAtt)
//
//        let strokeAtt = AttributedString(
//            .string("stroke: 0\n", [.stroke(), .font(.size(30))]),
//            .string("stroke: 1\n", .stroke(1)),
//            .string("stroke: 2\n", .stroke(2)),
//            .string("stroke: 3\n", .stroke(3)),
//            .string("stroke: 4\n", .stroke(4)),
//            .string("stroke: 5\n", .stroke(5)),
//            .string("stroke: 1\n", .stroke(1, color: .red)),
//            .string("stroke: 2\n", .stroke(2, color: .blue)),
//            .string("stroke: 3\n", .stroke(3, color: .purple)),
//            .string("stroke: 4\n", .stroke(4, color: .orange)),
//            .string("stroke: 5\n", .stroke(5, color: .brown))
//        ).font(.size(21, .regular))
//        fontAtt.append(strokeAtt)
//
//        let shadowAtt = AttributedString(
//            .string("shadow: defalut\n", .shadow()),
//            .string("shadow: offset 0 radius: 4 color: default\n", [.shadow(offset: .zero, blurRadius: 4)]),
//            .string("shadow: offset 0 radius: 4 color: blue\n", [.shadow(offset: .zero, blurRadius: 4, color: .blue)]),
//            .string("shadow: offset 0 radius: default color: blue\n", [.shadow(offset: .zero, blurRadius: 0, color: .blue)]),
//            .string("shadow: offset 3 radius: 4 color: red\n", [.shadow(offset: .init(width: 0, height: 3), blurRadius: 4, color: .gray)]),
//            .string("shadow: offset 3 radius: 10 color: red\n", [.shadow(offset: .init(width: 0, height: 3), blurRadius: 10, color: .red)]),
//            .string("shadow: offset 10 radius: 1 color: red\n", [.shadow(offset: .init(width: 0, height: 10), blurRadius: 3, color: .red)]),
//            .string("shadow: offset 4 radius: 3 color: cyan\n", [.shadow(offset: .init(width: 0, height: 4), blurRadius: 3, color: .cyan)])
//        ).font(.size(21, .regular))
//        fontAtt.append(shadowAtt)
//
//
//        let textEffectAtt = AttributedString(
//            .string("textEffect: none\n"),
//            .string("textEffect: .letterpressStyle\n", .font(.size(30))),
//            .string("textEffect: .letterpressStyle\n", [.textEffect(.letterpressStyle), .font(.size(30))])
//
//        )
//        fontAtt.append(textEffectAtt)
//
//
//        // 创建一些自定义视图控件
//        let customView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 100))
//        customView.backgroundColor = .red
//
//        let customImageView = UIImageView(image: #imageLiteral(resourceName: "swift-image-1"))
//        customImageView.contentMode = .scaleAspectFill
//        customImageView.sizeToFit()
//
//        let customLabel = UILabel()
//        customLabel.text = "1234567890"
//        customLabel.font = .systemFont(ofSize: 30, weight: .medium)
//        customLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
//        customLabel.sizeToFit()
//
//        let attachmentAtt = AttributedString(
//            .string("建议大小", [.font(.size(21))]),
//            .image(UIImage(named: "swift-icon")!, .proposed(), newline: .trailing),
//            .string("原始大小:", [.font(.size(21))]),
//            .image(UIImage(named: "swift-icon")!, .original(), newline: .trailing),
//            .string("自定义大小", [.font(.size(21))]),
//            .image(UIImage(named: "swift-icon")!, .custom(.center, size: .init(width: 50, height: 50)), newline: .trailing),
//            .view(customView, .original(.center)),
//            .view(customImageView, .original(.origin)),
//            .view(customLabel, .original(.center), newline: .trailing)
//        )
//
//        fontAtt.append(attachmentAtt)
//
//        // this static property is defined on key, and may not be available in this context.
//        let linkString = AttributedString(
//            .string("linnk: none\n"),
//            .string("link: https://www.apple.com\n", .link("https://www.apple.com"))
//        )
//        fontAtt.append(linkString)
//
//        let baselineoffset = AttributedString(
//            .string("baseline offset: none\n"),
//            .string("baseline"),
//            .string("baseline offset: 1\n", .baselineOffset(1)),
//            .string("baseline"),
//            .string("baseline offset: 3\n", .baselineOffset(3)),
//            .string("baseline"),
//            .string("baseline offset: 5\n", .baselineOffset(5)),
//            .string("baseline"),
//            .string("baseline offset: -1\n", .baselineOffset(-1)),
//            .string("baseline"),
//            .string("baseline offset: -3\n", .baselineOffset(-3)),
//            .string("baseline"),
//            .string("baseline offset: -5\n", .baselineOffset(-5))
//        )
//        fontAtt.append(baselineoffset)
//
//
//        let obliqueness = AttributedString(
//            .string("obliqueness: none\n"),
//            .string("obliqueness: 0.1\n", .obliqueness(0.1)),
//            .string("obliqueness: 0.3\n", .obliqueness(0.3)),
//            .string("obliqueness: 0.5\n", .obliqueness(0.5)),
//            .string("obliqueness: 1\n", .obliqueness(1)),
//            .string("obliqueness: -0.1\n", .obliqueness(-0.1)),
//            .string("obliqueness: -0.3\n", .obliqueness(-0.3)),
//            .string("obliqueness: -0.5\n", .obliqueness(-0.5)),
//            .string("obliqueness: -1\n", .obliqueness(-1))
//        )
//        fontAtt.append(obliqueness)
//
//        let expansion = AttributedString(
//            .string("expansion: none\n"),
//            .string("expansion: 0\n", .expansion(0)),
//            .string("expansion: 0.1\n", .expansion(0.1)),
//            .string("expansion: 0.3\n", .expansion(0.3)),
//            .string("expansion: 0.5\n", .expansion(0.5)),
//            .string("expansion: 1\n",   .expansion(1)),
//            .string("expansion: -0.1\n", .expansion(-0.1)),
//            .string("expansion: -0.3\n", .expansion(-0.3)),
//            .string("expansion: -0.5\n", .expansion(-0.5)),
//            .string("expansion: -1\n",   .expansion(-1))
//        )
//        fontAtt.append(expansion)
//
//        let writingDirection = AttributedString(
//            .string("writingDirection: none\n"),
//            .string("writingDirection: LRE\n", [.writingDirection(.LRE)]),
//            .string("writingDirection: RLE\n", [.writingDirection(.RLE)]),
//            .string("writingDirection: LRO\n", [.writingDirection(.LRO)]),
//            .string("writingDirection: RLO\n", [.writingDirection(.RLO)])
//        )
//        fontAtt.append(writingDirection)
        
        let verticalGlyphForm = AttributedString(
            .string("verticalGlyphForm: none\n"),
            .string("verticalGlyphForm: 1\n", [.verticalGlyphForm(true)]),
            .string("verticalGlyphForm: 0\n", [.verticalGlyphForm(false)]),
            .string("Currently on iOS, it's always horizontal.\n", [.font(.size(21)), .foreground(.red)])
        )
        fontAtt.append(verticalGlyphForm)
        
        
        let paragraph = AttributedString(
            .string(
                """
         这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试

      🔥段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等\n
"""
                , [.font(.size(17)), .foreground(.brown), .paragraph(.lineSpacing(10), .headIndent(20), .firstLineHeadIndent(50))]),
            
                .string(
                    """
          段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等
    """
                    , [.font(.size(17)), .foreground(.brown), .paragraph([.firstLineHeadIndent(20), .paragraphSpacingBefore(80), .alignment(.right)])])
        )
        
        fontAtt.append(paragraph)
        
        
        textView.attributed.string = fontAtt
    }
}

extension NSMutableAttributedString {
    
    @discardableResult
    func appendAttributedString(_ att: NSAttributedString) -> NSAttributedString {
        self.append(NSAttributedString.init(string: "\n\n\n"))
        self.append(att)
        return self
    }
}
