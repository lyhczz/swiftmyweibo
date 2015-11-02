//
//  YHStatusBottomView.swift
//  Myweibo
//
//  Created by mposthh on 15/11/1.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
/// cell的底部视图
class YHStatusBottomView: UIView {

    // MARK: -  构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.96, alpha: 0.9)
        
        prepareUI()
    }

    // MARK: -  准备UI
    private func prepareUI() {
        // 1.添加子控件
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(likeButton)
        addSubview(separatorViewOne)
        addSubview(separatorViewTwo)
        
        // 2.添加约束
        // 3个按钮平铺
        ff_HorizontalTile([forwardButton,commentButton,likeButton], insets: UIEdgeInsetsZero)
        
        // 分割线
        separatorViewOne.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: forwardButton, size: nil)
        separatorViewTwo.ff_AlignHorizontal(type: ff_AlignType.CenterRight, referView: commentButton, size: nil)
    }
    
    // MARK: -  懒加载控件
    /// 转发
    private lazy var forwardButton: UIButton = UIButton(title: "转发", fontSize: 12, textColor: UIColor.orangeColor(), imageName: "timeline_icon_retweet")
    private lazy var commentButton: UIButton = UIButton(title: "评论", fontSize: 12, textColor: UIColor.orangeColor(), imageName: "timeline_icon_comment")
    private lazy var likeButton: UIButton = UIButton(title: "赞", fontSize: 12, textColor: UIColor.orangeColor(), imageName: "timeline_icon_unlike")
    
    /// 水平分割线
    private lazy var separatorViewOne: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    private lazy var separatorViewTwo: UIImageView = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
}
