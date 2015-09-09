//
//  NewfeatureCollectionViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/9.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewfeatureCollectionViewController: UICollectionViewController {
    
    
    // MARK: /**************************** 属性 ****************************/
    /// 新特新界面数
    private let countItem = 4
    
    /// 布局
    private let layout = DSLayout()
    
    
    // MARK: /**************************** 初始化函数 ****************************/
    init() {

        super.init(collectionViewLayout: layout)
        
        collectionView?.backgroundColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        
        // 纯代码开发
        // fatalError("init(coder:) has not been implemented")
        
        // 混合开发
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.registerClass(DSCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

  
    
    // MARK: /**************************** 数据源方法 ****************************/
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return countItem
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DSCell
    
        cell.index = indexPath.item
    
        return cell
    }
    
    // MARK: /**************************** 代理方法 ****************************/
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let index = collectionView.indexPathsForVisibleItems().last!
        
        if index.item + 1 == countItem {
        
            let cell = collectionView.cellForItemAtIndexPath(index) as! DSCell
            cell.btnAnim()
        }
    }
 }




// MARK: /**************************** 新特性界面的cell ****************************/
class DSCell: UICollectionViewCell {

    
    // MARK: /**************************** 属性 ****************************/
    // 开始体验按钮
    private var btn = UIButton()
    
    // 图片
    private var imgView = UIImageView()
    
    // 图片名字
    private var imgName: String?
    
    // 图片索引
    private var index: Int = 0 {
    
        didSet {

            imgName = "new_feature_\(index + 1)"
            imgView.image = UIImage(named: imgName!)
        }
    }
    
    // MARK: /**************************** 初始化方法 ****************************/
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        
         // fatalError("init(coder:) has not been implemented")
        
        // 混合开发
        super.init(coder: aDecoder)
        
        prepareUI()
    }
    
    
    // MARK: /**************************** 加载cell的子控件 ****************************/
    private func prepareUI() {
    
        contentView.addSubview(imgView)
        contentView.addSubview(btn)
        
        // 设置图片的约束
        imgView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview": imgView]))
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[subview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview": imgView]))
        
        // 设置btn
        btn.hidden = true
        btn.setTitle("开始体验", forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        btn.addTarget(self, action: "clickBtn", forControlEvents: UIControlEvents.TouchUpInside)
        // 约束
        btn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: btn, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: btn, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -160))
    }
    
    // 监听按钮
    func clickBtn() {
    
        NSNotificationCenter.defaultCenter().postNotificationName(DSUIWindowDidChangeRootControllerNotification, object: isMainVC)
    }
    
    // 按钮动画
    private func btnAnim() {
    
        btn.hidden = false
        
        btn.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            self.btn.transform = CGAffineTransformIdentity
            
            self.btn.userInteractionEnabled = false
            }) { (_) -> Void in
                
                self.btn.userInteractionEnabled = true
        }
    }
    
    // 按钮动画2
    private func btnAnimation() {
    
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.toValue = 1.5
        anim.duration = 1
        anim.repeatCount = 1
        
        btn.layer.addAnimation(anim, forKey: nil)
    }
}




// MARK: /**************************** 流水布局 ****************************/
private class DSLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        itemSize = UIScreen.mainScreen().bounds.size
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
    }
}
