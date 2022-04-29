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
        
       let label = UILabel(frame: CGRect(30, 100, 300, 300))
//        label.text = "这是我的测试文本,可能很长很长,具体要看还剩余多长时间下班,下班了我就不写了"
        label.text = "这是我的测试文本,可能很长很长,具体要要看还剩余多长时间下班,下班了我就不写了"
//        label.attributed
//            .font(.systemFont(ofSize: 21))
//            .textColor(.brown)
//            .backgroundColor(.cyan)
//            .lineBreakMode(.byCharWrapping)
//            .numberOfLines(0)
////            .minimumScaleFactor(0.7)
////            .baselineAdjustment(.none)
////            .adjustsFontSizeToFitWidth(true)
////            .allowsDefaultTighteningForTruncation(true)
//            .showsExpansionTextWhenTruncated(true)
        view.addSubview(label)
        label.backgroundColor = .cyan
        
        let info = [
            NSMutableDictionary(object: "0", forKey: "0" as NSCopying),
            NSMutableDictionary(object: "1", forKey: "1" as NSCopying),
            NSMutableDictionary(object: "2", forKey: "2" as NSCopying),
            NSMutableDictionary(object: "3", forKey: "3" as NSCopying),
            NSMutableDictionary(object: "4", forKey: "4" as NSCopying),
            NSMutableDictionary(object: "5", forKey: "5" as NSCopying),
           
//            ["1" : "1"] as! NSMutableDictionary,
//            ["2" : "2"] as! NSMutableDictionary,
//            ["3" : "3"] as! NSMutableDictionary,
//            ["4" : "4"] as! NSMutableDictionary,
//            ["5" : "5"] as! NSMutableDictionary,
        ] as! NSArray
        
  
        let v = UIButton.init(frame: CGRect(0, 0, 100, 100))
        v.backgroundColor = .red
        v.addTarget(self, action: #selector(click), for: .touchUpInside)
        
        let customLabel = UILabel()
        customLabel.text = "1234567890"
        customLabel.font = .systemFont(ofSize: 30, weight: .medium)
        customLabel.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        customLabel.sizeToFit()
        let customLabel2 = UILabel()
        customLabel2.text = "1234"
        customLabel2.font = .systemFont(ofSize: 30, weight: .medium)
        customLabel2.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        customLabel2.sizeToFit()
        let customLabel3 = UILabel()
        customLabel3.text = "123456"
        customLabel3.font = .systemFont(ofSize: 50, weight: .medium)
        customLabel3.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        customLabel3.sizeToFit()
        
        let customLabel4 = UILabel()
        customLabel4.text = "123456"
        customLabel4.font = .systemFont(ofSize: 50, weight: .medium)
        customLabel4.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        customLabel4.sizeToFit()
        
        let customLabel5 = UILabel()
        customLabel5.text = "1234567890"
        customLabel5.font = .systemFont(ofSize: 50, weight: .medium)
        customLabel5.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        customLabel5.sizeToFit()
        
        let customLabel6 = UILabel()
        customLabel6.text = "12345"
        customLabel6.font = .systemFont(ofSize: 35, weight: .medium)
        customLabel6.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        customLabel6.sizeToFit()
        customLabel6.tag = 3
        
        
        guard let image1 = getImageFromView(view: v) else {
          return
        }
        
        let textAtt1 = NSTextAttachment()
        textAtt1.image = image1
        textAtt1.bounds = CGRect(0, 0, 100, 100)
        
        guard let image2 = getImageFromView(view: customLabel6) else {
          return
        }
        
        let textAtt2 = NSTextAttachment()
        textAtt2.image = image2
//        textAtt2.bounds = CGRect(0, 0, 100, 100)
        
        let attStr = NSMutableAttributedString(attachment: textAtt1)
        attStr.append(NSAttributedString(string: "我的测试数据"))
        attStr.append(NSMutableAttributedString(attachment: textAtt2))
        
        label.attributed.string = AttributedString(
            [.image(image1),
             .string("测试数据 "),
             .image(image2)
            ]
        )
        
    }
    
    @objc func click() {
        print("点击了button")
    }
    
    
    func getImageFromView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
}
