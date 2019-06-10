//
//  ParameterSecondViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 30/05/19.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

class ParameterSecondViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    // MARK: - IBAction
    @IBAction func next() {
        navigationFlow?.goNext()
    }
    
    @IBAction func back() {
        navigationFlow?.getBack()
    }
}
