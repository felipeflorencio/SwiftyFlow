//
//  ContainerFlowStack.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import UIKit

class ContainerFlowStack {
    
    private(set) var modules: [FlowElementContainer<UIViewController>]
    
    @discardableResult init() {
        modules = [FlowElementContainer]()
    }
    
    @discardableResult
    convenience init(for instances: (ContainerFlowStack) -> ()) {
        self.init()
        instances(self)
    }
    
    @discardableResult
    func registerModule<T: UIViewController>(for type: T.Type, resolve: @escaping () -> T?) -> FlowElementContainer<UIViewController> {
        let elementContainer = FlowElementContainer<UIViewController>(for: type, resolving: resolve)
        modules.append(elementContainer)
        
        return elementContainer
    }
    
    @discardableResult
    func _registerModule<T: UIViewController, Arguments>(for type: T.Type, resolve: @escaping (Arguments) -> Any?) -> FlowElementContainer<UIViewController> {
        
        let elementContainer = FlowElementContainer<UIViewController>(for: type, with: Arguments.self, resolving: resolve)
        modules.append(elementContainer)
        
        return elementContainer
    }
    
    // MARK: - Get list of items registered and the reference of an item
    
    // Get the module list that you registered, can have itens that are not being instantiate yet
    // or by you getting back they are nullified the reference, just need to be instantiate again
    func getModulesList() -> [FlowElementContainer<UIViewController>] {
        return modules
    }
    
    func getModuleIfHasInstance<T: UIViewController>(for type: T.Type) -> T? {
        
        // First we evaluate if we have the module inside
        guard let item = modules.first(where: { element -> Bool in
            return element.forType == type
        }) else {
            return nil
        }
        
        // Second we evaluate if is a resolved instance, that is `weak` or `strong`
        // As if is `none` will generate a new instance that is not the purpouse of
        // this method, here is to get the reference to a item that already is resolved
        guard item.scope != .none else {
            return nil
        }
        
        return item.resolve()
    }
    
    func resolve<T: UIViewController>(for item: T.Type) -> T? {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(element.forType)")
            
            return element.forType == item
        }
        
        return module?.resolve()
    }
    
//    func resolve<T: UIViewController, Arguments>(for item: T.Type, with type: Arguments, resolver arguments: @escaping ((Arguments) -> Any) -> T) -> T? {

    func resolve<T: UIViewController, Arguments>(for item: T.Type, with arg: Arguments) -> T? {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(element.forType)")
            
            return element.forType == item
        }
        
        let fac = module?.factoryParameter
        debugPrint(fac)
        let args = module?.arguments
        debugPrint(args)
        
        let preResolved = module?.factoryParameter as! Arguments
        let preArguments = module?.arguments as! Arguments
//        let test = preResolved(preArguments)
        let resolved = module?.factoryParameter as! (Arguments) -> Any
        
        return resolved(preArguments) as! T
    }
    
    // MARK: - Update reference item inside list
    func replaceInstanceReference<T: UIViewController>(for type: T.Type, instance reference: () -> UIViewController) {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting replace: \(type)")
            debugPrint("Container type replace: \(element.forType)")
            
            return element.forType == type
        }
        
        module?.inScope(scope: .weak)
        module?.updateInstance(reference: reference())
    }
    
    // This is used when we get back from navigation view controller, because as we get back our dependencies
    // still how the value from the previous reference, but should not as we will navigate again to, and by
    // the concept will be a new again, so with this we align our modules reference to be nullified beside
    // factory reference as he will possible be used again to get the instance again
    //
    // ** Should not be called when get back to root, if we are getting back to root the right to do is nullify
    // all our reference's beside the closure as we can start again, and if so we should start resolving and
    // using the new instance reference
    func updateModulesReference<T: UIViewController>(for navigation: [T], coordinator reference: FlowManager) {
        let notInTheNavigation = self.modules.filter { element -> Bool in
            return navigation.first(where: { type(of: $0) == element.forType }) == nil
        }
        
        notInTheNavigation.forEach { element in
            element.resetWeakInstanceReference()
        }
        
        navigation.forEach { viewController in
            (viewController as? NavigationFlow)?.navigationFlow = reference
        }
    }
    
    // Helper that need to be called everytime we call methods to get back to root when
    // is using stobyboard or when we "dismiss" completely our navigation so we nullify
    // the reference to those objects in order to guarante that will be not there
    func destroyInstanceReferenceWhenToRoot() {
        self.modules.forEach { element in
            element.resetInstanceReference()
        }
    }
}
