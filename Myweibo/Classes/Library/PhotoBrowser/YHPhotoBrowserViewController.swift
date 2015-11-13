//
//  YHPhotoBrowserViewController.swift
//  Myweibo
//
//  Created by mposthh on 15/11/8.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import SVProgressHUD

class YHPhotoBrowserViewController: UIViewController {

    // MARK: - 属性
    // cell的重用标识
    let YHPhotoBrowserViewCellIdentifier = "YHPhotoBrowserViewCellIdentifier"
    
    /// 要显示大图的urls数组
    private var photoModels: [YHPhotoBrowserModel]
    
    /// indexPath
    var indexPath: NSIndexPath
    
    /// 流水布局
    private var layout = UICollectionViewFlowLayout()
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(models: [YHPhotoBrowserModel], indexPath: NSIndexPath) {
        self.photoModels = models
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame.size.width += 15
        
        prepareUI()
        
        pageLabel.text = "\(indexPath.item + 1) / \(photoModels.count)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
    
    // MAKR: - 按钮点击事件
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        // 获取正在显示的图片
        let indexPath = collectionView.indexPathsForVisibleItems().first!
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! YHPhotoBrowserCell
        if let image = cell.imageView.image {
            // 保存 
            
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
            
        }
    }
    // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            print("保存图片失败:\(error)")
            SVProgressHUD.showErrorWithStatus("保存失败", maskType: SVProgressHUDMaskType.Black)
            return
        }
        SVProgressHUD.showSuccessWithStatus("保存成功", maskType: SVProgressHUDMaskType.Black)
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(pageLabel)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 添加按钮点击事件
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let viewDict = ["cv": collectionView, "pl": pageLabel, "cb": closeButton, "sb": saveButton]
        
        // collectionView填充父控件
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        collectionView.frame = view.bounds
        
        // pageLabel
        // 水平居中
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        // 距离顶部20
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20))
        
        // 关闭和保存按钮
        // v
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        // h
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[cb(75)]-(>=0)-[sb(75)]-23-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        
        prepareCollectionView()
    }
    
    /// 准备CollectionView
    private func prepareCollectionView() {
        // 注册cell
        collectionView.registerClass(YHPhotoBrowserCell.self, forCellWithReuseIdentifier: YHPhotoBrowserViewCellIdentifier)
        
        // itemSize 
        layout.itemSize = view.bounds.size
        
        // 滚动方法
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 间距
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 分页显示
        collectionView.pagingEnabled = true
        
        // 设置数据源和代理
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    // MARK: - 懒加载控件
    /// collectionView
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    /// 关闭按钮
    private lazy var closeButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "关闭", titleColor: UIColor.whiteColor(), fontSzie: 12)
    /// 保存按钮
    private lazy var saveButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "保存", titleColor: UIColor.whiteColor(), fontSzie: 12)
    
    /// 页码标签
    private lazy var pageLabel: UILabel = UILabel(textColor: UIColor.whiteColor(), fontSize: 15)
    
}

// MARK: - 扩展
extension YHPhotoBrowserViewController: UICollectionViewDelegate,UICollectionViewDataSource, UIViewControllerTransitioningDelegate {
    
    // 返回cell的数量
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YHPhotoBrowserViewCellIdentifier, forIndexPath: indexPath) as! YHPhotoBrowserCell
        // 获得对应的url
//        let url = urls[indexPath.item]
        // 赋值给cell
        cell.url = photoModels[indexPath.item].imageUrl
        
//        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
    
    // 监听cell的停止滚动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems().first {
            
            // 设置给当前的cell的属性
            self.indexPath = indexPath
            
            // 设置页码
            self.pageLabel.text = "\(indexPath.item + 1) / \(photoModels.count)"
        }
    }
    
    // MARK: - 实现 UIViewControllerTransitioningDelegate 来控制转场动画
    // 返回控制modal动画的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return YHPhotoBrowserModalAnimation()
    }
    
    // 返回控制 dismiss 动画的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return YHPhotoBrowserDismissAnimation()
    }
}

extension YHPhotoBrowserViewController {
    /// 提供过渡视图
    func modalTempImageView() -> UIImageView {
        // 获取模型
        let model = photoModels[indexPath.item]
        
        // 根据模型里面的imageView生成过渡视图
        let imageView = UIImageView(image: model.imageView?.image)
        
        // 设置相关属性
        imageView.contentMode = model.imageView!.contentMode
        imageView.clipsToBounds = true
        
        // 设置过渡视图的franme等于缩略图的frame
//        imageView.frame = model.imageView!.frame
         imageView.frame = model.imageView!.superview!.convertRect(model.imageView!.frame, toCoordinateSpace: view)
        
        return imageView
    }
    
    /// 计算放大后的frame,图片等比例放大到宽度等于屏幕宽度
    func modalTargetFrame() -> CGRect {
        // 获取图片
        let image = photoModels[indexPath.item].imageView!.image!
        
        // 计算高度
        // 放大后的高度 / 放大后的宽度 = 放大前的高度 / 放大前的宽度
        var newHeight = UIScreen.width() * image.size.height / image.size.width
        
        var offestY: CGFloat = 0
        if newHeight < UIScreen.height() {
            // 短图,居中
            offestY = (UIScreen.height() - newHeight) * 0.5
        } else {
            // 长图,顶部开始显示,高度等于屏幕的高度
            newHeight = UIScreen.height()
        }
        
        return CGRect(x: 0, y: offestY, width: UIScreen.width(), height: newHeight)
    }
    
    /// 提供缩小的过渡视图
    func dismissTempImageView() -> UIImageView {
        
        // 获取当前的索引
        let showIndexPath = collectionView.indexPathsForVisibleItems().first!
        
        // 获得正在显示的cell
        let cell = collectionView.cellForItemAtIndexPath(showIndexPath) as! YHPhotoBrowserCell
        
        // 获得正在显示的imageView
        let showImageView = cell.imageView
        
        // 生成过渡视图
        let tempImageView = UIImageView(image: showImageView.image)
        
        // 设置相关属性
        tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
        tempImageView.clipsToBounds = true
        
        // 将cell的imageView坐标系转换到当前控制器的view的坐标系
        let rect = showImageView.superview?.convertRect(showImageView.frame, toCoordinateSpace: view)
        tempImageView.frame = rect!
        
        return tempImageView
    }
    
    /**
    缩小后的frame,缩略图cell的位置
    - returns: 缩略图cell的位置
    */
    func dismissTargetFrame() -> CGRect {
        // 获取正在显示的cell的indexPath
        let showIndexPath = collectionView.indexPathsForVisibleItems().first
        
        // 获取对应的模型
        let model = photoModels[showIndexPath!.item]
        
        // 小图
        let imageView = model.imageView
        
        // 坐标系转换
        let rect = imageView?.convertRect(imageView!.frame, toCoordinateSpace: view)
        
        return rect!
    }
    
}




