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
    
    internal func handlePanning(recognizer: UIPanGestureRecognizer) {
        NSLog("Gesture recognized")
        var velocity:CGPoint = recognizer.velocityInView(self)
        var f:CGRect = self.frame

        if (velocity.y > 0) {
            delegate?.pullMenuMenuView(self, wantsToChangeHeightTo: f.size.height + 1)
        } else {
            delegate?.pullMenuMenuView(self, wantsToChangeHeightTo: f.size.height - 1)
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
