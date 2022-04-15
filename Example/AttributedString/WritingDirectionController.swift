//
//  WritingDirectionController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class WritingDirectionController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let writingDirection = AttributedString(
            .string("writingDirection: none\n"),
            .string("writingDirection: LRE\n", [.writingDirection(.LRE)]),
            .string("writingDirection: RLE\n", [.writingDirection(.RLE)]),
            .string("writingDirection: LRO\n", [.writingDirection(.LRO)]),
            .string("writingDirection: RLO\n", [.writingDirection(.RLO)])
        )
        
        textView.attributed.string = writingDirection
        Label.attributed.string = writingDirection
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
