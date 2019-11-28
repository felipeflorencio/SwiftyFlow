//
//  ResolveRootSecondViewController.swift
//  SwiftyFlow_Example
//
//  Created by Felipe Florencio Garcia on 28/11/19.
//  Copyright © 2019 Felipe F Garcia. All rights reserved.
//

import Foundation
import SwiftyFlow

class ResolveRootSecondViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    var parameterInjection: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseNavigationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("Parameter is: \(parameterInjection)")
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
        navigationFlow?.goNext(screen: AutomaticallyFirstViewController.self)
    }
}
