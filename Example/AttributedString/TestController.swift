//
//  TestController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class TestController: UIViewController {
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
       let label = UILabel(frame: CGRect(30, 100, 200, 21))
//        label.text = "这是我的测试文本,可能很长很长,具体要看还剩余多长时间下班,下班了我就不写了"
        label.text = "这是我的测试文本,可能很长很长,具体要要看还剩余多长时间下班,下班了我就不写了"
        label.attributed
            .font(.systemFont(ofSize: 21))
            .textColor(.brown)
            .backgroundColor(.cyan)
            .lineBreakMode(.byCharWrapping)
            .numberOfLines(0)
//            .minimumScaleFactor(0.7)
//            .baselineAdjustment(.none)
//            .adjustsFontSizeToFitWidth(true)
//            .allowsDefaultTighteningForTruncation(true)
            .showsExpansionTextWhenTruncated(true)
        view.addSubview(label)
        
    }
    
}
