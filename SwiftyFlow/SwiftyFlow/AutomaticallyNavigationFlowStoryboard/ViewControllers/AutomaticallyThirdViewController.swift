//
//  AutomaticallyThirdViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class AutomaticallyThirdViewController: UIViewController, NavigationFlow {
    
    var navigationFlow: FlowManager?
    
    // MARK: - IBAction
    @IBAction func back() {
        navigationFlow?.getBack()
    }
    
    @IBAction func backToRoot() {
        navigationFlow?.getBack(pop: .popToRoot(animated: true))
    }
}
