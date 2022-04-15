//
//  TextEffectController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class TextEffectController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let textEffectAttributedString = AttributedString(
            .string("textEffect: none\n"),
            .string("textEffect: .letterpressStyle\n", .font(.size(30)), .foreground(.brown)),
            .string("textEffect: .letterpressStyle\n", [.textEffect(.letterpressStyle), .font(.size(30)), .foreground(.brown)])
            
        )
        
        textView.attributed.string = textEffectAttributedString
        Label.attributed.string = textEffectAttributedString
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
