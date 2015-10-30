//
//  YHNewFeatureViewController.swift
//  Myweibo
//
//  Created by mposthh on 15/10/30.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class YHNewFeatureViewController: UICollectionViewController {

    // MARK: - 属性
    private let itemCount = 4
    /// layout
    private var layout = UICollectionViewFlowLayout()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.registerClass(YHNewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // 准备layout
        prepareLayout()

    }
    /// 准备collectionView的layout
    func prepareLayout() {
        // 大小
        layout.itemSize = view.bounds.size
        // 滑动方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 设置cell的间距
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 翻页效果
        collectionView?.pagingEnabled = true
        // 弹簧效果
        collectionView?.bounces = false
        // 条
        collectionView?.showsHorizontalScrollIndicator = false
        
    }
    
    // MARK: - UICollectionView方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! YHNewFeatureCell
        
        // 设置当前的cell是第几个cell
        cell.imageIndex = indexPath.item
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {

        // 获取正在显示的cell
        let indexPath = collectionView.indexPathsForVisibleItems().last
        
        // 判断是否是最后一页
        if indexPath?.item == itemCount - 1 {
            // 根据index获取cell
            let cell = collectionView.cellForItemAtIndexPath(indexPath!) as! YHNewFeatureCell
            // 开始动画
            cell.showStartButton()
        }
        
    }
    

}

// MARK: - 自定义UICollectionViewCell
class YHNewFeatureCell: UICollectionViewCell {
    
    var imageIndex: Int? = 0  {
        didSet {
            backgroundImageView.image = UIImage(named: "new_feature_\(imageIndex! + 1)")
            startButton.hidden = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 开始按钮动画
    /**
    开始按钮动画
    */
    func showStartButton() {
        startButton.hidden = false
        
        startButton.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1.2, delay: 0.05, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }) { (_) -> Void in
                
        }
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加为子控件
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(startButton)
        
        // 添加约束
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 填充父控件
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bg" : backgroundImageView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bg]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bg" : backgroundImageView]))
        
        // 开始体验按钮
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -160))
    
    }
    
    // MARK: - 懒加载控件
    /// 背景
    private lazy var backgroundImageView = UIImageView()
    
    /// 开始体验按钮
    private lazy var startButton: UIButton = {
        let button = UIButton()
        
        // 设置按钮背景
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        // 设置文字
        button.setTitle("开始体验", forState: UIControlState.Normal)
        
        return button
    }()
}

