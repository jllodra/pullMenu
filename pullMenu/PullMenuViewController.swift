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
    
    private func debug() {
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidLoad() {
        addControls()
        debug()
    }

}
