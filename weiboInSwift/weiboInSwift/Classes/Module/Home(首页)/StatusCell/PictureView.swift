//
//  PictureView.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/12.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import SDWebImage

/// 创建通知
let DSPictureViewCellSelectPhotoNotification = "DSPictureViewCellSelectPhotoNotification"
/// URL的KEY
let DSPictureViewCellSelectPhotoURLKEY = "DSPictureViewCellSelectPhotoURLKEY"
/// index的KEY
let DSPictureViewCellSelectPhotoIndexKEY = "DSPictureViewCellSelectPhotoIndexKEY"

class PictureView: UICollectionView {
    
    
    // MARK: - ----------------------------- 属性 -----------------------------
    private let pictureLayout = UICollectionViewFlowLayout()
    
    private var pictureURLs: [NSURL]?
    
    private var largerPictureURLs: [NSURL]?
    
    var status: Status? {
    
        didSet {
            pictureURLs = status?.pictureURls
            largerPictureURLs = status?.largerPictureURLs
        
            sizeToFit()
            
            reloadData() 
        }
    }

    
    // MARK: - ----------------------------- 构造方法 -----------------------------
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        
        super.init(frame: frame, collectionViewLayout: pictureLayout)
        
        backgroundColor = UIColor.whiteColor()
        
        /// 注册可重用cell
        registerClass(pictureCell.self, forCellWithReuseIdentifier: "PictureCell")
        
        /// 设置数据源和代理
        self.dataSource = self
        self.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - ----------------------------- 设置高度 -----------------------------
    override func sizeThatFits(size: CGSize) -> CGSize {
        
        return setupPictureViewSize()
    }
    private func setupPictureViewSize() -> (CGSize) {
        
        /// 准备常量
        let itemSize = CGSize(width: 90, height: 90)
        pictureLayout.itemSize = itemSize
        let margin: CGFloat = 10
        let rowCount = 3

        let count = pictureURLs?.count ?? 0
        
        if count == 0 {
        
            return CGSizeZero
        }
        
        if count == 1 {
            
            let key = pictureURLs![0].absoluteString
            
            /// image 不一定被缓存下来
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)

            var size = CGSize(width: 150, height: 120)
            
            if image != nil {
            
                size = image.size
            }
            
            size.width = size.width < 40 ? 40 : size.width
            size.width = size.height > UIScreen.mainScreen().bounds.width ? 150 : size.width
            
            pictureLayout.itemSize = size
            
            return size
        }

        if count == 4 {
            
            let w = itemSize.width * 2 + margin
            return CGSize(width: w, height: w)
        }
        
        /// 其它 2, 3, 5, 6, 7, 8, 9
        /// 计算行数
        let row = (count - 1) / rowCount + 1
        let h = itemSize.height * CGFloat(row) + (CGFloat(row) - 1) * margin
        let w = itemSize.width * CGFloat(rowCount) + (CGFloat(rowCount) - 1) * margin

        return CGSize(width: w, height: h)
    }
}

// MARK: - ----------------------------- 代理方法 -----------------------------
extension PictureView: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        /// 发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(DSPictureViewCellSelectPhotoNotification, object: self, userInfo: [DSPictureViewCellSelectPhotoURLKEY: largerPictureURLs!, DSPictureViewCellSelectPhotoIndexKEY: indexPath])
    }
}


// MARK: - ----------------------------- 数据源方法 -----------------------------
extension PictureView: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PictureCell", forIndexPath: indexPath) as! pictureCell
        
        cell.pictURL = pictureURLs![indexPath.item]
        
        return cell
    }
}


// MARK: - ----------------------------- 自定义cell -----------------------------
class pictureCell: UICollectionViewCell {

    
    // MARK: - ----------------------------- 属性 -----------------------------
    private lazy var gifImg: UIImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
    private lazy var imgView: UIImageView = UIImageView()
    private var pictURL: NSURL? {
    
        didSet {
            
            setupSubview()
        }
    }
    
    // MARK: - ----------------------------- 构造方法 -----------------------------
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
    
        contentView.addSubview(imgView)
        imgView.addSubview(gifImg)
        
        imgView.ff_Fill(contentView)
        gifImg.ff_AlignInner(type: ff_AlignType.BottomRight, referView: imgView, size: nil)
        
        imgView.contentMode = UIViewContentMode.ScaleAspectFill
        imgView.clipsToBounds = true
        
        imgView.sd_setImageWithURL(pictURL)
        
        if pictURL?.absoluteString.pathExtension.lowercaseString == "gif" {
        
            gifImg.hidden = false
        } else {
        
            gifImg.hidden = true
        }
    }
    
    
    
}

