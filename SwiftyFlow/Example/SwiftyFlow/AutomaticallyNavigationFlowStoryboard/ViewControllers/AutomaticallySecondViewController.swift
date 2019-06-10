//
//  AutomaticallySecondViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

class AutomaticallySecondViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    // MARK: - IBAction
    @IBAction func next() {
        navigationFlow?.goNext()
    }
    
    @IBAction func back() {
        navigationFlow?.getBack()
    }
}
