//
//  FirstViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, ViewModule, NavigationFlow {
    
    var navigationFlow: FlowManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)        
    }
    
    // Storyboard Navigation
    @IBAction func goNextView() {
        
        self.navigationFlow?.goNext(screen: { showView in
            showView(SecondViewController.self)
        }, resolve: .storyboard("Main"), resolved: { instance in
            instance.nameForTitle = "PASSING TO SECOND"
        })
    }
    
    @IBAction func goBackView() {
        navigationFlow?.getBack()
    }
    
    // NIB Navigation
    @IBAction func goNextNibView() {
        
        self.navigationFlow?.goNext(screen: { showView in
            showView(SecondViewController.self)
        }, resolve: .nib, resolved: { instance in
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
