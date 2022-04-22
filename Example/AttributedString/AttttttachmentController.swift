//
//  AttachmentController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit


class MGLabel : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 1 获取上下文
        let context = UIGraphicsGetCurrentContext()
        
        // 2 转换坐标
        context?.textMatrix = .identity
        context?.translateBy(x: 0, y: self.bounds.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 3 绘制区域
        let path = UIBezierPath(rect: rect)
        
//
//        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        
        let att = NSMutableAttributedString(string: "建议大小");

        var  imageCallback1 =  CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (refCon) -> Void in
               }, getAscent: { ( refCon) -> CGFloat in
                   return 300
//                               return attach.size.height  //返回高度
               }, getDescent: { (refCon) -> CGFloat in
                   return 50  //返回底部距离
               }) { (refCon) -> CGFloat in
//                               let attach = unsafeBitCast(refCon, to: AttributedStringItem.ViewAttachment.self)
//                               return attach.size.width  //返回宽度
                   return 100
           }
        
        // 创建一些自定义视图控件
        let customView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 150))
        customView.backgroundColor = .brown
        
        let customView2 = UIView(frame: .init(x: 0, y: 0, width: 350, height: 100))
        customView2.backgroundColor = .red
        
        let customLabel = UILabel()
        customLabel.text = "1234567890"
        customLabel.font = .systemFont(ofSize: 30, weight: .medium)
        customLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        customLabel.sizeToFit()
        
        let customLabel2 = UILabel()
        customLabel2.text = "1234567890"
        customLabel2.font = .systemFont(ofSize: 30, weight: .medium)
        customLabel2.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        customLabel2.sizeToFit()
        
        let attribute = AttributedStringItem.view(customView)
        var attachment = AttributedStringItem.ViewAttachment.view(attribute.view, attribute.style)
        let urlRunDelegate  = CTRunDelegateCreate(&imageCallback1, &attachment)
        
        var emptyChar: UInt16 = 0xFFFC
        let emptyString = NSString.init(characters: &emptyChar, length: 1) as String
        let attachmentString = NSMutableAttributedString(string: emptyString)
        attachmentString.addAttribute(kCTRunDelegateAttributeName as NSAttributedString.Key, value: urlRunDelegate as Any, range: NSRange(location: 0, length: 1))
        
        att.append(attachmentString)

        
        let attribute1 = AttributedStringItem.view(customView2)
        var attachment1 = AttributedStringItem.ViewAttachment.view(attribute1.view, attribute1.style)
        let urlRunDelegate1  = CTRunDelegateCreate(&imageCallback1, &attachment1)
        let attachmentString1 = NSMutableAttributedString(string: emptyString)
        attachmentString1.addAttribute(kCTRunDelegateAttributeName as NSAttributedString.Key, value: urlRunDelegate1 as Any, range: NSRange(location: 0, length: 1))
        att.append(attachmentString1)

 
        let typesetter = CTTypesetterCreateWithAttributedString(att)
        let framesetter = CTFramesetterCreateWithTypesetter(typesetter)
        
        let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path.cgPath, nil)
        
        sizeToFit()
        CTFrameDraw(ctframe,context!)
        
        
            
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
//                        for (_, containView) in attachmentViews {
//                            if (view as! AttributedStringItem.ViewAttachment).view == containView.view {
//                                lastAttHeight = containView.bounds.size.height
//                            }
//                        }
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
//                        for (_, containView) in attachmentViews {
//                            if (view as! AttributedStringItem.ViewAttachment).view == containView.view {
//    //                            containView.frame = runRect
//
//                                let size = containView.bounds.size
//                                containView.frame = CGRect(runRect.origin.x,
//                                                           lineY,
//                                                           size.width,
//                                                           size.height)
//                                print("😁containView.frame: ", containView.frame, "view.hieght: \(self.bounds.size.height)")
//                                continue
//                            }
//                        }
                    }
                }
                
                print("\n ---------------- line --------------  \n")
            }
                
                     
                }
        
        
    
}


class AttttttachmentController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
       let label = MGLabel(frame: CGRect(10, 90, 394, 500))
        label.backgroundColor = .brown
        view.addSubview(label)
        label.sizeToFit()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
