//
//  VerticalGlyphFormController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class VerticalGlyphFormController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let verticalGlyphForm = AttributedString(
            .string("verticalGlyphForm: none\n"),
            .string("verticalGlyphForm: 1\n", [.verticalGlyphForm(true)]),
            .string("verticalGlyphForm: 0\n", [.verticalGlyphForm(false)]),
            .string("Currently on iOS, it's always horizontal.\n", [.font(.size(21)), .foreground(.red)])
        )
        
        textView.attributed.string = verticalGlyphForm
        Label.attributed.string = verticalGlyphForm
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
