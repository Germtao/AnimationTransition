//
//  UIViewController+TTLateralSlider.swift
//  AnimationTransition
//
//  Created by TAO on 2018/1/8.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import UIKit

struct AssociatedKey {
    static let animatorKey = UnsafeRawPointer.init(bitPattern: "LateralSlideAnimatorKey".hashValue)!
}

// MARK: - 侧滑 extension
extension UIViewController {
    
    /// 呼出侧滑控制器的主要方法
    ///
    /// - Parameters:
    ///   - vc:            需要侧滑显示出来的控制器
    ///   - animtionType:  侧滑时的动画类型
    ///   - configuration: 侧滑过程的一些参数配置
    func tt_showDrawer(vc: UIViewController, animtionType: TTDrawerAnimationType, configuration: TTLateralSliderConfiguration) {
        
        var animator = objc_getAssociatedObject(self, AssociatedKey.animatorKey) as? TTLateralSliderAnimator
        
        if animator == nil {
            animator = TTLateralSliderAnimator(with: configuration)
            objc_setAssociatedObject(vc, AssociatedKey.animatorKey, animator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        vc.transitioningDelegate = animator
        
        let interactiveHidden = TTInteractiveTransition(transitionType: .hidden)
        interactiveHidden.setValue(vc, forKey: "weakVC")
        interactiveHidden.setValue(configuration.direction, forKey: "direction")
        
        animator?.setValue(interactiveHidden, forKey: "interactiveHidden")
        animator?.configuration = configuration
        animator?.animationType = animtionType
        
        present(vc, animated: true, completion: nil)
    }
    
    /// 注册手势驱动方法，侧滑呼出的方向自动确定，一般在viewDidLoad调用，调用之后会添加一个支持侧滑的手势到本控制器
    ///
    /// - Parameters:
    ///   - isOpenEdgeGesture:            是否开启边缘手势,边缘手势的开始范围为距离边缘50以内
    ///   - transitionDirectionAutoBlock: 手势过程中执行的操作。根据参数direction传整个点击present的事件即可（看demo的使用
    func tt_registerShowIntractiveWithEdgeGesture(isOpenEdgeGesture: Bool, transitionDirectionAutoBlock: @escaping (_ direction: TTDrawerTransitionDirection) -> ()) {
        
        let animator = TTLateralSliderAnimator(with: TTLateralSliderConfiguration.defalutConfiguration())
        self.transitioningDelegate = animator
        
        objc_setAssociatedObject(self, AssociatedKey.animatorKey, animator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let interactiveShow = TTInteractiveTransition(transitionType: .show)
        interactiveShow.addGesture(forvc: self)
        interactiveShow.setValue(isOpenEdgeGesture, forKey: "isOpenEdgeGesture")
        interactiveShow.setValue(transitionDirectionAutoBlock, forKey: "transitionDirectionAutoBlock")
        interactiveShow.setValue(TTDrawerTransitionDirection.left, forKey: "direction")
        
        animator.setValue(interactiveShow, forKey: "interactiveShow")
    }
    
    /// 自定义 push 方法
    /// 因为侧滑出来的控制器实际上是通过present出来的，这个时候是没有导航控制器的，
    /// 而侧滑出来的控制器上面的一些点击事件需要再push下一个控制器的时候，我们只能通过寻找到根控制器找到对应的导航控制器再进行push操作，
    /// QQ的效果能证明是这么实现的
    ///
    /// - Parameter viewController: 需要 push 出来的控制器
    func tt_push(viewController: UIViewController) {
        
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        var nav = UINavigationController()
        
        if rootVC.isKind(of: UITabBarController.self) {
            let tabBar = rootVC as! UITabBarController
            let index = tabBar.selectedIndex
            nav = tabBar.childViewControllers[index] as! UINavigationController
        }
        else if rootVC.isKind(of: UINavigationController.self) {
            nav = rootVC as! UINavigationController
        }
        else if rootVC.isKind(of: UIViewController.self) {
            print("This no UINavigationController...")
            return
        }
        
        dismiss(animated: true, completion: nil)
        nav.pushViewController(viewController, animated: false)
    }
    
}
