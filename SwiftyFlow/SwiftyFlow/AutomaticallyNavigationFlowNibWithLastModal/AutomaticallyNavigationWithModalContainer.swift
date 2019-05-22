//
//  AutomaticallyNavigationWithModalContainer.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 20/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation

class AutomaticallyNavigationWithModalContainer {
    
    func setupNavigationStack(using containerStack: ContainerFlowStack) {
        
        containerStack.registerModule(for: AutomaticallyInitialViewController.self) { () -> AutomaticallyInitialViewController in
            return AutomaticallyInitialViewController()
        }
        
        containerStack.registerModule(for: AutomaticallyFirstViewController.self) { () -> AutomaticallyFirstViewController in
            return AutomaticallyFirstViewController()
        }
        
        containerStack.registerModule(for: AutomaticallySecondViewController.self) { () -> AutomaticallySecondViewController in
            return AutomaticallySecondViewController()
        }
        
        containerStack.registerModule(for: AutomaticallyThirdModalViewController.self) { () -> AutomaticallyThirdModalViewController in
            return AutomaticallyThirdModalViewController()
        }
        
        containerStack.registerModule(for: AutomaticallyFourthModalViewController.self) { () -> AutomaticallyFourthModalViewController in
            return AutomaticallyFourthModalViewController()
        }.inScope(scope: .strong)
    }
}
