//
//  ViewController.swift
//  AnimationTransition
//
//  Created by TAO on 2018/1/8.
//  Copyright © 2018年 ShaggyT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    lazy var tableView: UITableView = {
//        let tableV = UITableView(frame: view.bounds, style: .plain)
//        tableV.delegate = self
//        tableV.dataSource = self
//        view.addSubview(tableV)
//        return tableV
//    }()
    
    lazy var contentView: TTScrollView = {
        
        let navBarH = navigationController?.navigationBar.bounds.height
        let tabBarH = tabBarController?.tabBar.bounds.height
        
        let scrollV = TTScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - navBarH! - tabBarH!))
        scrollV.backgroundColor = UIColor.green
        scrollV.isPagingEnabled = true
        scrollV.bounces = false
        scrollV.contentSize = CGSize(width: self.view.bounds.width * 3, height: 0)
        scrollV.showsHorizontalScrollIndicator = false
        scrollV.delegate = self
        self.view.addSubview(scrollV)
        return scrollV
    }()
    
    lazy var animator = TTLateralSliderAnimator(with: .defalutConfiguration())
    
    lazy var dataSource = ["仿QQ左侧滑出", "仿QQ右侧滑出", "左侧滑出并缩小", "右侧滑出并缩小", "左侧滑出遮盖上方", "右侧滑出遮盖上方"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        /// 注册手势驱动
        let interactiveShow = TTInteractiveTransition(transitionType: .show)
        animator.interactiveShow = interactiveShow
        switch animator.configuration.direction {
        case .left:
            leftItemClick()
        case .right:
            rightItemClick()
        }
    
    }

    private func setupUI() {
        
        self.view.backgroundColor = UIColor.white
        
        if self.responds(to: #selector(getter: edgesForExtendedLayout)) {
            self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        }
        
        setupNavBarItem()
        
        setupTableView()
    }
    
    private func setupNavBarItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(leftItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(rightItemClick))
    }
    
    private func setupTableView() {
        
        for index in 0..<3 {
            let tableView = UITableView(frame: CGRect(x: contentView.bounds.width * CGFloat(index), y: 0, width: contentView.bounds.width, height: contentView.bounds.height), style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            contentView.addSubview(tableView)
        }
    }

}

// MARK: - 转场动画
extension ViewController {
    
    /// 仿QQ左滑
    @objc private func leftItemClick() {
        transitioningDelegate = animator
        let interactiveHidden = TTInteractiveTransition(transitionType: .hidden)
        interactiveHidden.weakVC = self
        interactiveHidden.direction = .right
        animator.interactiveHidden = interactiveHidden
        present(LeftViewController(), animated: true, completion: nil)
    }
    
    /// 仿QQ右滑
    @objc private func rightItemClick() {
        
    }
    
    ///
    private func drawerDefaultAnimationRight() {
        
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        
        cell?.textLabel?.text = dataSource[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch indexPath.row {
        case 0: leftItemClick()
        case 1: rightItemClick()
        case 2: break
        case 3: break
        case 4: break
        case 5: break
        default:
            break
        }
    }
}

