//
//  AutomaticallyInitialViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

// This flow follows the MVC pattern, trying to use the most common and simples
// setup, that is the reason that our navigation stack will start from here
class AutomaticallyInitialViewController: UIViewController, NavigationFlow {
    
    var navigationFlow: FlowManager?
    
    // MARK: - IBAction
    @IBAction func startNavigation() {
        navigationFlow?.goNext()
    }
}
