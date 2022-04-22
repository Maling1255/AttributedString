//
//  AttachmentController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class AttachmentController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 创建一些自定义视图控件
        let customView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 150))
        customView.backgroundColor = .brown
        let customView2 = UIView(frame: .init(x: 0, y: 0, width: 350, height: 100))
        customView2.backgroundColor = .red
        
        
        
        let customImageView = UIImageView(image: #imageLiteral(resourceName: "swift-image-1"))
        customImageView.contentMode = .scaleAspectFill
        customImageView.sizeToFit()
        let customImageView2 = UIImageView(image: #imageLiteral(resourceName: "swift-image-1"))
        customImageView2.contentMode = .scaleAspectFill
        customImageView2.sizeToFit()
        
        
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
        
        
//        let attachmentAttributedString = AttributedString(
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
        
        let attachmentAttributedString2 = AttributedString(
            .string("建议大小", [.font(.size(21))]),
            
//            .string("原始大小:", [.font(.size(21))]),
//            .image(UIImage(named: "swift-icon")!, .original(), newline: .none),
//            .string("自定义大小", [.font(.size(21))]),
//            .image(UIImage(named: "swift-icon")!, .custom(.center, size: .init(width: 50, height: 50)), newline: .none),
//            .view(customView2, .original(.center), newline: .none),
            .view(customView, .original(.center), newline: .none),
            .view(customLabel2, .original(.center), newline: .none),
            .image(UIImage(named: "swift-icon")!, .proposed())
//            .view(customImageView2, .original(.origin))      
//            .view(customLabel2, .original(.center), newline: .trailing)
//            .string("建议大小", [.font(.size(21))])
        )
        
//        textView.attributed.string = attachmentAttributedString
//        Label.attributed.lineSpacing(10)
        Label.attributed.string = attachmentAttributedString2
        Label.backgroundColor = .cyan
        
//        Label.sizeToFit()
        
//        let fitSize = Label.sizeThatFits(CGSize(1000, 2000))
//        Label.frame = CGRect(Label.frame.origin.x, Label.frame.origin.y, fitSize.width, fitSize.height)
        
//        print(Label.sizeThatFits(CGSize(1000, 2000)), Label.frame,Label.bounds,  self.view.frame)
//
//        print(Label.numberOfLines)
        
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
