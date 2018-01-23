//
//  TabBarViewController.swift
//  AnimationTransition
//
//  Created by TAO on 2018/1/8.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let nav1 = NavigationViewController(rootViewController: ViewController())
        nav1.title = "发现"
        
        let nav2 = NavigationViewController(rootViewController: ViewController())
        nav2.title = "音乐"
        nav2.view.backgroundColor = UIColor.cyan
        
        viewControllers = [nav1, nav2]
    }

}
