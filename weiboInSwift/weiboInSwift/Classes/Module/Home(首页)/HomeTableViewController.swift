//
//  HomeTableViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/6.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseTableViewController {

    
    // MARK: - ----------------------------- 属性 -----------------------------
    // 数据
    private var statuses: [Status]? {
    
        didSet{
            
            tableView.reloadData()
        }
    }
    
    // MARK: - ----------------------------- 构造方法 -----------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置登录界面
        if UserAccount.sharedUserAccount == nil {
        
            visitLoginView?.setupLoginImageView(true, imgName: "visitordiscover_feed_image_smallicon", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
    
        refreshControl = UIRefreshControl()
        // 加载数据
        loadData()
        
        // 设置tableview
        setupTableview()
    }

    // 设置tableview
    private func setupTableview() {
    
        // 注册cell
        tableView.registerClass(NormalCell.self, forCellReuseIdentifier: StatusCellID.NormalCell.rawValue)
        tableView.registerClass(RetweetCell.self, forCellReuseIdentifier: StatusCellID.RetweetCell.rawValue)
        
        tableView.rowHeight = 300
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    // MARK: - ----------------------------- 加载数据 -----------------------------
    private func loadData() {
        
        Status.loadLists { (lists, error) -> () in
            
            if error != nil {
                
                print(error)
                return
            }
            self.statuses = lists
        }
    }
    
    
    // MARK: - ----------------------------- 数据源方法 -----------------------------
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statuses?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let status = statuses![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellID.cellID(status), forIndexPath: indexPath) as! StatusCell
        
        cell.status = status
        
        return cell
    }
    
    
    // MARK: - ----------------------------- 代理方法 -----------------------------
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let status = statuses![indexPath.row]
        
        if let h = status.rowHeight  {
        
            return h
        }
        
        // 返回高度
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellID.cellID(status)) as! StatusCell
        
        status.rowHeight = cell.rowHeight(status)
        
        return status.rowHeight!
    }
  
    
}