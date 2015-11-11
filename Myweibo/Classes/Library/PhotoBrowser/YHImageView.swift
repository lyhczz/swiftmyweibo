//
//  YHImageView.swift
//  Myweibo
//
//  Created by mposthh on 15/11/11.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHImageView: UIImageView {
    
    /// 覆盖父类的 transform
    override var transform: CGAffineTransform {
        didSet {
            if transform.a < YHPhotoBrowserCellminimumZoomScale {
                transform = CGAffineTransformMakeScale(YHPhotoBrowserCellminimumZoomScale, YHPhotoBrowserCellminimumZoomScale)
            }
        }
    }
}
