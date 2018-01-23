//
//  TTEnumConfigure.swift
//  AnimationTransition
//
//  Created by TT on 2018/1/23.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import Foundation

enum TTTransitionAnimationType: Int {
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
}
