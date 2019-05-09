//
//  ContainerFlowStack.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModule where Self: UIViewController { }

class ContainerFlowStack {
    
    private(set) var modules: [WeakContainer<UIViewController>]
    
    @discardableResult init() {
        modules = [WeakContainer]()
    }
    
    @discardableResult
    convenience init(for instances: (ContainerFlowStack) -> ()) {
        self.init()
        instances(self)
    }
    
    @discardableResult
    func registerModule<T: ViewModule>(for type: Any.Type, resolve: @escaping () -> T) -> WeakContainer<UIViewController> {
        let weakContainer = WeakContainer(for: type) { () -> UIViewController? in
            return resolve()
        }
        modules.append(weakContainer)
        
        return weakContainer
    }
    
    // MARK: - Get list of items registered and the reference of an item
    
    // Get the module list that you registered, can have itens that are not being instantiate yet
    // or by you getting back they are nullified the reference, just need to be instantiate again
    func getModulesList() -> [WeakContainer<UIViewController>] {
        return modules
    }
    
    func getModuleIfHasInstance<T: UIViewController>(for type: T.Type) -> T? {
        
        // First we evaluate if we have the module inside
        guard let item = modules.first(where: { weakContainer -> Bool in
            return weakContainer.forType == type
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
        let module = modules.first { weakContainer -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(weakContainer.type())")
            
            return weakContainer.type() == item
        }
        
        return module?.resolve()
    }
    
    // MARK: - Update reference item inside list
    func replaceInstanceReference<T: UIViewController>(for type: T.Type, instance reference: () -> UIViewController) {
        let module = modules.first { weakContainer -> Bool in
            debugPrint("Type requesting replace: \(type)")
            debugPrint("Container type replace: \(weakContainer.type())")
            
            return weakContainer.type() == type
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
        let notInTheNavigation = self.modules.filter { weakContainer -> Bool in
            return navigation.first(where: { type(of: $0) == weakContainer.forType }) == nil
        }
        
        notInTheNavigation.forEach { weakContainer in
            weakContainer.resetInstanceReference()
        }
        
        navigation.forEach { viewController in
            (viewController as? NavigationFlow)?.navigationFlow = reference
        }
    }
    
    // Helper that need to be called everytime we call methods to get back to root when
    // is using stobyboard or when we "dismiss" completely our navigation so we nullify
    // the reference to those objects in order to guarante that will be not there
    func destroyInstanceReferenceWhenToRoot() {
        self.modules.forEach { weakContainer in
            weakContainer.resetInstanceReference()
        }
    }
}

class WeakContainer<T> where T: UIViewController {
    
    public enum Scope {
        case none       // fresh instance all the time, default
        case weak       // weak ref to instance, at leas one object
        case strong     // keep alive
    }
    
    typealias Container = () -> T?
    private var factory: (Container)?
    private(set) var scope: Scope = .weak
    private(set) var forType: Any.Type
    private weak var weakInstance: AnyObject?
    private var strongInstance: T?
    
    init(for type: Any.Type, resolving: @escaping Container) {
        factory = resolving
        forType = type
    }
    
    // TODO: (felipe) Verify the moments that we want to deinit, as we want to have
    // strong reference, but this should never lead to an retain cycle
    deinit {
        factory = nil
        weakInstance = nil
        strongInstance = nil
    }
    
    func resolve<T>() -> T? {
        switch scope {
        case .none:
            return factory?() as? T
        case .weak:
            let resolved = (weakInstance as? T) ?? (factory?() as? T)
            weakInstance = resolved as? UIViewController
            return resolved
        case .strong where strongInstance == nil:
            strongInstance = factory?()
            fallthrough
        case .strong:
            return strongInstance as? T
        }
    }

    // To be able to see what is the type for this item
    func type() -> Any.Type {
        return forType
    }
    
    // Set the scope that we will want for this object
    @discardableResult
    public func inScope(scope: Scope) -> Self {
        self.scope = scope
        return self
    }
    
    // MARK: Helper to update self object reference for now when load from storyboard
    // for this we will nullify factory as we should not get anymore from the closure
    // and not maintain the reference as this were generated by the Navigation Coordinator
    func updateInstance<T: UIViewController>(reference object: T) {
        // TODO: (felipe) Validate if this behaviour is ok or need to be changed
        self.strongInstance = nil

        self.weakInstance = object
    }
    
    // This is used to remove any object reference and make sure that if we start the flow again
    // we will always use the fresh instance as is suppose to be
    func resetInstanceReference() {
        debugPrint("Destroying reference instance for \(self.forType)")
        self.weakInstance = nil
        self.strongInstance = nil
    }
}
