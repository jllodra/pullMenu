//
//  PullMenuMenuView.swift
//  pullMenu
//
//  Created by Ruben on 12/23/14.
//  Copyright (c) 2014 Ruben Nine & Josep Llodra. All rights reserved.
//

import UIKit

class PullMenuMenuView: UIView {

    private lazy var pgr: UIPanGestureRecognizer = {
        let obj = UIPanGestureRecognizer(target: self, action: "handlePanning:")
        
        return obj
    }()
    
    internal func handlePanning(recognizer: UIPanGestureRecognizer) {
        NSLog("Gesture recognized")
        var velocity:CGPoint = recognizer.velocityInView(self)
        var f:CGRect = self.frame
        if(velocity.y > 0) {
            f.size.height += 1
        } else {
            f.size.height -= 1
        }
        self.frame = f
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
