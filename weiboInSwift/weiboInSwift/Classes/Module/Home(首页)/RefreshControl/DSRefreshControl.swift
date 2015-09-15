//
//  DSRefreshControl.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/13.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

let refreshControlFrameY: CGFloat = -60

class DSRefreshControl: UIRefreshControl {
    
    // MARK: - ----------------------------- 构造方法 -----------------------------
    override init() {

        super.init()
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
//         fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    
    // MARK: - ----------------------------- 重写结束刷新 -----------------------------
    override func endRefreshing() {
        
        super.endRefreshing()
        
        refreshView.endLoadingAnim()
    }
    
    override func beginRefreshing() {
        
        super.beginRefreshing()
        
        refreshView.loadingAnim()
    }
    
    
    // MARK: - ----------------------------- 设置界面 -----------------------------
    private func setupUI() {
    
        // 从XIB中加载view
        addSubview(refreshView)
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
        
        
        /// kvo监听frame
        addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    
    // MARK: - ----------------------------- KVO方法 -----------------------------
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if frame.origin.y > 0 {
    
            return
        }
        
        // 开始加载转轮动画
//        if refreshing{
//        
//            refreshView.loadingAnim()
//        }
        
        // 箭头动画
        if frame.origin.y > refreshControlFrameY && refreshView.rotateFlag {
        
            refreshView.arrowImgDownAnim()
            
            return
        }
        if frame.origin.y < refreshControlFrameY && !refreshView.rotateFlag {
          
            refreshView.arrowImgUpAnim()
        }
    }
    
    deinit {
    
        self.removeObserver(self, forKeyPath: "frame", context: nil)
    }
    
    // MARK: - ----------------------------- 懒加载属性 -----------------------------
    lazy var refreshView: RefreshView = RefreshView.refreshView()
}



// MARK: - ----------------------------- refreshView -----------------------------
class RefreshView: UIView {

    
    // MARK: - ----------------------------- 属性 -----------------------------
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var loadView: UIView!
    @IBOutlet weak var circleView: UIImageView!
    
    private var rotateFlag = false
    
    
    // MARK: - ----------------------------- 类方法创建对象 -----------------------------
    class func refreshView() -> RefreshView {
    
        let v = NSBundle.mainBundle().loadNibNamed("DSRefreshView", owner: nil, options: nil).last as! RefreshView
        
        v.sizeToFit()
        
        return v
    }
    
    
    // MARK: - ----------------------------- 动画 -----------------------------
    /// 箭头动画
    private func arrowImgDownAnim() {
        
        rotateFlag = false
    
        UIView.animateWithDuration(0.5) { () -> Void in
            
            self.arrowImg.transform = CGAffineTransformRotate(self.arrowImg.transform, CGFloat(M_PI - 0.001))
        }
    }
    private func arrowImgUpAnim() {
        
        rotateFlag = true
    
        UIView.animateWithDuration(0.5) { () -> Void in
            
            self.arrowImg.transform = CGAffineTransformRotate(self.arrowImg.transform, CGFloat(M_PI + 0.001))
        }
    }
    
    /// 转轮动画
    func loadingAnim(){
        
        if circleView.layer.animationForKey("circleView") != nil {
        
            return
        }
    
        loadView.hidden = false
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * M_PI
        
        anim.repeatCount = MAXFLOAT
        
        anim.duration = 1.0
        
        circleView.layer.addAnimation(anim, forKey: "circleView")
    }
    
    func endLoadingAnim() {
    
        loadView.hidden = true
        
        circleView.layer.removeAllAnimations()
    }
}
