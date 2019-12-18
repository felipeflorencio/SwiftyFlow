//
//  ContainerFlowStack+GenericExtension.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 24/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

// Here we have all the generic methods that we use in order to register and resolve
// when is regarding generic parameters that we want to pass / resolve
extension ContainerFlowStack {
    
    /**
     This is the registration method for your view controller that you will receive some parameter when try to resolve, try to navigate using flow manager, you will be able to declare what you will expect as parameter, here you need to declare the type of the parameters that you will receive, and it's mandatory if you have one or more they be in the same order as when you send the parameter.
     
     - Parameters:
        - type: The View Controller type that you want to register.
        - resolve: Closure with the declaration of the type(s) that you will expect as parameter.
     
     - Returns: FlowElementContainer container.

     - Note: It has `@discardableResult` because you can use other helper methods just after calling this method as we always return Container Flow Stack instance.
     
     ### Usage Example: ###
     ````
         containerStack.registerModuleWithParameter(for: ParameterInitialViewController.self) { (arguments: (String, Double, String, Int)) -> ParameterInitialViewController? in
     
            let (first, second, third, fourth) = arguments
     
            let initialViewController = ParameterInitialViewController()
            initialViewController.setParameters(first: first, second, third, fourth)
     
            return initialViewController
         }
     ````
     
     - Important: If you want to use more than one parameter it's important to use tuple, as how generic works in order to identify you need to have a type of the thing so generics will understand about, this is why when we have multiples parameter we type as tuple.
    */
    @discardableResult
    public func registerModuleWithParameter<T: UIViewController, Resolver>(for type: T.Type, resolve: @escaping ((Resolver)) -> T?) -> FlowElementContainer<UIViewController> {
        
        let elementContainer = FlowElementContainer<UIViewController>(for: type, with: (Resolver).self, resolving: resolve)
        modules.append(elementContainer)
        
        return elementContainer
    }
    
    /**
     Resolver method for when you registered your view controller expecting have parameters when try to resolve.
     */
    func resolve<T: UIViewController, Resolver>(for item: T.Type, parameters data: () -> ((Resolver))) -> T? {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(element.forType)")
            
            return element.forType == item
        }
        
        // As we are registering in a very generic way, basically we need to make sure what we are doing
        // otherwise we can't check what is suppose to be the type to "convert back" to be able to call
        // the right closure that will pass / get the right parameter data, and resolve the instance that
        // we want back, it's very delicate, but it's the way that Swift can provide
        guard let factory = module?.factoryParameter else { return nil }
        
        let resolveInvoker = factory as! (Resolver) -> T?
        let resolvedInstance = resolveInvoker(data())
        module?.resolved(with: { resolvedInstance })
        
        return resolvedInstance
    }
    
    /**
     Resolver method for when you registered your view controller expecting have parameters when try to resolve.
     This is intended to be used when we use a custom identifier
     */
    func resolve<T: UIViewController, Resolver>(for item: T.Type, customIdentifier: String, parameters data: () -> ((Resolver))) -> T? {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(element.forType)")
            
            return element.forType == item && element.customIdentifier == customIdentifier
        }
        
        // As we are registering in a very generic way, basically we need to make sure what we are doing
        // otherwise we can't check what is suppose to be the type to "convert back" to be able to call
        // the right closure that will pass / get the right parameter data, and resolve the instance that
        // we want back, it's very delicate, but it's the way that Swift can provide
        guard let factory = module?.factoryParameter else { return nil }
        
        let resolveInvoker = factory as! (Resolver) -> T?
        let resolvedInstance = resolveInvoker(data())
        module?.resolved(with: { resolvedInstance })
        
        return resolvedInstance
    }
}
