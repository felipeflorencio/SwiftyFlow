//
//  NavigationCoordinator.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

enum ViewIntanceFrom {
    case nib
    case storyboard(String)
}

class NavigationCoordinator: NavigationStack {
    
    var containerStack: NavigationContainerStack?
    var screenOwner: (() -> NavigationStack)?
    
    private(set) var navigationController: UINavigationController
    
    init(navigation controller: UINavigationController, container stack: NavigationContainerStack) {
        self.navigationController = controller
        self.containerStack = stack
    }
    
    func goNext<T: UIViewController>(screen view: @escaping ((T.Type) -> ()) -> (), resolve asType: ViewIntanceFrom = .nib) {
        view({ [weak self] viewToGo in

            guard let controller = self?.resolveInstance(viewController: asType, for: viewToGo.self) else {
                debugPrint("Could not retrieve the view controller to push")
                return
            }
            
            (controller as? NavigationStack)?.navigationCoordinator = self
            
            self?.navigationController.pushViewController(controller, animated: true)
        })
    }
    
    func getBack<T: UIViewController>(screen view: @escaping ((T.Type) -> ()) -> ()) {
        
    }
    
    private func resolveInstance<T: UIViewController>(viewController from: ViewIntanceFrom, for view: T.Type) -> UIViewController? {
        switch from {
        case .storyboard(let storyboard):
            let storyboardName = storyboard.count == 0 ? "Main" : storyboard
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: String(describing: view.self))
            
            // As here we have a different instance, we need to update our navigation stack weak object reference with this new one
            // just to be able if we need to have the right reference variable in order to be able to pass some parameters or any one
            // need that is mandatory in order to have the right reference
            // FOR this we need to add some new interface method that update our WeakContainer object and pass to the caller back
            // using protocol this new value as reference so the one that instantiate can use
            containerStack?.replaceInstanceReference(for: view, instance: { () -> UIViewController in
                return controller
            })
            
            
            return controller
        case .nib:
            let resolvedInstance = containerStack?.resolve(for: view.self)
            return resolvedInstance
        }
    }
    
}
