//
//  ExpansionController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ExpansionController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let expansion = AttributedString(
            .string("expansion: none\n"),
            .string("expansion: 0\n", .expansion(0)),
            .string("expansion: 0.1\n", .expansion(0.1)),
            .string("expansion: 0.3\n", .expansion(0.3)),
            .string("expansion: 0.5\n", .expansion(0.5)),
            .string("expansion: 1\n",   .expansion(1)),
            .string("expansion: -0.1\n", .expansion(-0.1)),
            .string("expansion: -0.3\n", .expansion(-0.3)),
            .string("expansion: -0.5\n", .expansion(-0.5)),
            .string("expansion: -1\n",   .expansion(-1))
        )
        
        textView.attributed.string = expansion
        Label.attributed.string = expansion
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
