//
//  AutomaticallyNavigationNibContainer.swift
//  SwiftyFlow_Example
//
//  Created by Felipe Florencio Garcia on 16/06/19.
//  Copyright © 2019 Felipe F Garcia. All rights reserved.
//

import Foundation
import SwiftyFlow

class AutomaticallyNavigationNibContainer {
    
    func setupNavigationStack(using containerStack: ContainerFlowStack) {
        
        containerStack.registerModule(for: AutomaticallyNibInitialViewController.self) { () -> AutomaticallyNibInitialViewController in
            return AutomaticallyNibInitialViewController()
        }
        
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
