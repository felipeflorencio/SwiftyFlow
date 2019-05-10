//
//  DeeplinkNavigationContainer.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation

class DeeplinkNavigationContainer {
    
    func setupNavigationStack(using containerStack: ContainerFlowStack) {
        
        containerStack.registerModule(for: DeeplinkInitialViewController.self) { () -> DeeplinkInitialViewController in
            return DeeplinkInitialViewController()
        }
        
        containerStack.registerModule(for: DeeplinkFirstViewController.self) { () -> DeeplinkFirstViewController in
            return DeeplinkFirstViewController()
        }
        
        containerStack.registerModule(for: DeeplinkSecondViewController.self) { () -> DeeplinkSecondViewController in
            return DeeplinkSecondViewController()
        }
        
        containerStack.registerModule(for: DeeplinkThirdViewController.self) { () -> DeeplinkThirdViewController in
            return DeeplinkThirdViewController()
        }
        
        containerStack.registerModule(for: DeeplinkFourthViewController.self) { () -> DeeplinkFourthViewController in
            return DeeplinkFourthViewController()
        }
        
        containerStack.registerModule(for: DeeplinkFifthViewController.self) { () -> DeeplinkFifthViewController in
            return DeeplinkFifthViewController()
        }
        
        containerStack.registerModule(for: DeeplinkSixthViewController.self) { () -> DeeplinkSixthViewController in
            return DeeplinkSixthViewController()
        }
        
        containerStack.registerModule(for: DeeplinkSeventhViewController.self) { () -> DeeplinkSeventhViewController in
            return DeeplinkSeventhViewController()
        }
    }
}
