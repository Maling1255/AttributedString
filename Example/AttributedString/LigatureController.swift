//
//  LigatureController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class LigatureController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let ligature = AttributedString(
            .string("fltytfhijkflmnopqrfistyz\n", [.ligature(true), .font(.name("futura", size: 21)!)]),
            .string("fltytfhijkflmnopqrfistyz\n", [.ligature(false), .font(.name("futura", size: 21)!)])
        )
        textView.attributed.string = ligature
        Label.attributed.string = ligature
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
