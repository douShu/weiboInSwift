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
    /// 是否是 modal 的标识
    var isPresend = false

    
    /// 数据
    private var statuses: [Status]? {
    
        didSet{
            
            tableView.reloadData()
        }
    }
    
    private lazy var refreshlabel: UILabel = {
        
        let h: CGFloat = 44
        let l: UILabel = UILabel(frame: CGRect(x: 0, y: -2 * h, width: self.view.bounds.width, height: h))
        
        l.backgroundColor = UIColor.orangeColor()
        l.textColor = UIColor.whiteColor()
        l.textAlignment = NSTextAlignment.Center
        
        self.navigationController?.navigationBar.insertSubview(l, atIndex: 0)
        
        return l
    }()
    
    
    // MARK: - ----------------------------- 构造方法 -----------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置登录界面
        if UserAccount.sharedUserAccount == nil {
        
            visitLoginView?.setupLoginImageView(true, imgName: "visitordiscover_feed_image_smallicon", message: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        /// 设置tableview
        setupTableview()
        
        /// 加载数据
        loadData()
        
        /// 接受点击配图的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "photoBrowser:", name: DSPictureViewCellSelectPhotoNotification, object: nil)
        
    }

    /// 设置tableview
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
    
    /// 注销通知
    deinit {
    
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - ----------------------------- 显示大配图 -----------------------------
    func photoBrowser(n: NSNotification) {
    
        /// modal 浏览图片控制器
        /// 从自定义的通知中拿取参数, 一定要进行判断
        guard let largerPictureURLs = n.userInfo![DSPictureViewCellSelectPhotoURLKEY] as? [NSURL] else {
        
            print("没有传递largerPictureURLs")
            return
        }
        guard let indexPath = n.userInfo![DSPictureViewCellSelectPhotoIndexKEY] as? NSIndexPath else {
        
            print("没有传递indexPath")
            return
        }
        let vc = PhotoBrowserController(largerPictureURLs: largerPictureURLs, index: indexPath.item)
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.transitioningDelegate = self
        
        presentViewController(vc, animated: true, completion: nil)
        
    }
    // MARK: - ----------------------------- 刷新加载数据 -----------------------------
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
        
        /// UIView的动画底层是通过layer来实现的
        if refreshlabel.layer.animationForKey("position") != nil {
        
            print("正在刷新, 请耐心等待")
            return
        }
    
        refreshlabel.text = "刷新到\(count)条微博"
        let rect = refreshlabel.frame
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            
            // 自动反转
            UIView.setAnimationRepeatAutoreverses(true)
            
            self.refreshlabel.frame = CGRectOffset(self.refreshlabel.frame, 0, 3 * 44)
            
            }) { (_) -> Void in
                
                self.refreshlabel.frame = rect
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


// MARK: - ----------------------------- 自定义转场的协议 -----------------------------
extension HomeTableViewController: UIViewControllerTransitioningDelegate {

    /// 返回提供转场动画的遵守: UIViewControllerTransitioningDelegate 协议的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresend = true
        
        return self
    }
    

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    
        isPresend = false
        
        return self
    }
}


// MARK: - ----------------------------- 自定义转场动画 -----------------------------
extension HomeTableViewController: UIViewControllerAnimatedTransitioning {

    /// 转场动画时常
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    
        return 0.5
    }

    /**
    transitionContext 提供了转场动画需要的元素
    
    completeTransition(true) 动画结束后必须调用的
    containerView() 容器视图
    
    viewForKey      获取到转场的视图
    */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
        if isPresend {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            
            transitionContext.containerView()?.addSubview(toView!)
            toView?.alpha = 0.0
            
            UIView.animateWithDuration(transitionDuration(transitionContext)) { () -> Void in
                
                toView?.alpha = 1.0
            }
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                toView?.alpha = 1.0
                }) { (_) -> Void in
                    
                    transitionContext.completeTransition(true)
            }
        } else {
        
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
                
                fromView!.alpha = 0.0
                }, completion: { (_) -> Void in
                    
                    fromView?.removeFromSuperview()
                    
                    transitionContext.completeTransition(true)
            })
        }
    }

}