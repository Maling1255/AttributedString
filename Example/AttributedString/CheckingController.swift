//
//  CheckingController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/25.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class CheckingController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        func clicked(_ result: AttributedString.Action.Result) {
            switch result.content {
            case .string(let value):
                print("点击了文本: \n\(value) \nrange: \(result.range)")
                
                view.makeToast(value.string)
            case .attachment(let value):
                print("点击了附件: \n\(value) \nrange: \(result.range)")
                
            }
        }
        
        
        var string = AttributedString(string: " My name is Li Xiang, my mobile phone number is 18611401994, my email address is 18611401994@163.com, I live in No.10 Xitucheng Road, Haidian District, Beijing, China, and it is now 20:30 on June 28, 2020. My GitHub homepage is https://github.com/lixiang1994. Welcome to star me!")
        
        string.append(AttributedString(
            .string("Contact me", [.action(clicked)])
        ))
        
        string.add(checkings: [.phoneNumber], [.foreground(.green)])
        string.add(checkings: [.link], [.foreground(.blue), .action{ result in
            self.view.makeToast(result.content.value()!)
        }])
        string.add(checkings: [.date], [.font(.size(18, .bold)), .foreground(.brown)])
        string.add(checkings: [.regex("Li Xiang")], [.foreground(.purple)])
        string.add(checkings: [.address], [.font(.size(25, .bold)), .background(.gray)])
        string.add(checkings: [.action], [.background(.purple), .font(.size(21))])
        

        
        textView.attributed.string = string
        Label.attributed.string = string
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
