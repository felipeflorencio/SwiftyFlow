//
//  NavigationContainerStack.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModule where Self: UIViewController { }

class NavigationContainerStack {
    
    private(set) var modules: [WeakContainer<UIViewController>]
    
    @discardableResult init() {
        modules = [WeakContainer]()
    }
    
    @discardableResult convenience init(for instances: (NavigationContainerStack) -> ()) {
        self.init()
        instances(self)
    }
    
    @discardableResult func registerModule<T: ViewModule>(for type: Any.Type, resolve: @escaping () -> T) -> WeakContainer<UIViewController> {
        let weakContainer = WeakContainer(for: type) { () -> UIViewController? in
            return resolve()
        }
        modules.append(weakContainer)
        
        return weakContainer
    }
    
    // Get the module list that you registered, can have itens that are not being instantiate yet
    // or by you getting back they are nullified the reference, just need to be instantiate again
    func getModulesList() -> [WeakContainer<UIViewController>] {
        return modules
    }
    
    func getModuleIfInTheList<T: UIViewController>(for type: T.Type) {
//        let module
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
    func updateModulesReference<T: UIViewController>(for navigation: [T], coordinator reference: NavigationCoordinator) {
        let notInTheNavigation = self.modules.filter { weakContainer -> Bool in
            return navigation.first(where: { type(of: $0) == weakContainer.forType }) == nil
        }
        
        notInTheNavigation.forEach { weakContainer in
            weakContainer.resetInstanceReference()
        }
        
        navigation.forEach { viewController in
            (viewController as? NavigationStack)?.navigationCoordinator = reference
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
    private var scope: Scope = .weak
    private(set) var forType: Any.Type
    private weak var weakInstance: AnyObject?
    private var strongInstance: T?
    
    init(for type: Any.Type, resolving: @escaping Container) {
        factory = resolving
        forType = type
    }
    
    // TO-DO: Verify the moments that we want to deinit for for, as we want to have
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
            // TO-DO: Validate if we really want to have the type forced to be UIViewController here
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
        // TO-DO: Validate if this behaviour is ok or need to be changed
        self.strongInstance = nil

        self.weakInstance = object
    }
    
    func resetInstanceReference() {
        self.weakInstance = nil
        self.strongInstance = nil
    }
}
