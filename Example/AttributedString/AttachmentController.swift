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
        let customView2 = UIView(frame: .init(x: 0, y: 0, width: 150, height: 100))
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
        customLabel2.text = "1234"
        customLabel2.font = .systemFont(ofSize: 30, weight: .medium)
        customLabel2.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        customLabel2.sizeToFit()
        let customLabel3 = UILabel()
        customLabel3.text = "123456"
        customLabel3.font = .systemFont(ofSize: 50, weight: .medium)
        customLabel3.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        customLabel3.sizeToFit()
        
        let customLabel4 = UILabel()
        customLabel4.text = "123456"
        customLabel4.font = .systemFont(ofSize: 50, weight: .medium)
        customLabel4.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        customLabel4.sizeToFit()
        
        let customLabel5 = UILabel()
        customLabel5.text = "1234567890"
        customLabel5.font = .systemFont(ofSize: 50, weight: .medium)
        customLabel5.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        customLabel5.sizeToFit()
        
        let customLabel6 = UILabel()
        customLabel6.text = "12345"
        customLabel6.font = .systemFont(ofSize: 35, weight: .medium)
        customLabel6.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        customLabel6.sizeToFit()
        customLabel6.tag = 3
        
        let customLabel7 = UILabel()
        customLabel7.text = "12345"
        customLabel7.font = .systemFont(ofSize: 35, weight: .medium)
        customLabel7.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        customLabel7.sizeToFit()
        customLabel7.tag = 3
        
        let customLabel8 = UILabel()
        customLabel8.text = "12345"
        customLabel8.font = .systemFont(ofSize: 35, weight: .medium)
        customLabel8.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        customLabel8.sizeToFit()
        customLabel8.tag = 3
        
        let attachmentAttributedString = AttributedString(
            .string("建议大小", [.font(.size(21))]),
            .image(UIImage(named: "swift-icon")!, .proposed(), newline: .trailing),
            .string("原始大小:", [.font(.size(21))]),
            .image(UIImage(named: "swift-icon")!, .original(), newline: .trailing),
            .string("自定义大小", [.font(.size(21))]),
            .image(UIImage(named: "swift-icon")!, .custom(.center, size: .init(width: 50, height: 50)), newline: .trailing),
            .view(customView, .original(.center)),
//            .view(customImageView, .custom(.origin, size: CGSize(100, 50))),
            .view(customImageView, .original(.origin)),
            .view(customLabel, .original(.center), newline: .trailing)
            
        )
        

        
        // ----------------------------------------- Label ----------------------------------------------
        
        let attachmentAttributedString2 = AttributedString(
            .string("建议大小", [.font(.size(21))]),
            
//            .image(UIImage(named: "swift-icon")!, .original(), newline: .none),
//            .image(UIImage(named: "swift-icon")!, .custom(size: CGSize(50, 50)), newline: .none),
             .image(UIImage(named: "swift-icon")!, .proposed(), newline: .none),
            .view(customLabel2, .original(.center), newline: .none),
            .string("建议大小", [.font(.size(21))])
        )
        
        let attachmentAttributedString3 = AttributedString(
            .string("建议大小", [.font(.size(21))]),
            .view(customLabel2, .original(.center), newline: .none),
            .image(UIImage(named: "swift-icon")!, .original(), newline: .none),
            .view(customLabel3, .original(.center), newline: .none),
            .image(UIImage(named: "swift-icon")!, .proposed()),
//            .string("建", [.font(.size(21))]),
            .view(customLabel4, .original(.center), newline: .none),
            .image(UIImage(named: "swift-icon")!, .proposed()),
            .view(customLabel5, .original(.center), newline: .none)
//            .string("测试文字超试文字超出范围测试文字超出范围试文字超出范围测试文字超出范围出范围测试文字超出范围", [.font(.size(30))]),
//            .view(customLabel6, .original(.center), newline: .none),
//            .image(UIImage(named: "swift-icon")!, .original()),
//            .image(UIImage(named: "swift-icon")!, .proposed()),
//            .image(UIImage(named: "swift-icon")!, .proposed()),
//            .view(customLabel7, .original(.center), newline: .none),
//            .image(UIImage(named: "swift-icon")!, .proposed()),
//            .view(customLabel8, .original(.center), newline: .none),
//            .view(customImageView, .original(.origin))
        )
        let attachmentAttributedString4 = AttributedString(
            .image(UIImage(named: "swift-icon")!, .original(), newline: .none),
            .string("建议大小", [.font(.size(21))]),
            .view(customLabel3, .original(.center), newline: .none),
            .view(customLabel2, .original(.center), newline: .none),
            .image(UIImage(named: "swift-icon")!, .proposed())

        )
        
//        textView.attributed.string = attachmentAttributedString3
        
        Label.tag = 10086
        
        Label.attributed.string = attachmentAttributedString3
        Label.backgroundColor = .cyan
        
        // 文字间距
//        Label.attributed.kern(5)
        
        
        
        
        
        tipViewHeight.constant = 300
        tipLeftMargin.constant = 197.8631//110.4895
        //   105
        
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
