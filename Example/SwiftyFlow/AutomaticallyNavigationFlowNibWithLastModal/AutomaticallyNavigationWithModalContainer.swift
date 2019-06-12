//
//  AutomaticallyNavigationWithModalContainer.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 20/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import SwiftyFlow

class AutomaticallyNavigationWithModalContainer {
    
    func setupNavigationStack(using containerStack: ContainerFlowStack) {
        
        containerStack.registerModule(for: AutomaticallyInitialModalViewController.self) { () -> AutomaticallyInitialModalViewController in
            return AutomaticallyInitialModalViewController()
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
