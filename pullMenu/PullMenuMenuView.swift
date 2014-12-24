//
//  PullMenuMenuView.swift
//  pullMenu
//
//  Created by Ruben on 12/23/14.
//  Copyright (c) 2014 Ruben Nine & Josep Llodra. All rights reserved.
//

import UIKit

protocol PullMenuMenuViewDelegate {
    func pullMenuMenuView(pullMenuMenuView: PullMenuMenuView, wantsToChangeHeightTo height: CGFloat)
}

class PullMenuMenuView: UIView {

    var delegate: PullMenuMenuViewDelegate?
    
    private lazy var pgr: UIPanGestureRecognizer = {
        let obj = UIPanGestureRecognizer(target: self, action: "handlePanning:")
        
        return obj
    }()
    
    private var initialHeight: CGFloat = 0.0
    
    internal func handlePanning(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Began
        {
            initialHeight = self.frame.height
        }
        else if recognizer.state == UIGestureRecognizerState.Changed
        {
            NSLog("Gesture recognized")
            
            var translationPoint = recognizer.translationInView(self)
            
            delegate?.pullMenuMenuView(self, wantsToChangeHeightTo: initialHeight + translationPoint.y)
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
