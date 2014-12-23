//
//  PullMenuViewController.swift
//  pullMenu
//
//  Created by Ruben on 12/23/14.
//  Copyright (c) 2014 Ruben Nine & Josep Llodra. All rights reserved.
//

import UIKit

class PullMenuViewController: UIViewController {

    private lazy var menuView: PullMenuMenuView = {
        let obj = PullMenuMenuView(forAutoLayout: ())
        
        return obj
    }()    

    private lazy var contentView: UIView = {
        let obj = UIView(forAutoLayout: ())
        
        return obj
    }()

    private func addControls() {
        view.addSubview(menuView)
        view.addSubview(contentView)
    }

    private func setupConstraints()
    {
        menuView.autoSetDimension(
            ALDimension.Width,
            toSize: view.bounds.width
        )
        
        menuView.autoPinEdgeToSuperviewEdge(ALEdge.Top)
        menuView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        menuView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
        
        contentView.autoSetDimension(
            ALDimension.Width,
            toSize: view.bounds.width
        )

        contentView.autoPinEdge(
            ALEdge.Top,
            toEdge: ALEdge.Bottom,
            ofView: menuView
        )

        contentView.autoMatchDimension(
            ALDimension.Height,
            toDimension: ALDimension.Height,
            ofView: menuView
        )

        contentView.autoPinEdgeToSuperviewEdge(ALEdge.Bottom)
        contentView.autoPinEdgeToSuperviewEdge(ALEdge.Leading)
        contentView.autoPinEdgeToSuperviewEdge(ALEdge.Trailing)
    }
    
    private func debug() {
        view.backgroundColor = UIColor.blackColor()
        menuView.backgroundColor = UIColor.greenColor()
        contentView.backgroundColor = UIColor.blueColor()
        
        println("view.subviews = %d", view.subviews)
    }
    
    override func viewDidLoad() {
        addControls()
        setupConstraints()
        debug()
    }

}
