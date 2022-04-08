//
//  FontController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class FontController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let fontAtt = AttributedString(
            .string("字号10的大小\n", [.font(.size(10, .regular))]),
            .string("字号13的大小\n", [.font(.size(13, .regular))]),
            .string("字号16的大小\n", [.font(.size(16, .regular))]),
            .string("字号19的大小\n", [.font(.size(19, .regular))]),
            .string("字号21的大小\n", [.font(.size(21, .regular))]),
            .string("字号24的大小\n", [.font(.size(24, .regular))]),
            .string("字号30的大小\n", .font(.size(30, .regular))),
            .string("字号24的大小\n", .font(.size(24, .bold))),
            .string("字号21的大小\n", .font(.size(21, .bold))),
            .string("字号19的大小\n", .font(.size(19, .bold))),
            .string("字号16的大小\n", .font(.size(16, .bold))),
            .string("字号13的大小\n", .font(.size(13, .bold))),
            .string("字号10的大小\n", .font(.size(10, .bold)))
        )
        
        textView.attributed.string = fontAtt
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
