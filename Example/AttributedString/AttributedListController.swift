//
//  AttributedListController.swift
//  AttributedString_Example
//
//  Created by maling on 2022/4/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class AttributedListController: UITableViewController {

    
    var modes: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        modes = ["Font", "ParagraphStyle", "ForegroundColor"]
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "list_cell_id")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "list_cell_id")
        }
        if #available(iOS 14.0, *) {
            var content = cell?.defaultContentConfiguration()
            content?.text = "\(indexPath.row)"
            cell?.contentConfiguration = content
        } else {
            cell?.textLabel?.text = "\(indexPath.row)"
        }
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var string = modes[indexPath.row]
        string.append("Controller")
//        FontController
        

        let a: AnyClass! =  swiftClassFromString(className: string)
        
        
        let b = a as! UIViewController.Type
        self.navigationController?.pushViewController(b.init(), animated: true)
    }

    
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
