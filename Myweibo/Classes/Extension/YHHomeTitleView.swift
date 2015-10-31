//
//  YHHomeTitleView.swift
//  Myweibo
//
//  Created by mposthh on 15/10/31.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHHomeTitleView: UIButton {

    /// 改变button的文字与图片方向
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.width
        
    }
    
    /// 返回 YHHomeTitleView
    convenience init(title: String?) {
        self.init()
     
        setTitle(title, forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        sizeToFit()
        
    }

}
