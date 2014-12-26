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
    private var labelViews: [UIView] = []
    private var selectedTitle: String?
    
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
    
    func scrollToTitle(title: String) {
        if selectedTitle != title {
            if let index = find(items, title)
            {
                selectedTitle = title
                
                let labelWidth = labelViews[0].frame.width
                UIView.animateWithDuration(0.15,
                    delay: 0.0,
                    options: nil,
                    animations: {
                        self.scrollView.contentOffset = CGPointMake(CGFloat(index) * labelWidth, 0.0)
                    },
                    completion: nil
                )
            }
        }
    }
    
    func rebuildItems()
    {
        var selectedIndex = find(items, selectedTitle!) ?? 0
        var reorderedItems: [String] = []
        
        if (selectedIndex == 0)
        {
            // No reorder is needed
            
            reorderedItems = items
        }
        else if (selectedIndex == items.count - 1)
        {
            reorderedItems = [items.last!]
            reorderedItems += items[0...items.count - 2]
        }
        else
        {
            reorderedItems = []
            reorderedItems += items[selectedIndex...items.count - selectedIndex]
            reorderedItems += items[0...selectedIndex - 1]
        }
        
        items = reorderedItems
        
        self.scrollView.contentOffset = CGPointMake(0.0, 0.0)
        
        selectedTitle = items[0]
        didSetupConstraints = false
        setNeedsUpdateConstraints()
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
        
            for title in titlesToAdd {
                let label = UILabel(forAutoLayout: ())
                
                // Treat nil titles as fillers

                if title != nil {
                    label.text = title!
                    label.textAlignment = NSTextAlignment.Center
                    //label.backgroundColor = UIColor.greenColor()
                }
                
                scrollView.addSubview(label)

                label.autoMatchDimension(ALDimension.Width,
                    toDimension: ALDimension.Width,
                    ofView: scrollView,
                    withMultiplier: 0.33
                )
                
                label.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)

                labelViews.append(label)
            }
            
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
