//
//  PullMenuViewController.swift
//  pullMenu
//
//  Created by Ruben on 12/23/14.
//  Copyright (c) 2014 Ruben Nine & Josep Llodra. All rights reserved.
//

import UIKit

class PullMenuTabBarController: UITabBarController, PullMenuTabBarProxyViewDelegate {

    struct Config {
        static let menuViewHeight: CGFloat = 80.0
        static let animationTime: NSTimeInterval = 0.5
        static let animationDelay: NSTimeInterval = 0.0
        static let animationSpringWithDamping: CGFloat = 0.3
        static let animationInitialSpringVelocity: CGFloat = 0.5
    }
    
    var didSetupConstraints: Bool = false
    internal var menuViewHeightConstraint: NSLayoutConstraint?
    
    // MARK: Accessors
    
    private lazy var tabBarProxyView: PullMenuTabBarProxyView = {
        let obj = PullMenuTabBarProxyView(forAutoLayout: ())
        
        obj.delegate = self
        obj.tabBar = self.tabBar
        
        return obj
    }()    

    // MARK: Public Methods
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            tabBarProxyView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
            tabBarProxyView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
            tabBarProxyView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
            
            menuViewHeightConstraint = tabBarProxyView.autoSetDimension(ALDimension.Height,
                toSize: Config.menuViewHeight
            )
            
            let transitionView = view.subviews[0] as UIView

            transitionView.autoPinEdge(ALEdge.Top,
                toEdge: ALEdge.Bottom,
                ofView: tabBarProxyView
            )
            
            transitionView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
            transitionView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
            transitionView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        tabBar.hidden = true

        addControls()
        debug()
    }

    // MARK: Private Methods
    
    private func addControls() {
        view.addSubview(tabBarProxyView)
        view.setNeedsUpdateConstraints()
    }
    
    private func debug() {
        view.backgroundColor = UIColor.grayColor()
        tabBarProxyView.backgroundColor = UIColor.darkGrayColor()
    }
}

extension PullMenuTabBarController : PullMenuTabBarProxyViewDelegate {

    func pullMenuTabBarProxyView(pullMenuTabBarProxyView: PullMenuTabBarProxyView, wantsToChangeHeightTo height: CGFloat, isDragging: Bool) {
        let maxHeight = self.view.frame.height / 2.0
        let targetHeight = min(height, maxHeight)
        
        if (!isDragging)
        {
            UIView.animateWithDuration(Config.animationTime,
                delay: Config.animationDelay,
                usingSpringWithDamping: Config.animationSpringWithDamping,
                initialSpringVelocity: Config.animationInitialSpringVelocity,
                options: nil,
                animations: {
                    self.menuViewHeightConstraint?.constant = targetHeight
                    self.view.layoutIfNeeded()
                },
                completion: nil
            )
        }
        else
        {            
            self.menuViewHeightConstraint?.constant = targetHeight
            self.view.layoutIfNeeded()

            let numberOfItemsInTabBar = self.tabBar.items!.count
            
            let mappedItem = PullMenuUtils.mapValue(targetHeight,
                minV: Config.menuViewHeight,
                maxV: maxHeight,
                outMinV: 0.0,
                outMaxV: CGFloat(numberOfItemsInTabBar - 1)
            )
            
            selectedIndex = abs(max(0, Int(round(mappedItem))))
        }
    }
}
