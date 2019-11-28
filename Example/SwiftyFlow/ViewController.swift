//
//  ViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit
import SwiftyFlow

class ViewController: UIViewController {
    
    @IBOutlet weak var pushButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Swifty Flow"
    }
    
    // MARK: - Automatically Navigation Flow Using Storyboard
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    var flowManagerAutomaticallyNavigationFlow: FlowManager?
    @IBAction func startAutomaticallyNavigationFlow() {
        let navigationStack = ContainerFlowStack()
        AutomaticallyNavigationStoryboardContainer().setupNavigationStack(using: navigationStack)

        flowManagerAutomaticallyNavigationFlow = FlowManager(root: AutomaticallyInitialViewController.self,
                                                             container: navigationStack,
                                                             setupInstance: .storyboard("AutomaticallyNavigationFlow"))
        flowManagerAutomaticallyNavigationFlow?.start()
    }
    
    // MARK: - Automatically Navigation Flow Using NIB
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    var flowManagerAutomaticallyNavigationUsingNibFlow: FlowManager?
    @IBAction func startAutomaticallyNavigationUsingNibFlow() {
        let navigationStack = ContainerFlowStack()
        AutomaticallyNavigationNibContainer().setupNavigationStack(using: navigationStack)
        
        flowManagerAutomaticallyNavigationUsingNibFlow = FlowManager(root: AutomaticallyNibInitialViewController.self,
                                                                     container: navigationStack)
        flowManagerAutomaticallyNavigationUsingNibFlow?.start()
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
        flowManagerAutomaticallyGoAnywhereNavigationUsingNibFlow?.start()
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
        flowManagerParameterNavigationUsingNibFlow?.start()
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
        flowManagerDeepLinkNavigationUsingNibFlow?.start()
    }
    
    // MARK: - Deeplink Navigation Flow Using NIB
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    var flowManagerUsingNibWithModalFlow: FlowManager?
    @IBAction func navigationUsingNibWithModalFlow() {
        let navigationStack = ContainerFlowStack()
        AutomaticallyNavigationWithModalContainer().setupNavigationStack(using: navigationStack)
        
        flowManagerUsingNibWithModalFlow = FlowManager(root: AutomaticallyInitialModalViewController.self,
                                                       container: navigationStack,
                                                       dismissed: {
                                                        debugPrint("finished")
        })
        flowManagerUsingNibWithModalFlow?.start()
    }
    
    // MARK: - Navigation Flow Using NIB
    // If you do not set the return for some class variable after being allocated the
    // the object will be deallocated as is the normal behaviour in order to avoid
    // retain cycle
    enum ScreenToChose {
        case root
        case first
        case second
        case third
        
        var type: String {
            switch self {
            case .root: return "Root View"
            case .first: return "First View"
            case .second: return "Second View"
            case .third: return "Third View"
            }
        }
    }
    var flowManagerChoseRootViewWhenStartNavigation: FlowManager?
    let screenToStart = ScreenToChose.third
    @IBAction func selectRootWhenStartNavigationUsingNibFlow() {
        let container = ResolveRootNavigationNibContainer().setupNavigationStack()
        
        flowManagerChoseRootViewWhenStartNavigation = FlowManager(navigation: UINavigationController(), container: container)
        
        flowManagerChoseRootViewWhenStartNavigation?.startWith(root: {
            switch self.screenToStart {
                case .root: return ResolveRootNibInitialViewController.self
                case .first: return ResolveRootFirstViewController.self
                case .second: return ResolveRootSecondViewController.self
                case .third: return ResolveRootThirdViewController.self
            }
        }, resolved: { instance in
            switch self.screenToStart {
                case .root:
                    (instance as! ResolveRootNibInitialViewController).parameterInjection = self.screenToStart.type
                case .first:
                    (instance as! ResolveRootFirstViewController).parameterInjection = self.screenToStart.type
                case .second:
                    (instance as! ResolveRootSecondViewController).parameterInjection = self.screenToStart.type
                case .third:
                    (instance as! ResolveRootThirdViewController).parameterInjection = self.screenToStart.type
            }
        })
    }
}

