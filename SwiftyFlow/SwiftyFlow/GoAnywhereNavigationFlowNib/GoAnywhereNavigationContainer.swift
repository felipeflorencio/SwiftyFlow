//
//  GoAnywhereNavigationContainer.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation

class GoAnywhereNavigationContainer {
    
    private let containerStack: ContainerFlowStack

    init(stack container: ContainerFlowStack) {
        containerStack = container
    }
    
    func setup() -> ContainerFlowStack {

        containerStack.registerModuleWith(for: GoAnywhereInitialViewController.self) { (arguments: (String, Double)) -> GoAnywhereInitialViewController? in
            
            let (first, second) = arguments
            let firstData = first
            let secondData = second
            
            debugPrint("first data: \(firstData)")
            debugPrint("second data: \(secondData)")
            
            return GoAnywhereInitialViewController()
        }
        
//        containerStack.registerModule(for: GoAnywhereInitialViewController.self) { () -> GoAnywhereInitialViewController in
//            return GoAnywhereInitialViewController()
//        }
        
        containerStack.registerModule(for: GoAnywhereFirstViewController.self) { () -> GoAnywhereFirstViewController in
            return GoAnywhereFirstViewController()
        }
        
        containerStack.registerModule(for: GoAnywhereSecondViewController.self) { () -> GoAnywhereSecondViewController in
            return GoAnywhereSecondViewController()
        }
        
        containerStack.registerModule(for: GoAnywhereThirdViewController.self) { () -> GoAnywhereThirdViewController in
            return GoAnywhereThirdViewController()
        }
        
        containerStack.registerModule(for: GoAnywhereFourthViewController.self) { () -> GoAnywhereFourthViewController in
            return GoAnywhereFourthViewController()
        }
        
        containerStack.registerModule(for: GoAnywhereFifthViewController.self) { () -> GoAnywhereFifthViewController in
            return GoAnywhereFifthViewController()
        }
        
        containerStack.registerModule(for: GoAnywhereSixthViewController.self) { () -> GoAnywhereSixthViewController in
            return GoAnywhereSixthViewController()
        }
        
        containerStack.registerModule(for: GoAnywhereSeventhViewController.self) { () -> GoAnywhereSeventhViewController in
            return GoAnywhereSeventhViewController()
        }
        
        return containerStack
    }
}
