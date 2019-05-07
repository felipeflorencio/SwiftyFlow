//
//  FirstViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, ViewModule, NavigationStack {
    
    var navigationCoordinator: NavigationCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)        
    }
    
    // Storyboard Navigation
    @IBAction func goNextView() {
        
        self.navigationCoordinator?.goNext(screen: { showView in
            showView(SecondViewController.self)
        }, resolve: .storyboard("Main"), resolved: { instance in
            instance.nameForTitle = "PASSING TO SECOND"
        })
    }
    
    @IBAction func goBackView() {
        navigationCoordinator?.getBack()
    }
    
    // NIB Navigation
    @IBAction func goNextNibView() {
        
        self.navigationCoordinator?.goNext(screen: { showView in
            showView(SecondViewController.self)
        }, resolve: .nib, resolved: { instance in
            instance.nameForTitle = "PASSING TO SECOND"
        })
    }
    
    @IBAction func goBackNibView() {
        navigationCoordinator?.getBack()
    }
}
