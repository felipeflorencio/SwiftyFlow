//
//  AutomaticallyInitialModalViewController.swift
//  SwiftyFlow_Example
//
//  Created by Felipe Florencio Garcia on 12/06/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import SwiftyFlow

class AutomaticallyInitialModalViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseNavigationButton()
    }
    
    // MARK: UI Adjust
    private func addCloseNavigationButton() {
        self.navigationFlow?.managerNavigation()?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Close Navigation", style: .plain, target: self, action: #selector(closeTapped))
    }
    
    @objc private func closeTapped() {
        navigationFlow?.dismissFlowController()
    }
    
    // MARK: - IBAction
    @IBAction func startNavigation() {
        navigationFlow?.goNext()
    }
}
