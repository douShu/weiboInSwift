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

class PhotoBrowserController: UIViewController {
    
    // MARK: - ----------------------------- 属性 -----------------------------
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
        print("保存图片")
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
    
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["close": closeBtn, "save": saveBtn]
        
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[save]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[close]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[close(100)]-(>=0)-[save(100)]-28-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
        
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
        layout.itemSize = screenBounds.size
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }


    deinit {
    
        print("wo走了")
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
        cell.imageView.backgroundColor = UIColor.randomColor()
        
        return cell
    }
}
