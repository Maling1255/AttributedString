//
//  FontController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/3/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
//import AttributedString


class AttributedController: UIViewController {

    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!

    @IBOutlet weak var tipViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tipLeftMargin: NSLayoutConstraint!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let size = textView.sizeThatFits(CGSize(view.bounds.size.width, 1500))
        textViewHeight.constant = size.height + 25
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .white

    }
}

extension NSMutableAttributedString {
    
    @discardableResult
    func appendAttributedString(_ att: NSAttributedString) -> NSAttributedString {
        self.append(NSAttributedString.init(string: "\n\n\n"))
        self.append(att)
        return self
    }
}
