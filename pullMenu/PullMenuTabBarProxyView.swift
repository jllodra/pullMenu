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
    private var labelViews: Array<UIView> = Array()
    private var labelWidth: CGFloat = 0.0
    
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
    
    func scrollToLabel(index: Int) {
        scrollView.setContentOffset(CGPointMake(CGFloat(index)*labelViews[0].frame.width, 0.0), animated: false)
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

                let leftFillerView = UIView(forAutoLayout: ())
                
                scrollView.addSubview(leftFillerView)
                
                leftFillerView.autoMatchDimension(ALDimension.Width,
                    toDimension: ALDimension.Width,
                    ofView: scrollView,
                    withMultiplier: 0.33
                )
                
                leftFillerView.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
                
                labelViews.append(leftFillerView)
               
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

                    labelViews.append(label)
                }
                
                let rightFillerView = UIView(forAutoLayout: ())
                rightFillerView.backgroundColor = UIColor.orangeColor()
                
                scrollView.addSubview(rightFillerView)
                
                rightFillerView.autoMatchDimension(ALDimension.Width,
                    toDimension: ALDimension.Width,
                    ofView: scrollView,
                    withMultiplier: 0.33
                )
                
                rightFillerView.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)

                labelViews.append(rightFillerView)
                
                let views = labelViews as NSArray

                views.autoDistributeViewsAlongAxis(ALAxis.Horizontal,
                    alignedTo: ALAttribute.Horizontal,
                    withFixedSpacing: 0.0,
                    insetSpacing: true,
                    matchedSizes: false
                )
            }
            
            didSetupConstraints = true
        }

        labelWidth = labelViews[0].frame.width

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
