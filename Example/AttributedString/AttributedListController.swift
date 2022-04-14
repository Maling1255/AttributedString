//
//  AttributedListController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

struct Model {
    let title: String
    let explain: String
}

class AttributedListController: UITableViewController {

    
    var modes: [Model] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        modes = [
            Model(title: "Font", explain: "字体"),
            Model(title: "ParagraphStyle", explain: "段落样式"),
            Model(title: "Foreground", explain: "前景色"),
            Model(title: "Background", explain: "背景色"),
            Model(title: "Ligature", explain: "连体字"),
            Model(title: "Underline", explain: "下划线"),
            
            
            Model(title: "Test", explain: "🔥测试控制器"),
        ]
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "list_cell_id")
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "list_cell_id")
        }
        
        cell?.accessoryType = .disclosureIndicator
        
        let modes = modes[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell?.defaultContentConfiguration()
            content?.text = modes.title
            content?.secondaryText = modes.explain
            cell?.contentConfiguration = content
        } else {
            cell?.textLabel?.text = modes.title
            cell?.detailTextLabel?.text = modes.explain
        }
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let modes = modes[indexPath.row]
        
        if (modes.title == "Test") {
            self.navigationController?.pushViewController(TestController(), animated: true)
            return
        }
        
        var string = modes.title
        string.append("Controller")

        let anyClass: AnyClass! =  swiftClassFromString(className: string)
        let subClass = anyClass as! UIViewController.Type
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let baseVC: AttributedController = storyboard.instantiateViewController(withIdentifier: "AttributedController_id") as! AttributedController
        
        baseVC.title = " \(modes.title) "
        
        
        
        
        // 当前指针指向子类
        object_setClass(baseVC, subClass)
        self.navigationController?.pushViewController(baseVC, animated: true)
    }

    
    // 加载转换的类 需要添加工程路径
    func swiftClassFromString(className: String) -> AnyClass! {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
            // YourProject.className
            let classStringName = appName + "." + className
            return NSClassFromString(classStringName)
        }
        return nil;
    }
}
