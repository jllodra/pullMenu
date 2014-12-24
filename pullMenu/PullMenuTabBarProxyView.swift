//
//  PullMenuMenuView.swift
//  pullMenu
//
//  Created by Ruben on 12/23/14.
//  Copyright (c) 2014 Ruben Nine & Josep Llodra. All rights reserved.
//

import UIKit

protocol PullMenuTabBarProxyViewDelegate {
    func pullMenuTabBarProxyView(pullMenuMenuView: PullMenuTabBarProxyView, wantsToChangeHeightTo height: CGFloat, isDragging: Bool)
}

class PullMenuTabBarProxyView: UIView {

    var delegate: PullMenuTabBarProxyViewDelegate?
    var tabBar: UITabBar?

    private var areLabelsSet: Bool = false
    
    private lazy var pgr: UIPanGestureRecognizer = {
        let obj = UIPanGestureRecognizer(target: self, action: "handlePanning:")
        
        return obj
    }()
    
    private var initialHeight: CGFloat = 0.0
    
    internal func handlePanning(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            case UIGestureRecognizerState.Began:
                initialHeight = frame.height
                break
            case UIGestureRecognizerState.Changed:
                var translationPoint = recognizer.translationInView(self)

                delegate?.pullMenuTabBarProxyView(self, wantsToChangeHeightTo: initialHeight + translationPoint.y, isDragging: true)
                break
            case UIGestureRecognizerState.Ended:
                delegate?.pullMenuTabBarProxyView(self, wantsToChangeHeightTo: initialHeight, isDragging: false)
                break
            default:
                break
        }
    }
    
    override func updateConstraints() {
        if (!areLabelsSet)
        {
            if let items = tabBar?.items as? Array<UITabBarItem> {
                for item in items
                {
                    println(item.title)
                    
                    let label = UILabel(forAutoLayout: ())
                    
                    label.text = item.title
                    label.textAlignment = NSTextAlignment.Center

                    addSubview(label)

                    label.autoPinEdgeToSuperviewEdge(ALEdge.Top)
                    label.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
                    label.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
                    label.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
                }
            }
            
            areLabelsSet = true
        }

        super.updateConstraints()
    }
    
    override init() {
        super.init()
        NSLog("PullMenuTabBarProxyView init")
        addGestureRecognizer(pgr)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLog("PullMenuTabBarProxyView init with frame")
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
