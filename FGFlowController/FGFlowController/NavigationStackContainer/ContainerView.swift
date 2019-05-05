//
//  ContainerView.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation

class ContainerView {
    
    func setupStackNavigation(using container: NavigationContainerStack) {
        
        container.registerModule(for: FirstViewController.self) { () -> FirstViewController in
            return FirstViewController()
        }
        
        container.registerModule(for: SecondViewController.self) { () -> SecondViewController in
            return SecondViewController()
        }
        
        container.registerModule(for: ThirdViewController.self) { () -> ThirdViewController in
            return ThirdViewController()
        }
    }
}
