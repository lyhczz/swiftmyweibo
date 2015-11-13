//
//  YHPhotoBrowserDismissAnimation.swift
//  Myweibo
//
//  Created by mposthh on 15/11/12.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHPhotoBrowserDismissAnimation: NSObject,UIViewControllerAnimatedTransitioning
{
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 获得modal处理的view
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        // 获得modal出来的控制器
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! YHPhotoBrowserViewController
        
        // 获得过渡视图
        let tempView = fromVC.dismissTempImageView()
        
        // 添加到容器
        transitionContext.containerView()?.addSubview(tempView)
        
        // 隐藏collectionView
        fromVC.collectionView.hidden = true
        
        // 动画变透明
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            // 透明
            fromView?.alpha = 0
            
            // 过渡视图缩小
            tempView.frame = fromVC.dismissTargetFrame()
            
            }) { (_) -> Void in
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
}
