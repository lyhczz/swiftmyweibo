//
//  YHPlaceholderTextView.swift
//  Myweibo
//
//  Created by mposthh on 15/11/4.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHPlaceholderTextView: UITextView {

    // MARK: - 属性
    /// 占位文本
    var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            placeholderLabel.sizeToFit()
        }
    }
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
     
        prepareUI()
        
        // 使用通知监听placeholderLabel的文本改变
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidChange", name: UITextViewTextDidChangeNotification, object: self)
    }
    deinit {
        // 注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func textViewDidChange() {
        placeholderLabel.hidden = hasText()
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        addSubview(placeholderLabel)
        
        // 添加约束
        placeholderLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: 5, y: 8))
    }
    
    // MARK: - 懒加载
    /// 占位文本
    private lazy var placeholderLabel: UILabel = {
       
        // 创建
        let label = UILabel()
        //设置字体
        label.font = UIFont.systemFontOfSize(16)
        // 字体颜色 
        label.textColor = UIColor.lightGrayColor()
        // 大小
        label.sizeToFit()
        
        return label
    }()

}




