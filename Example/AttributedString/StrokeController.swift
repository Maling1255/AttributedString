//
//  StrokeController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class StrokeController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let strokeAttributedString = AttributedString(
            .string("stroke: 0\n", [.stroke(), .font(.size(30))]),
            .string("stroke: 1\n", .stroke(1)),
            .string("stroke: 2\n", .stroke(2)),
            .string("stroke: 3\n", .stroke(3)),
            .string("stroke: 4\n", .stroke(4)),
            .string("stroke: 5\n", .stroke(5)),
            .string("stroke: 1\n", .stroke(1, color: .red)),
            .string("stroke: 2\n", .stroke(2, color: .blue)),
            .string("stroke: 3\n", .stroke(3, color: .purple)),
            .string("stroke: 4\n", .stroke(4, color: .orange)),
            .string("stroke: 5\n", .stroke(5, color: .brown))
        )
        
        textView.attributed.string = strokeAttributedString
        Label.attributed.string = strokeAttributedString
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
