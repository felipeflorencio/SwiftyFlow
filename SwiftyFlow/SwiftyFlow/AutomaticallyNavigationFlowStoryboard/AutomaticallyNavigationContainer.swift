//
//  AutomaticallyNavigationContainer.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation

class AutomaticallyNavigationContainer {
    
    func setupNavigationStack(using containerStack: ContainerFlowStack) {
        
        // TODO: (felipe) This need to be done in order to test as our first view is just ViewController
        containerStack.registerModule(for: AutomaticallyInitialViewController.self) { () -> AutomaticallyInitialViewController in
            return AutomaticallyInitialViewController()
        }.inScope(scope: .strong)
        
        containerStack.registerModule(for: AutomaticallyFirstViewController.self) { () -> AutomaticallyFirstViewController in
            return AutomaticallyFirstViewController()
        }
        
        containerStack.registerModule(for: AutomaticallySecondViewController.self) { () -> AutomaticallySecondViewController in
            return AutomaticallySecondViewController()
        }
        
        containerStack.registerModule(for: AutomaticallyThirdViewController.self) { () -> AutomaticallyThirdViewController in
            return AutomaticallyThirdViewController()
        }
    }
}
