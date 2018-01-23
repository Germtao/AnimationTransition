//
//  TTLateralSliderConfiguration.swift
//  AnimationTransition
//
//  Created by TAO on 2018/1/8.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.width

/// 转场方向
enum TTDrawerTransitionDirection: Int {
    case left  = 0
    case right
}

/// configuration
class TTLateralSliderConfiguration: NSObject {
    
    /// 根控制器可偏移距离, 默认 0.75
    var distance: CGFloat = 0.75 * kScreenWidth {
        didSet {
            if distance == 0 {
                distance = 0.75 * kScreenWidth
            }
        }
    }
    
    /// 遮罩的透明度
    var maskAlpha: CGFloat = 0.4 {
        didSet {
            if maskAlpha == 0 {
                maskAlpha = 0.1
            }
        }
    }
    
    /// 根控制器在 y 方向的缩放, 默认不缩放
    var scaleY: CGFloat    = 1 {
        didSet {
            if scaleY == 0 {
                scaleY = 1
            }
        }
    }
    
    /// 滑出方向, 默认 left
    var direction: TTDrawerTransitionDirection = .left
    
    /// 动画切换过程中, 最底层的背景图片
    var backImage: UIImage? = nil
    
    deinit {
        print(#function)
    }
    
    /// 默认
    class func defalutConfiguration() -> TTLateralSliderConfiguration {
        return TTLateralSliderConfiguration(distance: kScreenWidth * 0.75,
                                            maskAlpha: 0.4,
                                            scaleY: 1,
                                            direction: .left,
                                            backImage: nil)
    }
}

extension TTLateralSliderConfiguration {
    
    /// 自定义构造方法
    convenience init(distance: CGFloat = kScreenWidth * 0.75, maskAlpha: CGFloat = 0.4, scaleY: CGFloat = 1, direction: TTDrawerTransitionDirection = .left, backImage: UIImage? = nil) {
        self.init()
        
        self.distance = distance
        self.maskAlpha = maskAlpha
        self.scaleY = scaleY
        self.direction = direction
        self.backImage = backImage
    }
    
    
}
