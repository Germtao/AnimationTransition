//
//  TTEnumConfigure.swift
//  AnimationTransition
//
//  Created by TT on 2018/1/23.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import Foundation

enum TTTransitionAnimationType: Int {
    /// ---------- 系统 -----------
    case fade = 1                    // 淡入淡出
    
    case pushFromRight               // push
    case pushFromLeft
    case pushFromTop
    case pushFromBottom
    
    case moveInFromRight             // 覆盖
    case moveInFromLeft
    case moveInFromTop
    case moveInFromBottom
    
    case revealFromRight             // 揭开
    case revealFromLeft
    case revealFromTop
    case revealFromBottom
    
    case cubeFromRight               // 立方体
    case cubeFromLeft
    case cubeFromTop
    case cubeFromBottom
    
    case suckEffect                  // 吮吸
    
    case oglFlipFromRight            // 翻转
    case oglFlipFromLeft
    case oglFlipFromTop
    case oglFlipFromBottom
    
    case rippleEffect                // 波纹
    
    case pageCurlFromRight           // 翻页
    case pageCurlFromLeft
    case pageCurlFromTop
    case pageCurlFromBottom
    
    case pageUnCurlFromRight         // 反翻页
    case pageUnCurlFromLeft
    case pageUnCurlFromTop
    case pageUnCurlFromBottom
    
    case cameraIrisHollowOpen        // 开镜头
    case cameraIrisHollowClose       // 关镜头
    
    /// ---------- 自定义 ------------
    case normalDefault
    
    case pageTransition
    
    case viewMoveToNextVC
    case viewMoveNormalToNextVC
    
    case cover
    
    case spreadFromRight
    case spreadFromLeft
    case spreadFromTop
    case spreadFromBottom
    case spreadPresent
    
    case boom
    
    case brickOpenVertical
    case brickOpenHorizontal
    case brickCloseVertical
    case brickCloseHorizontal
    
    case insideThenPush
    
    case fragmentShowFromRight
    case fragmentShowFromLeft
    case fragmentShowFromTop
    case fragmentShowFromBottom
    
    case fragmentHideFromRight
    case fragmentHideFromLeft
    case fragmentHideFromTop
    case fragmentHideFromBottom
    case tipFlip
}

/// 转场类型
enum TTTransitionType {
    case pop
    case push
    case present
    case dismiss
}

/// 手势转场类型
enum TTGestureType {
    case none
    case panLeft
    case panRight
    case panUp
    case panDown
}

/// 系统转场动画类型
enum TTTransitionSysAnimationType {
    case sysFade                       // 淡入淡出
    case sysPush                       // 推挤
    case sysReveal                     // 揭开
    case sysMoveIn                     // 覆盖
    case sysCube                       // 立方体
    case sysSuckEffect                 // 吮吸
    case sysOglFlip                    // 翻转
    case sysRippleEffect               // 波纹
    case sysPageCurl                   // 翻页
    case sysPageUnCurl                 // 反翻页
    case sysCameraIrisHollowOpen       // 开镜头
    case sysCameraIrisHollowClose      // 关镜头
    case sysCurlDown                   // 下翻页
    case sysCurlUp                     // 上翻页
    case sysFlipFromLeft               // 左翻转
    case sysFlipFromRight              // 右翻转
}







