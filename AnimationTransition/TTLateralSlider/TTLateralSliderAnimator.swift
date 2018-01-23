//
//  TTLateralSliderAnimator.swift
//  AnimationTransition
//
//  Created by TAO on 2018/1/8.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import UIKit

/// 动画转场动画类
class TTLateralSliderAnimator: NSObject {
    
    var configuration: TTLateralSliderConfiguration! {
        didSet {
            interactiveShow.setValue(configuration, forKey: "configuration")
            interactiveHidden.setValue(configuration, forKey: "configuration")
        }
    }
    
    var animationType: TTDrawerAnimationType = .normal
    
    var interactiveHidden: TTInteractiveTransition!
    var interactiveShow: TTInteractiveTransition!
    
}

// MARK: - 自定义 init
extension TTLateralSliderAnimator {
    
    /// 自定义 init
    convenience init(with configuration: TTLateralSliderConfiguration) {
        self.init()
        
        self.configuration = configuration
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension TTLateralSliderAnimator: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TTDrawerTransition(transitionType: .show, animationType: animationType, configuration: configuration)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TTDrawerTransition(transitionType: .hidden, animationType: animationType, configuration: configuration)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveShow.isInteractive ? interactiveShow : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveHidden.isInteractive ? interactiveHidden : nil
    }
}
