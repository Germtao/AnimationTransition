//
//  TTDrawerTransition.swift
//  AnimationTransition
//
//  Created by TAO on 2018/1/8.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import UIKit

let kLateralSliderTapNotification = "LateralSliderTapNotification"
let kLateralSliderPanNotification = "LateralSliderPanNotification"

/// 抽屉转场类型
enum TTDrawerTransitionType: Int {
    case show   = 0
    case hidden
}

/// 抽屉动画类型
enum TTDrawerAnimationType: Int {
    case normal = 0
    case mask
}

let maskView = MaskView()

/// 遮罩 view
class MaskView: UIView {
    
    var toViewSubViews: [UIView]?
    
    /// 单例
    class var shareInstance: MaskView {
        return maskView
    }
    
    /// 释放单例
    class func releaseInstance() {
        maskView.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.black
        alpha = 0
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func singleTap() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLateralSliderTapNotification), object: self)
    }
    
    @objc private func handlePan() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kLateralSliderPanNotification), object: self)
    }
}

/// 抽屉转场
class TTDrawerTransition: NSObject {
    
    var transitionType: TTDrawerTransitionType = .show
    
    var animationType: TTDrawerAnimationType = .normal
    
    var configuration: TTLateralSliderConfiguration?
}

// MARK: - convenience init
extension TTDrawerTransition {
    /// 自定义构造方法
    convenience init(transitionType: TTDrawerTransitionType, animationType: TTDrawerAnimationType, configuration: TTLateralSliderConfiguration) {
        self.init()
        
        self.transitionType = transitionType
        self.animationType = animationType
        self.configuration = configuration
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension TTDrawerTransition: UIViewControllerAnimatedTransitioning {
    
    /// 指定转场动画持续的时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionType == .show ? 0.25 : 0.25
    }
    
    /// 转场动画的具体内容
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch transitionType {
        case .show:
            animationShow(using: transitionContext)
        case .hidden:
            animationHidden(using: transitionContext)
        }
    }
    
}

// MARK: - private function
extension TTDrawerTransition {
    
    /// 动画出现
    private func animationShow(using transitionContext: UIViewControllerContextTransitioning?) {
        if animationType == .normal {
            defaultAnimationWith(using: transitionContext)
        } else {
            maskAnimationWith(using: transitionContext)
        }
    }
    
