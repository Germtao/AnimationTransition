//
//  TTInteractiveTransition.swift
//  AnimationTransition
//
//  Created by TAO on 2018/1/8.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import UIKit

/// 交互式转场切换动画
/// 
class TTInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    weak var configuration: TTLateralSliderConfiguration?
    
    var isInteractive: Bool = false
    
    weak var weakVC: UIViewController?
    
    var transitionType: TTDrawerTransitionType = .show
    
    var isOpenEdgeGesture: Bool = false
    
    var direction: TTDrawerTransitionDirection = .left
    
    /// 定时器
    private var displayLink: CADisplayLink?
    
    /// 转场方向自动回调
    var transitionDirectionAutoBlock: ((_ direction: TTDrawerTransitionDirection) -> ())?
    
    private var percent: CGFloat = 0
    private var remainCount: CGFloat = 0
    private var isToFinished: Bool = false
    private var oncePercent: CGFloat = 0
    
    deinit {
        print(#function)
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension TTInteractiveTransition {
    
    /// 自定义 init
    convenience init(transitionType: TTDrawerTransitionType) {
        self.init()
        
        self.transitionType = transitionType
        
        NotificationCenter.default.addObserver(self, selector: #selector(tt_singleTap), name: NSNotification.Name(rawValue: kLateralSliderTapNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tt_handleHiddenPan(_:)), name: NSNotification.Name(rawValue: kLateralSliderPanNotification), object: nil)
    }
    
    func addGesture(forvc vc: UIViewController) {
        
        weakVC = vc
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(tt_handleShowPan(_:)))
        vc.view.addGestureRecognizer(pan)
    }
}

// MARK: - CADisplayLink
extension TTInteractiveTransition {
    
    /// 启动定时器
    private func startDisplayLink() {
        
        if displayLink == nil {
            displayLink = CADisplayLink(target: self, selector: #selector(tt_update))
            displayLink?.add(to: RunLoop.current, forMode: .commonModes)
        }
    }
    
    /// 停止定时器
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}

// MARK: - private function
extension TTInteractiveTransition {
    
    /// 显示处理
    private func showBeganTranslationX(x: CGFloat, pan: UIPanGestureRecognizer) {
        print("------ \(x)")
        
        if x >= 0 {
            direction = .left
        } else {
            direction = .right
        }
        
        if (x < 0 && direction == .left) || (x > 0 && direction == .right) { return }
        
        let locX = pan.location(in: weakVC?.view).x
        print("~~~~~~ \(locX)")
        
        guard let width = weakVC?.view.frame.width else { return }
        
        if isOpenEdgeGesture && ((locX > 50 && direction == .left) ||
            (locX < width - 50 && direction == .right)) {  return }
        
        isInteractive = true
        
        if transitionDirectionAutoBlock != nil {
            transitionDirectionAutoBlock?(direction)
        }
    }
    
    /// 隐藏处理
    private func hiddenBeganTranslationX(x: CGFloat) {
        
        if (x > 0 && direction == .left) || (x < 0 && direction == .right)  { return }
        
        isInteractive = true
        
        weakVC?.dismiss(animated: true, completion: nil)
    }
    
    /// 开启定时器
    private func startDisplayLink(percent: CGFloat, toFinished finished: Bool) {
        isToFinished = finished
        let remainDuration = finished ? duration * (1 - percent) : duration * percent
        remainCount = 60 * remainDuration
        oncePercent = finished ? (1 - percent) / remainCount : percent / remainCount
        startDisplayLink()
    }
}

// MARK: - 事件处理
extension TTInteractiveTransition {
    
    /// 更新
    @objc private func tt_update() {
        if percent >= 1 && isToFinished {
            stopDisplayLink()
            finish()
        } else if percent < 0 && !isToFinished {
            stopDisplayLink()
            cancel()
        } else {
            if isToFinished {
                percent += oncePercent
            } else {
                percent -= oncePercent
            }
            
            percent = min(max(percent, 0), 1)
            update(percent)
        }
    }
    
    /// 手势处理
    private func handleGesture(pan: UIPanGestureRecognizer) {
        
        let x = pan.translation(in: pan.view).x
        guard let width = pan.view?.frame.width else { return }
        percent = x / width
        
        if (direction == .right && transitionType == .show) || (direction == .left && transitionType == .hidden) {
            percent = -percent
        }
        
        switch pan.state {
        case .began: break
        case .changed:
            if !isInteractive { /// 保证 percent 只调用一次
                if transitionType == .show {
                    if x != 0 {
                        showBeganTranslationX(x: x, pan: pan)
                    }
                } else {
                    hiddenBeganTranslationX(x: x)
                }
            } else {
                percent = min(max(percent, 0.001), 1.0)
                update(percent)
            }
        case .cancelled, .ended:
            isInteractive = false
            
            if percent > 0.5 {
                startDisplayLink(percent: percent, toFinished: true)
            } else {
                startDisplayLink(percent: percent, toFinished: false)
            }
        default: break
        }
    }
    
    /// 单点
    @objc private func tt_singleTap() {
        weakVC?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func tt_handleHiddenPan(_ noti: Notification) {
        
        if transitionType == .show { return }
        
        guard let pan = noti.object as? UIPanGestureRecognizer else { return }
        handleGesture(pan: pan)
    }
    
    @objc private func tt_handleShowPan(_ pan: UIPanGestureRecognizer) {
        
        if transitionType == .hidden { return }
        
        handleGesture(pan: pan)
    }
    
    
}
