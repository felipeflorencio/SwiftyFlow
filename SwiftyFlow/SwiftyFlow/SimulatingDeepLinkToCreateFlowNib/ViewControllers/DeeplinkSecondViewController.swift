//
//  DeeplinkSecondViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class DeeplinkSecondViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    // MARK: - IBAction
    @IBAction func backToRoot() {
        navigationFlow?.dismissFlowController()
    }
    
    @IBAction func closeHoleFlow() {
        navigationFlow?.dismissFlowController().finishFlowWith(parameter: true)
    }
}
