//
//  ThirdViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, ViewModule, NavigationStack {
        
    var navigationCoordinator: NavigationCoordinator?
    
    @IBAction func goBackToRootStoryboardNavigation() {
        self.navigationCoordinator?.getBack(pop: .popToRoot(animated: true))
    }
    
    @IBAction func goBackView() {
        self.navigationCoordinator?.getBack(pop: .popTo(animated: true), screen: { viewToGo in
            viewToGo(FirstViewController.self)
        })
    }
    
    // NIB Navigation
    @IBAction func goBackNibView() {
        self.navigationCoordinator?.getBack(pop: .popTo(animated: true), screen: { viewToGo in
            viewToGo(FirstViewController.self)
        })
    }
    
    // This is a behaviour that for now should only be used for test
    @IBAction func forDismissWhenPresenting() {
        navigationCoordinator?.dismissFlowController()
    }
}
