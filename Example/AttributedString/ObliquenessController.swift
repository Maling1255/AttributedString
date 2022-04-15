//
//  ObliquenessController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ObliquenessController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let obliqueness = AttributedString(
            .string("obliqueness: none\n"),
            .string("obliqueness: 0.1\n", .obliqueness(0.1)),
            .string("obliqueness: 0.3\n", .obliqueness(0.3)),
            .string("obliqueness: 0.5\n", .obliqueness(0.5)),
            .string("obliqueness: 1\n", .obliqueness(1)),
            .string("obliqueness: -0.1\n", .obliqueness(-0.1)),
            .string("obliqueness: -0.3\n", .obliqueness(-0.3)),
            .string("obliqueness: -0.5\n", .obliqueness(-0.5)),
            .string("obliqueness: -1\n", .obliqueness(-1))
        )
        
        textView.attributed.string = obliqueness
        Label.attributed.string = obliqueness
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
