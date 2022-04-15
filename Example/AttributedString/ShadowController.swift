//
//  ShadowController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ShadowController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let shadowAttributedString = AttributedString(
            .string("shadow: defalut\n", .shadow()),
            .string("shadow: offset 0 radius: 4 color: default\n", [.shadow(offset: .zero, blurRadius: 4)]),
            .string("shadow: offset 0 radius: 4 color: blue\n", [.shadow(offset: .zero, blurRadius: 4, color: .blue)]),
            .string("shadow: offset 0 radius: default color: blue\n", [.shadow(offset: .zero, blurRadius: 0, color: .blue)]),
            .string("shadow: offset 3 radius: 4 color: red\n", [.shadow(offset: .init(width: 0, height: 3), blurRadius: 4, color: .gray)]),
            .string("shadow: offset 3 radius: 10 color: red\n", [.shadow(offset: .init(width: 0, height: 3), blurRadius: 10, color: .red)]),
            .string("shadow: offset 10 radius: 1 color: red\n", [.shadow(offset: .init(width: 0, height: 10), blurRadius: 3, color: .red)]),
            .string("shadow: offset 4 radius: 3 color: cyan\n", [.shadow(offset: .init(width: 0, height: 4), blurRadius: 3, color: .cyan)])
        )
        
        textView.attributed.string = shadowAttributedString
        Label.attributed.string = shadowAttributedString
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
