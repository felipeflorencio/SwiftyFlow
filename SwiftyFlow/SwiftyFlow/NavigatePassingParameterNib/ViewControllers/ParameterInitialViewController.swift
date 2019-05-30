//
//  GoAnywhereInitialViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

// This flow follows the MVC pattern, trying to use the most common and simples
// setup, that is the reason that our navigation stack will start from here
class GoAnywhereInitialViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseNavigationButton()
    }
    
    // MARK: UI Adjust
    private func addCloseNavigationButton() {
      self.navigationFlow?.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Close Navigation", style: .plain, target: self, action: #selector(closeTapped))
    }
    
    @objc private func closeTapped() {
        navigationFlow?.dismissFlowController()
    }
    
    // MARK: - IBAction
    @IBAction func startNavigation() {
//        This works
//        navigationFlow?.goNextWith(parameters: { () -> ((String, Int)) in
//            return ("Felipe Garcia", 232)
//        }, screen: { (nextView) in
//            nextView(GoAnywhereFirstViewController.self)
//        })
        navigationFlow?.goNextWith(screen: GoAnywhereFirstViewController.self,
                                   parameters: { () -> ((String, Int)) in
            return ("Felipe Garcia", 232)
        })
    }
}
