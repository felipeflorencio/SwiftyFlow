//
//  ContainerFlowStack+GenericExtension.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 24/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

extension ContainerFlowStack {
    
    // Here we have all the generic methods that we use in order to register and resolve
    // when is regarding generic parameters that we want to pass / resolve
    @discardableResult func registerModuleWithParameter<T: UIViewController, Resolver>(for type: T.Type, resolve: @escaping ((Resolver)) -> T?) -> FlowElementContainer<UIViewController> {
        
        let elementContainer = FlowElementContainer<UIViewController>(for: type, with: (Resolver).self, resolving: resolve)
        modules.append(elementContainer)

        return elementContainer
    }
    
    func resolve<T: UIViewController, Resolver>(for item: T.Type, parameters data: () -> ((Resolver))) -> T? {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(element.forType)")
            
            return element.forType == item
        }
        
        // As we are registering in a very generic way, basically we need to make sure what we are doing
        // otherwise we can't check what is suppose to be the type to "convert back" to be able to call
        // the write closure that will pass / get the right parameter data, and resolve the instance that
        // we want back, it's very delicate, but it's the way that Swift can provide
        let resolveInvoker = module?.factoryParameter as! (Resolver) -> T?
        let resolvedInstance = resolveInvoker(data())
        
        return resolvedInstance
    }
}
