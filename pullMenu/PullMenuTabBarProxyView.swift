//
//  PullMenuMenuView.swift
//  pullMenu
//
//  Created by Ruben on 12/23/14.
//  Copyright (c) 2014 Ruben Nine & Josep Llodra. All rights reserved.
//

import UIKit

protocol PullMenuTabBarProxyViewDelegate {
    func pullMenuTabBarProxyView(pullMenuMenuView: PullMenuTabBarProxyView, wantsToChangeHeightTo height: CGFloat)
}

class PullMenuTabBarProxyView: UIView {

    var delegate: PullMenuTabBarProxyViewDelegate?
    var tabBar: UITabBar?
    
    private lazy var pgr: UIPanGestureRecognizer = {
        let obj = UIPanGestureRecognizer(target: self, action: "handlePanning:")
        
        return obj
    }()
    
    private var initialHeight: CGFloat = 0.0
    
    internal func handlePanning(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case UIGestureRecognizerState.Began:
                initialHeight = self.frame.height
                break
            case UIGestureRecognizerState.Changed:
                var translationPoint = recognizer.translationInView(self)

                delegate?.pullMenuTabBarProxyView(self, wantsToChangeHeightTo: initialHeight + translationPoint.y)
                break
            case UIGestureRecognizerState.Ended:
                self.delegate?.pullMenuTabBarProxyView(self, wantsToChangeHeightTo: self.initialHeight)
                break
            default:
                break
        }
    }
    
    override init() {
        super.init()
        NSLog("PullMenuMenuView init")
        addGestureRecognizer(pgr)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLog("PullMenuMenuView init with frame")
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
