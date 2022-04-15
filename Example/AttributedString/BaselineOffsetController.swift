//
//  BaselineOffsetController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class BaselineOffsetController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let baselineoffset = AttributedString(
            .string("baseline offset: none\n"),
            .string("baseline"),
            .string("baseline offset: 1\n", .baselineOffset(1)),
            .string("baseline"),
            .string("baseline offset: 3\n", .baselineOffset(3)),
            .string("baseline"),
            .string("baseline offset: 5\n", .baselineOffset(5)),
            .string("baseline"),
            .string("baseline offset: -1\n", .baselineOffset(-1)),
            .string("baseline"),
            .string("baseline offset: -3\n", .baselineOffset(-3)),
            .string("baseline"),
            .string("baseline offset: -5\n", .baselineOffset(-5))
        )
        
        textView.attributed.string = baselineoffset
        Label.attributed.string = baselineoffset
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
