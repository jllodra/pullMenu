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

    private var didSetupConstraints: Bool = false
    
    private lazy var scrollView: UIScrollView = {
        let obj = UIScrollView(forAutoLayout: ())
        
        //obj.scrollEnabled = false
        
        return obj
    }()

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
        if !didSetupConstraints
        {
            if !contains(subviews as Array<UIView>, scrollView)
            {
                addSubview(scrollView)

                scrollView.backgroundColor = UIColor.purpleColor()
                
                scrollView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
                scrollView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
                scrollView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
                scrollView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
            }

            if let items = tabBar?.items as? Array<UITabBarItem> {

                let dummyLabel = UILabel(forAutoLayout: ())
                dummyLabel.text = " "
                dummyLabel.backgroundColor = UIColor.orangeColor()
                
                scrollView.addSubview(dummyLabel)
                
                dummyLabel.autoMatchDimension(ALDimension.Width,
                    toDimension: ALDimension.Width,
                    ofView: scrollView,
                    withMultiplier: 0.33
                )
                
                dummyLabel.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
                
                for item in items
                {
                    let label = UILabel(forAutoLayout: ())
                    
                    label.text = item.title
                    label.textAlignment = NSTextAlignment.Center
                    label.backgroundColor = UIColor.greenColor()
                    
                    scrollView.addSubview(label)

                    label.autoMatchDimension(ALDimension.Width,
                        toDimension: ALDimension.Width,
                        ofView: scrollView,
                        withMultiplier: 0.33
                    )
                    
                    label.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
                }
                
                let dummyLabel2 = UILabel(forAutoLayout: ())
                dummyLabel2.text = " "
                dummyLabel2.backgroundColor = UIColor.orangeColor()
                
                scrollView.addSubview(dummyLabel2)
                
                dummyLabel2.autoMatchDimension(ALDimension.Width,
                    toDimension: ALDimension.Width,
                    ofView: scrollView,
                    withMultiplier: 0.33
                )
                
                dummyLabel2.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)

                let views = scrollView.subviews as NSArray

                views.autoDistributeViewsAlongAxis(ALAxis.Horizontal,
                    alignedTo: ALAttribute.Horizontal,
                    withFixedSpacing: 0.0,
                    insetSpacing: true,
                    matchedSizes: false
                )
            }
            
            didSetupConstraints = true
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
