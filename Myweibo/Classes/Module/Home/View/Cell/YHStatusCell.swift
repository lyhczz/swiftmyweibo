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
    /// 微博模型
    var status: YHStatus? {
        didSet {
            // 将模型属性赋值给topView
            topView.status = status
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
    

    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(topView)
        
        // 添加约束
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44))

    }
    
    // MARK: - 懒加载控件
    private lazy var topView: YHStatusTopView = YHStatusTopView()
}
