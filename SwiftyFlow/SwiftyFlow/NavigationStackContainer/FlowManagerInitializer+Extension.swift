//
//  FlowManagerInitializer+Extension.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 25/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

extension FlowManager {
    
    @discardableResult convenience init<T: UIViewController, Arg1, Arg2>(root instanceType: T.Type,
                                                                         container stack: ContainerFlowStack,
                                                                         parameters data: () -> (Arg1, Arg2),
                                                                         withCustom navigation: UINavigationController? = nil,
                                                                         setupInstance type: ViewIntanceFrom = .nib,
                                                                         finishedLoad presenting: (() -> ())? = nil,
                                                                         dismissed navigationFlow: (() -> ())? = nil) {
        self.init(navigation: nil, container: stack, setupInstance: type)
        
        let rootViewController = self.resolveInstance(viewController: type, for: instanceType, parameters: data)
        
        guard let rootView = rootViewController else {
            fatalError("You need to have a root view controller instance")
        }
        
        if let customNavigation = navigation {
            self.navigationController = customNavigation
        } else {
            self.navigationController = UINavigationController(rootViewController: rootView)
        }
        
        guard let navigationController = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        presentNewFlow(navigation: navigationController, resolved: {
            presenting?()
        })

        self.dismissedClosure = navigationFlow
    }
    
    internal func resolveInstance<T: UIViewController, Arg1, Arg2>(viewController from: ViewIntanceFrom,
                                                                   for view: T.Type,
                                                                   parameters data: () -> (Arg1, Arg2)) -> UIViewController? {
        switch from {
        case .storyboard(let storyboard):
            let storyboardName = storyboard.count == 0 ? "Main" : storyboard
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: String(describing: view.self))
            
            // As here we have a different instance, we need to update our navigation stack weak object reference with this new one
            // just to be able if we need to have the right reference variable in order to be able to pass some parameters or any one
            // need that is mandatory in order to have the right reference
            // FOR this we need to add some new interface method that update our FlowElementContainer object and pass to the caller back
            // using protocol this new value as reference so the one that instantiate can use
            containerStack?.replaceInstanceReference(for: view, instance: { () -> UIViewController in
                return controller
            })
            
            return controller
        case .nib:
            
            // this is my closure when I request
            // (Arg1, Arg2) -> T?
            
            let resolvedInstance = containerStack?.resolve(for: view, parameters: data)
            
            
            return resolvedInstance
        }
    }
}
