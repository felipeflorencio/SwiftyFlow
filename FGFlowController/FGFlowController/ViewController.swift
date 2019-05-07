//
//  ViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // You need to make sure that you initialize this, at least for now as a pock
    var navigationCoordinator: NavigationCoordinator!
    
    @IBOutlet weak var pushButton: UIButton!
    
    override func viewDidLoad() {
        self.navigationCoordinator = NavigationCoordinator(navigation: self.navigationController!, container: NavigationContainerStack())
        super.viewDidLoad()
        
        // Setup stack navigation - IN PROGRESS
        ContainerView().setupStackNavigation(using: self.navigationCoordinator!.containerStack!)
    }
    
    // MARK: - Navigation
    
    @IBAction func storyboardNavigationAction() {
        self.navigationCoordinator?.goNext(screen: { viewType in
            viewType(FirstViewController.self)
        }, resolve: .storyboard("Main"))
    }
    
    @IBAction func nibNavigationAction() {
        self.navigationCoordinator?.goNext(screen: { viewType in
            viewType(FirstViewController.self)
        }, resolve: .nib)
    }
}
