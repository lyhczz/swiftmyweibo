//
//  YHStatusNormalCell.swift
//  Myweibo
//
//  Created by mposthh on 15/11/2.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHStatusNormalCell: YHStatusCell {

    override func prepareUI() {
            super.prepareUI()

        //pictureView
        let con = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: statusCellMargin))
        
        // 获取微博配图的宽高约束
        pictureViewWidthCon = pictureView.ff_Constraint(con, attribute: NSLayoutAttribute.Width)
        pictureViewheightCon = pictureView.ff_Constraint(con, attribute: NSLayoutAttribute.Height)
    }

}
