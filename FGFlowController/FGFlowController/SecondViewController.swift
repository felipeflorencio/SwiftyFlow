//
//  SecondViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, ViewModule, NavigationStack {
    var type: Any.Type { return SecondViewController.self }
    
    var navigationCoordinator: NavigationCoordinator?
    
    @IBAction func goNextView() {
        self.navigationCoordinator?.goNext(screen: { showView in
            showView(ThirdViewController.self)
        }, resolve: .storyboard("Main"))
    }
    
    @IBAction func goBackView() {
//        navigationCoordinator?.getBack(screen: { showView in
//            showView(self.screenOwner?())
//        })
    }
}
