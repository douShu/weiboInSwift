//
//  BaseTableViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/6.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var userLogin: Bool = false
    
    override func loadView() {
        
        userLogin ? super.loadView() : (view = UIView())
    }

}
