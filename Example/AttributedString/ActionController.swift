//
//  ActionController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import Toast_Swift
class ActionController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        func actionClicked(_ result: AttributedString.Action.Result) {
            switch result.content {
            case .string(let attString):
                print("点击了文本: \(attString) range: \(result.range)")
                
                view.makeToast(attString.string)
                
            case .attachment(let attString):
                print("点击了附件: \n\(attString) \nrange: \(result.range)")
                view.makeToast("点击了附件")
            }
        }
        
        func actionPressed(_ result: AttributedString.Action.Result) {
            switch result.content {
            case .string(let value):
                print("按住了文本: \n\(value) \nrange: \(result.range)")
                
                view.makeToast(value.string)
                
            case .attachment(let value):
                print("按住了附件: \n\(value) \nrange: \(result.range)")
                
                view.makeToast("点击了附件")
            }
        }
        
        let custom = AttributedString.Action(.press, highlights: [.background(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), .foreground(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))]) { (result) in
            switch result.content {
            case .string(let value):
                print("按住了文本: \n\(value) \nrange: \(result.range)")
                
                self.view.makeToast(value.string)
            case .attachment(let value):
                print("按住了附件: \n\(value) \nrange: \(result.range)")
                
                self.view.makeToast("点击了附件")
            }
        }
        
        
        // 创建一些自定义视图控件
        let customView = UIView(frame: .init(x: 0, y: 0, width: 100, height: 150))
        customView.backgroundColor = .brown
        
        
        let customImageView = UIImageView(image: #imageLiteral(resourceName: "swift-image-1"))
        customImageView.contentMode = .scaleAspectFill
        customImageView.sizeToFit()

        
        
        let customLabel = UILabel()
        customLabel.text = "1234567890"
        customLabel.font = .systemFont(ofSize: 30, weight: .medium)
        customLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        customLabel.sizeToFit()
        
        let actionAtt = AttributedString(
            .string("自定义", [.font(.size(21))]),
            
            .string("这是可以点击的文字\n", [.font(.size(21)), .font(.systemFont(ofSize: 30, weight: .bold)), .action(actionClicked), .action(.press, actionPressed)]),
            .string("image 可以点击", .font(.size(21))),
            .image(UIImage(named: "swift-icon")!, .custom(.center, size: .init(width: 50, height: 50)), newline: .none, action: .action(actionClicked)),
            .string("长按响应事件\n", [.font(.size(21)), .action(.press, actionPressed)]),
            .string("自定义点击高亮", [.font(.size(21)), .action(custom)]),
            
            
            .view(customView, .original(.center), action: .action(actionClicked)),
            .view(customImageView, .original(.origin), action: .action(actionClicked)),
            .view(customLabel, .original(.center), newline: .trailing, action: .action(actionClicked))
        )
        
        
        
        textView.attributed.string = actionAtt
//        Label.attributed.string = actionAtt
        
        Label.backgroundColor = .cyan
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
