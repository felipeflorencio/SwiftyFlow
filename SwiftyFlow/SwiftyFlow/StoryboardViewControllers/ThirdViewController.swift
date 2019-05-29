//
//  ThirdViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, FlowNavigator {
        
    var navigationFlow: FlowManager?
    
    @IBAction func goBackToRootStoryboardNavigation() {
        self.navigationFlow?.getBack(pop: .popToRoot(animated: true)).finishFlowWith(parameter: "It's me calling back - popToRoot")
    }
    
    @IBAction func goBackView() {
        self.navigationFlow?.getBack(pop: .popTo(animated: true), screen: { viewToGo in
            viewToGo(FirstViewController.self)
        })
    }
    
    // NIB Navigation
    @IBAction func goBackNibView() {
        self.navigationFlow?.getBack(pop: .popTo(animated: true), screen: { viewToGo in
            viewToGo(FirstViewController.self)
        })
    }
    
    // This is a behaviour that for now should only be used for test
    @IBAction func forDismissWhenPresenting() {
        navigationFlow?.dismissFlowController().finishFlowWith(parameter: "It's me calling back - Presenter")
    }
}
