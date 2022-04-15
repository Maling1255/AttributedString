//
//  StrikethroughController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class StrikethroughController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let strikethroughAttributedString = AttributedString(
            .string("strikethrough: single\n", .strikethroughStyle(.single)),
            .string("strikethrough: thick\n", .strikethroughStyle(.thick)),
            .string("strikethrough: double\n", .strikethroughStyle(.double)),
            .string("strikethrough: 1\n", .strikethroughStyle(.init(rawValue: 1))),
            .string("strikethrough: 2\n", .strikethroughStyle(.init(rawValue: 2))),
            .string("strikethrough: 3\n", .strikethroughStyle(.init(rawValue: 3))),
            .string("strikethrough: 4\n", .strikethroughStyle(.init(rawValue: 4))),
            .string("strikethrough: 5\n", .strikethroughStyle(.init(rawValue: 5))),
            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 1), color: .red)),
            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 2), color: .cyan)),
            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 3), color: .orange)),
            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 4), color: .purple)),
            .string("strikethrough: 5\n", .strikethrough(.init(rawValue: 5), color: .brown))
        )
        textView.attributed.string = strikethroughAttributedString
        Label.attributed.string = strikethroughAttributedString
        
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
