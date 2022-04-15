//
//  UnderlineController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class UnderlineController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let underline = AttributedString(
            .string("single\n", .font(.size(18))),
            .string("thick\n", [.font(.size(18)), .underlineStyle(.thick)]),
            .string("styleDouble\n", [.font(.size(18)), .underlineStyle(.double)]),
            
            .string("patternDot\n", [.font(.size(18)), .underlineStyle([.patternDot, .thick])]),
            .string("patternDash\n", [.font(.size(18)), .underlineStyle([.patternDash, .thick])]),
            .string("patternDashDot\n", [.font(.size(18)), .underlineStyle([.patternDashDot, .thick])]),
            .string("patternDashDotDot\n", [.font(.size(18)), .underlineStyle([.patternDashDotDot, .thick])]),
            
            .string("byWord\n", [.font(.size(18)), .underlineStyle(.byWord)]),
            
            .string("rawValue: 1\n", .font(.size(18)), .underlineStyle(.init(rawValue: 1))),
            .string("rawValue: 2\n", .font(.size(18)), .underlineStyle(.init(rawValue: 2))),
            .string("rawValue: 3\n", .font(.size(18)), .underlineStyle(.init(rawValue: 3))),
            .string("rawValue: 4\n", .font(.size(18)), .underlineStyle(.init(rawValue: 4))),
            .string("rawValue: 5\n", .font(.size(18)), .underlineStyle(.init(rawValue: 5))),
            .string("rawValue: 6\n", .font(.size(18)), .underlineStyle(.init(rawValue: 6))),
            .string("rawValue: 7\n", .font(.size(18)), .underlineStyle(.init(rawValue: 7))),
            .string("rawValue: 1\n", .font(.size(18)), .underline(.init(rawValue: 1))),
            .string("rawValue: 8\n", .font(.size(18)), .underline(.single, color: .red)),
            .string("rawValue: 9\n", .font(.size(18)), .underline(.thick, color: .blue)),
            .string("rawValue: 10\n", .font(.size(18)), .underline(.double, color: .cyan)),
            .string("rawValue: 11\n", .font(.size(18)), .underlineColor(.red), .underlineStyle(.init(rawValue: 11))),
            .string("rawValue: 12\n", .font(.size(18)), .underlineColor(.blue), .underlineStyle(.init(rawValue: 12))),
            .string("rawValue: 13\n", .font(.size(18)), .underlineColor(.cyan), .underlineStyle(.init(rawValue: 13)))
            
        )
        
        textView.attributed.string = underline
        
        
        Label.attributed.string = underline
        Label.attributed.lineSpacing(10).backgroundColor(.brown)
      
        

        
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
