//
//  ThirdViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, ViewModule, NavigationStack {
        
    var navigationCoordinator: NavigationCoordinator?
    
    // Storyboard Navigation
//    @IBAction func goNextView() {
//        self.navigationCoordinator?.goNext(screen: { showView in
//            showView(SecondViewController.self)
//        }, resolve: .storyboard("Main"))
//    }
    
    @IBAction func goBackView() {
        self.navigationCoordinator?.getBack(pop: .popTo(animated: true), screen: { viewToGo in
            viewToGo(FirstViewController.self)
        })
    }
    
    // NIB Navigation
//    @IBAction func goNextNibView() {
//        self.navigationCoordinator?.goNext(screen: { showView in
//            showView(SecondViewController.self)
//        }, resolve: .nib)
//    }
    
    @IBAction func goBackNibView() {
        self.navigationCoordinator?.getBack(pop: .popTo(animated: true), screen: { viewToGo in
            viewToGo(FirstViewController.self)
        })
    }
}
