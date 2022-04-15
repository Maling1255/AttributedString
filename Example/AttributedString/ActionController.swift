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

        func clicked(_ result: AttributedString.Action.Result) {
            switch result.content {
            case .string(let attString):
                print("点击了文本: \(attString) range: \(result.range)")
                
                view.makeToast(attString.string)
                
            case .attachment(let attString):
                print("点击了附件: \n\(attString) \nrange: \(result.range)")
            }
        }
        
        func pressed(_ result: AttributedString.Action.Result) {
            switch result.content {
            case .string(let value):
                print("按住了文本: \n\(value) \nrange: \(result.range)")
                
                view.makeToast(value.string)
                
            case .attachment(let value):
                print("按住了附件: \n\(value) \nrange: \(result.range)")
            }
        }
        
        let actionAtt = AttributedString(
            .string("这是可以点击的文字\n", [.font(.size(21)), .font(.systemFont(ofSize: 30, weight: .bold)), .action(clicked), .action(.press, pressed)])
        )
        
        
        
        textView.attributed.string = actionAtt
        Label.attributed.string = actionAtt
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
