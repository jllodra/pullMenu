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
    var items: [String] = []
    
    private var didSetupConstraints: Bool = false
    private var labelViews: [UILabel] = []
    private var selectedIndex: Int = 0
    
    private lazy var scrollView: UIScrollView = {
        let obj = UIScrollView(forAutoLayout: ())
        
        obj.scrollEnabled = false
        
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
    
    func scrollToIndex(index: Int) {
        if selectedIndex != index {
            selectedIndex = index
            
            UIView.animateWithDuration(0.15,
                delay: 0.0,
                options: nil,
                animations: {
                    let xOffset = CGFloat(self.labelViews[index].frame.origin.x)
                    self.scrollView.contentOffset = CGPointMake(xOffset, 0.0)
                },
                completion: nil
            )
        }
    }
    
    func rebuildItems()
    {
        if (selectedIndex > 0) {
            let labels = actualLabelViews()

            if let selectedLabelIndex = find(items, labels[selectedIndex].text!) {
                var index = selectedLabelIndex
                
                for element in labels {
                    element.text = items[index]
                    index++
                    index %= items.count
                }
            }
        }
        
        selectedIndex = 0
        scrollView.contentOffset = CGPointMake(0.0, 0.0)
        
        updateLabelItemsAlpha(0.0)
    }
    
    func updateLabelItemsAlpha(distanceDone: CGFloat) {
        let labels = actualLabelViews()

        for (index, labelView) in enumerate(labels) {
            labelView.alpha = index == selectedIndex ? 1.0 : min(distanceDone, 0.66)
        }
    }
    
    func dimLabels() {
        let actualLabelViews = filter(labelViews) { $0.text != nil }

        for (index, labelView) in enumerate(actualLabelViews) {
            if index != selectedIndex {
                labelView.alpha = 0.0
            }
        }
    }
    
    private func actualLabelViews() -> [UILabel] {
        return filter(labelViews) { $0.text != nil }
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            if !contains(subviews as [UIView], scrollView) {
                addSubview(scrollView)
                
                scrollView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
                scrollView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
                scrollView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
                scrollView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
            }

            var titlesToAdd: [String?] = []
            
            titlesToAdd.append(nil)

            for item in items {
                titlesToAdd.append(item)
            }
            
            titlesToAdd.append(nil)
            
            // Remove existing labels
            
            for view in labelViews {
                view.removeFromSuperview()
            }
            
            labelViews = []
            
            // Create and add labels
        
            for (index, title) in enumerate(titlesToAdd) {
                let label = UILabel(forAutoLayout: ())
                
                // Treat nil titles as fillers

                if title != nil {
                    label.text = title!
                    label.textColor = UIColor.whiteColor()
                    label.textAlignment = NSTextAlignment.Center
                    //label.backgroundColor = UIColor.greenColor()
                }
                
                scrollView.addSubview(label)

                label.autoMatchDimension(ALDimension.Width,
                    toDimension: ALDimension.Width,
                    ofView: scrollView,
                    withMultiplier: 0.3333
                )
                
                label.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)

                labelViews.append(label)
            }
            
            dimLabels()
            
            (labelViews as NSArray).autoDistributeViewsAlongAxis(ALAxis.Horizontal,
                alignedTo: ALAttribute.Horizontal,
                withFixedSpacing: 0.0,
                insetSpacing: true,
                matchedSizes: false
            )
            
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
