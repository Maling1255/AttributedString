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


class AttributedController: UIViewController {
    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let size = textView.sizeThatFits(CGSize(view.bounds.size.width, 1500))
        textViewHeight.constant = size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        
        
        
        
//        let att = NSMutableAttributedString()



//        fontAtt.append(foregroundColorAtt)
//

//        fontAtt.append(backgroundColorAtt)
//

//        fontAtt.append(underlineAtt)
//

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
        
//        let verticalGlyphForm = AttributedString(
//            .string("verticalGlyphForm: none\n"),
//            .string("verticalGlyphForm: 1\n", [.verticalGlyphForm(true)]),
//            .string("verticalGlyphForm: 0\n", [.verticalGlyphForm(false)]),
//            .string("Currently on iOS, it's always horizontal.\n", [.font(.size(21)), .foreground(.red)])
//        )
//        fontAtt.append(verticalGlyphForm)
//
//

        
//        func clicked(_ result: AttributedString.Action.Result) {
//            switch result.content {
//            case .string(let attString):
//                print("点击了文本: \(attString) range: \(result.range)")
//            case .attachment(let attString):
//                print("点击了附件: \n\(attString) \nrange: \(result.range)")
//            }
//        }
//
//        func pressed(_ result: AttributedString.Action.Result) {
//            switch result.content {
//            case .string(let value):
//                print("按住了文本: \n\(value) \nrange: \(result.range)")
//
//            case .attachment(let value):
//                print("按住了附件: \n\(value) \nrange: \(result.range)")
//            }
//        }
//
//        let actionAtt = AttributedString(
//            .string("这是可以点击的文字\n", [.font(.size(21)), .font(.systemFont(ofSize: 30, weight: .bold)), .action(clicked), .action(.press, pressed)])
//        )
//
////        fontAtt.append(actionAtt)
//
//
//        textView.attributed.string = actionAtt
        
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
