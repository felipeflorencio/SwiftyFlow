//
//  ContainerView.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation

class ContainerView {
    
    func setupStackNavigation(using containerStack: ContainerFlowStack) {
        
        containerStack.registerModule(for: FirstViewController.self) { () -> FirstViewController in
            return FirstViewController()
        }
        
        containerStack.registerModule(for: SecondViewController.self) { () -> SecondViewController in
            return SecondViewController()
        }
        
        containerStack.registerModule(for: ThirdViewController.self) { () -> ThirdViewController in
            return ThirdViewController()
        }
    }
}
