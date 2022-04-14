//
//  BackgroundController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class BackgroundController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor = AttributedString(
            .string("black Color\n", .background(.black)),
            .string("darkGray Color\n", .background(.darkGray)),
            .string("lightGray Color\n", .background(.lightGray)),
            .string("white Color\n", .background(.white)),
            .string("gray Color\n", .background(.gray)),
            .string("red Color\n", .background(.red)),
            .string("green Color\n", .background(.green)),
            .string("blue Color\n", .background(.blue)),
            .string("cyan Color\n", .background(.cyan)),
            .string("blue Color\n", .background(.blue)),
            .string("yellow Color\n", .background(.yellow)),
            .string("magenta Color\n", .background(.magenta)),
            .string("orange Color\n", .background(.orange)),
            .string("purple Color\n", .background(.purple)),
            .string("brown Color\n", .background(.brown)),
            .string("clear Color\n", .background(.clear))
        )
        
        textView.attributed.string = backgroundColor
        Label.attributed.string = backgroundColor
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
