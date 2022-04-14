//
//  ForegroundController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ForegroundController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let foregroundColor = AttributedString(
            .string("black Color\n", .foreground(.black)),
            .string("darkGray Color\n", .foreground(.darkGray)),
            .string("lightGray Color\n", .foreground(.lightGray)),
            .string("white Color\n", .foreground(.white)),
            .string("gray Color\n", .foreground(.gray)),
            .string("red Color\n", .foreground(.red)),
            .string("green Color\n", .foreground(.green)),
            .string("blue Color\n", .foreground(.blue)),
            .string("cyan Color\n", .foreground(.cyan)),
            .string("blue Color\n", .foreground(.blue)),
            .string("yellow Color\n", .foreground(.yellow)),
            .string("magenta Color\n", .foreground(.magenta)),
            .string("orange Color\n", .foreground(.orange)),
            .string("purple Color\n", .foreground(.purple)),
            .string("brown Color\n", .foreground(.brown)),
            .string("clear Color\n", .foreground(.clear))
        )
        
        textView.attributed.string = foregroundColor
        Label.attributed.string = foregroundColor
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