    /// 动画隐藏
    private func animationHidden(using transitionContext: UIViewControllerContextTransitioning?) {
        guard let fromVC = transitionContext?.viewController(forKey: .from),
            let toVC = transitionContext?.viewController(forKey: .to) else { return }
        
        let maskView = MaskView.shareInstance
        for view in toVC.view.subviews {
            if !(maskView.toViewSubViews?.contains(view))! {
                view.removeFromSuperview()
            }
        }
        
        /// 转场动画发生在该 view 中
        guard let containerView = transitionContext?.containerView else { return }
        
        var backImageView = UIImageView()
        if let firstView = containerView.subviews.first as? UIImageView {
            backImageView = firstView
        }
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.01, relativeDuration: 0.99, animations: {
                toVC.view.transform = CGAffineTransform.identity
                fromVC.view.transform = CGAffineTransform.identity
                maskView.alpha = 0
                backImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
            
        }) { (finished) in
            
//            if !(transitionContext?.transitionWasCancelled)! {
//                maskView.toViewSubViews = nil
//                MaskView.releaseInstance()
//                backImageView.removeFromSuperview()
//            }
            
            guard let isCancelled = transitionContext?.transitionWasCancelled else { return }
            
            if !isCancelled {
                maskView.toViewSubViews = nil
                MaskView.releaseInstance()
                backImageView.removeFromSuperview()
            }
            
            /// 上报动画执行完毕
            transitionContext?.completeTransition(!isCancelled)
        }
        
    }
    
    /// 默认动画滑出
    private func defaultAnimationWith(using transitionContext: UIViewControllerContextTransitioning?) {
        
        /// 根据key返回一个ViewController
        /// 通过UITransitionContextFromViewControllerKey找到将被替换掉的ViewController
        /// 通过UITransitionContextToViewControllerKey找到将要显示的ViewController
        guard let fromVC = transitionContext?.viewController(forKey: .from),
            let toVC = transitionContext?.viewController(forKey: .to) else { return }
        
        let maskView = MaskView.shareInstance
        maskView.frame = fromVC.view.bounds
        fromVC.view.addSubview(maskView)
        
        guard let containerView = transitionContext?.containerView else { return }
        
        var imageView: UIImageView? = nil
        if configuration?.backImage != nil {
            imageView = UIImageView(frame: containerView.bounds)
            imageView?.image = configuration?.backImage
            imageView?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            imageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        containerView.addSubview(imageView!)
        
        guard let width = configuration?.distance else { return }
        var x = -width / 2
        var ret: CGFloat = 1
        if configuration?.direction == .right {
            x = kScreenWidth - width / 2
            ret = -1
        }
        toVC.view.frame = CGRect(x: x, y: 0, width: containerView.frame.width, height: containerView.frame.height)
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let t1 = CGAffineTransform(translationX: ret * width, y: 0)
        let t2 = CGAffineTransform(scaleX: 1, y: (configuration?.scaleY)!)
        let fromVCTransition = t1.concatenating(t2)
        var toVCTransition = CGAffineTransform()
        if configuration?.direction == .right {
            toVCTransition = CGAffineTransform(translationX: ret * (x - containerView.frame.width + width), y: 0)
        } else {
            toVCTransition = CGAffineTransform(translationX: ret * width / 2, y: 0)
        }
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: 0), animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                toVC.view.transform = fromVCTransition
                fromVC.view.transform = toVCTransition
                maskView.alpha = (self.configuration?.maskAlpha)!
                imageView?.transform = CGAffineTransform.identity
            })
            
        }) { (finished) in
            
            if !(transitionContext?.transitionWasCancelled)! {
                maskView.isUserInteractionEnabled = true
                maskView.toViewSubViews = fromVC.view.subviews
                transitionContext?.completeTransition(true)
                containerView.addSubview(fromVC.view)
            } else {
                imageView?.removeFromSuperview()
                maskView.removeFromSuperview()
                transitionContext?.completeTransition(false)
            }
        }
    }
    
    /// 蒙版
    private func maskAnimationWith(using transitionContext: UIViewControllerContextTransitioning?) {
        guard let fromVC = transitionContext?.viewController(forKey: .from),
            let toVC = transitionContext?.viewController(forKey: .to) else { return }
        
        let maskView = MaskView.shareInstance
        maskView.frame = fromVC.view.bounds
        fromVC.view.addSubview(maskView)
        
        guard let containerView = transitionContext?.containerView,
            let width = configuration?.distance else { return }
        var x =  -width
        var ret: CGFloat = 1
        if configuration?.direction == .right {
            x = kScreenWidth
            ret = -1
        }
        toVC.view.frame = CGRect(x: x, y: 0, width: width, height: containerView.frame.height)
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        let toVCTransition = CGAffineTransform(translationX: ret * width, y: 0)
        
        UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewKeyframeAnimationOptions(rawValue: 0), animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                toVC.view.transform = toVCTransition
                maskView.alpha = (self.configuration?.maskAlpha)!
            })
            
        }) { (finished) in
            
            if !(transitionContext?.transitionWasCancelled)! {
                transitionContext?.completeTransition(true)
                maskView.toViewSubViews = fromVC.view.subviews
                containerView.addSubview(fromVC.view)
                containerView.bringSubview(toFront: toVC.view)
                maskView.isUserInteractionEnabled = true
            } else {
                MaskView.releaseInstance()
                transitionContext?.completeTransition(false)
            }
            
        }
    }
}
