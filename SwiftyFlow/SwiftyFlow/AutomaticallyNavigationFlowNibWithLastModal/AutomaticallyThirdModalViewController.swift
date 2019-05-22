//
//  AutomaticallyThirdModalViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 21/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class AutomaticallyThirdModalViewController: UIViewController, NavigationFlow {
    
    var navigationFlow: FlowManager?
    
    // MARK: - IBAction
    @IBAction func nextModal() {
        navigationFlow?.goNextAsModal().dismissedModal({ [unowned self] in
            debugPrint("Finished close modal view")
            self.getSomeDataFromClosedModal()
        })
    }
    
    @IBAction func back() {
        navigationFlow?.getBack()
    }
    
    @IBAction func backToRoot() {
        navigationFlow?.getBack(pop: .popToRoot(animated: true))
    }
    
    @IBAction func closeHoleFlow() {
        navigationFlow?.dismissFlowController()
    }
    
    // The purpose of this is show the difference when we have the `strong` reference,
    // that even when we close we still have the reference to that object that we used
    // from our container list
    private func getSomeDataFromClosedModal() {
        let modalViewController = self.navigationFlow?.containerStack?.getModuleIfHasInstance(for: AutomaticallyFourthModalViewController.self)
        // Getting from variable
        if let fromVariable = modalViewController?.someData {
            debugPrint("Getting data from modal as variable: \(fromVariable)")
        }
        // Getting from function
        if let fromFunction = modalViewController?.modalViewSampleData() {
            debugPrint("Getting data from modal as function: \(fromFunction)")
        }
    }
}
