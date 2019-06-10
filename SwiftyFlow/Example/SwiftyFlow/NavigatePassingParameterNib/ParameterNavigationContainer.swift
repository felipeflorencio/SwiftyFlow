//
//  ParameterNavigationContainer.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 30/05/19.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import SwiftyFlow

class ParameterNavigationContainer {
    
    private let containerStack: ContainerFlowStack
    
    init(stack container: ContainerFlowStack) {
        containerStack = container
    }
    
    func setup() -> ContainerFlowStack {
        
        containerStack.registerModuleWithParameter(for: ParameterInitialViewController.self) { (arguments: (String, Double, String, Int)) -> ParameterInitialViewController? in
            
            let (first, second, third, fourth) = arguments

            let initialViewController = ParameterInitialViewController()
            initialViewController.setParameters(first: first, second, third, fourth)
            
            return initialViewController
        }
  
        containerStack.registerModuleWithParameter(for: ParameterFirstViewController.self) { (arguments: (String, Int)) -> ParameterFirstViewController? in
            let (first, second) = arguments
            
            let firstViewController = ParameterFirstViewController()
            firstViewController.setParameters(first: first, second)
            
            return firstViewController
        }
        
        containerStack.registerModule(for: ParameterSecondViewController.self) { () -> ParameterSecondViewController in
            return ParameterSecondViewController()
        }
        
        containerStack.registerModule(for: ParameterThirdViewController.self) { () -> ParameterThirdViewController in
            return ParameterThirdViewController()
        }
        
        containerStack.registerModule(for: ParameterFourthViewController.self) { () -> ParameterFourthViewController in
            return ParameterFourthViewController()
        }

        
        return containerStack
    }
}
