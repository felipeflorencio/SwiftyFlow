//
//  ViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // You need to make sure that you initialize this, at least for now as a pock
    var flowManager: FlowManager!
    var flowManagerFromScratch: FlowManager?
    
    @IBOutlet weak var pushButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup my flow for when using Storyboard
        self.flowManager = createMyStoryboardFlowManager()
    }
    
    private func createMyStoryboardFlowManager() -> FlowManager {
        let flowManager = FlowManager(navigation: self.navigationController!, container: ContainerFlowStack())

        // Setup stack navigation - Conceptual Idea
        ContainerView().setupStackNavigation(using: flowManager.containerStack!)
        return flowManager
    }
    
    var testReference: FlowManager?
    // MARK: - Automatically Navigation Flow
    @IBAction func startAutomaticallyNavigationFlow() {
        let navigationStack = ContainerFlowStack()
        AutomaticallyNavigationContainer().setupNavigationStack(using: navigationStack)

        testReference = FlowManager(rootType: AutomaticallyInitialViewController.self,
                                    container: navigationStack,
                                    setupInstance: .storyboard("AutomaticallyNavigationFlow"))
    }
    
    // MARK: - Navigation when Storyboard Views
    @IBAction func storyboardNavigationAction() {
        self.flowManager?.goNext(screen: { viewType in
            viewType(FirstViewController.self)
        }, resolve: .storyboard("Main"))
        
        self.flowManager.dismissedFlowWith { parameter in
            debugPrint("Finished passing this parameter \(parameter) that has the type: \(type(of: parameter))")
        }
    }
    
    // MARK: - Navigation when Nib Views
    @IBAction func nibNavigationAction() {
        self.flowManager?.goNext(screen: { viewType in
            viewType(FirstViewController.self)
        }, resolve: .nib)
    }
    
    // MARK: - Navigation with custom Navigation Controller
    @IBAction func newOneFromContainerAction() {
        // With this you can have you instance and handle dismiss and do what ever you want
        // Using this format as soon you finish load your navigation flow manager you will
        // present you navigation controller flow automatically
        let fromScratchCoordinator = createNavigationFromScratch()
        
        // This is not mandatory, but shows that you can still have the reference to your flow
        flowManagerFromScratch = fromScratchCoordinator
    }
    
    // Helper To Create the container
    func createNavigationFromScratch() -> FlowManager? {
        let navigationStack = ContainerFlowStack()
        ContainerView().setupStackNavigation(using: navigationStack)

        // I'm using my container view and getting one of my first view controllers
        // in order to be the root view controller for my custom navigation controller
        guard let rootViewController = navigationStack.resolve(for: FirstViewController.self) else {
            return nil
        }
        
        // As soon finish instantiate you will show you new navigation flow
        return FlowManager(rootInstance: { () -> UIViewController? in
            return rootViewController
        }, container: navigationStack,
           finishedLoad: {
            // Finished presenting
            debugPrint("Finished present navigation controller using present()")
        }, dismissed: {
            // Finished dismissing navigation flow completely
            debugPrint("Finished dismiss navigation controller using dismiss()")
        }).dismissedFlowWith(paramenter: { parameter in
            debugPrint("Finished passing this parameter \(parameter) that has the type: \(type(of: parameter))")
        })
    }
    
    @IBAction func automaticallyNavigation() {
        self.flowManager.goNext()
    }
}
