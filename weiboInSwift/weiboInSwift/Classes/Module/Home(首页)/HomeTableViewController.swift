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
        
        // 设置tableview
        setupTableview()
        
        // 加载数据
        loadData()
    }

    // 设置tableview
    private func setupTableview() {
    
        // 注册cell
        tableView.registerClass(NormalCell.self, forCellReuseIdentifier: StatusCellID.NormalCell.rawValue)
        tableView.registerClass(RetweetCell.self, forCellReuseIdentifier: StatusCellID.RetweetCell.rawValue)
        
        tableView.rowHeight = 300
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        // 设置下拉刷新控件
        refreshControl = DSRefreshControl()
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    // MARK: - ----------------------------- 加载数据 -----------------------------
    private var pullUpRefreshFlag = false
    func loadData() {
        
        // 开始刷新
        refreshControl?.beginRefreshing()
        
        var since_id = statuses?.first?.id ?? 0
        
        var max_id = 0
        
        if pullUpRefreshFlag {
        
            since_id = 0
            max_id = statuses?.last?.id ?? 0
        }
        Status.loadLists(since_id, max_id: max_id) { (lists, error) -> () in
           
            // 结束刷新
            self.refreshControl?.endRefreshing()
            
            // 对下拉刷新标记进行复位
            self.pullUpRefreshFlag = false
            
            if error != nil {
                
                print(error)
                return
            }
            
            let count = lists?.count ?? 0
            
            if since_id > 0 {
            
                self.showPullDownTip(count)
            }
            
            if count == 0 {
            
                return
            }
            
            
            if since_id > 0 { // 做下拉刷下
            
                self.statuses = lists! + self.statuses!
            } else if max_id > 0 { // 做上拉刷新
            
                self.statuses = self.statuses! + lists!
            } else {
            
                self.statuses = lists
            }
        }
    }
    
    /// 显示刷新了几条微博
    ///
    /// - parameter count: 微博数
    private func showPullDownTip(count: Int) {
    
        let h: CGFloat = 44
        let l: UILabel = UILabel(frame: CGRect(x: 0, y: -2 * h, width: view.bounds.width, height: h))
        l.backgroundColor = UIColor.orangeColor()
        l.textColor = UIColor.whiteColor()
        l.textAlignment = NSTextAlignment.Center
        l.text = "刷新到\(count)条微博"
        
        navigationController?.navigationBar.insertSubview(l, atIndex: 0)
        
        let rect = l.frame 
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            
            // 自动反转
            UIView.setAnimationRepeatAutoreverses(true)
            
            l.frame = CGRectOffset(l.frame, 0, 3 * h)
            
            }) { (_) -> Void in
                
                l.frame = rect
//                l.removeFromSuperview()
        }
    }
    
    // MARK: - ----------------------------- 数据源方法 -----------------------------
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statuses?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let status = statuses![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StatusCellID.cellID(status), forIndexPath: indexPath) as! StatusCell
        
        if indexPath.row == (statuses?.count)! - 1 {
        
            pullUpRefreshFlag = true
            
            loadData()
        }
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