//
//  FlowManagerInitializer+GenericExtension.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 25/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

extension FlowManager {
    
    @discardableResult convenience init<T: UIViewController, Resolver>(root instanceType: T.Type,
                                                                       container stack: ContainerFlowStack,
                                                                       parameters data: @escaping () -> ((Resolver)),
                                                                       withCustom navigation: UINavigationController? = nil,
                                                                       setupInstance type: ViewIntanceFrom = .nib,
                                                                       finishedLoad presenting: (() -> ())? = nil,
                                                                       dismissed navigationFlow: (() -> ())? = nil) {
        self.init(navigation: nil, container: stack, setupInstance: type)
        
        let rootViewController = self._resolveInstance(viewController: type, for: instanceType, parameters: data)
        
        self.initializerFunctionality(root: rootViewController, withCustom: navigation, finishedLoad: presenting, dismissed: navigationFlow)
    }
    
    // This is the method that we will use in order to send parameter when resolve our instance
    // for this we still can use the nagigate automatically, just need to have `closure` view
    // implemented when you call, so we know that you are declaring that will say to which screen
    // do you want to go
    // Remember that when declare the parameter data that you want to be resolved need to be inside
    // Tuple, as for swift when resolve everything need to have a type, with this we make sure that
    // always have type and the values are inside
    // For Example: (String, Double, Int)
    func goNextWith<T: UIViewController, Resolver>(parameters data: @escaping () -> ((Resolver)),
                                                   screen view: (((T.Type) -> ()) -> ())? = nil,
                                                   resolve asType: ViewIntanceFrom = .nib,
                                                   resolved instance: ((T) -> ())? = nil) {

        if let nextView = view {
            nextView({ [unowned self] viewToGo in
                self.navigateUsingParameter(parameters: data, next: viewToGo, resolve: asType, resolved: instance)
            })
        } else {
            guard let nextViewElement = self.findNextElementToNavigate() else {
                debugPrint("There's no more itens to go next or there's no declared types")
                return
            }
            
            debugPrint(T.Type.self)
            debugPrint(nextViewElement.forType)

            // Automatically resolve is not working need to figure out
            self.navigateUsingParameter(parameters: data,
                                        next: nextViewElement.forType as! T.Type,
                                        resolve: asType,
                                        resolved: instance)
        }
    }
    
    internal func navigateUsingParameter<T: UIViewController, Resolver>(parameters data: @escaping () -> ((Resolver)),
                                                                        next viewTo: T.Type,
                                                                        resolve asType: ViewIntanceFrom = .nib,
                                                                        resolved instance: ((T) -> ())? = nil) {
        guard let navigation = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        let navigationType = self.defaultNavigationType ?? asType
        
        guard let controller = self._resolveInstance(viewController: navigationType, for: viewTo, parameters: data) else {
            debugPrint("Could not retrieve the view controller to push")
            return
        }
        
        (controller as? NavigationFlow)?.navigationFlow = self
        instance?(controller as! T)
        
        navigation.pushViewController(controller, animated: true)
    }
}
