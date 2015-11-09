//
//  UIButton+Extension.swift
//  Myweibo
//
//  Created by mposthh on 15/11/1.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(title: String, fontSize: CGFloat, textColor: UIColor, imageName: String) {
        self.init()
        // 文字内容
        setTitle(title, forState: UIControlState.Normal)
        // 文字大小
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        // 文字颜色
        setTitleColor(textColor, forState: UIControlState.Normal)
        // 图片
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    }
    
    convenience init(bkgImageName: String, title: String, titleColor: UIColor, fontSzie: CGFloat) {
        self.init()
        // 设置背景图片
        setBackgroundImage(UIImage(named: bkgImageName), forState: UIControlState.Normal)
        
        // 设置文字内容
        setTitle(title, forState: UIControlState.Normal)
        setTitleColor(titleColor, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSzie)
    }
}