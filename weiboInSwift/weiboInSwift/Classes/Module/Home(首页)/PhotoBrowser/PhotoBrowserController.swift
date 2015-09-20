//
//  PhotoBrowserController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/18.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import SVProgressHUD

/// cell的标示符
private let DSPhotoBrowserCollectionCellID = "DSPhotoBrowserCollectionCell"

class PhotoBrowserController: UIViewController, PhotoCellDelegate {
    

    // MARK: - ----------------------------- 属性 -----------------------------
    lazy var photoScale: CGFloat = 1
    lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    var largerPictureURLs: [NSURL]
    var index: Int
    lazy var closeBtn: UIButton = UIButton(title: "关闭")
    lazy var saveBtn: UIButton = UIButton(title: "保存")
    lazy var screenBounds = UIScreen.mainScreen().bounds
    
    // MARK: - ----------------------------- 构造方法 -----------------------------
    init(largerPictureURLs: [NSURL], index: Int) {
        
        self.largerPictureURLs = largerPictureURLs
        
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - ----------------------------- view生命周期方法 -----------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func loadView() {
        
        screenBounds.size.width += 20
        
        view = UIView(frame: screenBounds)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    
    // MARK: - ----------------------------- 监听方法 -----------------------------
    func closeVC() {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func savePhoto() {
    
        let indexPath = collectionView.indexPathsForVisibleItems().last
        let cell = collectionView.cellForItemAtIndexPath(indexPath!) as! PhotoCell

        /// 判断是否有图片
        guard let img = cell.imageView.image else {
        
            return
        }
        
        /// 保存图片
        UIImageWriteToSavedPhotosAlbum(img, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }

    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
    
        let msg = error == nil ? "保存成功" : "保存失败"
        
        SVProgressHUD.showInfoWithStatus(msg)
    }
   
    // MARK: - ----------------------------- 设置UI -----------------------------
    private func setupUI() {
        
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        setupCollectionView()
        setupBtn()
    }
    
    private func setupBtn() {
        
        let rect = CGRect(x: 0, y: UIScreen.mainScreen().bounds.height - 40, width: 100, height: 32)
        closeBtn.frame = CGRectOffset(rect, 8, 0)
        saveBtn.frame = CGRectOffset(rect, UIScreen.mainScreen().bounds.width - rect.width - 8, 0)
        
        closeBtn.addTarget(self, action: "closeVC", forControlEvents: UIControlEvents.TouchUpInside)
        saveBtn.addTarget(self, action: "savePhoto", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupCollectionView() {
        print(view.bounds)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        
        /// 注册cell
        collectionView.registerClass(PhotoCell.self, forCellWithReuseIdentifier: DSPhotoBrowserCollectionCellID)
        
        /// 设置布局
        collectionView.pagingEnabled = true
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = view.bounds.size
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    
    // MARK: - ----------------------------- 捏合图片的代理 -----------------------------
    func photoCellZoom(scale: CGFloat) {
        
        print(scale)
        /// 1> 记录缩放比例
        photoScale = scale
        
        /// 2> 设置控件隐藏: scale小于 1
        if scale < 0.6 {
        
            hiddenControls(scale < 1)
        }
        
        /// 3> 开始转场
        if scale < 0.6 {
        
            startInteractiveTransition(self)
        } else {
        
            hiddenControls(false)
            view.transform = CGAffineTransformIdentity
            view.alpha = 1
        }
    }
    
    func photoCellEndZoom() {
        
        if photoScale < 0.6 {
        
            completeTransition(true)
        } else {
        
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.view.transform = CGAffineTransformIdentity
                }, completion: { (_) -> Void in
                    
                    self.photoScale = 1
                    
                    self.hiddenControls(false)
            })
        }
    }
    
    private func hiddenControls(hidden: Bool) {
    
        collectionView.backgroundColor = hidden ? UIColor.clearColor() : UIColor.blackColor()
        
        closeBtn.hidden = hidden
        
        saveBtn.hidden = hidden
    }
    
    
    // MARK: - ----------------------------- 当前显示的图片 -----------------------------
    func currentImageView() -> UIImageView {
    
        let cell = collectionView.cellForItemAtIndexPath(currentImageViewIndexPath()) as? PhotoCell
        
        return (cell?.imageView)!
    }
    
    func currentImageViewIndexPath() -> NSIndexPath {
    
        return collectionView.indexPathsForVisibleItems().last!
    }
}


// MARK: - ----------------------------- 数据源和代理方法 -----------------------------
extension PhotoBrowserController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (largerPictureURLs.count)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DSPhotoBrowserCollectionCellID, forIndexPath: indexPath) as! PhotoCell
        
        cell.imgURL = largerPictureURLs[indexPath.item]
        cell.photoDelegate = self
        
        return cell
    }
}

extension PhotoBrowserController: UIViewControllerInteractiveTransitioning {

    /// 开始交互转场
    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        view.transform = CGAffineTransformMakeScale(photoScale, photoScale)
    }
}

extension PhotoBrowserController: UIViewControllerContextTransitioning {

    func completeTransition(didComplete: Bool) {
        
        closeVC()
    }
    
    /// 容器视图
    func containerView() -> UIView? { return view.superview }
    
    func isAnimated() -> Bool { return true }
    func isInteractive() -> Bool { return true }
    func transitionWasCancelled() -> Bool { return false }
    func presentationStyle() -> UIModalPresentationStyle { return UIModalPresentationStyle.Custom }
    
    func updateInteractiveTransition(percentComplete: CGFloat) {}
    func finishInteractiveTransition() {}
    func cancelInteractiveTransition() {}
    
    func viewControllerForKey(key: String) -> UIViewController? { return self }
    func viewForKey(key: String) -> UIView? { return view }
    func targetTransform() -> CGAffineTransform { return CGAffineTransformIdentity }
    func initialFrameForViewController(vc: UIViewController) -> CGRect { return CGRectZero }
    func finalFrameForViewController(vc: UIViewController) -> CGRect { return CGRectZero }
}
