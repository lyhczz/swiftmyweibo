//
//  YHPhotoBrowserModalAnimation.swift
//  Myweibo
//
//  Created by mposthh on 15/11/12.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHPhotoBrowserModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 获取modal的目标控制器
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 添加到容器视图
        transitionContext.containerView()?.addSubview(toView)
        
        // 设置alpha
        toView.alpha = 0
        
        // 获取modal出来的控制器
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! YHPhotoBrowserViewController
        
        // 获取到 过渡视图
        let tempView = toVC.modalTempImageView()
        
        // 添加tempView到容器视图
        transitionContext.containerView()?.addSubview(tempView)
        
        // 隐藏collectionView
        toVC.collectionView.hidden = true
        
        // 动画将toView的alpha变成1
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            toView.alpha = 1
            // 放大动画
            tempView.frame = toVC.modalTargetFrame()
            
            
            }) { (_) -> Void in
                
                // 移除 过渡视图
                tempView.removeFromSuperview()
                
                // 显示collectionView
                toVC.collectionView.hidden = false
                
                transitionContext.completeTransition(true)
        }
    }
}
