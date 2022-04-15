//
//  KernController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class KernController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let kernAttributedString = AttributedString(
            .string("这是像素为0间距\n", .kern(0)),
            .string("这是像素为2间距\n", .kern(2)),
            .string("这是像素为4间距\n", .kern(4)),
            .string("这是像素为6间距\n", .kern(6)),
            .string("这是像素为8间距\n", .kern(8)),
            .string("这是像素为10间距\n", .kern(10)),
            .string("这是像素为8间距\n", .kern(8)),
            .string("这是像素为6间距\n", .kern(6)),
            .string("这是像素为4间距\n", .kern(4)),
            .string("这是像素为2间距\n", .kern(2)),
            .string("这是像素为0间距\n", .kern(0))
        )
        
        textView.attributed.string = kernAttributedString
        Label.attributed.string = kernAttributedString
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
