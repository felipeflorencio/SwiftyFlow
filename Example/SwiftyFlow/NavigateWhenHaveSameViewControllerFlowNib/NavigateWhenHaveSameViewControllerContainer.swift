//
//  NavigateWhenHaveSameViewControllerContainer.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 18/12/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import SwiftyFlow

class NavigateWhenHaveSameViewControllerContainer {
    
    private let containerStack = ContainerFlowStack()
    
    func setup() -> ContainerFlowStack {

        containerStack.registerModule(for: SameInitialViewController.self) { () -> SameInitialViewController in
            return SameInitialViewController()
        }
        
        containerStack.registerModule(for: SameFirstViewController.self) { () -> SameFirstViewController in
            return SameFirstViewController()
        }
        
        containerStack.registerModule(for: SameFirstViewController.self, customIdentifier: "FirstView1") { () -> SameFirstViewController in
            let viewController = SameFirstViewController()
            viewController.title = "FirstView1"
            return viewController
        }
        
        containerStack.registerModule(for: SameFirstViewController.self, customIdentifier: "FirstView2") { () -> SameFirstViewController in
            let viewController = SameFirstViewController()
            viewController.title = "FirstView2"
            return viewController
        }
                
        return containerStack
    }
}
