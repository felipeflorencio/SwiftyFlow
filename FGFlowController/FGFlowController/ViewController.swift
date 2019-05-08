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
    
    var coordinatorFromScratch: NavigationCoordinator?
    
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
    
    @IBAction func newOneFromContainerAction() {
        // With this you can have you instance and handle dismiss and do what ever you want
        // Using this format as soon you finish load your navigation coordinator you will
        // present you navigation controller flow automatically
        let fromScratchCoordinator = createNavigationFromScratch()
        coordinatorFromScratch = fromScratchCoordinator
    }
    
    // Helper To Create the container
    func createNavigationFromScratch() -> NavigationCoordinator? {
        let navigationStack = NavigationContainerStack()
        ContainerView().setupStackNavigation(using: navigationStack)

        guard let rootViewController = navigationStack.resolve(for: FirstViewController.self) else {
            return nil
        }
        
        return NavigationCoordinator(withRoot: { rootViewController },
                                     container: navigationStack,
                                     finishedLoad: {
            // Finished presenting
            debugPrint("Finished present navigation controller using present()")
        }, dismissed: {
            // Finished dismissing navigation flow completely
            debugPrint("Finished dismiss navigation controller using dismiss()")
        })
    }
}
