//
//  TTScrollView.swift
//  AnimationTransition
//
//  Created by TAO on 2018/1/8.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import UIKit

class TTScrollView: UIScrollView {

    /// 重写手势, 如果是 左滑, 则禁止 scrollView 自带手势
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let pan = gestureRecognizer as! UIPanGestureRecognizer
            print("\(pan.translation(in: self).x) -- \(self.contentOffset.x)")
            
            if pan.translation(in: self).x > 0, self.contentOffset.x == 0 {
                print("左滑手势")
                return false
            }
            
            if pan.translation(in: self).x < 0, self.contentSize.width - self.contentOffset.x <= self.bounds.width {
                print("右滑手势")
                return false
            }
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }

}
