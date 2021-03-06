//
//  YHStatusPictureView.swift
//  Myweibo
//
//  Created by mposthh on 15/11/2.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import SDWebImage

let YHStatusPictureViewCellSelectedPictureNotification = "YHStatusPictureViewCellSelectedPictureNotification"

let YHStatusPictureViewCellSelectedPictureURLKey = "YHStatusPictureViewCellSelectedPictureURLKey"

let YHStatusPictureViewCellSelectedPictureIndexPathKey = "YHStatusPictureViewCellSelectedPictureIndexKey"

let YHStatusPictureViewCellSelectedPictureModelKey = "YHStatusPictureViewCellSelectedPictureModelKey"

class YHStatusPictureView: UICollectionView {

    
    // MARK: - 属性
    // collectionView的布局
    private var pictureLayout = UICollectionViewFlowLayout()
    /// 微博模型
    var status: YHStatus? {
        didSet {
            // 刷新数据
            reloadData()
        }
    }
    /// cellID
    let pictrueViewCellReuseIdentifier = "pictrueViewCellReuseIdentifier"
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: pictureLayout)
        // 注册cell
        registerClass(YHStatusPictureViewCell.self, forCellWithReuseIdentifier: pictrueViewCellReuseIdentifier)
        // 设置数据源
        dataSource = self
        // 设置代理
        delegate = self
        // 设置颜色
        backgroundColor = UIColor(white: 0.96, alpha: 0.9)
     
    }
    
    /// 计算配图宽高
    func calcViewSize() -> CGSize {
        // 每个item的size
        let itemSize = CGSize(width: 90, height: 90)
        // 设置布局的size
        pictureLayout.itemSize = itemSize
        pictureLayout.minimumLineSpacing = 0
        pictureLayout.minimumInteritemSpacing = 0
        
        // item之间的间距
        let margin: CGFloat = 10
        
        // 最大列数
        let column = 3
        
        // 获得配图的数量
        let count = status?.pictureURLs?.count ?? 0
        
        // 根据配图数量计算尺寸
        // 没有图片
        if count == 0 {
            return CGSizeZero
        }
        
        // 只有一张图片
        if count == 1 {
            
            var size = CGSize(width: 150, height: 120)
//            pictureLayout.itemSize = size
//            return size
            
            // 获取图片url地址
            let urlSring = status!.pictureURLs![0].absoluteString
            
            // 获取图片,根据图片返回size
            if let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlSring) {
                size = image.size
            }
            // 有些图片宽度很小
            if size.width < 40 {
                size.width = 40
            }
            
            pictureLayout.itemSize = size
            return size
        }
        
        // 超过一张图片,设置间距
        pictureLayout.minimumInteritemSpacing = margin
        pictureLayout.minimumLineSpacing = margin
        
        // 4张图片
        if count == 4 {
            let width = itemSize.width * 2 + margin
            return CGSize(width: width, height: width)
        }
        
        // 其他
        // 计算行数
        let row = (count + column - 1) / column
        
        // 宽度
        let width = itemSize.width * CGFloat(column) + margin * (CGFloat(column) - 1)
        
        // 高度
        let height = itemSize.width * CGFloat(row) + margin * (CGFloat(row) - 1)
        
        return CGSize(width: width, height: height)
    }
    
    
}

// MARK: - 扩展,实现数据源
extension YHStatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return status?.pictureURLs?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(pictrueViewCellReuseIdentifier, forIndexPath: indexPath) as! YHStatusPictureViewCell
        
//        cell.backgroundColor = UIColor.redColor()
        cell.imageUrl = status?.pictureURLs?[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let count = status?.largePictureURLs?.count ?? 0
        
        // 创建模型数组
        var models = [YHPhotoBrowserModel]()
        
        // 遍历,创建模型
        for index in 0..<count {
            let model = YHPhotoBrowserModel()
            
            // 设置url
            model.imageUrl = status?.largePictureURLs![index]
            // 获取对应的cell
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as! YHStatusPictureViewCell
            
            // 设置imageView
            model.imageView = cell.iconView
            
            // 添加到数组
            models.append(model)
        }
        
        let userInfo: [String: AnyObject] = [
            YHStatusPictureViewCellSelectedPictureModelKey: models,
            YHStatusPictureViewCellSelectedPictureIndexPathKey: indexPath
        ]
        
        // 需要将cell的点击事件传递给控制器,通过通知的方法
        NSNotificationCenter.defaultCenter().postNotificationName(YHStatusPictureViewCellSelectedPictureNotification, object: self, userInfo: userInfo)
        
    }
    
}


// MARK: - 自定义cell
class YHStatusPictureViewCell: UICollectionViewCell {
    
    // MARK: - 属性
    var imageUrl: NSURL? {
        didSet {
            // 加载图片
            iconView.sd_setImageWithURL(imageUrl)
            
            // 判断是否是gif
            let gif = (imageUrl!.absoluteString as NSString).pathExtension.lowercaseString == "gif"
            
            gifImageView.hidden = !gif
        }
    }
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 准备UI
        prepareUI()
    }
    
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(gifImageView)
        
        // 添加约束
        iconView.ff_Fill(iconView)
        gifImageView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: contentView, size: nil)
    }
    
    // MARK: - 懒加载控件
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        imageView.clipsToBounds = true
        
        return imageView
    
    }()
    
    /// git 图标
    private lazy var gifImageView: UIImageView = UIImageView(image: UIImage(named: "timeline_image_gif"))
    
}


