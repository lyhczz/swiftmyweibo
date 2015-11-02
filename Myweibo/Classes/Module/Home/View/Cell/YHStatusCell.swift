//
//  YHStatusCell.swift
//  Myweibo
//
//  Created by mposthh on 15/11/1.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHStatusCell: UITableViewCell {
    
    // MARK: - 属性
    
    // 配图宽度约束
    private var pictureViewWidthCon: NSLayoutConstraint?
    // 配图高度约束
    private var pictureViewheightCon: NSLayoutConstraint?

    
    /// 微博模型
    var status: YHStatus? {
        didSet {
            // 将模型属性赋值给topView
            topView.status = status
            // 设置文本框内容
            contentLabel.text = status?.text
            
            // 将模型属性赋值给配图
            pictureView.status = status
            
            // 计算微博视图的size
            let size = pictureView.calcViewSize()
//            print("配图size:\(size)")
            
            // 布局宽高
            pictureViewWidthCon?.constant = size.width
            pictureViewheightCon?.constant = size.height
        }
    }
    
    // MARK: - 构造函数 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 准备UI
        prepareUI()
    }
    
    // MARK: - 计算行高
    /**
    根据微博内容返回cell的行高
    - parameter status: 微博模型
    - returns: cell的行高
    */
    func rowHeight(status: YHStatus) -> CGFloat {
        // 重新设置cell的status
        self.status = status
        // 更新布局
        layoutIfNeeded()
        
        return CGRectGetMaxY(bottomView.frame)
    }

    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        // 添加约束
        // topView
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.width(), height: 54))
        
        // contentLabel
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: 8, y: 8))
        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: UIScreen.width() - 2 * 8))
        
        //pictureView
        let con = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: 8))
        
        // 获取微博配图的宽高约束
        pictureViewWidthCon = pictureView.ff_Constraint(con, attribute: NSLayoutAttribute.Width)
        pictureViewheightCon = pictureView.ff_Constraint(con, attribute: NSLayoutAttribute.Height)
        
        // 底部视图
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: pictureView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8))
        contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 44))
        
        // contentView的底部和bottomView的底部重合
//        contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
    }
    
    // MARK: - 懒加载控件
    
    /// 顶部视图
    private lazy var topView: YHStatusTopView = YHStatusTopView()
    
    /// 微博内容标签
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        // 自动换行
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(16)
        label.textColor = UIColor(white: 0.2, alpha: 1)
        return label
    }()
    
    /// 微博配图视图
    private lazy var pictureView: YHStatusPictureView = YHStatusPictureView()
    
    // 顶部视图
    private lazy var bottomView: YHStatusBottomView = YHStatusBottomView()
}




