//
//  PullMenuViewController.swift
//  pullMenu
//
//  Created by Ruben on 12/23/14.
//  Copyright (c) 2014 Ruben Nine & Josep Llodra. All rights reserved.
//

import UIKit

class PullMenuViewController: UIViewController, PullMenuMenuViewDelegate {

    struct DefaultDimensions {
        static let menuViewHeight: CGFloat = 80.0
    }
    
    var didSetupConstraints: Bool = false
    var menuViewHeightConstraint: NSLayoutConstraint?

    // MARK: Accessors
    
    private lazy var menuView: PullMenuMenuView = {
        let obj = PullMenuMenuView(forAutoLayout: ())
        
        obj.delegate = self
        
        return obj
    }()    

    private lazy var contentView: UIView = {
        let obj = UIView(forAutoLayout: ())
        
        return obj
    }()
    
    // MARK: Public Methods
    
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            menuView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
            menuView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
            menuView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
            
            menuViewHeightConstraint = self.menuView.autoSetDimension(
                ALDimension.Height,
                toSize: DefaultDimensions.menuViewHeight
            )
            
            contentView.autoPinEdge(
                ALEdge.Top,
                toEdge: ALEdge.Bottom,
                ofView: menuView
            )
            
            contentView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
            contentView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
            contentView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        addControls()
        debug()
    }

    // MARK: Private Methods
    
    private func addControls() {
        view.addSubview(menuView)
        view.addSubview(contentView)
        view.setNeedsUpdateConstraints()
    }
    
    private func debug() {
        view.backgroundColor = UIColor.blackColor()
        menuView.backgroundColor = UIColor.greenColor()
        contentView.backgroundColor = UIColor.blueColor()
    }
}

extension PullMenuViewController : PullMenuMenuViewDelegate {

    func pullMenuMenuView(pullMenuMenuView: PullMenuMenuView, wantsToChangeHeightTo height: CGFloat) {
        menuViewHeightConstraint?.constant = height
        view.layoutIfNeeded()
    }
}
