//
//  FirstViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

class FirstViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)        
    }
    
    // Storyboard Navigation
    @IBAction func goNextView() {

        navigationFlow?.goNext(screen: SecondViewController.self, resolve: .storyboard("Main"), resolved: { instance in
            instance.nameForTitle = "PASSING TO SECOND"
        })
    }
    
    @IBAction func goBackView() {
        navigationFlow?.getBack()
    }
    
    // NIB Navigation
    @IBAction func goNextNibView() {
//        navigationFlow?.goNextWith(parameters: { () -> ((String, Int)) in
//            return ("Felipe Garcia", 232)
//        }, screen: { nextView in nextView(GoAnywhereFirstViewController.self) })

        
//        ((T.Type) -> ()) -> ()
        self.navigationFlow?.goNext(screen: SecondViewController.self, resolve: .nib, resolved: { instance in
            instance.nameForTitle = "PASSING TO SECOND"
        })
    }
    
    @IBAction func goBackNibView() {
        navigationFlow?.getBack()
    }
    
    // This is a behaviour that for now should only be used for test
    @IBAction func forDismissWhenPresenting() {
        navigationFlow?.dismissFlowController()
    }
}
