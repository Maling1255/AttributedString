//
//  LinkController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class LinkController: AttributedController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let linkString = AttributedString(
            .string("linnk: none\n"),
            .string("link: https://www.apple.com\n", .link("https://www.apple.com"))
        )
        
        textView.attributed.string = linkString
        Label.attributed.string = linkString
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
