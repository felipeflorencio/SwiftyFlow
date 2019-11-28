//
//  ResolveRootNavigationNibContainer.swift
//  SwiftyFlow_Example
//
//  Created by Felipe Florencio Garcia on 28/11/19.
//  Copyright © 2019 Felipe F Garcia. All rights reserved.
//

import Foundation
import SwiftyFlow

class ResolveRootNavigationNibContainer {
    
    let container = ContainerFlowStack()
    
    func setupNavigationStack() -> ContainerFlowStack {
        
        // The ones that we will use to be selected when start
        container.registerModule(for: ResolveRootNibInitialViewController.self) { () -> ResolveRootNibInitialViewController in
            return ResolveRootNibInitialViewController()
        }

        container.registerModule(for: ResolveRootFirstViewController.self) { () -> ResolveRootFirstViewController in
            return ResolveRootFirstViewController()
        }

        container.registerModule(for: ResolveRootSecondViewController.self) { () -> ResolveRootSecondViewController in
            return ResolveRootSecondViewController()
        }

        container.registerModule(for: ResolveRootThirdViewController.self) { () -> ResolveRootThirdViewController in
            return ResolveRootThirdViewController()
        }
        
//        container.registerModuleWithParameter(for: ResolveRootNibInitialViewController.self) { (arguments: (String)) -> ResolveRootNibInitialViewController in
//            let (parameterInjected) = arguments
//            let viewController = ResolveRootNibInitialViewController()
//            viewController.parameterInjection = parameterInjected
//            return viewController
//        }
//
//        container.registerModuleWithParameter(for: ResolveRootFirstViewController.self) { (arguments: (String)) -> ResolveRootFirstViewController in
//            let (parameterInjected) = arguments
//            let viewController = ResolveRootFirstViewController()
//            viewController.parameterInjection = parameterInjected
//            return viewController
//        }
//
//        container.registerModuleWithParameter(for: ResolveRootSecondViewController.self) { (arguments: (String)) -> ResolveRootSecondViewController in
//            let (parameterInjected) = arguments
//            let viewController = ResolveRootSecondViewController()
//            viewController.parameterInjection = parameterInjected
//            return viewController
//        }
//
//        container.registerModuleWithParameter(for: ResolveRootThirdViewController.self) { (arguments: (String)) -> ResolveRootThirdViewController in
//            let (parameterInjected) = arguments
//            let viewController = ResolveRootThirdViewController()
//            viewController.parameterInjection = parameterInjected
//            return viewController
//        }
        
        // From another flows just to show that you can navigate to any of these
        container.registerModule(for: AutomaticallyFirstViewController.self) { () -> AutomaticallyFirstViewController in
            return AutomaticallyFirstViewController()
        }
        
        container.registerModule(for: AutomaticallySecondViewController.self) { () -> AutomaticallySecondViewController in
            return AutomaticallySecondViewController()
        }
        
        container.registerModule(for: AutomaticallyThirdViewController.self) { () -> AutomaticallyThirdViewController in
            return AutomaticallyThirdViewController()
        }
        
        return container
    }
}
