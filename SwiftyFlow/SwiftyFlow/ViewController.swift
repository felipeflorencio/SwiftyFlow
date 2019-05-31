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
        
        self.title = "Swifty Flow"
        
        //Setup my flow for when using Storyboard
        self.flowManager = createMyStoryboardFlowManager()
    }
    
    private func createMyStoryboardFlowManager() -> FlowManager {
        let flowManager = FlowManager(navigation: self.navigationController!, container: ContainerFlowStack())

        // Setup stack navigation - Conceptual Idea
        ContainerView().setupStackNavigation(using: flowManager.containerStack!)
        return flowManager
    }
    
    // MARK: - Automatically Navigation Flow Using Storyboard
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    var flowManagerAutomaticallyNavigationFlow: FlowManager?
    @IBAction func startAutomaticallyNavigationFlow() {
        let navigationStack = ContainerFlowStack()
        AutomaticallyNavigationContainer().setupNavigationStack(using: navigationStack)

        flowManagerAutomaticallyNavigationFlow = FlowManager(root: AutomaticallyInitialViewController.self,
                                                             container: navigationStack,
                                                             setupInstance: .storyboard("AutomaticallyNavigationFlow"))
    }
    
    // MARK: - Automatically Navigation Flow Using NIB
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    var flowManagerAutomaticallyNavigationUsingNibFlow: FlowManager?
    @IBAction func startAutomaticallyNavigationUsingNibFlow() {
        let navigationStack = ContainerFlowStack()
        AutomaticallyNavigationContainer().setupNavigationStack(using: navigationStack)
        
        flowManagerAutomaticallyNavigationUsingNibFlow = FlowManager(root: AutomaticallyInitialViewController.self,
                                                                     container: navigationStack)
    }
    
    // MARK: - Automatically / Go Anywhere Navigation Flow Using NIB
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    var flowManagerAutomaticallyGoAnywhereNavigationUsingNibFlow: FlowManager?
    @IBAction func startAutomaticallyGoAnywhereNavigationUsingNibFlow() {
        let container = GoAnywhereNavigationContainer(stack: ContainerFlowStack())
        
        flowManagerAutomaticallyGoAnywhereNavigationUsingNibFlow = FlowManager(root: GoAnywhereInitialViewController.self,
                                                                               container: container.setup())
    }
    
    
    // MARK: - Parameter Navigation Flow Using NIB
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    var flowManagerParameterNavigationUsingNibFlow: FlowManager?
    @IBAction func startParameterNavigationUsingNibFlow() {
        let container = ParameterNavigationContainer(stack: ContainerFlowStack())
        
        flowManagerParameterNavigationUsingNibFlow = FlowManager(root: ParameterInitialViewController.self,
                                                                 container: container.setup(), parameters: {
                    return (("Felipe", 3123.232, "Florencio", 31))
        })
    }
    
    // MARK: - Deeplink Navigation Flow Using NIB
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    var flowManagerDeepLinkNavigationUsingNibFlow: FlowManager?
    @IBAction func deepLinkNavigationUsingNibFlow() {
        let navigationStack = ContainerFlowStack()
        DeeplinkNavigationContainer().setupNavigationStack(using: navigationStack)
        
        flowManagerDeepLinkNavigationUsingNibFlow = FlowManager(root: DeeplinkInitialViewController.self,
                                                                container: navigationStack)
    }
    
    // MARK: - Deeplink Navigation Flow Using NIB
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    var flowManagerUsingNibWithModalFlow: FlowManager?
    @IBAction func navigationUsingNibWithModalFlow() {
        let navigationStack = ContainerFlowStack()
        AutomaticallyNavigationWithModalContainer().setupNavigationStack(using: navigationStack)
        
        flowManagerUsingNibWithModalFlow = FlowManager(root: AutomaticallyInitialViewController.self,
                                                       container: navigationStack)
    }
    
    // MARK: - Navigation when Storyboard Views
    @IBAction func storyboardNavigationAction() {
        self.flowManager?.goNext(screen: FirstViewController.self, resolve: .storyboard("Main"))
        
        self.flowManager.dismissedFlowWith { parameter in
            debugPrint("Finished passing this parameter \(parameter) that has the type: \(type(of: parameter))")
        }
    }
    
    // MARK: - Navigation when Nib Views
    @IBAction func nibNavigationAction() {
        self.flowManager?.goNext(screen: FirstViewController.self, resolve: .nib)
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

        // As soon finish instantiate you will show you new navigation flow
        return FlowManager(root: FirstViewController.self, container: navigationStack,
           finishedLoad: {
            // Finished presenting
            debugPrint("Finished present navigation controller using present()")
        }, dismissed: {
            // Finished dismissing navigation flow completely
            debugPrint("Finished dismiss navigation controller using dismiss()")
        }).dismissedFlowWith(parameter: { parameter in
            debugPrint("Finished passing this parameter \(parameter) that has the type: \(type(of: parameter))")
        })
    }
}
