//
//  AutomaticallyFourthModalViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 21/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

class AutomaticallyFourthModalViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    var someData: String?
    
    // MARK: - IBAction
    @IBAction func back() {
        // The normal `getBack` is not modal, so you need to make sure that your
        // get back will pass the `pop` type as `modal`
        navigationFlow?.getBack(pop: .modal(animated: true))
        someData = "Getting data from another place"
    }
    
    @IBAction func closeHoleFlow() {
        navigationFlow?.dismissFlowController()
    }
    
    func modalViewSampleData() -> String? {
        return someData
    }
}
