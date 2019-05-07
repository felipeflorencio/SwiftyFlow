//
//  SecondViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, ViewModule, NavigationStack {
    
    var navigationCoordinator: NavigationCoordinator?
    
    var nameForTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = nameForTitle
    }
    
    // Storyboard Navigation
    @IBAction func goNextView() {
        self.navigationCoordinator?.goNext(screen: { showView in
            showView(ThirdViewController.self)
        }, resolve: .storyboard("Main"), resolved: { instance in
            
        })
    }
    
    @IBAction func goBackView() {
        navigationCoordinator?.getBack()
    }
    
    // NIB Navigation
    @IBAction func goNextNibView() {
        
        self.navigationCoordinator?.goNext(screen: { showView in
            showView(ThirdViewController.self)
        }, resolve: .nib, resolved: { instance in
            
        })
    }
    
    @IBAction func goBackNibView() {
        navigationCoordinator?.getBack()
    }
}
