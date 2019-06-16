//
//  AutomaticallyNibInitialViewController.swift
//  SwiftyFlow_Example
//
//  Created by Felipe Florencio Garcia on 16/06/19.
//  Copyright © 2019 Felipe F Garcia. All rights reserved.
//

import Foundation
import SwiftyFlow

class AutomaticallyNibInitialViewController: UIViewController, FlowNavigator {
    
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
