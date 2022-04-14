//
//  ParagraphStyleController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ParagraphStyleController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let paragraph = AttributedString(
            .string(
                        """
                 这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试
        
              🔥段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等\n
        """
                        , [.font(.size(17)), .foreground(.brown), .paragraph(.lineSpacing(10), .headIndent(20), .firstLineHeadIndent(50))]),
            
                .string(
                            """
                  段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等\n
            """
                            , [.font(.size(17)), .foreground(.brown), .paragraph([.firstLineHeadIndent(20), .paragraphSpacingBefore(80), .alignment(.right)])])
        )
        
        textView.attributed.string = paragraph
//        Label.attributed.string = paragraph
        
        Label.text = """
        这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试

        🔥段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等这是一段很长的文字,用来测试段落的,包括行间距,首行缩进等\n
        """

        Label.attributed
            .lineSpacing(40)
            .firstLineHeadIndent(40)
            .headIndent(20)
            .kern(20)
            .font(UIFont.systemFont(ofSize: 17))
            .writingDirection(.RTL, range: NSMakeRange(0, 10))
        
        
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
