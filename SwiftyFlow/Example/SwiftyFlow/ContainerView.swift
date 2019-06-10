//
//  ContainerView.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import SwiftyFlow

class ContainerView {
    
    func setupStackNavigation(using containerStack: ContainerFlowStack) {
        
        // TODO: (felipe) This need to be done in order to test as our first view is just ViewController
        containerStack.registerModule(for: ViewController.self) { () -> ViewController in
            return ViewController()
        }
        
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
