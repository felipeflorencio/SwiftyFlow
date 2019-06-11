//
//  ParameterThirdViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 30/05/19.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

class ParameterThirdViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    // MARK: - IBAction
    @IBAction func back() {
        navigationFlow?.getBack()
    }
    
    @IBAction func backToRoot() {
        navigationFlow?.getBack(pop: .popToRoot(animated: true))
    }
    
    @IBAction func closeHoleFlow() {
        navigationFlow?.dismissFlowController()
    }
}
